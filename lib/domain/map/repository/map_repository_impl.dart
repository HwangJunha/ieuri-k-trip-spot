import 'package:flutter/foundation.dart';
import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../model/commercial_activity_level.dart';
import '../model/commercial_display_state.dart';
import '../model/congestion_area.dart';
import '../model/congestion_level.dart';
import '../model/map_bounds.dart';
import '../model/map_failure.dart';
import '../model/map_marker.dart';
import '../model/map_viewport_result.dart';
import '../model/region_recommendation.dart';
import '../model/region_score.dart';
import '../model/seoul_congestion_result.dart';
import 'map_operations.graphql.dart';
import 'map_repository.dart';
import 'map_schema.graphql.dart';

/// GraphQL 기반 [MapRepository](SPEC-0014). 생성된 `*.graphql.dart` 타입은 이 파일
/// 밖으로 나가지 않는다(CLAUDE.md §3, POL-020).
class MapRepositoryImpl implements MapRepository {
  MapRepositoryImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<MapViewportResult> fetchViewport({
    required MapBounds bbox,
    required int zoom,
    bool? hasOrigin,
  }) async {
    // 카테고리 인자를 넘기지 않는다 — R21이 토글 필터를 두지 말라고 하므로 이
    // 화면에는 거를 기준이 없다. 서버 인자는 남아 있으니 필요해지면 그때 연결한다.
    final Map<String, dynamic> data = await _query(
      documentNodeQueryMapViewport,
      Variables$Query$MapViewport(
        bbox: _boundsInput(bbox),
        zoom: zoom,
        // null이면 변수를 보내지 않아 서버가 원문·번역을 모두 준다(SPEC-0019).
        hasOrigin: hasOrigin,
      ).toJson(),
      'mapViewport',
    );
    final Query$MapViewport$mapViewport result = Query$MapViewport.fromJson(
      data,
    ).mapViewport;

    return MapViewportResult(
      // spot과 행사를 한 목록에 섞는다(R21) — 항상 함께 표시하므로 나눠 들 이유가 없다.
      markers: <MapMarker>[
        for (final Query$MapViewport$mapViewport$spots s in result.spots)
          MapMarker(
            id: s.id,
            name: s.title,
            latitude: s.lat,
            longitude: s.lng,
            kind: MapMarkerKind.spot,
            categoryName: s.category.name,
            // 빈 문자열이 오면 없는 것으로 본다 — URL로 쓰면 로드가 실패한다.
            thumbnailUrl: s.thumbnailImageUrl.isEmpty
                ? null
                : s.thumbnailImageUrl,
          ),
        for (final Query$MapViewport$mapViewport$events e in result.events)
          MapMarker(
            id: e.id,
            name: e.title,
            latitude: e.lat,
            longitude: e.lng,
            kind: MapMarkerKind.culturalEvent,
            // 장소와 기간을 한 줄로 합친다 — 마커 말풍선이 좁아 두 줄을 쓰기 어렵다.
            subtitle: '${e.place} · ${e.period}',
          ),
      ],
      // 서버가 클러스터를 없앴다(2026-08-10) — `map_schema.graphql` 주석 참조.
      truncated: result.truncated,
    );
  }

  @override
  Future<SeoulCongestionResult> fetchCongestion({
    required MapBounds bbox,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySeoulCongestion,
      Variables$Query$SeoulCongestion(bbox: _boundsInput(bbox)).toJson(),
      'seoulCongestion',
    );
    final Query$SeoulCongestion$seoulCongestion result =
        Query$SeoulCongestion.fromJson(data).seoulCongestion;

    return SeoulCongestionResult(
      areas: result.areas
          .map(_areaFrom)
          .whereType<CongestionArea>()
          .toList(growable: false),
      degraded: result.degraded,
      staleSince: _parseTime(result.staleSince),
    );
  }

  @override
  Future<List<CongestionAreaBoundary>> fetchBoundaries() async {
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySeoulCongestionAreas,
      const <String, dynamic>{},
      'seoulCongestionAreas',
    );

    final List<Query$SeoulCongestionAreas$seoulCongestionAreas> raw =
        Query$SeoulCongestionAreas.fromJson(data).seoulCongestionAreas;
    final List<CongestionAreaBoundary> mapped = raw
        .map(_boundaryFrom)
        .whereType<CongestionAreaBoundary>()
        .toList(growable: false);

    // 121건이 와야 정상인데 매핑에서 걸러지면 폴리곤이 조용히 사라진다 — 실기기에서
    // 혼잡도는 왔는데 폴리곤이 하나도 안 그려진 적이 있어 남긴다.
    if (kDebugMode && mapped.length != raw.length) {
      debugPrint(
        '[Map] 경계 ${raw.length}건 중 ${raw.length - mapped.length}건이 '
        '매핑에서 제외됐다(좌표 형식 불일치)',
      );
    }
    return mapped;
  }

  @override
  Future<RegionRecommendationResult> fetchRecommendedRegions({
    required Coordinates origin,
    int? limit,
  }) async {
    // **origin은 필수다.** 서버가 origin이 속한 시도 안에서만 후보를 고르고 그
    // 시군구 자신은 제외하므로, 좌표가 없으면 질문 자체가 성립하지 않는다 —
    // GraphQL 검증 단계에서 거절된다. 위치 권한이 없으면 화면이 이 호출을 아예
    // 하지 않고 권한 안내를 그린다(설계 §9.3).
    final Map<String, dynamic> data = await _query(
      documentNodeQueryRecommendedRegions,
      Variables$Query$RecommendedRegions(
        origin: Input$CoordinatesInput(
          lat: origin.latitude,
          lng: origin.longitude,
        ),
        limit: limit,
      ).toJson(),
      'recommendedRegions',
    );

    final Query$RecommendedRegions$recommendedRegions result =
        Query$RecommendedRegions.fromJson(data).recommendedRegions;

    return RegionRecommendationResult(
      // 서버가 준 총점 내림차순을 그대로 둔다(R22) — 다시 정렬하지 않는다.
      regions: result.regions.map(_recommendationFrom).toList(growable: false),
      // 화면이 거리를 재려면 **조회에 실제로 쓴 좌표**가 필요하다. 내 위치 기준일
      // 때는 provider가 좌표를 얻으므로 화면이 알 수 없어, 여기서 실어 보낸다.
      origin: origin,
    );
  }

  /// 생성 타입 → 도메인 [RegionRecommendation].
  RegionRecommendation _recommendationFrom(
    Query$RecommendedRegions$recommendedRegions$regions r,
  ) => RegionRecommendation(
    code: r.code,
    name: r.name,
    provinceName: r.provinceName,
    scores: r.scores.map(_scoreFrom).toList(growable: false),
    scoreFactorCount: r.scoreFactorCount,
    centerLat: r.center.lat,
    centerLng: r.center.lng,
  );

  RegionScore _scoreFrom(
    Query$RecommendedRegions$recommendedRegions$regions$scores s,
  ) => RegionScore(factor: _factorFrom(s.factor), value: s.value, rank: s.rank);

  /// 도메인 [RegionScoreFactor] 매핑.
  ///
  /// **모르는 값을 예외로 만들지 않는다** — 서버가 항목을 추가했을 때 목록 전체가
  /// 실패하는 대신 그 항목만 [RegionScoreFactor.unknown]이 되고 화면이 건너뛴다.
  RegionScoreFactor _factorFrom(
    Enum$RegionScoreFactor factor,
  ) => switch (factor) {
    Enum$RegionScoreFactor.CONGESTION => RegionScoreFactor.congestion,
    Enum$RegionScoreFactor.VISITOR_VOLUME => RegionScoreFactor.visitorVolume,
    Enum$RegionScoreFactor.STAY_INTENSITY => RegionScoreFactor.stayIntensity,
    Enum$RegionScoreFactor.SPENDING_INTENSITY =>
      RegionScoreFactor.spendingIntensity,
    Enum$RegionScoreFactor.DISTANCE => RegionScoreFactor.distance,
    Enum$RegionScoreFactor.$unknown => RegionScoreFactor.unknown,
  };

  /// 생성 타입 → 도메인 [CongestionArea].
  ///
  /// **기준 시각을 파싱하지 못하면 그 구역을 버린다.** R27이 기준 시각 표시를
  /// 요구하는데, 시각 없이 그리면 "지금"으로 읽히는 것을 막을 방법이 없다 — 데이터가
  /// 약 30분 지연되므로(spec §4.2) 그 오해가 실제 피해가 된다. 한 구역이 이상해도
  /// 나머지는 정상적으로 그려진다.
  CongestionArea? _areaFrom(Query$SeoulCongestion$seoulCongestion$areas a) {
    final DateTime? observedAt = _parseTime(a.congestion.observedAt);
    if (observedAt == null) return null;

    return CongestionArea(
      id: a.id,
      name: a.name,
      congestion: CongestionSnapshot(
        level: _levelFrom(a.congestion.level),
        populationMin: a.congestion.populationMin,
        populationMax: a.congestion.populationMax,
        observedAt: observedAt,
      ),
      commercial: _commercialFrom(a.commercial),
    );
  }

  /// 상권은 **부재가 정상이다**(121곳 중 82곳만 값이 있다). 시각을 파싱하지 못하면
  /// 부재로 떨어뜨린다 — 상권이 없다고 구역 전체를 버리지는 않는다.
  CommercialStatus? _commercialFrom(
    Query$SeoulCongestion$seoulCongestion$areas$commercial? c,
  ) {
    if (c == null) return null;
    final DateTime? observedAt = _parseTime(c.observedAt);
    if (observedAt == null) return null;

    return CommercialStatus(
      level: _commercialLevelFrom(c.level),
      isDefaulted: c.isDefaulted,
      observedAt: observedAt,
    );
  }

  /// 생성 타입 → 도메인 [CongestionAreaBoundary].
  ///
  /// 폴리곤 좌표가 `[lng, lat]` 쌍이 아니면 그 구역을 버린다 — 좌표가 깨진 폴리곤을
  /// 그리면 지도에 엉뚱한 도형이 생긴다.
  CongestionAreaBoundary? _boundaryFrom(
    Query$SeoulCongestionAreas$seoulCongestionAreas b,
  ) {
    final List<List<double>> polygon = <List<double>>[];
    for (final List<double> point in b.polygon) {
      if (point.length < 2) return null;
      polygon.add(<double>[point[0], point[1]]);
    }
    if (polygon.isEmpty) return null;

    return CongestionAreaBoundary(
      id: b.id,
      name: b.name,
      category: b.category,
      polygon: polygon,
    );
  }

  Input$MapBoundsInput _boundsInput(MapBounds bbox) => Input$MapBoundsInput(
    minLat: bbox.minLat,
    minLng: bbox.minLng,
    maxLat: bbox.maxLat,
    maxLng: bbox.maxLng,
  );

  CongestionLevel _levelFrom(Enum$CongestionLevel level) => switch (level) {
    Enum$CongestionLevel.RELAXED => CongestionLevel.relaxed,
    Enum$CongestionLevel.NORMAL => CongestionLevel.normal,
    Enum$CongestionLevel.SLIGHTLY_CROWDED => CongestionLevel.slightlyCrowded,
    Enum$CongestionLevel.CROWDED => CongestionLevel.crowded,
    // 서버가 새 단계를 추가하면 여기로 온다. 임의 단계로 넘기지 않고 가장 낮은
    // 값으로 두는 것이 아니라, 표시상 중립인 `보통`으로 접는다 — 없는 위험을
    // 알리거나(붐빔) 안전하다고 오도하는(여유) 것보다 낫다.
    Enum$CongestionLevel.$unknown => CongestionLevel.normal,
  };

  CommercialActivityLevel _commercialLevelFrom(
    Enum$CommercialActivityLevel level,
  ) => switch (level) {
    Enum$CommercialActivityLevel.QUIET => CommercialActivityLevel.quiet,
    Enum$CommercialActivityLevel.NORMAL => CommercialActivityLevel.normal,
    Enum$CommercialActivityLevel.BUSY => CommercialActivityLevel.busy,
    Enum$CommercialActivityLevel.PEAK => CommercialActivityLevel.peak,
    Enum$CommercialActivityLevel.$unknown => CommercialActivityLevel.normal,
  };

  DateTime? _parseTime(String? raw) =>
      raw == null ? null : DateTime.tryParse(raw)?.toLocal();

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await _client.query(
        QueryOptions(document: document, variables: variables),
      );
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      throw MapFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    // 범위 판별은 `path`로 한다(다른 도메인과 동일) — 하위 필드 실패까지 전체
    // 실패로 뭉개지 않는다.
    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw MapFailure(_rootErrorCode(result, operation));
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw MapFailure.network;
    return data;
  }

  String? _rootErrorCode(QueryResult<Object?> result, String rootField) {
    final GraphQLError? error = firstRootError(result, rootField);
    if (error == null) return null;
    final Object? code = error.extensions?['code'];
    return code is String && code.isNotEmpty ? code : null;
  }
}
