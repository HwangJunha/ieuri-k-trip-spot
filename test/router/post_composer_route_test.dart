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
Future<void> _pumpRoute(
  WidgetTester tester,
  String location, {
  FakeCommunityRepository? repo,
}) async {
  final GoRoute route = buildRoutes().whereType<GoRoute>().firstWhere(
    (GoRoute r) => r.name == PostComposerScreen.routeName,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        communityRepositoryProvider.overrideWithValue(
          repo ?? FakeCommunityRepository(),
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
  // 장소 상세에서 진입하면 장소가 이미 정해진 채로 열린다.
  testWidgets('spotId·spotTitle 쿼리 파라미터가 컴포저에 전달된다', (
    WidgetTester tester,
  ) async {
    await _pumpRoute(
      tester,
      '/post-composer?spotId=11094&spotTitle=Gyeongbokgung',
    );

    // 고른 장소는 하단 액션 바의 장소 버튼 라벨로 드러난다.
    expect(find.text('Gyeongbokgung'), findsOneWidget);
  });

  // 커뮤니티 탭에서 진입하면 파라미터가 없다. **그래도 등록할 수 있다** — 장소는
  // 선택 항목이라 화면이 요구하지 않고, 시트를 여는 버튼만 남는다(가이드 §5).
  testWidgets('파라미터 없는 진입은 장소가 비어 있고 고를 수 있다', (WidgetTester tester) async {
    await _pumpRoute(tester, '/post-composer');

    final Finder spotButton = find.widgetWithText(TextButton, 'Place');
    expect(spotButton, findsOneWidget);
    // 고정이 아니므로 눌러서 시트를 열 수 있다 — 이것이 없어 장소를 못 고르던
    // 것이 원래 버그였다.
    expect(tester.widget<TextButton>(spotButton).onPressed, isNotNull);
  });

  // 수정 진입은 **id만 실어 보낸다** — 제목·본문·사진은 화면이 그 id로 다시
  // 조회해서 채운다. 예전에는 제목·본문을 URL에 실었는데 사진 키를 담을 수 없어
  // 수정 화면이 사진 없는 새 글처럼 열렸다.
  testWidgets('editPostId만 있으면 수정 모드로 열리고 내용을 조회로 채운다', (
    WidgetTester tester,
  ) async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..postById = fakePost(id: '42', title: 'Old title', ownedByViewer: true);

    await _pumpRoute(tester, '/post-composer?editPostId=42', repo: repo);

    expect(find.text('Edit post'), findsOneWidget);
    // 카테고리 칩은 **수정에서도 보인다** — 서버가 `editPost(category:)`를 받기
    // 시작해 숨길 이유가 없어졌다(이 기대는 원래 "보이지 않는다"였다).
    expect(find.byType(ChoiceChip), findsWidgets);
    expect(repo.lastFetchedPostId, '42');
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller?.text,
      'Old title',
    );
  });
}
