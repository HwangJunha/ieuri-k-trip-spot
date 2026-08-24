import 'package:ieuri_k_trip_spot/common/model/comment.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';
import 'package:ieuri_k_trip_spot/common/model/post_author.dart';
import 'package:ieuri_k_trip_spot/common/model/post_spot.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';

/// 테스트용 [Post] 하나. 값을 지정하지 않은 필드는 검증에 쓰이지 않는 자리채움이다.
///
/// **`common/`에 있다** — 모델이 `common/model/`로 올라오면서 커뮤니티와 설정
/// ("내가 쓴 글", SPEC-0011 R3)이 같은 픽스처를 쓴다. 기능별로 복제하면 모델이
/// 바뀔 때 두 곳이 따로 늙는다.
///
/// [spot]의 기본값이 있는 이유는 대부분의 테스트가 장소 있는 글을 다루기 때문이다.
/// **장소 없는 글**(가이드 §5)을 만들려면 `withoutSpot: true`를 준다.
Post fakePost({
  String id = 'p1',
  String title = 'Night opening was great',
  String body = 'Wear a hanbok and get in free.',
  TargetCategory? category = TargetCategory.touristSpot,
  List<String> tags = const <String>[],
  int likeCount = 3,
  int commentCount = 2,
  int viewCount = 0,
  bool likedByViewer = false,
  bool ownedByViewer = false,
  bool hidden = false,
  bool edited = false,
  bool withoutSpot = false,
  List<String> photoKeys = const <String>[],
  List<Comment> commentPreview = const <Comment>[],
  DateTime? createdAt,
}) => Post(
  id: id,
  title: title,
  body: body,
  category: category,
  tags: tags,
  spot: withoutSpot
      ? null
      : const PostSpot(
          id: '11094',
          title: 'Gyeongbokgung',
          thumbnailImageUrl: 'https://img/spot.jpg',
          category: TargetCategory.touristSpot,
        ),
  author: const PostAuthor(id: '20', nickname: 'Traveler'),
  createdAt: createdAt ?? DateTime.utc(2026, 8, 5, 9),
  photoKeys: photoKeys,
  likeCount: likeCount,
  commentCount: commentCount,
  viewCount: viewCount,
  likedByViewer: likedByViewer,
  ownedByViewer: ownedByViewer,
  hidden: hidden,
  edited: edited,
  commentPreview: commentPreview,
);

/// 테스트용 댓글 하나.
///
/// [replies]는 **최상위 댓글에만** 준다 — 답글의 답글은 없다(2차 가이드 §1).
/// [parentCommentId]가 있으면 답글이며 화면이 들여쓴다.
Comment fakeComment({
  String id = 'c1',
  String body = 'Nice!',
  String nickname = 'Minji',
  bool ownedByViewer = false,
  String? parentCommentId,
  List<Comment> replies = const <Comment>[],
}) => Comment(
  id: id,
  body: body,
  author: PostAuthor(id: '12', nickname: nickname),
  createdAt: DateTime.utc(2026, 8, 5, 10),
  ownedByViewer: ownedByViewer,
  parentCommentId: parentCommentId,
  replies: replies,
);
