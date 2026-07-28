import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/event/provider/event_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth/auth_test_doubles.dart';
import '../domain/event/event_test_doubles.dart';
import '../domain/spot/spot_test_doubles.dart';

Future<ProviderContainer> _homeContainer() async {
  SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
  final prefs = await SharedPreferences.getInstance();
  final SecureStorage secure = await seededSecureStorage(
    authenticated: true,
    onboarded: true,
  );

  final ProviderContainer container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      spotRepositoryProvider.overrideWithValue(FakeSpotRepository()),
      eventRepositoryProvider.overrideWithValue(FakeEventRepository()),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  return container;
}

Future<void> _pump(WidgetTester tester, ProviderContainer container) async {
  final GoRouter router = container.read(goRouterProvider);
  router.goNamed('home');
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
}

void main() {
  testWidgets('tapping the Chat tab shows its placeholder', (tester) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    // Home is the initial tab: its section headers are visible.
    expect(find.text('Recommended for You'), findsOneWidget);

    // Switch to the Chat tab via the floating nav.
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();

    // The Chat placeholder ("Coming soon.") is shown.
    expect(find.text('Coming soon.'), findsOneWidget);
    expect(find.text('Recommended for You'), findsNothing);
  });
}
