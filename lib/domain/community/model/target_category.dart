/// 글의 카테고리(서버 `TargetCategory`). 안정 식별자이며 **표시 문자열은
/// 클라이언트가 l10n으로 매핑한다** — 서버는 표시명을 내려주지 않는다(가이드 §9,
/// POL-023). `SpotCategory`가 이미 같은 방식이라 선례를 따른다.
///
/// **`SpotCategory`와 값이 같지만 다른 타입이다.** 글의 카테고리는 커뮤니티가
/// 소유하고 장소의 카테고리는 관광 도메인이 소유한다 — 값이 같다고 한 타입으로
/// 합치면 한쪽 도메인의 변경이 다른 쪽을 끌고 가고, 기능 간 import까지 생긴다
/// (CLAUDE.md §3).
///
/// 순수 도메인 enum — flutter·graphql·riverpod 의존 없음.
enum TargetCategory {
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
