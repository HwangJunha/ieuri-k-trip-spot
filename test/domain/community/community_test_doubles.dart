import 'dart:typed_data';

import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/blocked_user.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/comment.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_chip.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/nearby_spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_author.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_sort_order.dart';
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
  int viewCount = 0,
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

  /// 마지막 피드 조회에 넘어간 인자 — 범위·필터·정렬이 서버로 전달되는지 확인한다.
  ({
    String? spotId,
    double? latitude,
    double? longitude,
    TargetCategory? category,
    String? tag,
    PostSortOrder? sort,
    bool? hiddenByViewer,
    String? after,
  })?
  lastFetchPosts;

  /// 피드 조회에 넘어간 인자 **전부**(호출 순서대로). 정렬을 바꿨을 때 이전 커서를
  /// 재사용하지 않는지 보려면 마지막 한 번이 아니라 이력을 봐야 한다.
  final List<({PostSortOrder? sort, String? after, bool? hiddenByViewer})>
  fetchPostsCalls =
      <({PostSortOrder? sort, String? after, bool? hiddenByViewer})>[];

  int likeCalls = 0;
  int unlikeCalls = 0;

  /// 첫 페이지 조회 횟수. 당겨서 새로고침이 **실제로 다시 조회하는지** 본다.
  int firstPageCalls = 0;

  /// 설정하면 두 번째 이후의 첫 페이지 조회가 이 목록을 돌려준다 — 새로고침으로
  /// 목록이 갱신되는 것을 검증하기 위한 장치다.
  List<Post>? refreshedPosts;

  /// 정렬별로 다른 목록을 돌려줄 때 쓴다 — **정렬을 서버가 한다**는 것을 검증하기
  /// 위한 장치다. 여기 없는 정렬은 [posts]로 떨어진다.
  Map<PostSortOrder, List<Post>> postsBySort =
      const <PostSortOrder, List<Post>>{};

  /// `hiddenByViewer: true`로 조회했을 때 돌려줄 목록(숨김 해제 화면용).
  List<Post> hiddenPosts = const <Post>[];

  @override
  Future<CursorPage<Post>> fetchPosts({
    String? spotId,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    TargetCategory? category,
    String? tag,
    PostSortOrder? sort,
    bool? hiddenByViewer,
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
      sort: sort,
      hiddenByViewer: hiddenByViewer,
      after: after,
    );
    fetchPostsCalls.add((
      sort: sort,
      after: after,
      hiddenByViewer: hiddenByViewer,
    ));
    // 숨김 목록은 별도 축이다 — 피드와 섞이지 않는다(2차 가이드 §2).
    if (hiddenByViewer ?? false) {
      return CursorPage<Post>(items: hiddenPosts, hasNextPage: false);
    }
    if (after != null) {
      return CursorPage<Post>(items: nextPagePosts, hasNextPage: false);
    }
    firstPageCalls++;
    final List<Post> first0 =
        postsBySort[sort] ??
        (firstPageCalls > 1 ? (refreshedPosts ?? posts) : posts);
    return CursorPage<Post>(
      items: first0,
      hasNextPage: hasNextPage,
      endCursor: hasNextPage ? 'cursor-1' : null,
    );
  }

  /// `post(id:)`가 돌려줄 글. [post]와 달리 생성 후에도 바꿀 수 있다 — 수정 컴포저는
  /// 이 조회로 제목·본문·사진을 채우므로, 테스트가 케이스마다 다른 글을 세운다.
  /// 설정하지 않으면 [post]로 떨어진다.
  Post? postById;

  /// `post(id:)` 조회에 넘어간 마지막 id.
  String? lastFetchedPostId;

  /// 설정하면 `post(id:)`가 이 오류를 던진다(수정 컴포저의 조회 실패 상태 검증용).
  Object? postError;

  @override
  Future<Post?> fetchPost(String id) async {
    lastFetchedPostId = id;
    if (postError != null) throw postError!;
    if (feedError != null) throw feedError!;
    return postById ?? post;
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

  /// 서버가 내려주는 카테고리 줄 구성. **언어마다 다르고 빈 목록도 정상이라**
  /// 기본값을 비워 둔다 — 칩을 그리는 테스트가 필요한 값을 직접 정한다.
  List<NearbySpotCategory> spotCategories = const <NearbySpotCategory>[];

  /// 카테고리별로 다른 목록을 돌려줄 때 쓴다. 여기 없는 카테고리는 [nearbySpots]로
  /// 떨어진다 — 서버가 진짜로 거른다는 것을 검증하기 위한 장치다.
  Map<NearbySpotCategory, List<NearbySpot>> nearbySpotsByCategory =
      const <NearbySpotCategory, List<NearbySpot>>{};

  /// 마지막 주변 장소 조회 인자.
  ({
    double latitude,
    double longitude,
    NearbySpotCategory? category,
    int? page,
    int? size,
  })?
  lastFetchNearbySpots;

  /// 주변 장소 조회 횟수. 카테고리를 바꿨을 때 실제로 다시 조회하는지 본다.
  int nearbySpotsCalls = 0;

  @override
  Future<List<NearbySpotCategory>> fetchNearbySpotCategories() async =>
      spotCategories;

  @override
  Future<OffsetPage<NearbySpot>> fetchNearbySpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    NearbySpotCategory? category,
    int? page,
    int? size,
  }) async {
    nearbySpotsCalls++;
    if (nearbySpotsError != null) throw nearbySpotsError!;
    lastFetchNearbySpots = (
      latitude: latitude,
      longitude: longitude,
      category: category,
      page: page,
      size: size,
    );
    if ((page ?? 0) > 0) {
      return OffsetPage<NearbySpot>(
        items: nextNearbySpots,
        page: page!,
        hasNext: false,
      );
    }
    return OffsetPage<NearbySpot>(
      items: category == null
          ? nearbySpots
          : nearbySpotsByCategory[category] ?? nearbySpots,
      page: 0,
      hasNext: nearbySpotsHasNext,
    );
  }

  /// 장소 선택 시트의 "좋아요한 장소" 탭이 받을 목록. **빈 목록이 기본이다** —
  /// 좋아요한 장소가 없는 계정이 정상 상태이기 때문이다.
  List<NearbySpot> likedSpots = const <NearbySpot>[];

  /// `after`가 주어진 두 번째 조회에서 돌려줄 항목들(추가 로딩 검증용).
  List<NearbySpot> nextLikedSpots = const <NearbySpot>[];

  bool likedSpotsHasNext = false;

  /// 설정하면 좋아요한 장소 조회가 이 오류를 던진다.
  Object? likedSpotsError;

  /// 카테고리별로 다른 목록을 돌려줄 때 쓴다 — 카테고리 줄이 이 탭에도 걸리는지
  /// 검증하기 위한 장치다.
  Map<NearbySpotCategory, List<NearbySpot>> likedSpotsByCategory =
      const <NearbySpotCategory, List<NearbySpot>>{};

  /// 마지막 좋아요한 장소 조회 인자.
  ({NearbySpotCategory? category, int? first, String? after})? lastFetchLiked;

  int likedSpotsCalls = 0;

  @override
  Future<CursorPage<NearbySpot>> fetchLikedSpots({
    NearbySpotCategory? category,
    int? first,
    String? after,
  }) async {
    likedSpotsCalls++;
    if (likedSpotsError != null) throw likedSpotsError!;
    lastFetchLiked = (category: category, first: first, after: after);
    if (after != null) {
      return CursorPage<NearbySpot>(items: nextLikedSpots, hasNextPage: false);
    }
    return CursorPage<NearbySpot>(
      items: category == null
          ? likedSpots
          : likedSpotsByCategory[category] ?? likedSpots,
      hasNextPage: likedSpotsHasNext,
      endCursor: likedSpotsHasNext ? 'liked-cursor-1' : null,
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
  ({
    String postId,
    String title,
    String body,
    List<String>? photoKeys,
    TargetCategory? category,
    bool changeSpot,
    String? spotId,
    List<String>? tags,
  })?
  lastEditPost;
  ({String postId, String body, String? parentCommentId})? lastCreateComment;
  String? lastHiddenPostId;
  String? lastUnhiddenPostId;
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

  /// 1단계(`createPostImageUploadUrls`)에 넘어간 요청들, 호출마다 한 건.
  ///
  /// **비어 있다는 것이 "사진을 골랐을 뿐 아직 아무것도 올리지 않았다"의 증거다** —
  /// 업로드가 등록 시점으로 미뤄졌는지는 이 목록으로만 확인할 수 있다.
  final List<List<PostImageUploadRequest>> uploadUrlCalls =
      <List<PostImageUploadRequest>>[];

  /// 3단계(`confirmPostImageUploads`)에 넘어간 임시 키들, 호출마다 한 건.
  final List<List<String>> confirmCalls = <List<String>>[];

  /// 설정하면 1단계 발급이 이 오류를 던진다. [mutationError]와 분리한 이유는
  /// **업로드가 통째로 실패해도 글은 올라가야** 하기 때문이다 — 두 실패를 한
  /// 스위치로 묶으면 그 경로를 검증할 수 없다.
  Object? uploadUrlError;

  /// 설정하면 3단계 확인이 이 오류를 던진다. [uploadUrlError]와 같은 이유로 분리했다.
  Object? confirmError;

  /// 설정하면 1단계 발급이 이 Future가 완결될 때까지 멈춘다. **업로드가 도는 동안의
  /// 화면 상태**(등록 버튼이 스피너로 바뀌어 다시 눌리지 않는지)를 보려면 그 순간에
  /// 멈춰 세울 수단이 필요하다.
  Future<void>? uploadGate;

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
    TargetCategory? category,
    bool changeSpot = false,
    String? spotId,
    List<String>? tags,
  }) async {
    lastEditPost = (
      postId: postId,
      title: title,
      body: body,
      photoKeys: photoKeys,
      category: category,
      changeSpot: changeSpot,
      spotId: spotId,
      tags: tags,
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
    String? parentCommentId,
  }) async {
    lastCreateComment = (
      postId: postId,
      body: body,
      parentCommentId: parentCommentId,
    );
    if (mutationError != null) throw mutationError!;
    return 'new-comment';
  }

  @override
  Future<void> hidePost(String postId) async {
    lastHiddenPostId = postId;
    if (mutationError != null) throw mutationError!;
  }

  @override
  Future<void> unhidePost(String postId) async {
    lastUnhiddenPostId = postId;
    if (mutationError != null) throw mutationError!;
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
    uploadUrlCalls.add(images);
    if (uploadGate != null) await uploadGate;
    // **[mutationError]를 보지 않는다.** 그것은 `createPost`/`editPost`의 실패
    // 스위치다 — 사진 업로드까지 함께 죽이면 "글은 거부됐지만 사진은 이미 올라간"
    // 경로를 재현할 수 없다. 업로드 실패는 [uploadUrlError]로 따로 세운다.
    if (uploadUrlError != null) throw uploadUrlError!;
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
    confirmCalls.add(objectKeys);
    if (confirmError != null) throw confirmError!;
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
