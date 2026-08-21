/// 공유 링크로 조회한 다른 회원의 지도(R37·R38).
class SharedMap {
  const SharedMap({
    required this.ownerNickname,
    required this.visitedCellIds,
    required this.visitedCount,
    this.overlappingCellIds,
  });

  /// 지도 주인의 닉네임. 이메일 등 다른 개인정보는 오지 않는다(POL-011).
  final String ownerNickname;

  /// 주인이 방문한 칸 id.
  final List<String> visitedCellIds;

  /// 나와 겹치는 칸 id.
  ///
  /// **null과 빈 목록이 다르다.**
  /// - `null` — 비인증이라 비교 자체를 못 했다. "로그인하면 겹치는 곳을 볼 수 있어요"
  /// - `[]` — 비교했는데 겹치는 곳이 없다. "겹치는 곳이 없네요"
  ///
  /// 둘을 같게 처리하면 안 된다.
  final List<String>? overlappingCellIds;

  /// 주인이 방문한 칸 수. 목록 길이를 세지 않아도 되게 서버가 준다.
  final int visitedCount;

  /// 겹침을 계산할 수 있었는지(= 조회자가 인증됐는지).
  bool get canCompare => overlappingCellIds != null;

  /// 비교했는데 겹치는 곳이 없는 상태.
  bool get hasNoOverlap => overlappingCellIds?.isEmpty ?? false;

  @override
  bool operator ==(Object other) =>
      other is SharedMap &&
      other.ownerNickname == ownerNickname &&
      other.visitedCount == visitedCount &&
      _same(other.visitedCellIds, visitedCellIds) &&
      _sameNullable(other.overlappingCellIds, overlappingCellIds);

  @override
  int get hashCode => Object.hash(
    ownerNickname,
    visitedCount,
    Object.hashAll(visitedCellIds),
    overlappingCellIds == null ? null : Object.hashAll(overlappingCellIds!),
  );

  static bool _same(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _sameNullable(List<String>? a, List<String>? b) {
    if (a == null || b == null) return a == null && b == null;
    return _same(a, b);
  }
}

/// 공유 링크(R36).
class MapShareLink {
  const MapShareLink({required this.shareUrl, required this.createdAt});

  /// 공유할 링크 **전체**. 시스템 공유 시트에 그대로 넘긴다.
  ///
  /// **조립하지 않는다.** 지금은 `ieuri://shared/<token>`이고 웹이 생기면
  /// Universal Link로 바뀌는데, 서버가 조립하므로 그때 앱 배포가 필요 없다.
  final String shareUrl;

  final DateTime createdAt;

  /// 링크에서 토큰을 꺼낸다.
  ///
  /// **경로의 마지막 조각을 쓴다** — 스킴이 바뀌어도 이 코드가 안 바뀐다.
  static String? tokenOf(String shareUrl) {
    final List<String> parts = shareUrl
        .split('/')
        .where((String s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return null;
    final String last = parts.last;
    // 쿼리·프래그먼트가 붙어 있으면 떼어 낸다.
    final String token = last.split('?').first.split('#').first;
    return token.isEmpty ? null : token;
  }

  @override
  bool operator ==(Object other) =>
      other is MapShareLink &&
      other.shareUrl == shareUrl &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(shareUrl, createdAt);
}
