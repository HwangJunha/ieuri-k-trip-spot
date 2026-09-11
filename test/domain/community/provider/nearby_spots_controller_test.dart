import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/nearby_spots_providers.dart';

import '../../spot/spot_test_doubles.dart';
import '../community_test_doubles.dart';

/// 컨트롤러가 **전이적으로** 위치 provider를 watch하므로 그것까지 오버라이드해야
/// 컨테이너가 선다 — 빠뜨리면 provider가 오류 상태로 떠 `.future`가 완결되지 않는다.
ProviderContainer _container(FakeCommunityRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      communityRepositoryProvider.overrideWithValue(repo),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

NearbySpot _spot(String id, String title, [double distance = 10]) =>
    NearbySpot(id: id, title: title, distanceMeters: distance);

void main() {
  test('첫 페이지를 받아 누적 상태로 만든다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..nearbySpots = <NearbySpot>[_spot('1', '서울갤러리', 16)];

    final NearbySpotsState state = await _container(
      repo,
    ).read(nearbySpotsControllerProvider.future);

    expect(state.items, hasLength(1));
    expect(state.items.first.title, '서울갤러리');
    expect(state.isEmpty, isFalse);
    // 좌표는 위치 서비스에서 온다 — 화면이 넘기지 않는다.
    expect(repo.lastFetchNearbySpots?.latitude, 37.5);
  });

  test('반경 안에 장소가 없으면 빈 상태다', () async {
    final NearbySpotsState state = await _container(
      FakeCommunityRepository(),
    ).read(nearbySpotsControllerProvider.future);

    expect(state.isEmpty, isTrue);
  });

  test('다음 페이지를 이어 붙인다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..nearbySpots = <NearbySpot>[_spot('1', '가까운 곳')]
      ..nextNearbySpots = <NearbySpot>[_spot('2', '조금 먼 곳')]
      ..nearbySpotsHasNext = true;
    final ProviderContainer container = _container(repo);

    await container.read(nearbySpotsControllerProvider.future);
    await container.read(nearbySpotsControllerProvider.notifier).loadMore();

    final NearbySpotsState state = container
        .read(nearbySpotsControllerProvider)
        .requireValue;
    expect(state.items.map((NearbySpot s) => s.id), <String>['1', '2']);
    // `hasMore`는 서버의 `hasNextPage`를 그대로 따른다(SPEC-0035 AC-30.2).
    expect(state.hasMore, isFalse);
    // 커서 페이징이다 — 이전 페이지의 endCursor를 after로 넘긴다.
    expect(
      repo.lastFetchNearbySpots?.after,
      FakeCommunityRepository.nearbySpotsCursor,
    );
  });

  test('더 받을 것이 없으면 추가 조회를 하지 않는다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..nearbySpots = <NearbySpot>[_spot('1', '하나뿐')];
    final ProviderContainer container = _container(repo);

    await container.read(nearbySpotsControllerProvider.future);
    await container.read(nearbySpotsControllerProvider.notifier).loadMore();

    expect(repo.nearbySpotsCalls, 1);
    expect(repo.lastFetchNearbySpots?.after, isNull);
  });

  // SPEC-0035 R30 — 시트 「주변」 탭은 `location.spots`를 커서로 쓴다.
  test('AC-30.1 · 첫 요청은 반경 5000·first 50·커서 없음이다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository();

    await _container(repo).read(nearbySpotsControllerProvider.future);

    expect(repo.nearbySpotsCalls, 1);
    expect(repo.lastFetchNearbySpots?.radiusMeters, nearbySpotsRadiusMeters);
    expect(repo.lastFetchNearbySpots?.first, nearbySpotsPageSize);
    expect(repo.lastFetchNearbySpots?.after, isNull);
  });

  // SPEC-0013 R14 — 주변 탭은 이제 받아 둔 목록을 거르지 않고 서버 검색을 부른다.
  group('SpotSearchList — 서버 검색 (R14)', () {
    test('AC-14.1 · 질의를 서버로 보낸다 (클라이언트 필터가 아니다)', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        // 주변 목록에는 '경복궁'이 없다. 클라이언트 필터였다면 결과가 비었을 것이다.
        ..nearbySpots = <NearbySpot>[_spot('1', '서울갤러리')]
        ..searchResults = <NearbySpot>[_spot('2', '경복궁')];
      final ProviderContainer container = _container(repo);
      // 디바운스 대기 중 autoDispose provider가 폐기되면 조회가 나가지 않는다 —
      // 구독을 유지해 실제 화면과 같은 조건으로 둔다.
      container.listen(
        spotSearchListProvider('경복'),
        (_, _) {},
        fireImmediately: true,
      );

      final SpotSearchListState state = await container.read(
        spotSearchListProvider('경복').future,
      );

      expect(repo.lastSearchQuery, '경복');
      expect(state.items.map((NearbySpot s) => s.id), <String>['2']);
    });

    test('AC-14.2 · 질의가 있어도 다음 페이지를 이어 받는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..searchResults = <NearbySpot>[_spot('1', '경복궁')]
        ..searchHasNextPage = true;
      final ProviderContainer container = _container(repo);
      // autoDispose provider가 조회 도중 폐기되지 않도록 구독을 유지한다.
      container.listen(
        spotSearchListProvider('경복'),
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(spotSearchListProvider('경복').future);

      repo.searchResults = <NearbySpot>[_spot('2', '경복궁 야간개장')];
      repo.searchHasNextPage = false;
      await container.read(spotSearchListProvider('경복').notifier).loadMore();

      final SpotSearchListState state = container
          .read(spotSearchListProvider('경복'))
          .value!;
      expect(state.items.map((NearbySpot s) => s.id), <String>['1', '2']);
      // 다음 페이지 번호로 이어 받았다(오프셋 페이징).
      expect(repo.lastSearchPage, 1);
    });

    test('시트 카테고리 칩이 검색에도 걸린다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..searchResults = <NearbySpot>[_spot('1', '무교동 북어국집')];
      final ProviderContainer container = _container(repo);
      container
          .read(nearbySpotCategoryFilterProvider.notifier)
          .set(NearbySpotCategory.restaurant);
      container.listen(
        spotSearchListProvider('북어'),
        (_, _) {},
        fireImmediately: true,
      );

      // 카테고리를 바꾸면 build가 다시 도는데, 그 재빌드가 끝날 때까지 기다린다.
      await container.read(spotSearchListProvider('북어').future);
      await container.read(spotSearchListProvider('북어').future);

      // 칩과 검색창이 한 시트에 있으니 둘이 함께 걸린다.
      expect(repo.lastSearchCategory, NearbySpotCategory.restaurant);
    });

    test('AC-14.3 · 빈 질의는 서버를 부르지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);
      container.listen(
        spotSearchListProvider('   '),
        (_, _) {},
        fireImmediately: true,
      );

      final SpotSearchListState state = await container.read(
        spotSearchListProvider('   ').future,
      );

      // 질의를 지우면 시트가 좌표 기반 목록으로 되돌아가므로 검색은 나가지 않는다.
      expect(repo.searchCallCount, 0);
      expect(state.items, isEmpty);
    });
  });

  group('NearbySpotQuery', () {
    test('입력한 필터가 상태에 반영된다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      container.read(nearbySpotQueryProvider.notifier).set('경복');

      expect(container.read(nearbySpotQueryProvider), '경복');
    });
  });

  group('카테고리 필터 — 이름 필터와 달리 서버가 거른다', () {
    test('처음에는 전체(null)다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      expect(container.read(nearbySpotCategoryFilterProvider), isNull);
    });

    test('카테고리를 고르면 그 값으로 페이지 0부터 다시 조회한다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot('1', '경복궁')]
        ..nearbySpotsByCategory = <NearbySpotCategory, List<NearbySpot>>{
          NearbySpotCategory.restaurant: <NearbySpot>[_spot('2', '무교동 북어국집')],
        };
      final ProviderContainer container = _container(repo);
      // 구독을 유지해야 autoDispose provider가 재조회 도중 폐기되지 않는다.
      container.listen(
        nearbySpotsControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(nearbySpotsControllerProvider.future);

      container
          .read(nearbySpotCategoryFilterProvider.notifier)
          .set(NearbySpotCategory.restaurant);
      final NearbySpotsState state = await container.read(
        nearbySpotsControllerProvider.future,
      );

      expect(
        repo.lastFetchNearbySpots?.category,
        NearbySpotCategory.restaurant,
      );
      // 커서는 조건에 묶여 있으므로 이어 붙이지 않고 커서 없이 처음부터 받는다(AC-30.3).
      expect(repo.lastFetchNearbySpots?.after, isNull);
      expect(state.items.map((NearbySpot s) => s.id), <String>['2']);
    });

    test('전체로 되돌리면 카테고리 없이 다시 조회한다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot('1', '경복궁')];
      final ProviderContainer container = _container(repo);
      container.listen(
        nearbySpotsControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(nearbySpotsControllerProvider.future);

      container
          .read(nearbySpotCategoryFilterProvider.notifier)
          .set(NearbySpotCategory.lodging);
      await container.read(nearbySpotsControllerProvider.future);
      container.read(nearbySpotCategoryFilterProvider.notifier).set(null);
      await container.read(nearbySpotsControllerProvider.future);

      expect(repo.lastFetchNearbySpots?.category, isNull);
    });

    test('카테고리 목록은 서버가 준 것을 그대로 쓴다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..spotCategories = <NearbySpotCategory>[
          NearbySpotCategory.touristSpot,
          NearbySpotCategory.restaurant,
        ];

      final List<NearbySpotCategory> categories = await _container(
        repo,
      ).read(nearbySpotCategoriesProvider.future);

      expect(categories, <NearbySpotCategory>[
        NearbySpotCategory.touristSpot,
        NearbySpotCategory.restaurant,
      ]);
    });
  });

  // 한 페이지에 더 받아 둘수록 이름 필터가 짚는 범위가 넓어진다. 50은 서버가 그대로
  // 지켜 주는 값이다(라이브 확인).
  test('한 번에 50건을 요청한다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository();

    await _container(repo).read(nearbySpotsControllerProvider.future);

    expect(repo.lastFetchNearbySpots?.first, 50);
  });
}
