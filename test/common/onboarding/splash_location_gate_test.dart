import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/navigation/root_navigator_key.dart';
import 'package:ieuri_k_trip_spot/common/permission/component/permission_boot_gate.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/auth/auth_test_doubles.dart';
import '../permission/permission_test_doubles.dart';

/// [AMEND] SPEC-0001: location is mandatory. The splash must NOT hand off to the
/// language/login flow until location is granted — overriding R4 for location.
/// Notification stays optional and does not gate the splash.
///
/// Drives the real splash under the real router and the real
/// [PermissionBootGate], varying only the faked OS permission outcomes.
Future<(GoRouter, ProviderContainer)> _pumpBoot(
  WidgetTester tester,
  FakePermissionService service,
) async {
  SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
  final prefs = await SharedPreferences.getInstance();
  final SecureStorage secure = await seededSecureStorage(authenticated: false);

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      permissionServiceProvider.overrideWithValue(service),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);

  final GoRouter router = container.read(goRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        builder: (context, child) => PermissionBootGate(
          navigatorKey: rootNavigatorKey,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    ),
  );
  // The splash shows a looping progress bar, so pumpAndSettle would never
  // settle. Pump past the 1.5s min brand delay and let the boot sheets appear.
  await _tick(tester);
  return (router, container);
}

/// Advances time enough for the splash min-delay and any pending sheet/route
/// transition to complete, without waiting on the never-ending progress bar.
Future<void> _tick(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
}

String _path(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.path;

void main() {
  testWidgets('splash holds on `/` until location is granted', (tester) async {
    // Location denied and the OS won't grant it → the app is parked on splash.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.denied,
        PermissionKind.notification: PermissionState.granted,
      },
      requestResult: {PermissionKind.location: PermissionState.denied},
    );
    final (router, _) = await _pumpBoot(tester, service);

    // The mandatory rationale appears; proceed through the OS dialog (denied).
    await tester.tap(find.text('Continue'));
    await _tick(tester);

    // Location never granted → we are still on the splash route, NOT /language.
    expect(_path(router), '/');
  });

  testWidgets('splash advances once location is granted', (tester) async {
    // Location granted on the boot dialog → the splash hands off past `/`.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.denied,
        PermissionKind.notification: PermissionState.granted,
      },
      requestResult: {PermissionKind.location: PermissionState.granted},
    );
    final (router, _) = await _pumpBoot(tester, service);

    await tester.tap(find.text('Continue')); // location granted
    await _tick(tester);

    // Language is already 'en', so the redirect chain lands on the login gate.
    expect(_path(router), '/login');
  });

  testWidgets('notification is still prompted after location, and dismissing it '
      'advances the splash (optional, R2)', (tester) async {
    // Location already granted; notification undecided → the splash must NOT
    // route yet: the optional notification prompt still has to run first.
    final service = FakePermissionService(
      initial: {
        PermissionKind.location: PermissionState.granted,
        PermissionKind.notification: PermissionState.denied,
      },
      requestResult: {PermissionKind.notification: PermissionState.denied},
    );
    final (router, _) = await _pumpBoot(tester, service);

    // The notification rationale is shown and the splash is still on `/` —
    // proving location-granted alone does not skip the notification prompt.
    expect(find.text('Stay in the loop'), findsOneWidget);
    expect(_path(router), '/');

    // Dismissing the optional prompt completes the sequence → splash advances.
    await tester.tap(find.text('Not now'));
    await _tick(tester);

    expect(_path(router), '/login');
  });

  testWidgets(
    'permanently-denied location shows the Settings path, then advances on '
    'resume after the user enables it (R5)',
    (tester) async {
      final service = FakePermissionService(
        initial: {
          PermissionKind.location: PermissionState.permanentlyDenied,
          PermissionKind.notification: PermissionState.granted,
        },
      );
      final (router, _) = await _pumpBoot(tester, service);

      // No OS dialog can appear → the splash offers the Settings path and holds.
      expect(find.text('Open Settings'), findsOneWidget);
      expect(_path(router), '/');

      // User enables location in Settings and returns → resume re-check grants.
      service.setStatus(PermissionKind.location, PermissionState.granted);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await _tick(tester);

      expect(_path(router), '/login');
    },
  );
}
