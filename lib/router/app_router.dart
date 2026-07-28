import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
const String _home = '/home';

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

      // Auth state is async on first build; while it resolves, don't redirect.
      final AuthState? authState = ref.read(authControllerProvider).value;
      if (authState == null) return null;

      // Step 2: unauthenticated users are pinned to the auth routes (§10.2).
      if (!authState.isAuthenticated) {
        return _authPaths.contains(location) ? null : _login;
      }

      // Step 3: authenticated but onboarding not done → onboarding (§10.3).
      if (!authState.onboardingCompleted) {
        return location == _onboarding ? null : _onboarding;
      }

      // Step 4: authenticated and onboarded → keep them out of the pre-home
      // routes (§10.4).
      if (_authPaths.contains(location) ||
          location == _onboarding ||
          location == _language) {
        return _home;
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
