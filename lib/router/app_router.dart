import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/debug/debug_back_button.dart';
import '../common/onboarding/provider/onboarding_controller.dart';
import '../common/onboarding/view/language_selection_screen.dart';
import '../common/onboarding/view/onboarding_screen.dart';
import '../common/onboarding/view/splash_screen.dart';
import '../common/onboarding/view/home_placeholder_screen.dart';

part 'app_router.g.dart';

/// Route paths for the first-run flow.
class Routes {
  const Routes._();

  static const String splash = '/';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    redirect: (context, state) {
      final bool completed = ref.read(onboardingControllerProvider);
      final String location = state.matchedLocation;

      // Onboarded users never see language selection / onboarding again.
      if (completed &&
          (location == Routes.language || location == Routes.onboarding)) {
        return Routes.home;
      }
      // First-run users cannot jump straight to home.
      if (!completed && location == Routes.home) {
        return Routes.language;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      // TEMPORARY: wraps the flow routes with a top-left debug back button.
      ShellRoute(
        builder: (context, state, child) =>
            DebugBackButton(location: state.matchedLocation, child: child),
        routes: <RouteBase>[
          GoRoute(
            path: Routes.language,
            builder: (_, _) => const LanguageSelectionScreen(),
          ),
          GoRoute(
            path: Routes.onboarding,
            builder: (_, _) => const OnboardingScreen(),
          ),
          GoRoute(
            path: Routes.home,
            builder: (_, _) => const HomePlaceholderScreen(),
          ),
        ],
      ),
    ],
  );
}
