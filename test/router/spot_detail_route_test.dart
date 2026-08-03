import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
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
  testWidgets('the category query parameter reaches the detail query', (
    tester,
  ) async {
    // Discover 카드가 만드는 URL 그대로. category가 유실되면 서버가
    // MissingFieldArgument로 쿼리를 거절한다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1?category=restaurant');

    expect(repo.requestedDetailCategory, SpotCategory.restaurant);
  });

  testWidgets('every category name survives the round trip', (tester) async {
    // enum 이름 ↔ 쿼리 파라미터 왕복이 전 값에 대해 성립해야 한다.
    for (final SpotCategory category in SpotCategory.values) {
      final repo = FakeSpotRepository(detail: detailSpot('c1'));
      await _pumpRoute(tester, repo, '/spot/c1?category=${category.name}');

      expect(repo.requestedDetailCategory, category);
    }
  });

  testWidgets('a missing category still renders the detail screen', (
    tester,
  ) async {
    // 매핑 안 된 값이나 파라미터 누락으로 화면 전체가 실패하면 안 된다.
    final repo = FakeSpotRepository(
      detail: detailSpot('c1', title: 'Fallback'),
    );
    await _pumpRoute(tester, repo, '/spot/c1');

    expect(repo.requestedDetailCategory, isNotNull);
    expect(find.text('Fallback'), findsOneWidget);
  });

  testWidgets('thumb 쿼리 파라미터가 상세 화면에 전달된다 (AC-24)', (tester) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(
      tester,
      repo,
      '/spot/c1?category=restaurant&thumb=https%3A%2F%2Fimg%2Fcard.jpg',
    );

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(view.initialThumbnailUrl, 'https://img/card.jpg');
  });

  testWidgets('thumb가 없는 직접 진입도 오류가 아니다 (AC-25)', (tester) async {
    final repo = FakeSpotRepository(detail: detailSpot('c1', title: 'Direct'));
    await _pumpRoute(tester, repo, '/spot/c1?category=restaurant');

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(view.initialThumbnailUrl, isNull);
    // 조회 결과로 정상 렌더된다.
    expect(find.text('Direct'), findsOneWidget);
  });

  testWidgets('feed 파라미터가 소비 대상 피드를 정한다 (R11)', (tester) async {
    // feed는 category(관광지의 카테고리)와 다른 값이다 — 전체 피드에서 식당 카드를
    // 열면 category=restaurant, feed 없음(=전체)이 된다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1?category=restaurant&feed=lodging');

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(view.category, SpotCategory.restaurant);
    expect(view.feedCategory, SpotCategory.lodging);
  });

  testWidgets('feed 파라미터가 없으면 전체 피드(null)로 본다 (R11)', (tester) async {
    // 기본값으로 떨어뜨리면 안 된다 — null이 "전체 피드"라는 유효한 값이다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1?category=restaurant');

    final SpotDetailView view = tester.widget<SpotDetailView>(
      find.byType(SpotDetailView),
    );
    expect(view.feedCategory, isNull);
  });

  testWidgets('상세 라우트는 아래→위 전환을 지정한다 (AC-17·AC-20·AC-22)', (tester) async {
    // 전환의 시각적 결과는 이 테스트 범위 밖이지만(설계문서 §7), 라우트가 기본
    // 좌우 슬라이드가 아닌 커스텀 전환을 갖는지는 확인할 수 있다. 같은
    // CustomTransitionPage가 역방향에도 쓰이므로 종료 전환도 함께 정해진다.
    final repo = FakeSpotRepository(detail: detailSpot('c1'));
    await _pumpRoute(tester, repo, '/spot/c1?category=restaurant');

    expect(find.byType(SlideTransition), findsWidgets);
  });
}
