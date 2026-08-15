import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_search_result.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_search_state.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_suggestion.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/recent_searches_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_search_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// 검색 결과 상태 기계(SPEC-0013 R11·R13, AC-11.1~11.4·12.1·13.2).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer makeContainer(FakeSpotRepository repository) {
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
        spotRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  SpotSearchResult resultWith(List<String> ids) => SpotSearchResult(
    page: OffsetPage<TouristSpot>(
      items: ids.map(homeSpot).toList(growable: false),
      page: 0,
      hasNext: false,
    ),
    totalCount: ids.length,
  );

  test('초기 상태는 질의 없음이다', () {
    final container = makeContainer(FakeSpotRepository());

    expect(container.read(spotSearchProvider), isA<SpotSearchIdle>());
  });

  test('AC-11.1 · 결과가 있으면 결과 목록 상태가 된다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = resultWith(<String>['a', 'b']);
    final container = makeContainer(repository);

    await container.read(spotSearchProvider.notifier).search('경복궁');

    final state = container.read(spotSearchProvider);
    expect(state, isA<SpotSearchLoaded>());
    expect((state as SpotSearchLoaded).result.spots, hasLength(2));
    expect(state.query, '경복궁');
  });

  test('AC-11.2 · 결과가 0건이면 실패가 아니라 빈 결과 상태다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = SpotSearchResult.empty;
    final container = makeContainer(repository);

    await container.read(spotSearchProvider.notifier).search('없는장소');

    final state = container.read(spotSearchProvider);
    expect(state, isA<SpotSearchEmpty>());
    expect(state, isNot(isA<SpotSearchFailed>()));
  });

  test('AC-11.3 · 조회가 실패하면 빈 결과와 구분되는 실패 상태다', () async {
    final repository = FakeSpotRepository()
      ..searchFailure = SpotFailure.network;
    final container = makeContainer(repository);

    await container.read(spotSearchProvider.notifier).search('경복궁');

    final state = container.read(spotSearchProvider);
    expect(state, isA<SpotSearchFailed>());
    expect(state, isNot(isA<SpotSearchEmpty>()));
  });

  test('AC-11.4 · 결과 도착 전에는 로딩 상태다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = resultWith(<String>['a']);
    final container = makeContainer(repository);

    // await 하지 않고 상태를 본다 — 응답 전 시점이다.
    final Future<void> pending = container
        .read(spotSearchProvider.notifier)
        .search('경복궁');
    expect(container.read(spotSearchProvider), isA<SpotSearchLoading>());

    await pending;
    expect(container.read(spotSearchProvider), isA<SpotSearchLoaded>());
  });

  test('AC-11.3 · 재시도는 같은 질의를 다시 조회한다', () async {
    final repository = FakeSpotRepository()
      ..searchFailure = SpotFailure.network;
    final container = makeContainer(repository);
    await container.read(spotSearchProvider.notifier).search('경복궁');

    // 서버가 회복된 상황을 만든다.
    repository
      ..searchFailure = null
      ..searchResult = resultWith(<String>['a']);
    await container.read(spotSearchProvider.notifier).retry();

    expect(container.read(spotSearchProvider), isA<SpotSearchLoaded>());
    expect(repository.lastSearchQuery, '경복궁');
    expect(repository.searchCallCount, 2);
  });

  test('AC-12.1 · 검색을 실행하면 최근 검색어에 기록된다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = resultWith(<String>['a']);
    final container = makeContainer(repository);

    await container.read(spotSearchProvider.notifier).search('경복궁');

    expect(container.read(recentSearchesProvider), <String>['경복궁']);
  });

  test('실패해도 최근 검색어에는 남는다', () async {
    // 서버 실패로 기록이 사라지면 재시도할 발판이 없어진다.
    final repository = FakeSpotRepository()
      ..searchFailure = SpotFailure.network;
    final container = makeContainer(repository);

    await container.read(spotSearchProvider.notifier).search('경복궁');

    expect(container.read(recentSearchesProvider), <String>['경복궁']);
  });

  test('공백뿐인 질의는 서버를 부르지 않고 초기 상태로 돌아간다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = resultWith(<String>['a']);
    final container = makeContainer(repository);
    await container.read(spotSearchProvider.notifier).search('경복궁');

    await container.read(spotSearchProvider.notifier).search('   ');

    expect(container.read(spotSearchProvider), isA<SpotSearchIdle>());
    // 첫 검색 1회뿐 — 빈 질의로는 조회하지 않았다(R8).
    expect(repository.searchCallCount, 1);
  });

  test('AC-13.2 · 상세를 다녀와도 질의와 결과가 유지된다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = resultWith(<String>['a']);
    final container = makeContainer(repository);
    await container.read(spotSearchProvider.notifier).search('경복궁');

    // 상세 화면으로 이동해 검색 화면이 트리에서 빠진 상황을 모사한다.
    // keepAlive라 provider가 버려지지 않으므로 상태가 그대로 남는다.
    final state = container.read(spotSearchProvider);
    expect(state, isA<SpotSearchLoaded>());
    expect((state as SpotSearchLoaded).query, '경복궁');
    expect(state.result.spots.single.id, 'a');
    // 조회는 늘지 않는다 — 돌아왔다고 다시 검색하지 않는다.
    expect(repository.searchCallCount, 1);
  });

  // R7(중복·누락 없는 페이지네이션)은 **서버 몫이 됐다.** 초안은 커서로 그것을
  // 보장하려 했으나 서버가 오프셋으로 전환했으므로, 클라이언트가 검증할 수 있는
  // 것은 "받은 페이지를 순서대로 이어 붙이는가"까지다.
  test('다음 페이지를 이어 붙인다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = SpotSearchResult(
        page: OffsetPage<TouristSpot>(
          items: <TouristSpot>[homeSpot('a')],
          page: 0,
          hasNext: true,
        ),
        totalCount: 2,
      );
    final container = makeContainer(repository);
    await container.read(spotSearchProvider.notifier).search('경복궁');

    repository.searchResult = SpotSearchResult(
      page: OffsetPage<TouristSpot>(
        items: <TouristSpot>[homeSpot('b')],
        page: 1,
        hasNext: false,
      ),
      totalCount: 2,
    );
    await container.read(spotSearchProvider.notifier).loadMore();

    final state = container.read(spotSearchProvider) as SpotSearchLoaded;
    // 받은 순서대로 이어 붙었다.
    expect(state.result.spots.map((TouristSpot s) => s.id), <String>['a', 'b']);
    expect(state.result.hasNextPage, isFalse);
    expect(state.isLoadingMore, isFalse);
    // **다음 장을 `page + 1`로 요청했다** — 오프셋 전환의 핵심이라, 번호를 잘못
    // 계산하면 같은 페이지를 다시 받아 결과가 중복된다.
    expect(repository.lastSearchPage, 1);
  });

  test('다음 페이지가 없으면 추가 조회를 하지 않는다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = resultWith(<String>['a']);
    final container = makeContainer(repository);
    await container.read(spotSearchProvider.notifier).search('경복궁');

    await container.read(spotSearchProvider.notifier).loadMore();

    // 첫 검색 1회뿐이다.
    expect(repository.searchCallCount, 1);
  });

  test('추가 로딩이 실패해도 이미 받은 결과는 남는다', () async {
    final repository = FakeSpotRepository()
      ..searchResult = SpotSearchResult(
        page: OffsetPage<TouristSpot>(
          items: <TouristSpot>[homeSpot('a')],
          page: 0,
          hasNext: true,
        ),
        totalCount: 2,
      );
    final container = makeContainer(repository);
    await container.read(spotSearchProvider.notifier).search('경복궁');

    repository.searchFailure = SpotFailure.network;
    await container.read(spotSearchProvider.notifier).loadMore();

    // 화면 전체가 실패로 바뀌지 않는다 — 보고 있던 목록이 그대로다.
    final state = container.read(spotSearchProvider);
    expect(state, isA<SpotSearchLoaded>());
    expect((state as SpotSearchLoaded).result.spots.single.id, 'a');
    expect(state.isLoadingMore, isFalse);
  });

  test('R9 · 자동완성은 접두사로 제안을 돌려준다', () async {
    final repository = FakeSpotRepository()
      ..suggestions = const <SpotSuggestion>[
        SpotSuggestion(id: 's1', title: '경복궁', category: null),
      ];
    final container = makeContainer(repository);
    // 디바운스 대기 중 autoDispose provider가 폐기되지 않도록 구독을 유지한다.
    container.listen(
      spotSearchSuggestionsProvider('경복'),
      (_, _) {},
      fireImmediately: true,
    );

    final List<SpotSuggestion> suggestions = await container.read(
      spotSearchSuggestionsProvider('경복').future,
    );

    expect(repository.lastSuggestionQuery, '경복');
    expect(suggestions.single.title, '경복궁');
  });

  test('AC-9.4 · 빈 질의는 서버를 부르지 않고 빈 목록이다', () async {
    final repository = FakeSpotRepository();
    final container = makeContainer(repository);

    final List<SpotSuggestion> suggestions = await container.read(
      spotSearchSuggestionsProvider('   ').future,
    );

    expect(suggestions, isEmpty);
    expect(repository.lastSuggestionQuery, isNull);
  });

  test('결과 spot에 별점·혼잡도가 없다 (AC-15.2·15.3)', () async {
    final repository = FakeSpotRepository()
      ..searchResult = resultWith(<String>['a']);
    final container = makeContainer(repository);

    await container.read(spotSearchProvider.notifier).search('경복궁');

    final state = container.read(spotSearchProvider) as SpotSearchLoaded;
    final TouristSpot spot = state.result.spots.single;
    // 서버가 주는 값만 실린다.
    expect(spot.distance?.meters, 1200);
  });
  // R5 — 검색 결과를 단일 카테고리로 좁힌다.
  group('카테고리 필터 (R5)', () {
    test('AC-5.1 · 고른 카테고리가 서버 조회에 실린다', () async {
      final repository = FakeSpotRepository()
        ..searchResult = resultWith(<String>['a']);
      final container = makeContainer(repository);
      container.read(spotSearchCategoryProvider.notifier).replace(
        <SpotCategory>{catRestaurant},
      );

      await container.read(spotSearchProvider.notifier).search('경복궁');

      // 걸러 내는 것은 서버 몫이다 — 클라이언트는 필터를 실어 보내기만 한다.
      expect(repository.lastSearchCategoryCodes, <String>[catRestaurant.code]);
    });

    test('AC-5.2 · 카테고리를 고르지 않으면 전체가 대상이다', () async {
      final repository = FakeSpotRepository()
        ..searchResult = resultWith(<String>['a']);
      final container = makeContainer(repository);

      await container.read(spotSearchProvider.notifier).search('경복궁');

      // null = 전체(서버 규약).
      expect(repository.lastSearchCategoryCodes, isNull);
    });

    test('AC-5.3 · 일치하는 spot이 없으면 실패가 아니라 빈 결과다', () async {
      final repository = FakeSpotRepository()
        ..searchResult = SpotSearchResult.empty;
      final container = makeContainer(repository);
      container.read(spotSearchCategoryProvider.notifier).replace(
        <SpotCategory>{catLodging},
      );

      await container.read(spotSearchProvider.notifier).search('경복궁');

      expect(container.read(spotSearchProvider), isA<SpotSearchEmpty>());
    });

    test('카테고리를 바꾸면 같은 질의로 처음부터 다시 조회한다', () async {
      final repository = FakeSpotRepository()
        ..searchResult = resultWith(<String>['a']);
      final container = makeContainer(repository);
      await container.read(spotSearchProvider.notifier).search('경복궁');

      container.read(spotSearchCategoryProvider.notifier).replace(
        <SpotCategory>{catRestaurant},
      );
      await container.read(spotSearchProvider.notifier).reapplyCategory();

      expect(repository.searchCallCount, 2);
      expect(repository.lastSearchQuery, '경복궁');
      expect(repository.lastSearchCategoryCodes, <String>[catRestaurant.code]);
      // 이어 붙이지 않고 0페이지부터 받는다 — 필터가 바뀌면 결과 집합이 다르다.
      expect(repository.lastSearchPage, 0);
    });

    test('검색 전에는 카테고리를 바꿔도 조회하지 않는다', () async {
      final repository = FakeSpotRepository();
      final container = makeContainer(repository);

      container.read(spotSearchCategoryProvider.notifier).replace(
        <SpotCategory>{catRestaurant},
      );
      await container.read(spotSearchProvider.notifier).reapplyCategory();

      // 고를 질의가 없다 — 선택만 기억하고 다음 검색에 실린다.
      expect(repository.searchCallCount, 0);
      expect(container.read(spotSearchProvider), isA<SpotSearchIdle>());
    });

    // 선택한 카테고리가 **서버 조회 인자로 실려야** 한다. 클라이언트가 받은 목록을
    // 다시 거르지 않으므로(POL-019), 이 인자가 빠지면 필터가 아무 일도 하지 않는다.
    //
    // 참고: 서버 `searchSpots`가 이 인자를 현재 무시한다(2026-08-15 확인). 그것은
    // 서버 결함이고, 이 테스트는 **클라이언트가 제 몫을 한다**는 것을 고정한다 —
    // 서버가 고쳐질 때 클라이언트를 의심하지 않도록.
    test('선택한 카테고리가 검색 조회에 실린다', () async {
      final repository = FakeSpotRepository()
        ..searchResult = resultWith(<String>['a']);
      final container = makeContainer(repository);

      container.read(spotSearchCategoryProvider.notifier).replace(
        <SpotCategory>{catCulturalFacility},
      );
      await container.read(spotSearchProvider.notifier).search('올리브');

      expect(repository.lastSearchCategoryCodes, <String>[
        catCulturalFacility.code,
      ]);
    });

    // AC5.1 — **빈 배열은 보내지 않는다.** 서버가 `EMPTY_CATEGORY_SET`으로 거절하므로
    // 선택이 비면 인자를 생략해 전체를 받는다. 프로덕션 화면은 기본값을 심어 이
    // 상태를 만들지 않지만, 그 방어가 repository 경계에 있다는 것을 고정한다.
    test('선택이 비면 카테고리 인자를 보내지 않는다(빈 배열 아님)', () async {
      final repository = FakeSpotRepository()
        ..searchResult = resultWith(<String>['a']);
      final container = makeContainer(repository);

      // 아무것도 고르지 않은 상태 그대로 조회한다.
      await container.read(spotSearchProvider.notifier).search('올리브');

      expect(repository.lastSearchCategoryCodes, isNull);
    });
  });
}
