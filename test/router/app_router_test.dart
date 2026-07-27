import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth/auth_test_doubles.dart';

Future<ProviderContainer> _container({
  required bool authed,
  required bool onboarded,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
  final prefs = await SharedPreferences.getInstance();
  final SecureStorage secure = await seededSecureStorage(
    authenticated: authed,
    onboarded: onboarded,
  );

  final ProviderContainer container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    ],
  );
  addTearDown(container.dispose);
  // Resolve auth state before redirects evaluate.
  await container.read(authControllerProvider.future);
  return container;
}

Future<String> _land(WidgetTester tester, ProviderContainer container) async {
  final GoRouter router = container.read(goRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router.routerDelegate.currentConfiguration.uri.path;
}

void main() {
  testWidgets('unauthenticated user is pinned to the login gate', (
    tester,
  ) async {
    final container = await _container(authed: false, onboarded: false);
    container.read(goRouterProvider).go(Routes.home);
    expect(await _land(tester, container), Routes.login);
  });

  testWidgets('authenticated but not onboarded goes to onboarding', (
    tester,
  ) async {
    final container = await _container(authed: true, onboarded: false);
    container.read(goRouterProvider).go(Routes.home);
    expect(await _land(tester, container), Routes.onboarding);
  });

  testWidgets('authenticated and onboarded reaches home', (tester) async {
    final container = await _container(authed: true, onboarded: true);
    container.read(goRouterProvider).go(Routes.login);
    expect(await _land(tester, container), Routes.home);
  });
}
