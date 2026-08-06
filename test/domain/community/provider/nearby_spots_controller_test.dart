import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
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
    expect(state.hasMore, isFalse);
    // 커서가 아니라 오프셋이다 — 다음 페이지 번호로 조회한다.
    expect(repo.lastFetchNearbySpots?.page, 1);
  });

  test('더 받을 것이 없으면 추가 조회를 하지 않는다', () async {
    final FakeCommunityRepository repo = FakeCommunityRepository()
      ..nearbySpots = <NearbySpot>[_spot('1', '하나뿐')];
    final ProviderContainer container = _container(repo);

    await container.read(nearbySpotsControllerProvider.future);
    await container.read(nearbySpotsControllerProvider.notifier).loadMore();

    expect(repo.lastFetchNearbySpots?.page, 0);
  });

  group('filtered — 받아 둔 목록만 좁힌다', () {
    test('제목으로 좁힌다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..nearbySpots = <NearbySpot>[_spot('1', '서울갤러리'), _spot('2', '경복궁')];

      final NearbySpotsState state = await _container(
        repo,
      ).read(nearbySpotsControllerProvider.future);

      expect(state.filtered('경복').map((NearbySpot s) => s.id), <String>['2']);
      // 빈 질의는 전부를 남긴다.
      expect(state.filtered(''), hasLength(2));
    });
  });

  group('NearbySpotQuery', () {
    test('입력한 필터가 상태에 반영된다', () {
      final ProviderContainer container = _container(FakeCommunityRepository());

      container.read(nearbySpotQueryProvider.notifier).set('경복');

      expect(container.read(nearbySpotQueryProvider), '경복');
    });
  });
}
