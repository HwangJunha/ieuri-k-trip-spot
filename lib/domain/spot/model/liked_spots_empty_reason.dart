/// 좋아요 목록이 비었을 때 **왜** 비었는지(SPEC-0033 §두 개의 빈 상태).
///
/// 사용자가 할 일이 다르므로 문구가 달라야 한다 — 저장한 것이 없는 사람에게
/// "검색 결과가 없습니다"는 다음 할 일을 알려주지 못한다.
enum LikedSpotsEmptyReason {
  /// 좋아요한 장소가 하나도 없다. 검색어가 쳐 있어도 이쪽이 **우선한다**(AC8.4).
  noLikes,

  /// 좋아요는 있는데 검색 결과가 0건이다 — 검색어를 지우거나 바꾸도록 안내한다.
  noSearchResults,
}

/// 빈 상태의 근거를 가른다.
///
/// [hasAnyLikes]는 "검색·필터를 걷어낸 좋아요가 하나라도 있는가"다. **결과 목록만
/// 보고는 두 상태를 가를 수 없다** — 검색 결과 0건은 그 자체로 좋아요가 없다는
/// 뜻이 아니다. 서버가 필터 없는 총량을 따로 주지 않으므로(`LikedSpotConnection`에
/// `totalCount`가 없다 — 라이브 확인 후 SDL에서도 걷었다) 필터도 검색어도 없을 때
/// 받은 목록에서 관측해 둔다 — `likedSpotsPresenceProvider`가 그 관측값이다.
/// 왕복을 늘리지 않는다.
///
/// 반환이 null이면 빈 상태가 아니다 — 보여줄 항목이 있다.
LikedSpotsEmptyReason? likedSpotsEmptyReason({
  required bool isEmpty,
  required bool hasQuery,
  required bool hasAnyLikes,
}) {
  if (!isEmpty) return null;
  // 좋아요 0건이 검색어보다 우선한다(AC8.4).
  if (!hasAnyLikes) return LikedSpotsEmptyReason.noLikes;
  return hasQuery
      ? LikedSpotsEmptyReason.noSearchResults
      : LikedSpotsEmptyReason.noLikes;
}
