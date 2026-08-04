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
  // SPEC-0008 AC-38·AC-41: 탭 3은 좋아요 목록으로 간다.
  testWidgets('tapping the Liked tab shows the liked spots screen', (
    tester,
  ) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    // Home is the initial tab: its section headers are visible.
    expect(find.text('Recommended for You'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom_nav_liked')));
    await tester.pumpAndSettle();

    expect(find.text('No liked spots yet.'), findsOneWidget);
    expect(find.text('Recommended for You'), findsNothing);
  });

  // SPEC-0008 AC-39·AC-42: 탭 4는 커뮤니티 라벨로 바뀌되 화면 내용(플레이스홀더)은
  // 그대로다. 행사 탭은 도달 경로가 사라진다.
  testWidgets('tapping the Community tab shows the unchanged placeholder', (
    tester,
  ) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    await tester.tap(find.byKey(const Key('bottom_nav_community')));
    await tester.pumpAndSettle();

    expect(find.text('Coming soon.'), findsOneWidget);
    expect(find.text('Recommended for You'), findsNothing);
  });

  // SPEC-0008 AC-40: 목적지만 교체되고 탭 수(5)는 그대로다. 라벨 문자열이 아니라
  // 구조를 검사한다 — 폐기된 라벨 키의 부재는 nav_arb_keys_test가 훨씬 싸게 잡는다.
  testWidgets('the shell still has exactly five tabs', (tester) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });
}
