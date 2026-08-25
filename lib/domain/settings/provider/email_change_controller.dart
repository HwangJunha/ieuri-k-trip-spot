import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../../auth/provider/auth_controller.dart';
import '../model/email_change_confirmation.dart';
import '../model/email_change_failure_reason.dart';
import '../model/email_change_request.dart';
import '../model/settings_failure.dart';
import '../repository/email_change_repository.dart';
import '../repository/email_change_repository_impl.dart';

part 'email_change_controller.g.dart';

/// 재발송 쿨다운(디자인 §4). 서버가 `RESEND_COOLDOWN_ACTIVE`로 거절하기 전에
/// 클라이언트가 **미리 막는다** — 눌러 본 뒤 거절당하는 것보다 남은 시간을 보여주는
/// 편이 낫다. 서버 오류는 여전히 처리한다.
const Duration emailChangeResendCooldown = Duration(seconds: 60);

/// 서버가 재발송 쿨다운에 쓰는 `UserError.code`. 클라이언트 차단을 뚫고 왔다는 뜻
/// (기기 시계 차이 등)이므로 일반 실패가 아니라 전용 안내로 옮긴다.
const String resendCooldownActiveCode = 'RESEND_COOLDOWN_ACTIVE';

/// 새 주소가 이미 다른 계정에 쓰이고 있을 때의 서버 코드. **클라이언트가 미리
/// 조회하지 않는다** — 조회와 제출 사이에 선점당할 수 있어 어차피 서버 판정을
/// 처리해야 한다(닉네임 중복과 같은 판단, R5).
const String emailAlreadyInUseCode = 'EMAIL_ALREADY_IN_USE';

/// 이메일 변경 repository 하나의 출처(CLAUDE.md §5). 테스트는 이 provider만
/// 오버라이드한다.
@Riverpod(keepAlive: true)
EmailChangeRepository emailChangeRepository(Ref ref) =>
    EmailChangeRepositoryImpl(ref.watch(graphqlClientProvider));

/// 지금 어느 단계인지(디자인 §4 — 2단계 화면).
enum EmailChangeStep {
  /// 새 주소 입력. 아직 서버를 부르지 않았거나, 시도 초과로 되돌아온 상태다.
  address,

  /// 코드 입력. `verificationId`가 잡혀 있다.
  code,

  /// 검증 성공. 이 시점에 비로소 프로필 이메일이 바뀌었다(R7 첫 기준).
  done,
}

/// 이메일 변경 화면의 상태(SPEC-0011 R7·R8).
///
/// **입력 텍스트를 담지 않는다** — 주소와 코드는 `TextEditingController`가 들고,
/// 이 notifier는 흐름의 위치와 결과만 갖는다(프로필 수정과 같은 판단).
class EmailChangeState {
  const EmailChangeState({
    this.step = EmailChangeStep.address,
    this.verificationId,
    this.pendingEmail,
    this.confirmedEmail,
    this.reason,
    this.failure,
    this.resendCooldownUntil,
    this.busy = false,
    this.resent = false,
  });

  final EmailChangeStep step;

  /// 진행 중인 검증 건의 손잡이. 코드 단계에서만 채워진다.
  final String? verificationId;

  /// 코드를 보낸 새 주소. 코드 화면이 "어디로 보냈는지"를 보여주는 데 쓴다.
  /// **아직 프로필의 이메일이 아니다** — 그래서 이름이 pending이다.
  final String? pendingEmail;

  /// 검증에 성공해 서버가 확정한 새 이메일.
  final String? confirmedEmail;

  /// 직전 검증이 실패한 사유(R8). 사유마다 화면 문구와 다음 행동이 다르다.
  final EmailChangeFailureReason? reason;

  /// 전송·인증 계열 실패. 검증 판정([reason])과 구분한다 — 원인도 안내도 다르다.
  final SettingsFailure? failure;

  /// 이 시각 전에는 재발송을 막는다. null이면 즉시 보낼 수 있다.
  final DateTime? resendCooldownUntil;

  /// 서버 호출이 진행 중인지. 버튼 비활성과 진행 표시의 근거다.
  final bool busy;

  /// 직전 동작이 재발송이었고 성공했는지. 화면이 스낵바를 띄우는 계기다.
  final bool resent;

  EmailChangeState copyWith({
    EmailChangeStep? step,
    String? verificationId,
    String? pendingEmail,
    String? confirmedEmail,
    EmailChangeFailureReason? reason,
    SettingsFailure? failure,
    DateTime? resendCooldownUntil,
    bool? busy,
    bool? resent,
    bool clearReason = false,
    bool clearFailure = false,
  }) => EmailChangeState(
    step: step ?? this.step,
    verificationId: verificationId ?? this.verificationId,
    pendingEmail: pendingEmail ?? this.pendingEmail,
    confirmedEmail: confirmedEmail ?? this.confirmedEmail,
    reason: clearReason ? null : (reason ?? this.reason),
    failure: clearFailure ? null : (failure ?? this.failure),
    resendCooldownUntil: resendCooldownUntil ?? this.resendCooldownUntil,
    busy: busy ?? this.busy,
    resent: resent ?? this.resent,
  );
}

/// 이메일 변경 2단계 흐름(SPEC-0011 R7·R8).
///
/// **가입 검증(`verifyEmail`)을 돌려 쓰지 않는다**(디자인 §4) — 한 뮤테이션에 두
/// 의미를 얹으면 가입 흐름의 상태 기계가 여기 끌려온다. 화면 형태는 닮았지만
/// 호출부가 다르다.
///
/// 검증에 성공하면 세션의 `Me`를 다시 조회한다 — 설정 홈과 프로필 화면이 그리는
/// 이메일이 그 값이라, 갱신하지 않으면 바꿨는데 옛 주소가 남는다.
@riverpod
class EmailChangeController extends _$EmailChangeController {
  @override
  EmailChangeState build() => const EmailChangeState();

  EmailChangeRepository get _repository =>
      ref.read(emailChangeRepositoryProvider);

  /// 사용자가 입력을 고치면 직전 오류를 지운다 — 고쳤는데 빨간 줄이 남아 있으면
  /// 아직 틀린 줄 안다.
  void clearErrors() {
    if (state.reason == null && state.failure == null && !state.resent) return;
    state = state.copyWith(
      clearReason: true,
      clearFailure: true,
      resent: false,
    );
  }

  /// 1단계 — 새 주소로 코드 발송을 요청한다(R7).
  ///
  /// **성공해도 프로필 이메일은 그대로다.** 코드 화면의 대기 배너가 그 사실을
  /// 드러낸다 — 안 그러면 사용자가 실패로 오해한다.
  Future<void> requestChange(String newEmail) async {
    if (state.busy) return;
    final String email = newEmail.trim();

    state = EmailChangeState(busy: true, pendingEmail: email);
    try {
      final EmailChangeRequest request = await _repository.requestEmailChange(
        email,
      );
      state = EmailChangeState(
        step: EmailChangeStep.code,
        verificationId: request.verificationId,
        pendingEmail: email,
        // 코드가 방금 나갔으므로 재발송 쿨다운은 여기서 시작한다.
        resendCooldownUntil: DateTime.now().add(emailChangeResendCooldown),
      );
    } on Object catch (error) {
      // `SettingsFailure`만 잡으면 매핑 중의 예상 밖 예외가 busy를 true로 굳혀
      // 사용자가 다시 시도조차 못 한다(프로필 이미지와 같은 판단).
      state = EmailChangeState(pendingEmail: email, failure: _asFailure(error));
    }
  }

  /// 2단계 — 코드를 검증한다(R8).
  ///
  /// 실패 사유는 예외가 아니라 값으로 온다. [EmailChangeFailureReason.canRetryHere]가
  /// false인 사유(시도 초과)는 이 검증 건이 죽었다는 뜻이라 **주소 입력 단계로
  /// 되돌린다** — 남은 시도가 없는 화면에 붙잡아 두면 무엇을 눌러도 같은 오류다.
  Future<void> confirm(String code) async {
    final String? verificationId = state.verificationId;
    if (state.busy || verificationId == null) return;

    // **검증이 도는 동안 화면을 나갈 수 있다.** 이 뒤로는 서버에서 주소가 이미
    // 바뀐 시점이 나오므로, 여기서 `UnmountedRefException`이 나면 사용자는 실패로
    // 보는데 이메일은 바뀌어 있는 최악의 어긋남이 된다. 인증 notifier는
    // keepAlive라 미리 읽어 두면 폐기 뒤에도 갱신을 마칠 수 있다.
    final AuthController auth = ref.read(authControllerProvider.notifier);

    state = state.copyWith(busy: true, clearReason: true, clearFailure: true);
    try {
      final EmailChangeConfirmation result = await _repository
          .confirmEmailChange(
            verificationId: verificationId,
            code: code.trim(),
          );

      if (!result.succeeded) {
        final EmailChangeFailureReason reason = result.reason!;
        if (!ref.mounted) return;
        state = reason.canRetryHere
            ? state.copyWith(busy: false, reason: reason)
            : EmailChangeState(
                // 처음부터 다시 — 죽은 `verificationId`를 들고 가지 않는다.
                pendingEmail: state.pendingEmail,
                reason: reason,
              );
        return;
      }

      // 여기서 비로소 프로필 이메일이 바뀌었다. 세션을 다시 맞춰야 설정 홈이
      // 새 주소를 그린다. **화면을 나갔어도 갱신은 마친다** — 바뀐 주소를 세션에
      // 반영하지 않으면 다시 들어왔을 때 옛 주소가 남는다.
      await auth.refreshMe();
      if (ref.mounted) {
        state = EmailChangeState(
          step: EmailChangeStep.done,
          confirmedEmail: result.email,
          pendingEmail: state.pendingEmail,
        );
      }
    } on Object catch (error) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, failure: _asFailure(error));
      }
    }
  }

  /// 코드 재발송(R8).
  ///
  /// **쿨다운이 남아 있으면 서버를 부르지 않는다**(디자인 §4). 화면도 버튼을 막지만
  /// 여기서 한 번 더 확인한다 — 상태를 가진 쪽이 규칙을 지키는 것이 맞다.
  Future<void> resend() async {
    final String? verificationId = state.verificationId;
    if (state.busy || verificationId == null || !canResendNow()) return;

    state = state.copyWith(busy: true, clearReason: true, clearFailure: true);
    try {
      final EmailChangeRequest request = await _repository.resendEmailChange(
        verificationId,
      );
      state = state.copyWith(
        busy: false,
        // 서버가 새 id를 줬을 수 있다 — 옛 id로 검증하면 실패한다.
        verificationId: request.verificationId,
        resendCooldownUntil: DateTime.now().add(emailChangeResendCooldown),
        resent: true,
      );
    } on Object catch (error) {
      final SettingsFailure failure = _asFailure(error);
      // 서버가 쿨다운으로 거절했다 = 우리 시계가 서버보다 앞섰다. 다음 시도를
      // 다시 막아 두는 편이 사용자에게 덜 혼란스럽다.
      //
      // 그 밖의 실패에는 **쿨다운을 건드리지 않는다.** 인자를 넘기지 않아야 기존
      // 값이 유지된다 — 전에는 `: null`을 넘겼는데, `copyWith`가 null을 "그대로
      // 두기"로 읽어 결과는 같았지만 코드는 "지운다"로 보였다. 동작과 표기가
      // 어긋나면 다음 사람이 반대로 고친다.
      state = failure.code == resendCooldownActiveCode
          ? state.copyWith(
              busy: false,
              failure: failure,
              resendCooldownUntil: DateTime.now().add(
                emailChangeResendCooldown,
              ),
            )
          : state.copyWith(busy: false, failure: failure);
    }
  }

  /// 지금 재발송할 수 있는지. 화면의 카운트다운도 같은 기준을 쓴다.
  bool canResendNow() {
    final DateTime? until = state.resendCooldownUntil;
    return until == null || !DateTime.now().isBefore(until);
  }

  /// 어떤 예외든 `SettingsFailure`로 좁힌다 — 정체불명 예외가 화면까지 새어 나가면
  /// 안내할 문구를 고를 수 없다.
  SettingsFailure _asFailure(Object error) =>
      error is SettingsFailure ? error : SettingsFailure.unknown;
}
