import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/copyright_badge.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/liked_spots_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

LikedSpot _liked(String id, {SpotCategory category = catTouristSpot}) =>
    LikedSpot(
      id: id,
      title: 'Spot $id',
      thumbnailImageUrl: 'https://img/$id.jpg',
      category: category,
      copyright: CopyrightType.type1,
      attributionText: '출처: 한국관광공사',
    );

/// `availableSpotCategories`가 locale을 watch하므로 `sharedPreferencesProvider`
/// override와 바인딩 초기화가 필요하다(CLAUDE.md §8).
Future<void> _pump(WidgetTester tester, FakeSpotRepository repo) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        spotRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: LikedSpotsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('상단 카테고리 바가 서버가 준 카테고리를 렌더한다', (tester) async {
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[_liked('a')],
      categories: const <SpotCategory>[catTouristSpot, catRestaurant],
    );

    await _pump(tester, repo);

    // **"전체 보기" 칩은 사라졌다**(SPEC-0020 R1) — 선택이 비어 있을 수 없으므로
    // "필터 없음"이라는 칩이 뜻할 것이 없다. 서버가 준 카테고리만 그리고, 라벨도
    // 서버가 준 `label`이다(클라이언트가 번역하지 않는다, R11).
    //
    // 카드에도 카테고리 라벨이 있으므로 칩으로 한정해 센다.
    final Finder chips = find.byType(FilterChip);
    expect(
      find.descendant(of: chips, matching: find.text('View all')),
      findsNothing,
    );
    expect(
      find.descendant(of: chips, matching: find.text('Tourist Spots')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: chips, matching: find.text('Restaurants')),
      findsOneWidget,
    );
  });

  testWidgets('카테고리를 고르면 선택 집합에 더해져 다시 조회한다', (tester) async {
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[
        _liked('a'),
        _liked('b', category: catRestaurant),
      ],
      categories: const <SpotCategory>[catTouristSpot, catRestaurant],
    );

    await _pump(tester, repo);
    // 최초 진입 기본값은 TOURIST_SPOT이다(R4·AC4.1) — 예전의 "전체"(null)가 아니다.
    expect(repo.lastLikedCategoryCodes, <String>[catTouristSpot.code]);

    // 카드에도 같은 카테고리 라벨이 있으므로 칩(FilterChip)으로 한정해 누른다.
    await tester.tap(
      find.descendant(
        of: find.byType(FilterChip),
        matching: find.text('Restaurants'),
      ),
    );
    await tester.pumpAndSettle();

    // 필터링은 서버가 한다 — 고른 카테고리 **집합**이 조회에 실려 나간다.
    // 토글은 기본값을 덮지 않고 **더한다**(R2·AC2.1) — 기본 TOURIST_SPOT에
    // RESTAURANT가 얹혀 둘 다 실린다. 코드는 정렬된 순서다.
    expect(repo.lastLikedCategoryCodes, <String>[
      catRestaurant.code,
      catTouristSpot.code,
    ]);
    // 두 카테고리가 모두 걸렸으므로 둘 다 남는다(OR 필터).
    expect(find.text('Spot a'), findsOneWidget);
    expect(find.text('Spot b'), findsOneWidget);
  });

  testWidgets('목록 카드에는 출처 문구를 얹지 않는다', (tester) async {
    // 출처는 상세 화면의 AttributionBlock이 전문으로 밝힌다 — 작은 썸네일마다
    // 붙이면 제목·주소를 가린다.
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[_liked('a')],
    );

    await _pump(tester, repo);

    expect(find.text('Spot a'), findsOneWidget);
    // 픽스처 문구가 아니라 위젯의 부재를 단언한다 — 문구를 바꿔도 검증이 살아있다.
    expect(find.byType(CopyrightBadge), findsNothing);
  });
}
