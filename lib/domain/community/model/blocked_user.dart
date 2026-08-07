import '../../../common/model/post_author.dart';

/// 내가 차단한 사람 한 명(서버 `BlockedUserEdge`).
///
/// **나를 차단한 사람은 여기 없다** — 남이 건 차단은 내가 풀 수 없기 때문이다.
/// "글이 안 보이는데 목록에 없다"는 정상 동작이다(가이드 §6).
class BlockedUser {
  const BlockedUser({required this.member, required this.blockedAt});

  final PostAuthor member;

  /// 차단한 시각(UTC).
  final DateTime blockedAt;

  @override
  bool operator ==(Object other) =>
      other is BlockedUser &&
      other.member == member &&
      other.blockedAt == blockedAt;

  @override
  int get hashCode => Object.hash(member, blockedAt);
}
