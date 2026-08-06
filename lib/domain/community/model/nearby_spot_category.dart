/// 장소 선택 시트의 카테고리 필터 값(서버 `SpotCategory`).
///
/// **관광 도메인의 `SpotCategory`와 값이 같지만 다른 타입이다.** 커뮤니티가
/// `domain/spot`을 import하면 기능 간 의존이 생긴다(CLAUDE.md §3) — `NearbySpot`이
/// `TouristSpot`을 재사용하지 않은 것과 같은 이유다.
///
/// **구성은 서버가 정한다.** 어떤 값이 실제로 쓰이는지는 `availableSpotCategories`가
/// 언어별로 내려주므로(ko에는 `TRAVEL_COURSE`가 있고 en에는 대신 `TRANSPORT`가 있다)
/// 화면이 이 enum 전체를 그려서는 안 된다. 이 enum은 **서버가 보낼 수 있는 값의
/// 집합**일 뿐이고, 그중 무엇을 보여줄지는 서버 응답이 정한다.
///
/// 순수 도메인 enum — flutter·graphql·riverpod 의존 없음.
enum NearbySpotCategory {
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
