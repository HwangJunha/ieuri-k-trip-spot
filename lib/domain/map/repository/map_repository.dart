import '../../../common/location/coordinates.dart';
import '../model/congestion_area.dart';
import '../model/map_bounds.dart';
import '../model/map_viewport_result.dart';
import '../model/region_recommendation.dart';
import '../model/seoul_congestion_result.dart';

/// 지도 데이터 접근 경계(SPEC-0014). 생성된 `*.graphql.dart` 타입은 구현체 안에만
/// 있고 이 인터페이스에는 도메인 모델만 오간다(POL-020, CLAUDE.md §3).
///
/// **세 조회를 하나로 묶지 않는다**(설계 §6.3). 마커와 혼잡도는 별개 최상위 필드라
/// 한쪽 실패가 다른 쪽을 가리면 안 되고(R29), 경계는 정적이라 조회 주기 자체가
/// 다르다(R26).
abstract interface class MapRepository {
  /// 뷰포트 안의 마커·클러스터를 조회한다(R1·R2·R3·R12).
  ///
  /// [zoom]에 따라 서버가 개별 마커와 클러스터 중 한쪽만 채운다 — 클라이언트가 그
  /// 판정을 다시 하지 않는다.
  ///
  /// **카테고리 필터를 받지 않는다.** 서버 쿼리에는 인자가 있지만 R21이 토글 필터를
  /// 두지 말라고 하므로 이 화면에는 거를 기준이 없다. 필요해지면 그때 넓힌다.
  Future<MapViewportResult> fetchViewport({
    required MapBounds bbox,
    required int zoom,
  });

  /// 뷰포트에 걸치는 구역의 실시간 혼잡도를 조회한다(R6~R11).
  ///
  /// **줌 게이트를 통과했을 때만 부른다**(R25) — 이 호출을 아끼는 것이 일일 쿼터
  /// 1000건을 지키는 실질적 장치다(설계 §5.1).
  Future<SeoulCongestionResult> fetchCongestion({required MapBounds bbox});

  /// 121곳의 정적 폴리곤 경계를 조회한다(R17·R26).
  ///
  /// 활성 언어로 된 구역명이 함께 온다(R31) — 캐시할 때 언어를 키에 포함해야 한다.
  Future<List<CongestionAreaBoundary>> fetchBoundaries();

  /// 추천 시군구 목록을 총점 내림차순으로 조회한다(SPEC-0015).
  ///
  /// **[origin]은 선택이다**(R27) — 생략하면 서버가 거리 항목을 빼고 나머지 넷으로
  /// 산출한다. 위치 권한이 없다고 조회를 거르지 않는다.
  ///
  /// 빈 목록은 오류가 아니다(R15) — 기준 시점의 유무로 "아직 모으는 중"과 "조건에 맞는
  /// 지역이 없음"이 갈린다(§5.1).
  ///
  /// 여기서도 **새 repository를 만들지 않는다**(§1) — 같은 GraphQL 엔드포인트에 대해
  /// 두 개가 생기기 때문이다.
  Future<RegionRecommendationResult> fetchRecommendedRegions({
    Coordinates? origin,
  });
}
