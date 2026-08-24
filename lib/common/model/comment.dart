import 'post_author.dart';

/// 댓글 하나(서버 `Comment`).
///
/// **깊이 2단계다**(2차 가이드 §1). `comments(postId:)`는 최상위 댓글만 주고 답글은
/// [replies]에 담겨 온다. [parentCommentId]가 null이면 최상위, 있으면 답글이며 그
/// 값이 **들여쓰기 판정 기준**이다.
///
/// [replies]에는 페이지네이션이 없고 답글의 [replies]는 **항상 비어 있다**(3단계가
/// 없다). 답글은 **오래된 순**으로 오며 대화 흐름이라 뒤집지 않는다 — 최상위 목록만
/// 최신순이다.
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
    this.parentCommentId,
    this.replies = const <Comment>[],
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

  /// 부모 댓글 id. **null이면 최상위, 있으면 답글이다**(2차 가이드 §1).
  ///
  /// 답글에 답글을 달면 서버가 최상위 부모로 눕히므로 **응답 값이 보낸 값과 다를 수
  /// 있다** — 그래서 화면은 답글에 "답글 달기"를 두지 않는다.
  final String? parentCommentId;

  /// 이 댓글에 달린 답글(오래된 순). **최상위 댓글에만 채워진다** — 답글의 답글은
  /// 없으므로 답글의 이 목록은 항상 비어 있다.
  final List<Comment> replies;

  /// 최상위 댓글인지. 답글 버튼과 들여쓰기를 이 값으로 가른다.
  bool get isTopLevel => parentCommentId == null;

  @override
  bool operator ==(Object other) =>
      other is Comment &&
      other.id == id &&
      other.body == body &&
      other.author == author &&
      other.createdAt == createdAt &&
      other.ownedByViewer == ownedByViewer &&
      other.hidden == hidden &&
      other.parentCommentId == parentCommentId &&
      _sameReplies(other.replies);

  bool _sameReplies(List<Comment> other) {
    if (other.length != replies.length) return false;
    for (int i = 0; i < replies.length; i++) {
      if (other[i] != replies[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    id,
    body,
    author,
    createdAt,
    ownedByViewer,
    hidden,
    parentCommentId,
    Object.hashAll(replies),
  );
}
