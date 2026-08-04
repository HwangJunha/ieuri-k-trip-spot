import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/component/copyright_badge.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/liked_spots_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

LikedSpot _liked(
  String id, {
  SpotCategory category = SpotCategory.touristSpot,
}) => LikedSpot(
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
      categories: const <SpotCategory>[
        SpotCategory.touristSpot,
        SpotCategory.restaurant,
      ],
    );

    await _pump(tester, repo);

    // 첫 칩은 "전체", 뒤로 서버가 준 카테고리가 붙는다. 카드에도 카테고리 라벨이
    // 있으므로 칩으로 한정해 센다.
    final Finder chips = find.byType(ChoiceChip);
    expect(
      find.descendant(of: chips, matching: find.text('View all')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: chips, matching: find.text('Restaurants')),
      findsOneWidget,
    );
  });

  testWidgets('카테고리를 고르면 그 필터로 다시 조회한다', (tester) async {
    final FakeSpotRepository repo = FakeSpotRepository(
      liked: <LikedSpot>[
        _liked('a'),
        _liked('b', category: SpotCategory.restaurant),
      ],
      categories: const <SpotCategory>[
        SpotCategory.touristSpot,
        SpotCategory.restaurant,
      ],
    );

    await _pump(tester, repo);
    expect(repo.lastLikedCategory, isNull);

    // 카드에도 같은 카테고리 라벨이 있으므로 칩(ChoiceChip)으로 한정해 누른다.
    await tester.tap(
      find.descendant(
        of: find.byType(ChoiceChip),
        matching: find.text('Restaurants'),
      ),
    );
    await tester.pumpAndSettle();

    // 필터링은 서버가 한다 — 카테고리가 조회에 실려 나간다.
    expect(repo.lastLikedCategory, SpotCategory.restaurant);
    expect(find.text('Spot b'), findsOneWidget);
    expect(find.text('Spot a'), findsNothing);
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
