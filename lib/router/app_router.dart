import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/navigation/root_navigator_key.dart';
import '../common/storage/app_preferences.dart';
import '../domain/auth/model/auth_state.dart';
import '../domain/auth/provider/auth_controller.dart';
import '../domain/settings/model/agreement_status.dart';
import '../domain/settings/provider/agreements_controller.dart';
import 'route_gate.dart';
import 'routes.dart';

part 'app_router.g.dart';

/// 필수 약관 게이트에 막히기 직전의 목적지(SPEC-0011 R12 — 해제 후 원래 가려던 곳으로
/// 복귀). 리다이렉트는 순수 판정이라 상태를 갖지 않으므로, 보관은 여기서 한다.
///
/// **provider가 아니라 평범한 클래스인 이유가 핵심이다.** 리다이렉트는 위젯 트리가
/// 빌드되는 중에 돌기 때문에, 여기서 provider의 state를 쓰면 Riverpod이
/// `Tried to modify a provider while the widget tree was building`으로 즉시 던진다.
/// 이 값은 UI가 그리는 것도 아니고(화면은 읽지 않는다) 다시 그릴 필요도 없으므로
/// provider일 이유가 없다 — 라우터가 자기 수명 동안 들고 있는 지역 상태다.
class PendingDestination {
  String? _location;

  void remember(String location) => _location = location;

  /// 보관한 목적지를 꺼내고 비운다. 한 번 쓰면 사라져야 다음 게이트가 옛 목적지로
  /// 잘못 보내지 않는다.
  String take() {
    final String destination = destinationAfterGate(_location);
    _location = null;
    return destination;
  }
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  // 라우터와 수명을 같이하는 지역 상태 — 리다이렉트가 빌드 중에 쓰므로 provider가
  // 아니어야 한다(위 주석).
  final PendingDestination pending = PendingDestination();
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
      final AsyncValue<List<AgreementStatus>> agreements = ref.read(
        agreementsControllerProvider,
      );

      final AuthGateState authGate = _authGate(auth);
      // 약관은 **인증된 사용자에게만 의미가 있다.** 미인증 상태에서 조회를 기다리면
      // 로그인 화면조차 스플래시에 갇힌다 — 인증 전에는 충족으로 보고 인증 게이트가
      // 판정을 가져가게 둔다.
      final TermsGateState termsGate = authGate == AuthGateState.ready
          ? _termsGate(agreements)
          : TermsGateState.satisfied;

      final String? target = resolveGate(
        location: location,
        languageChosen: ref.read(appPreferencesProvider).savedLanguage != null,
        auth: authGate,
        terms: termsGate,
      );

      // 약관 게이트에 막혀 되돌려지는 경우에만 목적지를 보관한다(R12). 다른 게이트는
      // 각자 복귀 규칙이 이미 있다.
      if (target == requiredTermsPath && location != requiredTermsPath) {
        pending.remember(location);
      }

      // 게이트가 풀린 직후 동의 화면에서 나갈 때는 **보관해 둔 목적지로 돌려보낸다**
      // (R12 — 원래 가려던 곳으로 복귀). `resolveGate`는 순수 판정이라 이 상태를
      // 모르고 기본 착지점을 주므로, 그 값을 여기서 갈아 끼운다. 보관한 것이 없으면
      // `take()`가 기본 착지점을 그대로 돌려준다.
      if (location == requiredTermsPath && target == discoverPath) {
        return pending.take();
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
AuthGateState _authGate(AsyncValue<AuthState> auth) {
  final AuthState? value = auth.value;
  if (auth.isLoading || value == null) return AuthGateState.loading;
  if (!value.isAuthenticated) return AuthGateState.unauthenticated;
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
