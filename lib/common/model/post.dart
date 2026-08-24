import 'comment.dart';
import 'list_equality.dart';
import 'post_author.dart';
import 'post_spot.dart';
import 'target_category.dart';

/// 커뮤니티 게시글 하나(서버 `Post`).
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음. repository가 생성 타입에서
/// 매핑하고 생성 타입은 밖으로 나가지 않는다(POL-020).
///
/// **[spot]은 null일 수 있다.** 장소 없는 글이 허용되며(가이드 §5) 그 글은 좌표
/// 반경 조회에 잡히지 않는다(§10). 카드는 그때 장소 이름을 아예 그리지 않는다.
///
/// **[photoKeys]는 URL이 아니라 키다.** CDN 베이스와 조합하는 것은 표시 계층의
/// 몫이며(가이드 §4), 베이스가 바뀌어도 서버 배포 없이 앱만 고치면 되도록 모델은
/// 서버가 준 키를 그대로 보유한다. 개발 환경 시드의 키는 실제 오브젝트가 없어
/// **404가 정상**이고, 그것이 레이아웃을 깨뜨려선 안 된다.
///
/// **댓글 전체 목록은 여기 없다.** `comments`가 루트 쿼리가 되면서 상세 화면이
/// 자기 provider로 따로 받는다(가이드 §2) — 목록 안에 목록을 중첩해 페이지네이션하면
/// 어느 카드의 커서인지 추적할 수 없다. 카드가 쓰는 미리보기만 [commentPreview]다.
class Post {
  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.author,
    required this.createdAt,
    this.tags = const <String>[],
    this.spot,
    this.photoKeys = const <String>[],
    this.likeCount = 0,
    this.commentCount = 0,
    this.viewCount = 0,
    this.likedByViewer = false,
    this.ownedByViewer = false,
    this.hidden = false,
    this.edited = false,
    this.commentPreview = const <Comment>[],
  });

  final String id;

  /// 제목(1~50 코드포인트). 카드에서 굵게 그린다.
  final String title;

  final String body;

  /// 사용자가 직접 입력한 태그. **번역 대상이 아니다** — 원문 그대로 표시한다
  /// (가이드 §9).
  final List<String> tags;

  /// 글의 카테고리. 서버가 아직 매핑되지 않은 값을 추가했으면 null이며, 그때는
  /// 카테고리 라벨만 빠지고 나머지는 정상 표시된다.
  final TargetCategory? category;

  /// 붙은 장소. **없을 수 있다**(가이드 §5).
  final PostSpot? spot;

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

  /// 서버가 준 조회수. 카드 하단에 댓글·좋아요와 나란히 그린다. 클라이언트가 세는
  /// 값이 아니라 서버 값을 그대로 쓴다 — 지어내면 실제와 어긋난다.
  final int viewCount;

  /// 내가 좋아요했는지.
  final bool likedByViewer;

  /// 내 글인지. true면 ⋮ 메뉴에 수정·삭제가 뜬다(가이드 §5).
  final bool ownedByViewer;

  /// 신고 누적(서로 다른 5명)으로 자동 숨김됐는지. 숨김 글은 **작성자 본인에게만**
  /// 내려오므로, true를 받으면 "신고 누적으로 숨겨졌다" 배지를 보여준다 — 작성자는
  /// 왜 반응이 없는지 모르면 서버 장애로 오해한다(가이드 §6).
  ///
  /// 숨겨진 글은 **수정할 수 없다**(`POST_NOT_EDITABLE`). ⋮ 메뉴의 수정을 비활성화해
  /// 미리 막는다.
  final bool hidden;

  /// 수정된 글인지. true면 "수정됨"을 표시한다 — 이력은 보관하지 않는다(가이드 §5).
  final bool edited;

  /// 카드에 그릴 최신 댓글 몇 건. **페이지네이션이 없다**(가이드 §2). 상세 화면의
  /// 전체 목록은 루트 쿼리 `comments(postId:)`가 따로 받는다.
  final List<Comment> commentPreview;

  /// 좋아요 낙관적 갱신용 사본(디자인 §6). 실패 시 이전 값으로 되돌리고, 성공하면
  /// **서버가 돌려준 likeCount로 되맞춘다** — 서버 값이 정본이다(가이드 §7).
  Post copyWith({bool? likedByViewer, int? likeCount}) => Post(
    id: id,
    title: title,
    body: body,
    tags: tags,
    category: category,
    spot: spot,
    author: author,
    createdAt: createdAt,
    photoKeys: photoKeys,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount,
    viewCount: viewCount,
    likedByViewer: likedByViewer ?? this.likedByViewer,
    ownedByViewer: ownedByViewer,
    hidden: hidden,
    edited: edited,
    commentPreview: commentPreview,
  );

  @override
  bool operator ==(Object other) =>
      other is Post &&
      other.id == id &&
      other.title == title &&
      other.body == body &&
      listEquals(other.tags, tags) &&
      other.category == category &&
      other.spot == spot &&
      other.author == author &&
      other.createdAt == createdAt &&
      other.likeCount == likeCount &&
      other.commentCount == commentCount &&
      other.viewCount == viewCount &&
      other.likedByViewer == likedByViewer &&
      other.ownedByViewer == ownedByViewer &&
      other.hidden == hidden &&
      other.edited == edited;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    body,
    Object.hashAll(tags),
    category,
    spot,
    author,
    createdAt,
    likeCount,
    commentCount,
    viewCount,
    likedByViewer,
    ownedByViewer,
    hidden,
    edited,
  );
}
