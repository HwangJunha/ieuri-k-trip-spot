import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/navigation/pending_destination.dart';
import '../common/navigation/root_navigator_key.dart';
import '../common/storage/app_preferences.dart';
import '../domain/auth/model/auth_state.dart';
import '../domain/auth/provider/auth_controller.dart';
import '../domain/auth/view/email_verification_screen.dart';
import '../domain/settings/model/agreement_status.dart';
import '../domain/settings/provider/agreements_controller.dart';
import 'route_gate.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// 보관해 둔 목적지를 꺼내 **실제로 보낼 경로**로 바꾼다(SPEC-0011 R12 · SPEC-0028 R17).
///
/// 보관 자체는 `common/navigation/pending_destination.dart`가 하고, 여기서는 경로
/// 상수를 아는 라우터만 할 수 있는 마지막 판정을 얹는다 — 보관된 것이 진입 전
/// 화면이거나 아무것도 없으면 기본 착지점으로 떨어뜨린다.
String _takeDestination(PendingDestination pending) =>
    destinationAfterGate(pending.takeLocation());

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  // 라우터와 수명을 같이하는 지역 상태 — 리다이렉트가 빌드 중에 쓰므로 state를 가진
  // provider가 아니어야 한다(위 주석). 푸시가 값을 넣을 수 있게 인스턴스만 공유한다.
  final PendingDestination pending = ref.read(pendingDestinationProvider);
  return GoRouter(
    initialLocation: splashPath,
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(ref),
    // **게이트는 이 하나뿐이다**(설계 §3). 인증 게이트(SPEC-0005)와 약관 게이트
    // (SPEC-0011)가 각자 리다이렉트하면 서로를 되돌리는 순환이 생긴다. 판정은 전부
    // `resolveGate`에 있고 여기서는 provider에서 값을 읽어 넘기기만 한다.
    redirect: (_, GoRouterState state) {
      final String location = state.matchedLocation;

      final AsyncValue<AuthState> auth = ref.read(authControllerProvider);
      final AuthGateState authGate = _authGate(auth);

      // 약관은 **인증된 사용자에게만 의미가 있다.** 미인증 상태에서 조회를 기다리면
      // 로그인 화면조차 스플래시에 갇힌다 — 인증 전에는 충족으로 보고 인증 게이트가
      // 판정을 가져가게 둔다.
      //
      // **`ready`일 때만 읽는다.** 밖에서 미리 읽으면 autoDispose provider가 그때마다
      // 되살아나 조회를 내는데, 이메일 미인증 상태에서는 서버가 그 요청을 전부
      // `EMAIL_NOT_VERIFIED`로 거절한다. 값을 쓰지도 않으면서 실패만 만들어 내고,
      // 그 실패가 안전망을 깨워 리다이렉트를 다시 유발하면 무한 루프가 된다
      // (실기기에서 agreements·me가 끝없이 반복했다).
      final TermsGateState termsGate = authGate == AuthGateState.ready
          ? _termsGate(ref.read(agreementsControllerProvider))
          : TermsGateState.satisfied;

      // 가입 직후 경로는 `extra`에 서버 핸들을 싣고 들어온다. 그 경우에만 세션 없이
      // 인증 화면에 머물 수 있다 — 게이트로 들어온 세션이 로그아웃하면 핸들이 없어
      // 로그인 화면으로 나가야 한다(그러지 않으면 빠져나갈 수 없다).
      final Object? extra = state.extra;
      final bool holdsHandle =
          extra is EmailVerificationArgs && extra.verificationId.isNotEmpty;

      final String? target = resolveGate(
        location: location,
        languageChosen: ref.read(appPreferencesProvider).savedLanguage != null,
        auth: authGate,
        terms: termsGate,
        emailVerificationHoldsHandle: holdsHandle,
      );

      // 약관 게이트에 막혀 되돌려지는 경우에만 목적지를 보관한다(R12). 다른 게이트는
      // 각자 복귀 규칙이 이미 있다.
      //
      // **이미 값이 있으면 덮어쓰지 않는다**(SPEC-0028 §3.3). 푸시로 열린 경우 목적지가
      // 게이트보다 먼저 들어와 있고, 그것이 곧 "막히지 않았다면 갔을 곳"이다.
      if (target == requiredTermsPath && location != requiredTermsPath) {
        pending.rememberIfAbsent(location);
      }

      // 게이트가 풀린 직후 동의 화면에서 나갈 때는 **보관해 둔 목적지로 돌려보낸다**
      // (R12 — 원래 가려던 곳으로 복귀). `resolveGate`는 순수 판정이라 이 상태를
      // 모르고 기본 착지점을 주므로, 그 값을 여기서 갈아 끼운다. 보관한 것이 없으면
      // `take()`가 기본 착지점을 그대로 돌려준다.
      if (location == requiredTermsPath && target == discoverPath) {
        return _takeDestination(pending);
      }

      // 푸시로 보관된 목적지는 약관 화면을 거치지 않는다 — 인증만 끝나면 되는 경우가
      // 대부분이다(SPEC-0028 §3.3). 게이트가 전부 통과시키는 시점에 보관된 값이
      // 있으면 그때 꺼낸다(AC17.2).
      //
      // **`target == null`만으로는 안 된다.** 그 값은 세 가지 다른 상황에서 나온다.
      //   - 스플래시(`location == splashPath`)는 판정 전에 무조건 null이다 — 여기서
      //     꺼내면 인증을 기다리지 않고 이동해 AC17.1을 어긴다
      //   - 미인증 상태의 로그인·가입 화면도 null이다(`authPaths`) — 여기서 꺼내면
      //     로그인하던 사용자를 목적지로 끌어내 로그인을 마칠 수 없다
      //   - 게이트를 전부 통과한 경우 — **이때만 꺼내야 한다**
      //
      // 그래서 인증이 `ready`인지를 함께 본다. 미인증으로 판정된 동안에는 꺼내지
      // 않고 두었다가, 로그인을 마치면 그때 소비된다. 끝내 로그인하지 않으면 앱이
      // 끝날 때 라우터와 함께 사라진다(AC17.3).
      if (target == null &&
          authGate == AuthGateState.ready &&
          location != splashPath &&
          pending.hasDestination) {
        final String destination = _takeDestination(pending);
        // 이미 그 자리면 다시 보내지 않는다 — 같은 곳으로의 리다이렉트는 루프다.
        return destination == location ? null : destination;
      }
      return target;
    },
    routes: buildRoutes(),
  );
}

/// 인증 `AsyncValue`를 게이트 입력으로 접는다(SPEC-0005 §2.5).
///
/// loading과 error/null을 **같이 다룬다** — 둘 다 "판정할 수 없음"이고, 그 구간에
/// 보호 화면을 그리면 provider가 발화한다. `spots`가 토큰 없이도 200에 데이터를
/// 반환하므로 게이트가 새면 화면이 정상처럼 채워져 결함이 눈에 띄지 않는다.
/// 이메일 인증 판정(SPEC-0024 R10)은 여기 한 곳에서만 한다. 로그인 직후(R10-1)와
/// 세션 복원 직후(R10-4)가 모두 `authControllerProvider`를 거쳐 이 함수로 오므로,
/// 두 경로를 따로 다루면 판정이 갈라진다.
AuthGateState _authGate(AsyncValue<AuthState> auth) {
  final AuthState? value = auth.value;
  if (auth.isLoading || value == null) return AuthGateState.loading;
  if (!value.isAuthenticated) return AuthGateState.unauthenticated;
  if (!value.emailVerified) return AuthGateState.emailVerificationRequired;
  if (!value.onboardingCompleted) return AuthGateState.onboardingRequired;
  return AuthGateState.ready;
}

/// 약관 `AsyncValue`를 게이트 입력으로 접는다(SPEC-0011 R11).
///
/// **조회 실패는 [TermsGateState.satisfied]로 본다.** 서버가 잠깐 죽었다고 사용자를
/// 동의 화면에 가두면 동의 버튼조차 같은 실패를 만나 빠져나갈 수 없다 — 막는 쪽이
/// 안전해 보이지만 실제로는 앱을 벽돌로 만든다. 미동의 사용자를 놓치는 위험은 서버가
/// 각 뮤테이션에서 다시 막는다.
TermsGateState _termsGate(AsyncValue<List<AgreementStatus>> agreements) {
  if (agreements.hasError) return TermsGateState.satisfied;
  final List<AgreementStatus>? value = agreements.value;
  if (value == null) return TermsGateState.loading;
  return value.requiredSatisfied
      ? TermsGateState.satisfied
      : TermsGateState.unmet;
}

/// Riverpod의 인증·약관 변화를 GoRouter로 잇는다 — 로그인/로그아웃, 온보딩 완료,
/// 필수 약관 동의가 리다이렉트를 다시 평가하게 한다(위젯 분기가 아니라
/// `refreshListenable`).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
    ref.listen(agreementsControllerProvider, (_, _) => notifyListeners());
  }
}
