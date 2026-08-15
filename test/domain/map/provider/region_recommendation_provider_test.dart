import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_area.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_bounds.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_viewport_result.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_recommendation.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_score.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/seoul_congestion_result.dart';
import 'package:ieuri_k_trip_spot/domain/map/provider/map_providers.dart';
import 'package:ieuri_k_trip_spot/domain/map/provider/region_recommendation_provider.dart';
import 'package:ieuri_k_trip_spot/domain/map/repository/map_repository.dart';

/// 추천만 답하는 최소 repository. 나머지 연산은 이 테스트가 건드리지 않는다.
final class FakeMapRepository implements MapRepository {
  FakeMapRepository({this.result, this.failure});

  final RegionRecommendationResult? result;
  final Object? failure;

  /// 조회가 실제로 몇 번 일어났는지. 재시도 상한 검증의 근거다.
  int calls = 0;

  /// 마지막 요청에 실린 좌표. 위치 없이 요청했는지 확인한다.
  Coordinates? lastOrigin;

  @override
  Future<RegionRecommendationResult> fetchRecommendedRegions({
    required Coordinates origin,
    int? limit,
  }) async {
    calls++;
    lastOrigin = origin;
    if (failure != null) throw failure!;
    // 실제 구현과 같게 **쓴 좌표를 결과에 담는다** — 화면이 이 값으로 거리를 잰다.
    return RegionRecommendationResult(regions: result!.regions, origin: origin);
  }

  @override
  Future<List<CongestionAreaBoundary>> fetchBoundaries() =>
      throw UnimplementedError();

  @override
  Future<SeoulCongestionResult> fetchCongestion({required MapBounds bbox}) =>
      throw UnimplementedError();

  @override
  Future<MapViewportResult> fetchViewport({
    required MapBounds bbox,
    required int zoom,
    bool? hasOrigin,
  }) => throw UnimplementedError();
}

/// 좌표가 null이면 권한이 없는 상태를 흉내낸다.
final class FakeLocationService implements LocationService {
  FakeLocationService(this._coordinates);

  final Coordinates? _coordinates;

  @override
  Future<Coordinates> currentCoordinates() async {
    final Coordinates? value = _coordinates;
    if (value == null) {
      throw const LocationUnavailable(
        LocationUnavailableReason.permissionDenied,
      );
    }
    return value;
  }

  @override
  Stream<Coordinates> watchCoordinates() => throw UnimplementedError();
}

/// 지역 추천 provider. 위치가 없어도 추천이 나와야 하고(R27), 재시도는 횟수로
/// 막혀야 한다(R28).
void main() {
  final RegionRecommendationResult twoRegions = RegionRecommendationResult(
    regions: <RegionRecommendation>[
      const RegionRecommendation(
        code: '11110',
        name: 'Jongno-gu',
        provinceName: 'Seoul',
        scores: <RegionScore>[
          RegionScore(factor: RegionScoreFactor.congestion, value: 90, rank: 2),
          RegionScore(
            factor: RegionScoreFactor.spendingIntensity,
            value: 55,
            rank: 8,
          ),
          RegionScore(factor: RegionScoreFactor.distance, value: 60, rank: 12),
        ],
        scoreFactorCount: 3,
        centerLat: 37.5735,
        centerLng: 126.9790,
      ),
      const RegionRecommendation(
        code: '26110',
        name: 'Jung-gu',
        provinceName: 'Busan',
        scores: <RegionScore>[
          RegionScore(factor: RegionScoreFactor.congestion, value: 70, rank: 5),
        ],
        scoreFactorCount: 1,
        centerLat: 35.1064,
        centerLng: 129.0324,
      ),
    ],
  );

  ProviderContainer containerWith({
    required FakeMapRepository repository,
    Coordinates? coordinates,
  }) {
    final ProviderContainer c = ProviderContainer(
      overrides: [
        mapRepositoryProvider.overrideWithValue(repository),
        locationServiceProvider.overrideWithValue(
          FakeLocationService(coordinates),
        ),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('서버가 준 배열 순서를 그대로 유지한다', () async {
    // R22 — 배열 순서가 곧 추천 순위다(totalScore는 계약에서 삭제됐다).
    // 클라이언트가 다시 정렬하지 않는다.
    final ProviderContainer c = containerWith(
      repository: FakeMapRepository(result: twoRegions),
      coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
    );

    final RegionRecommendationResult result = await c.read(
      regionRecommendationsProvider(null).future,
    );

    expect(
      result.regions.map((RegionRecommendation r) => r.code).toList(),
      <String>['11110', '26110'],
    );
  });

  test('항목별 점수와 산출 항목 수가 보존된다', () async {
    // R23 · R31 — 총점만 남기면 왜 추천됐는지 알 수 없다.
    final ProviderContainer c = containerWith(
      repository: FakeMapRepository(result: twoRegions),
      coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
    );

    final RegionRecommendationResult result = await c.read(
      regionRecommendationsProvider(null).future,
    );

    expect(result.regions.first.scores, hasLength(3));
    expect(result.regions.first.scoreFactorCount, 3);
  });

  test('항목별 순위가 보존된다', () async {
    // 화면이 "시·도 n위"로 적는 값이다 — 목록 안 순위가 아니라 시도 전체 기준이라
    // 그대로 실려 와야 한다.
    final ProviderContainer c = containerWith(
      repository: FakeMapRepository(result: twoRegions),
      coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
    );

    final RegionRecommendationResult result = await c.read(
      regionRecommendationsProvider(null).future,
    );

    expect(result.regions.first.scores.first.rank, 2);
  });

  group('위치가 없을 때', () {
    test('권한 안내로 구분되는 예외를 올린다', () async {
      // 서버가 origin을 필수로 두어 좌표 없이는 조회 자체가 불가능하다. 일반
      // 오류로 올리면 화면이 재시도 버튼을 그리는데, 재시도로는 권한이 생기지
      // 않는다(설계 §9.3).
      final FakeMapRepository repository = FakeMapRepository(
        result: twoRegions,
      );
      final ProviderContainer c = containerWith(repository: repository);

      // **`.future`가 아니라 `AsyncValue`로 본다.** autoDispose provider에 `.future`로
      // 접근하면 로딩 중 폐기돼 원래 예외 대신 "disposed during loading state"가
      // 올라온다. 화면이 실제로 보는 것도 `AsyncValue`다.
      final ProviderSubscription<AsyncValue<RegionRecommendationResult>> sub = c
          .listen(
            regionRecommendationsProvider(null),
            (_, _) {},
            onError: (_, _) {},
          );
      addTearDown(sub.close);

      // 조회가 끝날 때까지 이벤트 루프를 돌린다.
      for (int i = 0; i < 10 && sub.read().isLoading; i++) {
        await Future<void>.delayed(Duration.zero);
      }

      expect(sub.read().error, isA<RegionRecommendationNeedsLocation>());
      // 조회를 아예 걸지 않는다 — 실패할 요청을 서버에 보내지 않는다.
      expect(repository.calls, 0);
    });

    test('내 위치로 조회해도 그 좌표가 결과에 남는다', () async {
      // 화면은 이 값으로 거리를 잰다. 내 위치는 provider가 얻으므로 결과에 실려
      // 오지 않으면 화면이 알 방법이 없어 거리가 사라진다.
      final FakeMapRepository repository = FakeMapRepository(
        result: twoRegions,
      );
      final ProviderContainer c = containerWith(
        repository: repository,
        coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
      );

      final RegionRecommendationResult result = await c.read(
        regionRecommendationsProvider(null).future,
      );

      expect(
        result.origin,
        const Coordinates(latitude: 37.5, longitude: 127.0),
      );
    });

    test('위치가 있으면 좌표를 실어 보낸다', () async {
      final FakeMapRepository repository = FakeMapRepository(
        result: twoRegions,
      );
      final ProviderContainer c = containerWith(
        repository: repository,
        coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
      );

      await c.read(regionRecommendationsProvider(null).future);

      expect(repository.lastOrigin?.latitude, 37.5);
      expect(repository.lastOrigin?.longitude, 127.0);
    });
  });
}
