/// Discover(스와이프) 상단 카테고리 바가 다루는 관광지 분류. 안정 식별자이며,
/// 표시명은 클라이언트 l10n 키로 매핑한다(POL-023: enum은 식별자, 표시는 별도).
///
/// 값 집합은 **서버 `SpotCategory` enum**과 1:1로 맞춘다(한국관광공사 분류). 어떤
/// 카테고리를 노출할지는 서버(`availableSpotCategories`)가 단일 출처다 — 이 enum은
/// 매핑 가능한 값의 전체 집합일 뿐, 클라이언트가 가용성을 하드코딩하지 않는다
/// (spec §5). 순수 도메인 enum.
enum SpotCategory {
  touristSpot,
  culturalFacility,
  festivalEvent,
  travelCourse,
  leisureSports,
  lodging,
  shopping,
  restaurant,
  transport,
}
