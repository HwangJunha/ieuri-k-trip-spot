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
}
