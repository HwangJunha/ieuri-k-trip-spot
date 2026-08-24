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
  transport;

  /// 서버 enum 값 그대로의 코드(`TOURIST_SPOT` 등).
  ///
  /// **여기 한 번만 적는다.** 칩 줄(표시 순서·아이콘 매핑의 키), 선택 집합의 정규화
  /// 키, 리포지토리의 생성 enum 변환이 모두 같은 문자열을 쓰는데, 예전에는 위젯 안의
  /// private switch 하나가 그 역할을 겸하고 있었다 — 세 벌로 갈리면 한 곳만 고쳐
  /// 어긋난다.
  ///
  /// `SpotCategory.code`와 값이 같은 것은 서버가 두 도메인에 같은 코드 체계를 쓰기
  /// 때문이며, 그래서 `kCategoryDisplayOrder`·`spotCategoryIcon()`을 함께 쓸 수 있다.
  /// **타입을 합치지는 않는다**(위 주석).
  String get code => switch (this) {
    TargetCategory.touristSpot => 'TOURIST_SPOT',
    TargetCategory.culturalFacility => 'CULTURAL_FACILITY',
    TargetCategory.festivalEvent => 'FESTIVAL_EVENT',
    TargetCategory.travelCourse => 'TRAVEL_COURSE',
    TargetCategory.leisureSports => 'LEISURE_SPORTS',
    TargetCategory.lodging => 'LODGING',
    TargetCategory.shopping => 'SHOPPING',
    TargetCategory.restaurant => 'RESTAURANT',
    TargetCategory.transport => 'TRANSPORT',
  };

  /// [code]의 역방향. 모르는 코드면 null이다 — 서버가 enum을 늘리면 클라이언트가
  /// 아직 모르는 값이 올 수 있고, 그때 예외를 던지면 화면 전체가 죽는다.
  static TargetCategory? fromCode(String code) {
    for (final TargetCategory category in TargetCategory.values) {
      if (category.code == code) return category;
    }
    return null;
  }
}
