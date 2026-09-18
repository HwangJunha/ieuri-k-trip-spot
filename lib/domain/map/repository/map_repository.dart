import '../../../common/location/coordinates.dart';
import '../model/congestion_area.dart';
import '../model/map_bounds.dart';
import '../model/map_recommendation_result.dart';
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
  /// [categoryCodes]로 종류를 거른다(SPEC-0020 R7). **SPEC-0014의 R21이 뒤집혔다** —
  /// 그때는 토글 필터를 두지 말라고 해서 이 인자가 없었으나, SPEC-0020이 지도에도
  /// 카테고리 필터를 신설한다. null이면 전체이고, **빈 목록은 넘기지 않는다**
  /// (서버가 `EMPTY_CATEGORY_SET`으로 거절한다, AC5.1) — 다른 조회와 같은 규약이다.
  ///
  /// **마커는 활성 언어에 원문이 있는 장소뿐이다**(SPEC-0029). 원문/번역을 고르던
  /// `hasOrigin`은 계약에서 사라졌고, 뷰포트 조회도 한 번으로 끝난다.
  Future<MapViewportResult> fetchViewport({
    required MapBounds bbox,
    required int zoom,
    List<String>? categoryCodes,
  });

  /// 지도 영역 안의 장소를 **추천 순서로** 조회한다(SPEC-0036 FR-001·FR-002).
  ///
  /// [fetchViewport]를 대체하지 않는다 — 문화행사 마커는 그쪽이 계속 맡고(FR-012)
  /// 이 조회는 spot만 준다. **인증 필수**이며 미인증이면 `UNAUTHENTICATED`가
  /// [MapFailure]로 온다.
  ///
  /// [excludedIds]는 이 세션에서 **이미 표시한** 장소다(FR-004). 세션을 들고 있는
  /// 쪽이 클라이언트인 이유는 「봤다」의 판정이 *마커로 실제 그려졌는가*이기 때문이다
  /// — 격자로 솎아 그리므로 서버가 보낸 10건과 그려진 10건이 다르고, 서버가 세션을
  /// 들면 그리지 않은 장소까지 「봤다」로 기록해 남은 후보를 잃는다(FR-009).
  ///
  /// **커서도 오프셋도 없다**(POL-037). 「다음 장소」는 페이지 넘기기가 아니라
  /// [excludedIds]를 빼고 같은 영역을 다시 받는 것이다 — 그래서 같은 영역에서 다시
  /// 부를 때 [bbox]가 첫 조회와 같아야 한다(FR-010).
  ///
  /// 거리 요인은 [bbox] **중심점** 기준으로 계산되며 점수 계수는 SPEC-0035를
  /// 승계한다. 후보 조달은 원이 아니라 사각형이라 화면 네 모서리가 빠지지 않는다
  /// (서버 결정 2026-09-18, 미결 T3 해소).
  Future<MapRecommendationResult> fetchRecommendedSpots({
    required MapBounds bbox,
    required List<String> excludedIds,
    int? first,
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
  /// **[origin]은 필수다.** 설계 초안에서는 선택이었으나(R27) 서버가 필수로 확정했다
  /// — 이 쿼리는 "지금 있는 곳 말고 근처의 다른 곳"을 답하므로, origin이 속한 시도
  /// 안에서만 고르고 origin의 시군구 자신은 결과에서 빠진다. 좌표가 없으면 질문이
  /// 성립하지 않아 GraphQL 검증 단계에서 거절된다. 위치 권한이 없을 때는 이 호출을
  /// 하지 않고 화면이 권한 안내를 그린다(설계 §9.3).
  ///
  /// [limit]을 생략하면 서버 기본값 10이다. 상한 50을 넘으면 잘리지만 0 이하는
  /// `INVALID_LIMIT`으로 거절된다.
  ///
  /// 빈 목록은 오류가 아니다(R15) — 바다·해외 좌표, 시군구 3개 미만인 시도, 후보가
  /// 없는 시도가 모두 빈 목록으로 온다.
  ///
  /// 여기서도 **새 repository를 만들지 않는다**(§1) — 같은 GraphQL 엔드포인트에 대해
  /// 두 개가 생기기 때문이다.
  Future<RegionRecommendationResult> fetchRecommendedRegions({
    required Coordinates origin,
    int? limit,
  });
}
