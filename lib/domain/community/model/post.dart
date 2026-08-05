import 'comment.dart';
import 'post_author.dart';
import 'post_target.dart';
import 'post_topic.dart';

/// 커뮤니티 게시글 하나(서버 `Post`).
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음. repository가 생성 타입에서
/// 매핑하고 생성 타입은 밖으로 나가지 않는다(POL-020).
///
/// **[photoKeys]는 URL이 아니라 키다.** CDN 베이스와 조합하는 것은 표시 계층의
/// 몫이며(가이드 §3), 베이스가 바뀌어도 서버 배포 없이 앱만 고치면 되도록 모델은
/// 서버가 준 키를 그대로 보유한다. 개발 환경 시드의 키는 실제 오브젝트가 없어
/// **404가 정상**이고, 그것이 레이아웃을 깨뜨려선 안 된다.
///
/// [comments]는 상세에서만 채워진다. 목록 카드는 [commentCount]만 쓴다 — 피드에서
/// `comments`를 요청하면 20건짜리 목록에 댓글 쿼리가 20번 붙는다(가이드 §4).
class Post {
  const Post({
    required this.id,
    required this.body,
    required this.topic,
    required this.target,
    required this.author,
    required this.createdAt,
    this.photoKeys = const <String>[],
    this.likeCount = 0,
    this.commentCount = 0,
    this.likedByViewer = false,
    this.ownedByViewer = false,
    this.hidden = false,
    this.comments,
  });

  final String id;
  final String body;

  /// 주제 태그. 클라이언트가 모르는 새 값이면 null — 글 전체를 실패시키지 않고
  /// 태그 pill만 그리지 않는다.
  final PostTopic? topic;

  final PostTarget target;
  final PostAuthor author;

  /// 작성 시각(UTC). 서버 ISO-8601 문자열을 파싱한 값.
  final DateTime createdAt;

  /// 사진 **키** 배열(URL 아님). 순서가 표시 순서다.
  final List<String> photoKeys;

  final int likeCount;

  /// 서버가 준 댓글 수. **목록 길이와 다를 수 있다** — 차단된 사람의 댓글은 목록에서
  /// 빠지지만 숫자에는 남기 때문이다(가이드 §6). 불일치는 버그가 아니므로 오류로
  /// 처리하지 않고, 화면은 항상 이 값을 그대로 쓴다.
  final int commentCount;

  /// 내가 좋아요했는지. **미인증이면 null이 아니라 false**로 온다(가이드 §13).
  final bool likedByViewer;

  /// 내 글인지. 미인증이면 false.
  final bool ownedByViewer;

  /// 신고 누적(서로 다른 5명)으로 자동 숨김됐는지. 숨김 글은 **작성자 본인에게만**
  /// 내려오므로, true를 받으면 "신고 누적으로 숨겨졌다" 배지를 보여준다 — 작성자는
  /// 왜 반응이 없는지 모르면 서버 장애로 오해한다(가이드 §6).
  final bool hidden;

  /// 상세에서 함께 받은 첫 댓글 페이지. 목록에서는 null이다.
  final List<Comment>? comments;

  /// 좋아요 낙관적 갱신용 사본(설계 §5). 실패 시 이전 값으로 되돌리고, 성공하면
  /// **서버가 돌려준 likeCount로 되맞춘다** — 서버 값이 정본이다(가이드 §8).
  Post copyWith({
    bool? likedByViewer,
    int? likeCount,
    List<Comment>? comments,
  }) => Post(
    id: id,
    body: body,
    topic: topic,
    target: target,
    author: author,
    createdAt: createdAt,
    photoKeys: photoKeys,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount,
    likedByViewer: likedByViewer ?? this.likedByViewer,
    ownedByViewer: ownedByViewer,
    hidden: hidden,
    comments: comments ?? this.comments,
  );

  @override
  bool operator ==(Object other) =>
      other is Post &&
      other.id == id &&
      other.body == body &&
      other.topic == topic &&
      other.target == target &&
      other.author == author &&
      other.createdAt == createdAt &&
      other.likeCount == likeCount &&
      other.commentCount == commentCount &&
      other.likedByViewer == likedByViewer &&
      other.ownedByViewer == ownedByViewer &&
      other.hidden == hidden;

  @override
  int get hashCode => Object.hash(
    id,
    body,
    topic,
    target,
    author,
    createdAt,
    likeCount,
    commentCount,
    likedByViewer,
    ownedByViewer,
    hidden,
  );
}
