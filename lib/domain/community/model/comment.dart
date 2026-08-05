import 'post_author.dart';

/// 댓글 하나(서버 `Comment`).
///
/// **1단계뿐이다** — 서버 타입에 부모 필드가 아예 없고 대댓글은 비범위다(가이드 §15).
/// 답글 버튼도 들여쓰기도 만들지 않는다.
///
/// 순수 도메인 모델. repository가 생성 타입에서 매핑하며 생성 타입은 밖으로 나가지
/// 않는다(POL-020).
class Comment {
  const Comment({
    required this.id,
    required this.body,
    required this.author,
    required this.createdAt,
    this.ownedByViewer = false,
    this.hidden = false,
  });

  final String id;
  final String body;
  final PostAuthor author;

  /// 서버가 준 ISO-8601 문자열을 파싱한 시각(UTC). 상대 시각 표시에 쓴다.
  final DateTime createdAt;

  /// 내 댓글인지. **미인증이면 null이 아니라 false**로 온다(가이드 §13).
  final bool ownedByViewer;

  /// 신고 누적으로 숨겨졌는지. 숨김 댓글은 **작성자 본인에게만** 내려오므로
  /// true를 받으면 "신고 누적으로 숨겨졌다" 배지를 보여준다(가이드 §6).
  final bool hidden;

  @override
  bool operator ==(Object other) =>
      other is Comment &&
      other.id == id &&
      other.body == body &&
      other.author == author &&
      other.createdAt == createdAt &&
      other.ownedByViewer == ownedByViewer &&
      other.hidden == hidden;

  @override
  int get hashCode =>
      Object.hash(id, body, author, createdAt, ownedByViewer, hidden);
}
