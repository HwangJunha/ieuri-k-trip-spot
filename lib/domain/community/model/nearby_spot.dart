/// 컴포저의 장소 선택 시트가 그리는 주변 장소 한 건.
///
/// 서버 `spots` 쿼리는 **좌표 기반이고 이름 검색이 없다** — 반경 안의 장소를 거리
/// 오름차순으로 준다. 그래서 이 모델은 "가까운 순으로 고르는" 목록에 필요한 것만
/// 담는다.
///
/// **관광 도메인의 `TouristSpot`과 값이 겹치지만 다른 타입이다.** 커뮤니티가
/// `domain/spot`을 import하면 기능 간 의존이 생기고(CLAUDE.md §3), 이 화면이 쓰는
/// 것은 그 모델의 일부뿐이다. 서버 `SpotCategory`는 관광 도메인이 소유한 enum이라
/// 아예 요청하지 않는다 — 시트가 카테고리를 그리지 않기 때문이다.
///
/// 순수 도메인 — flutter·graphql·riverpod 의존 없음.
class NearbySpot {
  const NearbySpot({
    required this.id,
    required this.title,
    required this.distanceMeters,
    this.thumbnailImageUrl,
    this.address,
  });

  /// 서버 `Spot.id`(=contentId). 글 등록 시 `spotId`로 그대로 넘어간다.
  final String id;

  /// 표시 이름. `Accept-Language`를 따른다.
  final String title;

  /// 현재 좌표로부터의 거리(미터). 서버가 이 값 오름차순으로 정렬해 준다.
  final double distanceMeters;

  /// 썸네일. 없을 수 있어 화면은 자리채움 아이콘으로 떨어진다.
  final String? thumbnailImageUrl;

  final String? address;

  /// [query]가 제목에 들어 있는지(대소문자 무시). **이미 받아 둔 목록을 좁히는
  /// 용도다** — 서버에 이름 검색 인자가 없어 클라이언트가 거른다.
  bool matches(String query) {
    final String needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    return title.toLowerCase().contains(needle);
  }

  @override
  bool operator ==(Object other) =>
      other is NearbySpot &&
      other.id == id &&
      other.title == title &&
      other.distanceMeters == distanceMeters &&
      other.thumbnailImageUrl == thumbnailImageUrl &&
      other.address == address;

  @override
  int get hashCode =>
      Object.hash(id, title, distanceMeters, thumbnailImageUrl, address);
}
