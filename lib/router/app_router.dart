import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common/onboarding/view/language_selection_screen.dart';
import '../common/onboarding/view/splash_screen.dart';
import '../common/storage/app_preferences.dart';
import '../common/widget/floating_bottom_nav_scaffold.dart';
import '../domain/auth/model/auth_state.dart';
import '../domain/auth/provider/auth_controller.dart';
import '../domain/auth/view/email_verification_screen.dart';
import '../domain/auth/view/login_screen.dart';
import '../domain/auth/view/password_reset_screen.dart';
import '../domain/auth/view/sign_up_screen.dart';
import '../domain/chat/view/chat_placeholder_screen.dart';
import '../domain/discover/view/discover_placeholder_screen.dart';
import '../domain/events/view/events_placeholder_screen.dart';
import '../domain/home/view/home_screen.dart';
import '../domain/map/view/map_placeholder_screen.dart';
import '../domain/onboarding/view/onboarding_screen.dart';
import 'debug_back_button.dart';

part 'app_router.g.dart';

/// Route paths. Flow order (spec §4.1): splash → language → login/signUp
/// (mandatory gate) → onboarding (per account) → home.
class Routes {
  const Routes._();

  static const String splash = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String emailVerification = '/email-verification';
  static const String passwordReset = '/password-reset';
  static const String onboarding = '/onboarding';

  // Bottom-nav shell tabs (each keeps its own stack via StatefulShellRoute).
  static const String home = '/home';
  static const String map = '/map';
  static const String discover = '/discover';
  static const String events = '/events';
  static const String chat = '/chat';
}

/// Typed arguments for the email-verification route (spec §10 — pass values via
/// `extra`, not the model). Carries the server `verificationId` and the email to
/// prefill on the login screen after verification.
class EmailVerificationArgs {
  const EmailVerificationArgs({
    required this.verificationId,
    required this.email,
  });

  final String verificationId;
  final String email;
}

/// The auth routes the gate lets an unauthenticated user reach (spec §10.2).
const Set<String> _authRoutes = <String>{
  Routes.login,
  Routes.signUp,
  Routes.emailVerification,
  Routes.passwordReset,
};

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: GoRouterRefreshStream(ref),
    redirect: (context, state) {
      final String location = state.matchedLocation;

      // The splash screen drives its own initial navigation.
      if (location == Routes.splash) return null;

      // Step 1: language must be chosen first (spec §10.1).
      final bool languageChosen =
          ref.read(appPreferencesProvider).savedLanguage != null;
      if (!languageChosen) {
        return location == Routes.language ? null : Routes.language;
      }

      // Auth state is async on first build; while it resolves, don't redirect.
      final AsyncValue<AuthState> auth = ref.read(authControllerProvider);
      final AuthState? authState = auth.value;
      if (authState == null) return null;

      final bool authenticated = authState.isAuthenticated;

      // Step 2: unauthenticated users are pinned to the auth routes (§10.2).
      if (!authenticated) {
        return _authRoutes.contains(location) ? null : Routes.login;
      }

      // Step 3: authenticated but onboarding not done → onboarding (§10.3).
      if (!authState.onboardingCompleted) {
        return location == Routes.onboarding ? null : Routes.onboarding;
      }

      // Step 4: authenticated and onboarded → home; keep them out of the
      // pre-home routes (§10.4).
      if (_authRoutes.contains(location) ||
          location == Routes.onboarding ||
          location == Routes.language) {
        return Routes.home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
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
            path: Routes.login,
            builder: (_, state) {
              final Object? extra = state.extra;
              return LoginScreen(
                prefilledEmail: extra is String ? extra : null,
              );
            },
          ),
          GoRoute(path: Routes.signUp, builder: (_, _) => const SignUpScreen()),
          GoRoute(
            path: Routes.emailVerification,
            builder: (_, state) {
              final Object? extra = state.extra;
              final EmailVerificationArgs args = extra is EmailVerificationArgs
                  ? extra
                  : const EmailVerificationArgs(verificationId: '', email: '');
              return EmailVerificationScreen(
                verificationId: args.verificationId,
                email: args.email,
              );
            },
          ),
          GoRoute(
            path: Routes.passwordReset,
            builder: (_, _) => const PasswordResetScreen(),
          ),
          GoRoute(
            path: Routes.onboarding,
            builder: (_, _) => const OnboardingScreen(),
          ),
        ],
      ),
      // The post-onboarding 5-tab shell. Each tab keeps its own navigation
      // stack (spec §6). The home branch is wrapped with the temporary debug
      // back button so stepping back past the auth gate still works (§10).
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            FloatingBottomNavScaffold(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.home,
                builder: (_, state) => DebugBackButton(
                  location: state.matchedLocation,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.map,
                builder: (_, _) => const MapPlaceholderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.discover,
                builder: (_, _) => const DiscoverPlaceholderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.events,
                builder: (_, _) => const EventsPlaceholderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: Routes.chat,
                builder: (_, _) => const ChatPlaceholderScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
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
