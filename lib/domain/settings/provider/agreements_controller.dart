import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/terms_code.dart';
import '../../../common/network/graphql_client.dart';
// 인증 상태는 앱 전역이며 설정 기능이 이미 여러 곳에서 읽는다(탈퇴·프로필 수정).
import '../../auth/model/auth_state.dart';
import '../../auth/provider/auth_controller.dart';
import '../model/agreement_status.dart';
import '../model/settings_failure.dart';
import '../repository/settings_repository.dart';
import '../repository/settings_repository_impl.dart';

part 'agreements_controller.g.dart';

/// 설정 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지 않는다).
/// 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(ref.watch(graphqlClientProvider));

/// 인증 실패는 재시도하지 않는다 — SPEC-0005의 갱신·로그아웃 경로가 소관이며 여기서
/// 다시 조회해 봐야 같은 실패가 난다. 나머지는 1회만 재시도한다(커뮤니티와 같은 이유).
Duration? settingsRetryPolicy(int retryCount, Object error) {
  if (error is SettingsFailure &&
      error.kind == SettingsFailureKind.unauthenticated) {
    return null;
  }
  if (retryCount >= 1) return null;
  return const Duration(milliseconds: 400);
}

/// 약관 동의 상태(SPEC-0011 R9~R12).
///
/// **`keepAlive`인 이유는 게이트다.** 라우터 리다이렉트가 매 내비게이션마다 이 값을
/// `ref.read`로 읽는데(R11), autoDispose면 화면이 없는 순간 폐기됐다가 다음 리다이렉트에
/// 다시 조회가 시작되고 그 사이 상태가 `loading`이 된다 — 게이트가 사용자를 스플래시에
/// 묶어 화면 전환이 네트워크에 묶인다(설계 §3). 조회는 앱 수명 동안 한 번이면 족하다.
///
/// 토글은 **낙관적으로 반영하고 실패하면 되돌린다**(R10). 서버 왕복을 기다리면 스위치가
/// 손가락을 따라오지 않아 먹통처럼 보인다.
@Riverpod(keepAlive: true, retry: settingsRetryPolicy)
class AgreementsController extends _$AgreementsController {
  @override
  Future<List<AgreementStatus>> build() async {
    // **인증 전에는 조회하지 않는다.** `agreements`는 토큰의 주체를 보는 쿼리라 미인증
    // 상태에서 부르면 반드시 실패한다. 게이트가 이 provider를 앱 시작 시점부터 듣고
    // 있어서, 막지 않으면 로그인 화면에서도 요청이 나가고 그 실패가 재시도로 이어진다.
    //
    // 로그인·로그아웃이 `authControllerProvider`를 바꾸면 `watch` 덕분에 이 provider가
    // 다시 만들어져 그때 조회가 시작된다.
    final AsyncValue<AuthState> auth = ref.watch(authControllerProvider);
    if (auth.value?.isAuthenticated != true) return const <AgreementStatus>[];

    return ref.watch(settingsRepositoryProvider).fetchAgreements();
  }

  /// 약관 하나를 토글한다(R10).
  ///
  /// **필수 항목도 끌 수 있다.** 사용자가 동의를 거두는 것은 막을 일이 아니고,
  /// 막으면 스위치가 있는데 안 움직이는 화면이 된다. 대신 끄는 순간 라우터 게이트
  /// (R11)가 걸려 홈·탐색·커뮤니티가 막히고 동의 화면으로 보내진다 — "동의하지
  /// 않으면 서비스를 이용할 수 없다"가 문구가 아니라 **동작으로** 드러난다.
  /// 설정·로그아웃·탈퇴는 그때도 열려 있어 빠져나갈 길이 있다.
  ///
  /// 필수/선택 구분은 **서버가 정한다**(`AgreementStatus.required`) — 클라이언트가
  /// 정책을 복제하지 않는다. 위치정보가 지금 선택인 것도 서버 판단이다.
  Future<void> toggle(TermsCode code, bool agreed) async {
    final List<AgreementStatus>? current = state.value;
    if (current == null) return;

    final AgreementStatus? target = current
        .where((AgreementStatus a) => a.termsCode == code)
        .firstOrNull;
    // 모르는 항목은 토글 대상이 아니다.
    if (target == null) return;

    // 1) 낙관적 반영 — 사용자는 즉시 스위치가 움직이는 것을 본다.
    state = AsyncValue<List<AgreementStatus>>.data(
      _replace(current, target.copyWith(agreed: agreed)),
    );

    try {
      final AgreementStatus? updated = await ref
          .read(settingsRepositoryProvider)
          .updateAgreement(termsCode: code, agreed: agreed);
      // 서버가 갱신본을 주면 그것이 진실이다(동의 일자·버전이 함께 바뀐다). 안 주면
      // 낙관적 값을 그대로 둔다 — 성공했는데 되돌리면 더 혼란스럽다.
      if (updated != null) {
        state = AsyncValue<List<AgreementStatus>>.data(
          _replace(state.value ?? current, updated),
        );
      }
    } on Object {
      // 2) 롤백 — **이 항목 하나만** 진입 시점 값으로 되돌린다. 오류 상태로 만들지
      // 않는 이유는 화면 전체가 사라지면 안 되기 때문이다. 스위치가 제자리로
      // 돌아가는 것이 피드백이다.
      //
      // 진입 시점의 **목록 전체**로 되돌리면 안 된다. 두 항목을 잇달아 토글하면
      // 나중 것이 아직 응답을 기다리는 사이에 앞의 것이 실패할 수 있는데, 그때
      // 옛 목록을 통째로 씌우면 **다른 항목의 낙관적 값까지 지운다** — 사용자가
      // 건드리지도 않은 스위치가 되돌아간다. 최신 목록 위에 이 항목만 덮는다.
      state = AsyncValue<List<AgreementStatus>>.data(
        _replace(state.value ?? current, target),
      );
      rethrow;
    }
  }

  /// 미동의 필수 약관에 일괄 동의한다(R12).
  ///
  /// **반환된 전체 상태로 갱신하므로 재조회가 없다** — 게이트는 이 provider를 보고
  /// 있으므로 그 자리에서 풀린다.
  Future<void> agreeToRequired() async {
    final List<AgreementStatus> current =
        state.value ?? const <AgreementStatus>[];
    final List<TermsCode> codes = current.unmetRequired
        .map((AgreementStatus a) => a.termsCode)
        .toList();
    if (codes.isEmpty) return;

    state = const AsyncValue<List<AgreementStatus>>.loading();
    state = await AsyncValue.guard(
      () => ref.read(settingsRepositoryProvider).agreeToRequiredTerms(codes),
    );
  }

  List<AgreementStatus> _replace(
    List<AgreementStatus> list,
    AgreementStatus updated,
  ) => list
      .map(
        (AgreementStatus a) => a.termsCode == updated.termsCode ? updated : a,
      )
      .toList();
}
