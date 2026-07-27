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

/// Regression: on first run (no saved language, not signed in), picking a
/// language and pressing Confirm must persist the choice and hand off to the
/// login gate — not leave the user stuck on the language screen. The bug was a
/// fire-and-forget save: navigation fired before the async write landed, so the
/// redirect gate still saw no language and bounced back to `/language`.
void main() {
  testWidgets('confirming a language leaves the picker for the login gate', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(
      <String, Object>{},
    ); // no locale saved
    final prefs = await SharedPreferences.getInstance();
    final SecureStorage secure = await seededSecureStorage(
      authenticated: false,
      onboarded: false,
    );

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        secureStorageProvider.overrideWithValue(secure),
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
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
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The gate parks a language-less first run on the picker.
    expect(router.routerDelegate.currentConfiguration.uri.path, '/language');
    expect(container.read(appPreferencesProvider).savedLanguage, isNull);

    // Pick Korean, then confirm.
    await tester.tap(find.text('한국어'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(
        AppLocalizations.of(
          tester.element(find.byType(Scaffold)),
        ).confirmSelection,
      ),
    );
    await tester.pumpAndSettle();

    // The choice is persisted and we advance to the login gate (spec §10 order:
    // language → login → onboarding). Crucially, we are NOT stuck on /language.
    expect(container.read(appPreferencesProvider).savedLanguage, isNotNull);
    expect(router.routerDelegate.currentConfiguration.uri.path, '/login');
  });
}
