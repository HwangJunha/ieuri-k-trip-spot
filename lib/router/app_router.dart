import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/navigation/root_navigator_key.dart';
import '../common/storage/app_preferences.dart';
import '../domain/auth/model/auth_state.dart';
import '../domain/auth/provider/auth_controller.dart';
import 'routes.dart';

part 'app_router.g.dart';

// Route paths used by the auth gate below. Widgets never see these — they
// navigate by name (`Screen.routeName`); only the redirect needs raw paths.
const String _splash = '/';
const String _language = '/language';
const String _login = '/login';
const String _onboarding = '/onboarding';

/// 로그인·온보딩을 마친 사용자의 착지점. 앱의 핵심 동선이 스와이프라 홈이 아니라
/// Discover로 보낸다 — 홈은 하단 탭으로 언제든 갈 수 있다.
const String _discover = '/discover';

/// Paths an unauthenticated user is allowed to reach (spec §10.2).
const Set<String> _authPaths = <String>{
  _login,
  '/sign-up',
  '/sns-sign-up',
  '/email-verification',
  '/password-reset',
};

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: _splash,
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(ref),
    redirect: (_, GoRouterState state) {
      final String location = state.matchedLocation;

      // The splash screen drives its own initial navigation.
      if (location == _splash) return null;

      // Step 1: language must be chosen first (spec §10.1).
      final bool languageChosen =
          ref.read(appPreferencesProvider).savedLanguage != null;
      if (!languageChosen) {
        return location == _language ? null : _language;
      }

      // 인증 상태를 loading / authenticated / unauthenticated 세 갈래로 다룬다
      // (SPEC-0005 §2.5). loading에서 리다이렉트를 포기하면 그 구간에 보호 대상
      // 화면이 렌더링되고 provider가 발화한다 — 대신 스플래시로 보내 보호 대상
      // 화면 자체를 그리지 않는다(R1·R2, AC-1·AC-4).
      //
      // `spots`가 토큰 없이도 200에 데이터를 반환하므로 게이트가 새면 화면이
      // 정상처럼 채워져 결함이 눈에 띄지 않는다. 클라이언트 게이트가 유일한
      // 방어선이다(§2.5).
      final AsyncValue<AuthState> auth = ref.read(authControllerProvider);
      final AuthState? authState = auth.value;
      if (auth.isLoading || authState == null) {
        // 대기 화면은 빈 화면이나 에러 화면이 아니어야 한다(AC-2) — 스플래시를
        // 유지한다. 인증이 필요 없는 경로는 그대로 두어 로그인 흐름을 막지 않는다.
        if (_authPaths.contains(location) || location == _language) return null;
        return _splash;
      }

      // Step 2: unauthenticated users are pinned to the auth routes (§10.2).
      if (!authState.isAuthenticated) {
        return _authPaths.contains(location) ? null : _login;
      }

      // Step 3: authenticated but onboarding not done → onboarding (§10.3).
      if (!authState.onboardingCompleted) {
        return location == _onboarding ? null : _onboarding;
      }

      // Step 4: authenticated and onboarded → keep them out of the pre-home
      // routes (§10.4). 착지점은 Discover다 — 앱의 핵심 동선이 스와이프이므로
      // 로그인 직후 바로 카드를 보게 한다(홈은 탭으로 언제든 갈 수 있다).
      if (_authPaths.contains(location) ||
          location == _onboarding ||
          location == _language) {
        return _discover;
      }
      return null;
    },
    routes: buildRoutes(),
  );
}

/// Bridges Riverpod auth/onboarding changes to GoRouter so a redirect
/// re-evaluates on sign-in/out and onboarding completion (spec §10 —
/// `refreshListenable`, not ad-hoc widget branching).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}
