/// 관계 지도의 상대 한 명(SPEC-0030 관계 지도).
///
/// 공유 링크로 맺어진 사이다. **겹침은 조회 시점에 재계산된 값**이라 등록 이후
/// 서로 여행을 더 다니면 다음 조회에서 늘어난다 — 이 값을 캐시에 오래 들고
/// 있으면 안 되는 이유다(사용자 결정, 2026-08-22).
class MapRelation {
  const MapRelation({
    required this.memberId,
    required this.nickname,
    required this.overlappingCount,
    required this.overlappingCellIds,
    required this.theirVisitedCount,
  });

  final String memberId;

  /// 닉네임만 온다. 이메일 등 다른 개인정보는 서버가 주지 않는다.
  final String nickname;

  /// 나와 겹치는 칸 수.
  final int overlappingCount;

  /// 나와 겹치는 칸 id. 지도에 표시할 때 쓴다.
  final List<String> overlappingCellIds;

  /// 상대가 방문한 총 칸 수. 겹침을 비율로 보여줄 때 쓴다.
  final int theirVisitedCount;

  /// 상대의 방문 칸 중 나와 겹치는 비율(0.0~1.0).
  ///
  /// 관계 지도에서 **가운데(나)와의 거리**를 정하는 값이다. 겹친 수만 쓰면
  /// 많이 다닌 사람이 무조건 가까워져 "취향이 비슷하다"는 뜻이 흐려진다.
  double get overlapRatio => theirVisitedCount == 0
      ? 0
      : (overlappingCount / theirVisitedCount).clamp(0.0, 1.0);

  @override
  bool operator ==(Object other) =>
      other is MapRelation &&
      other.memberId == memberId &&
      other.nickname == nickname &&
      other.overlappingCount == overlappingCount &&
      other.theirVisitedCount == theirVisitedCount &&
      _sameIds(other.overlappingCellIds, overlappingCellIds);

  @override
  int get hashCode => Object.hash(
    memberId,
    nickname,
    overlappingCount,
    theirVisitedCount,
    Object.hashAll(overlappingCellIds),
  );

  static bool _sameIds(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// 관계 목록 한 페이지.
///
/// 서버 정렬은 **맺은 시각 내림차순 고정**이다. 겹침 수로 정렬하지 않는 이유는
/// 그 값이 조회마다 바뀌어 커서가 불안정해지기 때문이다 — 겹침 순으로 보려면
/// 받은 페이지 안에서 클라이언트가 정렬한다.
class MapRelationPage {
  const MapRelationPage({
    required this.relations,
    required this.hasMore,
    this.endCursor,
  });

  final List<MapRelation> relations;
  final bool hasMore;
  final String? endCursor;

  /// 겹침이 많은 순으로 정렬한 사본. 같으면 닉네임 순으로 안정화한다.
  List<MapRelation> get byOverlapDesc =>
      List<MapRelation>.of(relations)..sort((MapRelation a, MapRelation b) {
        final int c = b.overlappingCount.compareTo(a.overlappingCount);
        return c != 0 ? c : a.nickname.compareTo(b.nickname);
      });
}
