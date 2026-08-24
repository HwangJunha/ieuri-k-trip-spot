/// 컴포저의 장소 선택 시트가 그리는 장소 한 건.
///
/// **출처가 둘이다** — 서버 `spots`(주변, 오프셋 페이징)와 `likedSpots`(좋아요한
/// 장소, 커서 페이징). 시트가 두 탭으로 같은 줄 모양을 그리므로 모델도 하나다:
/// 값이 같은 것을 두 타입으로 갈라 두면 `_SpotTile`이 둘을 다 알아야 한다.
///
/// [distanceMeters]가 **nullable인 이유가 그 둘의 차이다** — `spots`는 좌표 기반이라
/// 거리를 주지만 `likedSpots`는 좌표 인자가 없어 주지 않는다. null이면 시트가 거리
/// 대신 주소를 그린다.
///
/// **관광 도메인의 `TouristSpot`과 값이 겹치지만 다른 타입이다.** 커뮤니티가
/// `domain/spot`을 import하면 기능 간 의존이 생기고(CLAUDE.md §3), 이 화면이 쓰는
/// 것은 그 모델의 일부뿐이다.
///
/// 순수 도메인 — flutter·graphql·riverpod 의존 없음.
class NearbySpot {
  const NearbySpot({
    required this.id,
    required this.title,
    this.distanceMeters,
    this.thumbnailImageUrl,
    this.address,
  });

  /// 서버 `Spot.id`(=contentId). 글 등록 시 `spotId`로 그대로 넘어간다.
  final String id;

  /// 표시 이름. `Accept-Language`를 따른다.
  final String title;

  /// 현재 좌표로부터의 거리(미터). 서버가 이 값 오름차순으로 정렬해 준다.
  ///
  /// **좋아요한 장소에는 없다**(null) — `likedSpots`는 좌표를 받지 않으므로 거리를
  /// 계산할 수 없다. 그때 시트는 거리 대신 주소를 그린다.
  final double? distanceMeters;

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
