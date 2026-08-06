import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/nearby_spots_providers.dart';

import '../community_test_doubles.dart';

/// **위치 provider를 오버라이드하지 않는다** — `likedSpots`는 좌표를 받지 않아
/// 컨트롤러가 위치를 watch하지 않기 때문이다. 그것이 이 탭의 성질이다.
ProviderContainer _container(FakeCommunityRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [communityRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// 좋아요한 장소는 거리가 없다 — 서버가 좌표를 받지 않는다.
NearbySpot _liked(String id, String title) =>
    NearbySpot(id: id, title: title, address: '서울특별시');

void main() {
  test('첫 페이지를 받아 누적 상태로 만든다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..likedSpots = <NearbySpot>[_liked('5092', '국회박물관')];

    final LikedSpotsState state = await _container(
      repo,
    ).read(likedSpotsControllerProvider.future);

    expect(state.items, hasLength(1));
    expect(state.items.first.title, '국회박물관');
    expect(state.items.first.distanceMeters, isNull);
    expect(state.isEmpty, isFalse);
  });

  // 좋아요한 장소가 없는 계정이 정상 상태다 — 화면이 오류가 아니라 빈 안내를 그린다.
  test('좋아요한 장소가 없으면 빈 상태다', () async {
    final LikedSpotsState state = await _container(
      FakeCommunityRepository(),
    ).read(likedSpotsControllerProvider.future);

    expect(state.isEmpty, isTrue);
  });

  // 주변 목록과 달리 **커서**로 이어 붙인다.
  test('다음 페이지를 커서로 이어 붙인다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..likedSpots = <NearbySpot>[_liked('1', '첫 장소')]
      ..nextLikedSpots = <NearbySpot>[_liked('2', '다음 장소')]
      ..likedSpotsHasNext = true;
    final ProviderContainer container = _container(repo);

    await container.read(likedSpotsControllerProvider.future);
    await container.read(likedSpotsControllerProvider.notifier).loadMore();

    final LikedSpotsState state = container
        .read(likedSpotsControllerProvider)
        .requireValue;
    expect(state.items.map((NearbySpot s) => s.id), <String>['1', '2']);
    expect(state.hasMore, isFalse);
    // 페이지 번호가 아니라 커서를 넘긴다.
    expect(repo.lastFetchLiked?.after, 'liked-cursor-1');
  });

  test('더 받을 것이 없으면 추가 조회를 하지 않는다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..likedSpots = <NearbySpot>[_liked('1', '하나뿐')];
    final ProviderContainer container = _container(repo);

    await container.read(likedSpotsControllerProvider.future);
    await container.read(likedSpotsControllerProvider.notifier).loadMore();

    expect(repo.likedSpotsCalls, 1);
  });

  // 카테고리 줄 하나가 두 출처에 함께 걸린다.
  test('카테고리를 고르면 그 값으로 처음부터 다시 조회한다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..likedSpots = <NearbySpot>[_liked('1', '국회박물관')]
      ..likedSpotsByCategory = <NearbySpotCategory, List<NearbySpot>>{
        NearbySpotCategory.restaurant: <NearbySpot>[_liked('2', '무교동 북어국집')],
      };
    final ProviderContainer container = _container(repo);
    // 구독을 유지해야 autoDispose provider가 재조회 도중 폐기되지 않는다.
    container.listen(
      likedSpotsControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );
    await container.read(likedSpotsControllerProvider.future);

    container
        .read(nearbySpotCategoryFilterProvider.notifier)
        .set(NearbySpotCategory.restaurant);
    final LikedSpotsState state = await container.read(
      likedSpotsControllerProvider.future,
    );

    expect(repo.lastFetchLiked?.category, NearbySpotCategory.restaurant);
    // 커서는 카테고리마다 다르므로 이어 붙이지 않고 처음부터 받는다.
    expect(repo.lastFetchLiked?.after, isNull);
    expect(state.items.map((NearbySpot s) => s.id), <String>['2']);
  });

  group('filtered — 받아 둔 목록만 좁힌다', () {
    test('제목으로 좁힌다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..likedSpots = <NearbySpot>[_liked('1', '국회박물관'), _liked('2', '경복궁')];

      final LikedSpotsState state = await _container(
        repo,
      ).read(likedSpotsControllerProvider.future);

      expect(state.filtered('경복').map((NearbySpot s) => s.id), <String>['2']);
      expect(state.filtered(''), hasLength(2));
    });
  });

  group('SpotPickerSourceTab', () {
    // 주변이 기본이다 — 컴포저에서 고르는 장소는 대개 지금 있는 곳이다.
    test('처음에는 주변이다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      expect(
        container.read(spotPickerSourceTabProvider),
        SpotPickerSource.nearby,
      );
    });

    test('탭을 바꾸면 상태에 반영된다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      container
          .read(spotPickerSourceTabProvider.notifier)
          .set(SpotPickerSource.liked);

      expect(
        container.read(spotPickerSourceTabProvider),
        SpotPickerSource.liked,
      );
    });
  });
}
