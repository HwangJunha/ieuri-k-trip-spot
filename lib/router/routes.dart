import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/onboarding/view/language_selection_screen.dart';
import '../common/onboarding/view/splash_screen.dart';
import '../common/widget/floating_bottom_nav_scaffold.dart';
import '../domain/auth/view/email_verification_screen.dart';
import '../domain/auth/view/login_screen.dart';
import '../domain/auth/view/password_reset_screen.dart';
import '../domain/auth/view/sign_up_screen.dart';
import '../domain/event/view/events_screen.dart';
import '../domain/onboarding/view/onboarding_screen.dart';
import '../domain/spot/view/chat_screen.dart';
import '../domain/spot/view/discover_screen.dart';
import '../domain/spot/view/home_screen.dart';
import '../domain/spot/view/map_screen.dart';

/// The app's flat route table. Each screen owns its `routeName`; navigation is
/// by name (`context.goNamed(Screen.routeName)`), so no path strings leak into
/// widgets. The auth gate lives in the router's `redirect` (see app_router.dart).
List<RouteBase> buildRoutes() => <RouteBase>[
  GoRoute(
    path: '/',
    name: SplashScreen.routeName,
    builder: (_, _) => const SplashScreen(),
  ),
  GoRoute(
    path: '/language',
    name: LanguageSelectionScreen.routeName,
    builder: (_, _) => const LanguageSelectionScreen(),
  ),
  GoRoute(
    path: '/login',
    name: LoginScreen.routeName,
    // The sign-up / reset flows pass the email to prefill via `extra`.
    builder: (_, GoRouterState state) => LoginScreen(
      prefilledEmail: state.extra is String ? state.extra as String : null,
    ),
  ),
  GoRoute(
    path: '/sign-up',
    name: SignUpScreen.routeName,
    builder: (_, _) => const SignUpScreen(),
  ),
  GoRoute(
    path: '/email-verification',
    name: EmailVerificationScreen.routeName,
    builder: (_, GoRouterState state) {
      final args = state.extra is EmailVerificationArgs
          ? state.extra as EmailVerificationArgs
          : const EmailVerificationArgs(verificationId: '', email: '');
      return EmailVerificationScreen(
        verificationId: args.verificationId,
        email: args.email,
      );
    },
  ),
  GoRoute(
    path: '/password-reset',
    name: PasswordResetScreen.routeName,
    builder: (_, _) => const PasswordResetScreen(),
  ),
  GoRoute(
    path: '/onboarding',
    name: OnboardingScreen.routeName,
    builder: (_, _) => const OnboardingScreen(),
  ),
  // The post-onboarding 5-tab shell. Each tab keeps its own navigation stack.
  StatefulShellRoute.indexedStack(
    builder: (_, _, StatefulNavigationShell shell) =>
        FloatingBottomNavScaffold(navigationShell: shell),
    branches: <StatefulShellBranch>[
      _branch('/home', HomeScreen.routeName, const HomeScreen()),
      _branch('/map', MapScreen.routeName, const MapScreen()),
      _branch('/discover', DiscoverScreen.routeName, const DiscoverScreen()),
      _branch('/events', EventsScreen.routeName, const EventsScreen()),
      _branch('/chat', ChatScreen.routeName, const ChatScreen()),
    ],
  ),
];

/// One tab branch of the bottom-nav shell: a single-route stack.
StatefulShellBranch _branch(String path, String name, Widget screen) =>
    StatefulShellBranch(
      routes: <RouteBase>[
        GoRoute(path: path, name: name, builder: (_, _) => screen),
      ],
    );
