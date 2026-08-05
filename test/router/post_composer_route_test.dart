import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/view/post_composer_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:ieuri_k_trip_spot/router/routes.dart';

import '../domain/community/community_test_doubles.dart';
import '../domain/spot/spot_test_doubles.dart';

/// 컴포저 라우트 하나만 태워 URL → 위젯 인자 변환을 검증한다.
Future<void> _pumpRoute(WidgetTester tester, String location) async {
  final GoRoute route = buildRoutes().whereType<GoRoute>().firstWhere(
    (GoRoute r) => r.name == PostComposerScreen.routeName,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        communityRepositoryProvider.overrideWithValue(
          FakeCommunityRepository(),
        ),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
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
        routerConfig: GoRouter(
          initialLocation: location,
          routes: <RouteBase>[route],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  // 관광지 상세에서 진입하면 대상이 이미 정해진 채로 열린다(디자인 §3).
  testWidgets('targetId·targetTitle 쿼리 파라미터가 컴포저에 전달된다', (
    WidgetTester tester,
  ) async {
    await _pumpRoute(
      tester,
      '/post-composer?targetId=11094&targetTitle=Gyeongbokgung',
    );

    expect(find.text('Gyeongbokgung'), findsOneWidget);
    expect(find.text('Select a spot'), findsNothing);
  });

  // 커뮤니티 탭에서 진입하면 파라미터가 없고 화면이 장소 선택을 요구한다.
  testWidgets('파라미터 없는 진입은 장소 선택을 요구한다', (WidgetTester tester) async {
    await _pumpRoute(tester, '/post-composer');

    expect(find.text('Select a spot'), findsOneWidget);
  });
}
