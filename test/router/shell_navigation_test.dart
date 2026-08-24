import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/seen_answer_counts_providers.dart';
import '../domain/spot_qa/spot_qa_test_doubles.dart';
import 'package:ieuri_k_trip_spot/domain/dm/provider/dm_providers.dart';
import '../domain/dm/dm_test_doubles.dart';
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
        // SPEC-0026: 홈 상단 「내 질문」 배지가 로그인 상태에서 목록을 받는다.
        // 오버라이드가 없으면 실제 GraphQL 클라이언트로 나가 타이머가 남는다.
        spotQaRepositoryProvider.overrideWithValue(FakeSpotQaRepository()),
        seenAnswerCountsStoreProvider.overrideWithValue(
          FakeSeenAnswerCountsStore(),
        ),
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
      // SPEC-0026: 홈 상단의 메시지 배지가 대화 목록을 받는다. 오버라이드가 없으면
      // 실제 GraphQL 클라이언트로 나가 타이머가 남는다.
      dmRepositoryProvider.overrideWithValue(FakeDmRepository()),
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
  // SPEC-0030 R18: 좋아요는 보관함 탭 안에 있고, 그 탭의 첫 화면이 좋아요다.
  //
  // SPEC-0008 AC-38·AC-41이 "탭 3 = 좋아요"였고 도달 경로만 바뀌었다 — 여전히
  // 하단 탭 한 번으로 좋아요 목록에 닿는다.
  testWidgets('tapping the Library tab shows the liked spots screen', (
    tester,
  ) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    // Home is the initial tab: its section headers are visible.
    expect(find.text('Near You'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom_nav_library')));
    await tester.pumpAndSettle();

    expect(find.text('No liked spots yet.'), findsOneWidget);
    expect(find.text('Near You'), findsNothing);
  });

  // SPEC-0030 R18: 커뮤니티는 보관함 안의 토글로 간다. 별도 탭이 아니다.
  //
  // 검사하는 계약은 "커뮤니티에 도달하고 홈이 사라진다"로 그대로이며, 경로만
  // 탭 4에서 보관함 토글로 바뀌었다.
  testWidgets('toggling to Community inside Library shows Spot Talk', (
    tester,
  ) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    await tester.tap(find.byKey(const Key('bottom_nav_library')));
    await tester.pumpAndSettle();

    // 토글은 앱바 우측 아이콘 버튼이다 — 세그먼트 라벨이 아니다.
    await tester.tap(find.byKey(const Key('library_toggle')));
    await tester.pumpAndSettle();

    expect(find.text('Spot Talk'), findsOneWidget);
    expect(find.text('Near You'), findsNothing);
  });

  // SPEC-0030 R18: 토글 선택은 탭을 떠나도 유지된다.
  testWidgets('the Library toggle survives leaving and returning to the tab', (
    tester,
  ) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    await tester.tap(find.byKey(const Key('bottom_nav_library')));
    await tester.pumpAndSettle();
    // 토글은 앱바 우측 아이콘 버튼이다 — 세그먼트 라벨이 아니다.
    await tester.tap(find.byKey(const Key('library_toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Spot Talk'), findsOneWidget);

    // 홈에 갔다가 돌아온다.
    await tester.tap(find.byKey(const Key('bottom_nav_home')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bottom_nav_library')));
    await tester.pumpAndSettle();

    expect(
      find.text('Spot Talk'),
      findsOneWidget,
      reason: '마지막으로 보던 쪽이 그대로 나와야 한다',
    );
  });

  // SPEC-0008 AC-40: 목적지만 교체되고 탭 수(5)는 그대로다. 라벨 문자열이 아니라
  // 구조를 검사한다 — 폐기된 라벨 키의 부재는 nav_arb_keys_test가 훨씬 싸게 잡는다.
  testWidgets('the shell still has exactly five tabs', (tester) async {
    final container = await _homeContainer();
    await _pump(tester, container);

    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });
}
