import 'dart:typed_data';

import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/blocked_user.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/comment.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_chip.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_author.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/report_reason.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/repository/community_repository.dart';

/// 테스트용 [Post] 하나. 값을 지정하지 않은 필드는 검증에 쓰이지 않는 자리채움이다.
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
  bool likedByViewer = false,
  bool ownedByViewer = false,
  bool hidden = false,
  bool edited = false,
  bool withoutSpot = false,
  List<String> photoKeys = const <String>[],
  List<Comment> commentPreview = const <Comment>[],
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
  createdAt: DateTime.utc(2026, 8, 5, 9),
  photoKeys: photoKeys,
  likeCount: likeCount,
  commentCount: commentCount,
  likedByViewer: likedByViewer,
  ownedByViewer: ownedByViewer,
  hidden: hidden,
  edited: edited,
  commentPreview: commentPreview,
);

Comment fakeComment({
  String id = 'c1',
  String body = 'Nice!',
  bool ownedByViewer = false,
}) => Comment(
  id: id,
  body: body,
  author: const PostAuthor(id: '12', nickname: 'Minji'),
  createdAt: DateTime.utc(2026, 8, 5, 10),
  ownedByViewer: ownedByViewer,
);

/// 정형 응답을 돌려주는 [CommunityRepository]. provider·위젯 테스트가 이 하나만
/// 오버라이드해 네트워크 없이 상태 전이를 검증한다.
class FakeCommunityRepository implements CommunityRepository {
  FakeCommunityRepository({
    this.posts = const <Post>[],
    this.chips = const <CommunityChip>[],
    this.comments = const <Comment>[],
    this.blockedUsers = const <BlockedUser>[],
    this.post,
    this.hasNextPage = false,
    this.nextPagePosts = const <Post>[],
    this.feedError,
    this.commentsError,
    this.likeError,
    this.serverLikeCount,
  });

  final List<Post> posts;
  final List<CommunityChip> chips;
  final List<Comment> comments;
  final List<BlockedUser> blockedUsers;
  final Post? post;
  final bool hasNextPage;

  /// `after`가 주어진 두 번째 조회에서 돌려줄 항목들.
  final List<Post> nextPagePosts;

  /// 설정하면 피드 조회가 이 오류를 던진다.
  final Object? feedError;

  /// 설정하면 댓글 조회가 이 오류를 던진다.
  final Object? commentsError;

  /// 설정하면 좋아요 뮤테이션이 이 오류를 던진다.
  final Object? likeError;

  /// 좋아요 성공 시 서버가 돌려주는 최종 수(되맞춤 검증용).
  final int? serverLikeCount;

  /// 마지막 피드 조회에 넘어간 인자 — 범위·필터가 서버로 전달되는지 확인한다.
  ({
    String? spotId,
    double? latitude,
    double? longitude,
    TargetCategory? category,
    String? tag,
    String? after,
  })?
  lastFetchPosts;

  int likeCalls = 0;
  int unlikeCalls = 0;

  @override
  Future<CursorPage<Post>> fetchPosts({
    String? spotId,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    TargetCategory? category,
    String? tag,
    int? first,
    String? after,
  }) async {
    if (feedError != null) throw feedError!;
    lastFetchPosts = (
      spotId: spotId,
      latitude: latitude,
      longitude: longitude,
      category: category,
      tag: tag,
      after: after,
    );
    if (after != null) {
      return CursorPage<Post>(items: nextPagePosts, hasNextPage: false);
    }
    return CursorPage<Post>(
      items: posts,
      hasNextPage: hasNextPage,
      endCursor: hasNextPage ? 'cursor-1' : null,
    );
  }

  @override
  Future<Post?> fetchPost(String id) async {
    if (feedError != null) throw feedError!;
    return post;
  }

  @override
  Future<CursorPage<Comment>> fetchComments(
    String postId, {
    int? first,
    String? after,
  }) async {
    if (commentsError != null) throw commentsError!;
    return CursorPage<Comment>(items: comments, hasNextPage: false);
  }

  @override
  Future<List<CommunityChip>> fetchCommunityChips() async => chips;

  /// 컴포저 장소 선택 시트가 받을 주변 장소. 거리 오름차순으로 오는 것을 흉내 낸다.
  List<NearbySpot> nearbySpots = const <NearbySpot>[];

  /// `page`가 0보다 클 때 돌려줄 항목들(추가 로딩 검증용).
  List<NearbySpot> nextNearbySpots = const <NearbySpot>[];

  /// 설정하면 주변 장소 조회가 이 오류를 던진다 — 위치 실패·조회 실패 상태 검증용.
  Object? nearbySpotsError;

  bool nearbySpotsHasNext = false;

  /// 마지막 주변 장소 조회 인자.
  ({double latitude, double longitude, int? page})? lastFetchNearbySpots;

  @override
  Future<OffsetPage<NearbySpot>> fetchNearbySpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    int? page,
    int? size,
  }) async {
    if (nearbySpotsError != null) throw nearbySpotsError!;
    lastFetchNearbySpots = (
      latitude: latitude,
      longitude: longitude,
      page: page,
    );
    if ((page ?? 0) > 0) {
      return OffsetPage<NearbySpot>(
        items: nextNearbySpots,
        page: page!,
        hasNext: false,
      );
    }
    return OffsetPage<NearbySpot>(
      items: nearbySpots,
      page: 0,
      hasNext: nearbySpotsHasNext,
    );
  }

  @override
  Future<CursorPage<BlockedUser>> fetchBlockedUsers({
    int? first,
    String? after,
  }) async => CursorPage<BlockedUser>(items: blockedUsers, hasNextPage: false);

  @override
  Future<int?> likePost(String postId) async {
    likeCalls++;
    if (likeError != null) throw likeError!;
    return serverLikeCount;
  }

  @override
  Future<int?> unlikePost(String postId) async {
    unlikeCalls++;
    if (likeError != null) throw likeError!;
    return serverLikeCount;
  }

  // --- 쓰기/모더레이션 ---------------------------------------------------------

  /// 설정하면 아래 뮤테이션들이 이 오류를 던진다.
  Object? mutationError;

  /// `createPost`가 돌려줄 새 글 id. 가이드 §5대로 서버는 id만 준다.
  String? createdPostId = 'new-post';

  ({
    TargetCategory category,
    String title,
    String body,
    String? spotId,
    List<String> tags,
    List<String> photoKeys,
  })?
  lastCreatePost;
  ({String postId, String title, String body, List<String>? photoKeys})?
  lastEditPost;
  ({String postId, String body})? lastCreateComment;
  String? lastDeletedCommentId;
  String? lastBlockedMemberId;
  String? lastUnblockedMemberId;
  String? lastDeletedPostId;
  String? lastDeletedImageKey;
  ({
    ReportTargetType targetType,
    String targetId,
    ReportReason reason,
    String? detail,
  })?
  lastReport;

  /// 1단계가 돌려줄 발급 URL들. 빈 목록은 "전부 거부"를 뜻한다(가이드 §4).
  List<PostImageUploadUrl> uploadUrls = const <PostImageUploadUrl>[];

  /// 3단계 확인 결과. 부분 성공을 흉내 낼 수 있다.
  PostImageConfirmation confirmation = const PostImageConfirmation();

  /// PUT이 실패할 uploadUrl 집합.
  Set<String> failingUploadUrls = <String>{};

  final List<String> uploadedUrls = <String>[];

  @override
  Future<String?> createPost({
    required TargetCategory category,
    required String title,
    required String body,
    String? spotId,
    List<String> tags = const <String>[],
    List<String> photoKeys = const <String>[],
  }) async {
    lastCreatePost = (
      category: category,
      title: title,
      body: body,
      spotId: spotId,
      tags: tags,
      photoKeys: photoKeys,
    );
    if (mutationError != null) throw mutationError!;
    return createdPostId;
  }

  @override
  Future<void> editPost({
    required String postId,
    required String title,
    required String body,
    List<String>? photoKeys,
  }) async {
    lastEditPost = (
      postId: postId,
      title: title,
      body: body,
      photoKeys: photoKeys,
    );
    if (mutationError != null) throw mutationError!;
  }

  @override
  Future<void> deletePost(String postId) async {
    lastDeletedPostId = postId;
    if (mutationError != null) throw mutationError!;
  }

  @override
  Future<String?> createComment({
    required String postId,
    required String body,
  }) async {
    lastCreateComment = (postId: postId, body: body);
    if (mutationError != null) throw mutationError!;
    return 'new-comment';
  }

  @override
  Future<void> deleteComment(String commentId) async {
    lastDeletedCommentId = commentId;
    if (mutationError != null) throw mutationError!;
  }

  @override
  Future<List<PostImageUploadUrl>> createPostImageUploadUrls(
    List<PostImageUploadRequest> images,
  ) async {
    if (mutationError != null) throw mutationError!;
    return uploadUrls;
  }

  @override
  Future<void> uploadPostImage({
    required String uploadUrl,
    required String contentType,
    required Uint8List bytes,
  }) async {
    if (failingUploadUrls.contains(uploadUrl)) {
      throw Exception('storage rejected');
    }
    uploadedUrls.add(uploadUrl);
  }

  @override
  Future<PostImageConfirmation> confirmPostImageUploads(
    List<String> objectKeys,
  ) async {
    if (mutationError != null) throw mutationError!;
    return confirmation;
  }

  @override
  Future<void> deletePostImage(String objectKey) async {
    lastDeletedImageKey = objectKey;
  }

  @override
  Future<void> blockUser(String targetMemberId) async {
    lastBlockedMemberId = targetMemberId;
    if (mutationError != null) throw mutationError!;
  }

  @override
  Future<void> unblockUser(String targetMemberId) async {
    lastUnblockedMemberId = targetMemberId;
    if (mutationError != null) throw mutationError!;
  }

  @override
  Future<void> reportContent({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
    String? detail,
  }) async {
    lastReport = (
      targetType: targetType,
      targetId: targetId,
      reason: reason,
      detail: detail,
    );
    if (mutationError != null) throw mutationError!;
  }
}
