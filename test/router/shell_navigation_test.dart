import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/event/provider/event_providers.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/agreements_controller.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth/auth_test_doubles.dart';
import '../domain/community/community_test_doubles.dart';
import '../domain/event/event_test_doubles.dart';
import '../domain/settings/settings_test_doubles.dart';
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
      // SPEC-0010: 커뮤니티 탭이 실제 화면이 되면서 repository와 좌표가 필요해졌다.
      // 오버라이드가 없으면 실제 GraphQL 클라이언트로 나가 탭 전환 검증이 네트워크에
      // 매달린다.
      communityRepositoryProvider.overrideWithValue(
        FakeCommunityRepository(posts: <Post>[fakePost()]),
      ),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
      // SPEC-0011 R11: 게이트가 필수 약관 상태를 읽는다. 오버라이드가 없으면 실제
      // GraphQL 클라이언트로 나가 상태가 loading에 머물고, 게이트가 사용자를
      // 스플래시에 묶어 탭 자체가 렌더링되지 않는다.
      settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
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

  // SPEC-0008 AC-39: 탭 4는 커뮤니티로 간다. 행사 탭은 도달 경로가 사라진다.
  //
  // AC-42("화면 내용은 플레이스홀더 그대로")는 SPEC-0010이 대체한다 — 같은 탭·같은
  // 라우트를 유지한 채 스텁 내용만 Spot Talk 화면으로 바뀌었다. 여기서 검사하는 것은
  // 여전히 "탭 4를 누르면 커뮤니티에 도달하고 홈이 사라진다"이며, 그 계약은 그대로다.
  testWidgets('tapping the Community tab shows the Spot Talk screen', (
    tester,
  ) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    await tester.tap(find.byKey(const Key('bottom_nav_community')));
    await tester.pumpAndSettle();

    expect(find.text('Spot Talk'), findsOneWidget);
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
