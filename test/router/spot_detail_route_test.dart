import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category_selection.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_feed_key.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/spot_detail_view.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/routes.dart';

import '../domain/spot/spot_test_doubles.dart';

/// 상세 라우트 하나만 태워 URL → 위젯 인자 변환을 검증한다. 셸 전체를 띄우지 않는다.
Future<void> _pumpRoute(
  WidgetTester tester,
  FakeSpotRepository repo,
  String location,
) async {
  final GoRoute detailRoute = buildRoutes().whereType<GoRoute>().firstWhere(
    (GoRoute r) => r.name == SpotDetailView.routeName,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [spotRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        routerConfig: GoRouter(
          initialLocation: location,
          routes: <RouteBase>[detailRoute],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  // SPEC-0020: `category` 쿼리 파라미터가 사라졌다. 서버가 상세를 spot 자신의
  // 카테고리로 해석하므로 라우트가 실어 나를 것이 없다 — 예전에는 이 파일 대부분이
  // enum 이름 ↔ 파라미터 왕복을 고정했으나, 그 왕복 자체가 없어졌다.
  testWidgets('id만으로 상세가 열린다 (카테고리 인자 없음)', (tester) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1', title: 'Direct'));
    await _pumpRoute(tester, repo, '/spot/c1');

    expect(repo.detailCallCount, 1);
    expect(find.text('Direct'), findsOneWidget);
  });

  testWidgets('thumb 쿼리 파라미터가 상세 화면에 전달된다 (AC-24)', (tester) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(
      tester,
      repo,
      '/spot/c1?thumb=https%3A%2F%2Fimg%2Fcard.jpg',
    );

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(view.initialThumbnailUrl, 'https://img/card.jpg');
  });

  testWidgets('thumb가 없는 직접 진입도 오류가 아니다 (AC-25)', (tester) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1', title: 'Direct'));
    await _pumpRoute(tester, repo, '/spot/c1');

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(view.initialThumbnailUrl, isNull);
    // 조회 결과로 정상 렌더된다.
    expect(find.text('Direct'), findsOneWidget);
  });

  testWidgets('category 파라미터가 소비 대상 스와이프 세션을 정한다 (R11)', (tester) async {
    // category는 **스와이프 세션의 선택 집합**이다 — 이 관광지의 카테고리가 아니다.
    // 콤마로 이은 코드가 그대로 세션 키가 된다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1?category=LODGING,RESTAURANT');

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(
      view.swipeFeed,
      SwipeFeedKey(
        recommended: false,
        selection: SpotCategorySelection(const <SpotCategory>[
          catLodging,
          catRestaurant,
        ]),
      ),
    );
  });

  // SPEC-0035 — 소스도 세션 키의 일부다. 같은 필터의 추천 세션과 전체 세션은 다른
  // 인스턴스라, 빠뜨리면 상세의 좋아요가 없는 세션에서 카드를 찾는다.
  testWidgets('source=recommended면 추천 세션 키로 되돌린다', (tester) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1?category=&source=recommended');

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(
      view.swipeFeed,
      SwipeFeedKey(recommended: true, selection: SpotCategorySelection.empty),
    );
  });

  testWidgets('category의 코드 순서가 달라도 같은 세션을 가리킨다', (tester) async {
    // 선택 *순서*는 필터의 뜻을 바꾸지 않는다 — 순서가 키를 가르면 같은 필터가
    // 두 세션으로 갈라져 피드를 두 번 받는다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1?category=RESTAURANT,LODGING');

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(
      view.swipeFeed?.selection,
      SpotCategorySelection(const <SpotCategory>[catLodging, catRestaurant]),
    );
  });

  testWidgets('category 파라미터가 없으면 스와이프 밖 진입(null)이다 (R11)', (tester) async {
    // null이 유효한 값이다 — 검색·좋아요·지도·딥링크로 들어오면 소비할 카드
    // 스택이 없다. 기본값으로 떨어뜨리면 없던 세션을 새로 만든다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1');

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(view.swipeFeed, isNull);
  });

  testWidgets('상세 라우트는 아래→위 전환을 지정한다 (AC-17·AC-20·AC-22)', (tester) async {
    // 전환의 시각적 결과는 이 테스트 범위 밖이지만(설계문서 §7), 라우트가 기본
    // 좌우 슬라이드가 아닌 커스텀 전환을 갖는지는 확인할 수 있다. 같은
    // CustomTransitionPage가 역방향에도 쓰이므로 종료 전환도 함께 정해진다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1');

    expect(find.byType(SlideTransition), findsWidgets);
  });
}
