/// 스와이프 반응(spec §3): 오른쪽=LIKE, 왼쪽=DISLIKE. 서버 `reactToSpot`
/// 뮤테이션 인자로 매핑된다. 순수 도메인 enum.
enum SpotReaction {
  like,
  dislike;

  /// 뮤테이션에 넘길 와이어 토큰.
  String get wire => switch (this) {
    SpotReaction.like => 'LIKE',
    SpotReaction.dislike => 'DISLIKE',
  };
}
