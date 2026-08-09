import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/navigation/spot_detail_route.dart';
import 'package:ieuri_k_trip_spot/domain/event/component/event_card.dart';
import 'package:ieuri_k_trip_spot/domain/event/model/festival.dart';
import 'package:ieuri_k_trip_spot/domain/event/provider/event_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/popular_spot_card.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/spot_card.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/popular_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/home_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../event/event_test_doubles.dart';
import '../spot_test_doubles.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    // 홈의 Near you가 반경 설정을 watch 하므로 SharedPreferences가 필요하다.
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
  });

  Future<void> pump(
    WidgetTester tester, {
    required FakeSpotRepository repo,
    FakeEventRepository? eventRepo,
  }) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          locationServiceProvider.overrideWithValue(FakeLocationService()),
          spotRepositoryProvider.overrideWithValue(repo),
          eventRepositoryProvider.overrideWithValue(
            eventRepo ?? FakeEventRepository(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<Object>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: HomeScreen(),
        ),
      ),
    );
  }

  /// 홈과 상세 라우트를 함께 태워 **카드 탭이 실제로 이동하는지** 본다.
  /// `pump`는 라우터가 없어 `context.pushNamed`가 동작하지 않는다.
  Future<void> pumpWithRouter(
    WidgetTester tester, {
    required FakeSpotRepository repo,
    FakeEventRepository? eventRepo,
  }) async {
    final GoRouter router = GoRouter(
      initialLocation: '/home',
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          name: HomeScreen.routeName,
          builder: (_, _) => const HomeScreen(),
        ),
        // 실제 상세 화면 대신 스텁을 태운다 — 여기서 볼 것은 "상세로 갔는가"이지
        // 상세 화면이 무엇을 그리는가가 아니다(그건 spot_detail 테스트 몫).
        GoRoute(
          path: '/spot/:id',
          name: spotDetailRouteName,
          builder: (_, GoRouterState state) => Scaffold(
            body: Text(
              'detail:${state.pathParameters['id']}'
              ':${state.uri.queryParameters['category'] ?? '-'}',
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          locationServiceProvider.overrideWithValue(FakeLocationService()),
          spotRepositoryProvider.overrideWithValue(repo),
          eventRepositoryProvider.overrideWithValue(
            eventRepo ?? FakeEventRepository(festivals: const <Festival>[]),
          ),
        ],
        child: MaterialApp.router(
          localizationsDelegates: const <LocalizationsDelegate<Object>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          routerConfig: router,
        ),
      ),
    );
  }

  testWidgets('renders the three section headers', (tester) async {
    await pump(
      tester,
      repo: FakeSpotRepository(
        feed: <TouristSpot>[homeSpot('a')],
        pageSize: 10,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Near You'), findsOneWidget);
    expect(find.text('Happening Now'), findsOneWidget);

    // Popular sits below the fold; drag the page up to build it.
    await tester.dragUntilVisible(
      find.text('Popular Spots'),
      find.byType(HomeScreen),
      const Offset(0, -200),
    );
    expect(find.text('Popular Spots'), findsOneWidget);
  });

  // AC-19.3 — 세 섹션 중 둘이 비어도 나머지 하나를 정상적으로 보여준다.
  //
  // 지금 상황이 정확히 그렇다: Happening Now와 Popular은 서버 쿼리가 없어 비어
  // 있고 Near you만 결과가 있다. 레이아웃이 "세 섹션이 모두 찬다"를 가정하지
  // 않는지 여기서 고정한다(설계 §2).
  testWidgets('renders a filled section while the other two are empty', (
    tester,
  ) async {
    await pump(
      tester,
      repo: FakeSpotRepository(
        feed: <TouristSpot>[homeSpot('a')],
        pageSize: 10,
      ),
      // Happening Now와 Popular은 비어 있다 — 서버 쿼리가 배포되기 전의 실제 상황.
      eventRepo: FakeEventRepository(festivals: const <Festival>[]),
    );
    await tester.pumpAndSettle();

    // 찬 섹션은 카드를 그린다.
    expect(find.text('Spot a'), findsOneWidget);

    // 빈 섹션은 빈 공간이 아니라 이유 문구를 보여준다. `skipOffstage: false`로
    // 찾는 이유는 ListView가 화면 밖 항목을 이미 만들어 두기 때문이다 —
    // 여기서 검증할 것은 스크롤 위치가 아니라 "빈 섹션이 문구를 그리는가"다.
    expect(
      find.text(
        'No festivals running near you right now.',
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    expect(
      find.text('No popular spots near you yet.', skipOffstage: false),
      findsOneWidget,
    );
  });
  // SPEC-0013 — 홈 카드를 누르면 상세로 간다.
  //
  // 목 데이터 시절부터 카드에 `onTap`이 아예 없어 눌러도 아무 일도 일어나지
  // 않았다(실기기에서 발견됐다). 세 섹션 모두 같은 규약을 따르는지 고정한다.
  testWidgets('Near you 카드를 누르면 상세 라우트로 간다', (tester) async {
    await pumpWithRouter(
      tester,
      repo: FakeSpotRepository(
        feed: <TouristSpot>[homeSpot('a')],
        pageSize: 10,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SpotCard));
    await tester.pumpAndSettle();

    // **화면으로 확인한다.** `push`는 스택에 쌓을 뿐이라
    // `currentConfiguration.uri`는 이전 위치를 그대로 들고 있다 — 그것으로
    // 단언하면 이동이 정상인데도 실패한다(실제로 그렇게 헤맸다).
    // 카테고리가 없는 spot(매핑되지 않은 서버 enum)도 상세는 열린다 — 파라미터를
    // 빼고 라우트가 기본값으로 폴백한다(AC-25와 같은 규약).
    expect(find.text('detail:a:-'), findsOneWidget);
  });

  testWidgets('Popular 카드를 누르면 상세 라우트로 간다', (tester) async {
    await pumpWithRouter(
      tester,
      repo: FakeSpotRepository()
        ..popular = <PopularSpot>[
          PopularSpot(spot: homeSpot('p1'), likeCount: 21),
        ],
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopularSpotCard));
    await tester.pumpAndSettle();

    expect(find.text('detail:p1:-'), findsOneWidget);
  });

  testWidgets('Happening Now 카드를 누르면 상세 라우트로 간다', (tester) async {
    await pumpWithRouter(
      tester,
      repo: FakeSpotRepository(),
      eventRepo: FakeEventRepository(
        festivals: <Festival>[festival('f1', title: '서울등축제')],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(EventCard));
    await tester.pumpAndSettle();

    // 축제는 항상 축제 카테고리로 연다 — 문자열이 enum 이름과 맞아야 한다.
    expect(find.text('detail:f1:festivalEvent'), findsOneWidget);
  });

}
