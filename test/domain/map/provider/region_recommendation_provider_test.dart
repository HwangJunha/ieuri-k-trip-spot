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
    Coordinates? origin,
  }) async {
    calls++;
    lastOrigin = origin;
    if (failure != null) throw failure!;
    return result!;
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
        totalScore: 88,
        scores: <RegionScore>[
          RegionScore(factor: RegionScoreFactor.congestion, value: 90),
          RegionScore(factor: RegionScoreFactor.distance, value: 60),
        ],
        scoreFactorCount: 2,
        centerLat: 37.5735,
        centerLng: 126.9790,
      ),
      const RegionRecommendation(
        code: '26110',
        name: 'Jung-gu',
        provinceName: 'Busan',
        totalScore: 72,
        scores: <RegionScore>[
          RegionScore(factor: RegionScoreFactor.congestion, value: 70),
        ],
        scoreFactorCount: 1,
        centerLat: 35.1064,
        centerLng: 129.0324,
      ),
    ],
    dataBasisAt: DateTime(2026, 8, 11, 4),
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

  test('서버가 준 총점 내림차순을 그대로 유지한다', () async {
    // R22 — 클라이언트가 다시 정렬하지 않는다.
    final ProviderContainer c = containerWith(
      repository: FakeMapRepository(result: twoRegions),
      coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
    );

    final RegionRecommendationResult result = await c.read(
      regionRecommendationsProvider.future,
    );

    expect(
      result.regions.map((RegionRecommendation r) => r.totalScore).toList(),
      <double>[88, 72],
    );
  });

  test('항목별 점수와 산출 항목 수가 보존된다', () async {
    // R23 · R31 — 총점만 남기면 왜 추천됐는지 알 수 없다.
    final ProviderContainer c = containerWith(
      repository: FakeMapRepository(result: twoRegions),
      coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
    );

    final RegionRecommendationResult result = await c.read(
      regionRecommendationsProvider.future,
    );

    expect(result.regions.first.scores, hasLength(2));
    expect(result.regions.first.scoreFactorCount, 2);
  });

  test('기준 시점이 결과에 포함된다', () async {
    // R24 — 이 값이 "실시간이 아님"을 드러내는 유일한 장치다.
    final ProviderContainer c = containerWith(
      repository: FakeMapRepository(result: twoRegions),
      coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
    );

    final RegionRecommendationResult result = await c.read(
      regionRecommendationsProvider.future,
    );

    expect(result.dataBasisAt, DateTime(2026, 8, 11, 4));
  });

  group('위치 권한이 없을 때(R27)', () {
    test('위치 없이 조회하고 오류로 만들지 않는다', () async {
      final FakeMapRepository repository = FakeMapRepository(
        result: twoRegions,
      );
      final ProviderContainer c = containerWith(repository: repository);

      final RegionRecommendationResult result = await c.read(
        regionRecommendationsProvider.future,
      );

      expect(repository.lastOrigin, isNull);
      expect(result.regions, isNotEmpty);
    });

    test('위치가 있으면 좌표를 실어 보낸다', () async {
      final FakeMapRepository repository = FakeMapRepository(
        result: twoRegions,
      );
      final ProviderContainer c = containerWith(
        repository: repository,
        coordinates: const Coordinates(latitude: 37.5, longitude: 127.0),
      );

      await c.read(regionRecommendationsProvider.future);

      expect(repository.lastOrigin?.latitude, 37.5);
      expect(repository.lastOrigin?.longitude, 127.0);
    });
  });

}
