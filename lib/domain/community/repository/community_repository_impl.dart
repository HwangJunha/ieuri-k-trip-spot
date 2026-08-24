import 'dart:io';
import 'dart:typed_data';

import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/shared_schema.graphql.dart';
import '../../../common/network/graphql_failure.dart';
import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
// `spot_schema.graphql.dart` import는 SPEC-0020에서 사라졌다 — 서버 `SpotCategory`가
// enum에서 객체로 바뀌며 `Enum$SpotCategory`가 없어졌고, 이제 카테고리를 코드
// 문자열로 주고받으므로 생성 타입을 빌려올 이유가 없다. 도메인 모델은 여전히
// 커뮤니티가 소유한 `NearbySpotCategory`다(CLAUDE.md §3).
import '../model/blocked_user.dart';
import '../../../common/model/comment.dart';
import '../model/community_failure.dart';
import '../model/nearby_spot.dart';
import '../model/nearby_spot_category.dart';
import '../../../common/model/post.dart';
import '../../../common/model/post_author.dart';
import '../../../common/model/post_image_upload.dart';
import '../model/post_sort_order.dart';
import '../../../common/model/post_spot.dart';
import '../model/report_reason.dart';
import '../../../common/model/target_category.dart';
import 'community_operations.graphql.dart';
import 'community_repository.dart';
import 'community_schema.graphql.dart';

/// GraphQL 기반 [CommunityRepository](SPEC-0010). graphql_codegen이 만든 타입 연산을
/// 공용 클라이언트로 실행하고 응답을 도메인 모델로 매핑한다. 생성 타입
/// (`*.graphql.dart`)은 **이 파일 밖으로 나가지 않는다**(CLAUDE.md §3, POL-020).
///
/// 실패 판정은 두 갈래다(가이드 §7):
///  - 최상위 `errors[]` — **인증 실패만**. `path`로 전체/부분 실패를 가른다.
///  - payload의 `success`·`userErrors[]` — 나머지 전부. **HTTP는 실패해도 200이다.**
///
/// [uploadPostImage]만 GraphQL이 아니다 — 사진 바이트는 서버를 거치지 않고 앱이
/// 스토리지로 직접 PUT한다(가이드 §4). 그래도 repository에 두는 이유는 그것이
/// 데이터 접근이고, 위젯이나 provider가 HTTP를 직접 부르면 계층이 무너지기 때문이다.
class CommunityRepositoryImpl implements CommunityRepository {
  CommunityRepositoryImpl(this._client, {HttpClient? httpClient})
    : _httpClient = httpClient,
      // 우리가 만든 클라이언트만 닫는다 — 주입받은 것은 호출부 소유다.
      _ownsHttpClient = httpClient == null;

  final GraphQLClient _client;

  /// 스토리지 PUT 전용 클라이언트. **`package:http`가 의존성에 없어 `dart:io`의
  /// [HttpClient]를 쓴다** — 이것 하나 때문에 새 패키지를 들이지 않는다.
  /// 테스트가 갈아끼울 수 있도록 주입 가능하게 두고, 없으면 그때 만든다.
  final HttpClient? _httpClient;

  /// 클라이언트를 우리가 만들었는지. 주입받은 것을 닫으면 호출부의 다음 요청이
  /// 깨진다.
  final bool _ownsHttpClient;

  @override
  Future<CursorPage<Post>> fetchPosts({
    String? catalogId,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    Iterable<TargetCategory>? categories,
    String? tag,
    PostSortOrder? sort,
    bool? hiddenByViewer,
    int? first,
    String? after,
  }) async {
    // 좌표는 **둘 다** 있어야 의미가 있다. 하나만 주면 서버가 둘 다 무시하므로,
    // 어중간한 요청을 보내느니 여기서 아예 빼서 "전체 피드"라는 의도를 분명히 한다
    // (가이드 §2).
    final bool hasCoords = latitude != null && longitude != null;
    // **빈 목록은 null로 접는다.** 빈 배열을 그대로 보내면 서버가
    // `EmptyCategorySetException`으로 거절하는데, 그 오류는 `errorType: INTERNAL`에
    // Java 예외명이 실려 올 뿐이라 코드로 분기할 수도 없다. 인자를 생략하면 전체다.
    final List<Enum$TargetCategory>? categoryInput =
        (categories == null || categories.isEmpty)
        ? null
        : categories.map(_categoryInput).toList(growable: false);
    final Map<String, dynamic> data = await _query(
      documentNodeQueryPosts,
      Variables$Query$Posts(
        catalogId: catalogId,
        latitude: hasCoords ? latitude : null,
        longitude: hasCoords ? longitude : null,
        radiusMeters: hasCoords ? radiusMeters : null,
        categories: categoryInput,
        tag: tag,
        // null이면 변수를 보내지 않아 서버 기본값(LATEST)이 걸린다.
        sort: sort == null ? null : _sortInput(sort),
        hiddenByViewer: hiddenByViewer,
        first: first,
        after: after,
      ).toJson(),
      'posts',
    );
    final Query$Posts$posts result = Query$Posts.fromJson(data).posts;
    return CursorPage<Post>(
      items: result.edges
          .map((Query$Posts$posts$edges e) => _postFromCard(e.node))
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<Post?> fetchPost(String id) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryPostDetail,
      Variables$Query$PostDetail(id: id).toJson(),
      'post',
    );
    // null은 오류가 아니다 — 차단·숨김·삭제면 서버가 오류 대신 null을 준다(가이드 §6).
    final Fragment$PostCardFields? node = Query$PostDetail.fromJson(data).post;
    return node == null ? null : _postFromCard(node);
  }

  @override
  Future<CursorPage<Comment>> fetchComments(
    String postId, {
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryComments,
      Variables$Query$Comments(
        postId: postId,
        first: first,
        after: after,
      ).toJson(),
      'comments',
    );
    final Query$Comments$comments result = Query$Comments.fromJson(
      data,
    ).comments;
    return CursorPage<Comment>(
      items: result.edges
          .map((Query$Comments$comments$edges e) => _commentFromNode(e.node))
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<OffsetPage<NearbySpot>> fetchNearbySpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    NearbySpotCategory? category,
    int? page,
    int? size,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryNearbySpots,
      Variables$Query$NearbySpots(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        // null이면 전체다 — 서버가 nullable로 받는다.
        categories: category == null ? null : _spotCategoryInput(category),
        page: page,
        size: size,
      ).toJson(),
      'spots',
    );
    final Query$NearbySpots$spots result = Query$NearbySpots.fromJson(
      data,
    ).spots;
    return OffsetPage<NearbySpot>(
      items: result.items
          .map(
            (Query$NearbySpots$spots$items s) => NearbySpot(
              id: s.id,
              title: s.title,
              distanceMeters: s.distanceMeters,
              // 서버가 빈 문자열을 줄 수 있다 — 화면이 자리채움으로 떨어지도록
              // 여기서 null로 접는다.
              thumbnailImageUrl: s.thumbnailImageUrl.isEmpty
                  ? null
                  : s.thumbnailImageUrl,
              address: s.address,
            ),
          )
          .toList(growable: false),
      page: result.page,
      hasNext: result.hasNext,
      totalCount: result.totalCount,
    );
  }

  @override
  Future<OffsetPage<NearbySpot>> searchSpots({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    NearbySpotCategory? category,
    int? page,
    int? size,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryCommunitySearchSpots,
      Variables$Query$CommunitySearchSpots(
        query: query,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        // null이면 전체다 — 주변 목록과 같은 규약.
        categories: category == null ? null : _spotCategoryInput(category),
        page: page,
        size: size,
      ).toJson(),
      'searchSpots',
    );
    final Query$CommunitySearchSpots$searchSpots payload =
        Query$CommunitySearchSpots.fromJson(data).searchSpots;

    // 입력 검증 실패(EMPTY_QUERY·QUERY_TOO_LONG·RADIUS_TOO_LARGE)는 최상위
    // errors[]가 아니라 payload로 온다(POL-015). 질의 원문은 사용자 입력이라
    // 로깅하지 않고 코드만 남긴다(POL-013).
    final List<({String code, String? field})> userErrors = payload.userErrors
        .map(
          (Query$CommunitySearchSpots$searchSpots$userErrors e) =>
              (code: e.code, field: e.field),
        )
        .toList(growable: false);
    if (userErrors.isNotEmpty) {
      GraphqlDebugLog.userErrors('searchSpots', userErrors);
      throw CommunityFailure.userError(userErrors.first.code);
    }
    if (!payload.success) throw CommunityFailure.unknown;

    final Query$CommunitySearchSpots$searchSpots$connection c =
        payload.connection;
    return OffsetPage<NearbySpot>(
      items: c.items
          .map(
            (Query$CommunitySearchSpots$searchSpots$connection$items i) =>
                NearbySpot(
                  id: i.id,
                  title: i.title,
                  distanceMeters: i.distanceMeters,
                  // 서버가 빈 문자열을 줄 수 있다 — 화면이 자리채움으로 떨어지도록
                  // 여기서 null로 접는다(주변 목록과 같은 규칙).
                  thumbnailImageUrl: i.thumbnailImageUrl.isEmpty
                      ? null
                      : i.thumbnailImageUrl,
                  address: i.address,
                ),
          )
          .toList(growable: false),
      page: c.page,
      hasNext: c.hasNext,
      totalCount: c.totalCount,
    );
  }

  @override
  Future<CursorPage<NearbySpot>> fetchLikedSpots({
    NearbySpotCategory? category,
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryCommunityLikedSpots,
      Variables$Query$CommunityLikedSpots(
        // 주변 장소와 같은 필터다 — null이면 전체.
        categories: category == null ? null : _spotCategoryInput(category),
        first: first,
        after: after,
      ).toJson(),
      'likedSpots',
    );
    final Query$CommunityLikedSpots$likedSpots result =
        Query$CommunityLikedSpots.fromJson(data).likedSpots;
    return CursorPage<NearbySpot>(
      items: result.edges
          .map(
            (Query$CommunityLikedSpots$likedSpots$edges e) => NearbySpot(
              id: e.node.id,
              title: e.node.title,
              // **거리가 없다** — `likedSpots`는 좌표를 받지 않는다. 시트가 그 자리에
              // 주소를 그린다.
              thumbnailImageUrl: e.node.thumbnailImageUrl.isEmpty
                  ? null
                  : e.node.thumbnailImageUrl,
              address: e.node.address,
            ),
          )
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<List<NearbySpotCategory>> fetchNearbySpotCategories() async {
    // 언어는 인자가 아니라 `Accept-Language` 헤더로 간다 — 서버가 그 언어에서
    // 쓰이는 카테고리만 골라 준다. 빈 목록이 정상이므로 오류로 만들지 않는다.
    final Map<String, dynamic> data = await _query(
      documentNodeQueryNearbySpotCategories,
      const <String, dynamic>{},
      'availableSpotCategories',
    );
    return Query$NearbySpotCategories.fromJson(data).availableSpotCategories
        .map(
          (Query$NearbySpotCategories$availableSpotCategories c) =>
              _spotCategoryFromCode(c.code),
        )
        // 클라이언트가 모르는 값은 그릴 수 없으므로 뺀다 — 칩 하나 때문에 줄
        // 전체를 실패시키지 않는다(상단 칩과 같은 규약).
        .whereType<NearbySpotCategory>()
        .toList(growable: false);
  }

  @override
  Future<List<TargetCategory>> fetchCommunityChips() async {
    // 앱 구분(X-App-Key)과 언어(Accept-Language)는 인자가 아니라 헤더로 간다
    // (가이드 §1). 빈 목록이 정상이므로 오류로 만들지 않는다(§2).
    final Map<String, dynamic> data = await _query(
      documentNodeQueryCommunityChips,
      const <String, dynamic>{},
      'communityChips',
    );
    return Query$CommunityChips.fromJson(data).communityChips
        .map(_categoryFromEnum)
        // **모르는 코드는 여기서만 버린다.** 서버가 카테고리를 늘리면 생성 enum이
        // `$unknown`을 주는데, 이 필드는 값 자체가 카테고리라서 클라이언트에 라벨도
        // 아이콘도 없다 — 그리려 해도 그릴 것이 없다. 칩 하나 때문에 상단 줄 전체를
        // 실패시키지 않으려고 거르며, 이것이 서버가 늘린 카테고리를 사용자에게
        // 숨기는 유일한 지점이다(앱 업데이트로 enum이 추가되면 그대로 나타난다).
        // 반대로 `kCategoryDisplayOrder`에 없을 뿐인 **아는** 코드는 버리지 않고
        // 줄 끝에 붙는다(`orderedCategoryChips`).
        .whereType<TargetCategory>()
        .toList(growable: false);
  }

  @override
  Future<CursorPage<BlockedUser>> fetchBlockedUsers({
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryBlockedUsers,
      Variables$Query$BlockedUsers(first: first, after: after).toJson(),
      'blockedUsers',
    );
    final Query$BlockedUsers$blockedUsers result = Query$BlockedUsers.fromJson(
      data,
    ).blockedUsers;
    return CursorPage<BlockedUser>(
      items: result.edges
          .map(
            (Query$BlockedUsers$blockedUsers$edges e) => BlockedUser(
              member: _authorFromNode(
                id: e.node.id,
                nickname: e.node.nickname,
                profileImageUrl: e.node.profileImageUrl,
              ),
              blockedAt: _parseTime(e.blockedAt),
            ),
          )
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<int?> likePost(String postId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationLikePost,
      Variables$Mutation$LikePost(postId: postId).toJson(),
      'likePost',
    );
    final Mutation$LikePost$likePost payload = Mutation$LikePost.fromJson(
      data,
    ).likePost;
    _check(
      'likePost',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$LikePost$likePost$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
    return payload.likeCount;
  }

  @override
  Future<int?> unlikePost(String postId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationUnlikePost,
      Variables$Mutation$UnlikePost(postId: postId).toJson(),
      'unlikePost',
    );
    final Mutation$UnlikePost$unlikePost payload = Mutation$UnlikePost.fromJson(
      data,
    ).unlikePost;
    _check(
      'unlikePost',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$UnlikePost$unlikePost$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
    return payload.likeCount;
  }

  @override
  Future<String?> createPost({
    required TargetCategory category,
    required String title,
    required String body,
    String? catalogId,
    List<String> tags = const <String>[],
    List<String> photoKeys = const <String>[],
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationCreatePost,
      Variables$Mutation$CreatePost(
        category: _categoryInput(category),
        catalogId: catalogId,
        tags: tags,
        title: title,
        body: body,
        photoKeys: photoKeys,
      ).toJson(),
      'createPost',
    );
    final Mutation$CreatePost$createPost payload = Mutation$CreatePost.fromJson(
      data,
    ).createPost;
    _check(
      'createPost',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$CreatePost$createPost$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
    // `post`는 항상 null이라 요청조차 하지 않는다 — id만 돌려주고 화면이 그 id로
    // 다시 조회하거나 피드를 새로 고친다(가이드 §5).
    return payload.postId;
  }

  @override
  Future<void> editPost({
    required String postId,
    required String title,
    required String body,
    List<String>? photoKeys,
    TargetCategory? category,
    bool changeSpot = false,
    String? catalogId,
    List<String>? tags,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationEditPost,
      Variables$Mutation$EditPost(
        postId: postId,
        title: title,
        body: body,
        // null이면 변수 자체를 보내지 않아 사진을 건드리지 않는다. 빈 배열을 보내면
        // 사진이 전부 떨어진다 — 둘은 다른 뜻이다(가이드 §5). [tags]도 같다.
        photoKeys: photoKeys,
        category: category == null ? null : _categoryInput(category),
        // **장소를 건드리지 않을 때는 catalogId를 아예 싣지 않는다.** changeSpot이
        // false면 서버가 catalogId를 무시하지만, 보내지 않는 편이 의도가 분명하다.
        changeSpot: changeSpot,
        catalogId: changeSpot ? catalogId : null,
        tags: tags,
      ).toJson(),
      'editPost',
    );
    final Mutation$EditPost$editPost payload = Mutation$EditPost.fromJson(
      data,
    ).editPost;
    _check(
      'editPost',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$EditPost$editPost$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationDeletePost,
      Variables$Mutation$DeletePost(postId: postId).toJson(),
      'deletePost',
    );
    final Mutation$DeletePost$deletePost payload = Mutation$DeletePost.fromJson(
      data,
    ).deletePost;
    _check(
      'deletePost',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$DeletePost$deletePost$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<String?> createComment({
    required String postId,
    required String body,
    String? parentCommentId,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationCreateComment,
      Variables$Mutation$CreateComment(
        postId: postId,
        body: body,
        // null이면 변수를 보내지 않아 최상위 댓글이 된다(2차 가이드 §1).
        parentCommentId: parentCommentId,
      ).toJson(),
      'createComment',
    );
    final Mutation$CreateComment$createComment payload =
        Mutation$CreateComment.fromJson(data).createComment;
    _check(
      'createComment',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$CreateComment$createComment$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
    return payload.commentId;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationDeleteComment,
      Variables$Mutation$DeleteComment(commentId: commentId).toJson(),
      'deleteComment',
    );
    final Mutation$DeleteComment$deleteComment payload =
        Mutation$DeleteComment.fromJson(data).deleteComment;
    _check(
      'deleteComment',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$DeleteComment$deleteComment$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<List<PostImageUploadUrl>> createPostImageUploadUrls(
    List<PostImageUploadRequest> images,
  ) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationCreatePostImageUploadUrls,
      Variables$Mutation$CreatePostImageUploadUrls(
        images: images
            .map(
              (PostImageUploadRequest r) => Input$PostImageUploadRequest(
                contentType: r.contentType,
                contentLength: r.contentLength,
              ),
            )
            .toList(growable: false),
      ).toJson(),
      'createPostImageUploadUrls',
    );
    final Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls payload =
        Mutation$CreatePostImageUploadUrls.fromJson(
          data,
        ).createPostImageUploadUrls;
    _check(
      'createPostImageUploadUrls',
      payload.success,
      payload.userErrors
          .map(
            (
              Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$userErrors
              e,
            ) => (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
    return payload.uploadUrls
        .map(
          (
            Mutation$CreatePostImageUploadUrls$createPostImageUploadUrls$uploadUrls
            u,
          ) => PostImageUploadUrl(
            uploadUrl: u.uploadUrl,
            objectKey: u.objectKey,
            expiresAt: u.expiresAt,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> uploadPostImage({
    required String uploadUrl,
    required String contentType,
    required Uint8List bytes,
  }) async {
    final HttpClient client = _httpClient ?? HttpClient();
    try {
      final HttpClientRequest request = await client.putUrl(
        Uri.parse(uploadUrl),
      );
      // **두 헤더가 1단계 선언과 정확히 같아야 한다** — 서명에 들어 있어서 다르면
      // 스토리지가 403 SignatureDoesNotMatch로 거부한다(가이드 §4).
      //
      // `contentType` 대신 `set`을 쓰는 이유: HttpHeaders.contentType은 파싱 후
      // 다시 조립하며 charset을 덧붙일 수 있고, 그러면 서명이 깨진다.
      request.headers.set(HttpHeaders.contentTypeHeader, contentType);
      request.headers.contentLength = bytes.length;
      // 압축이 걸리면 Content-Length가 바뀌어 서명이 깨진다.
      request.headers.set(HttpHeaders.acceptEncodingHeader, 'identity');
      // **인증 헤더를 붙이지 않는다** — 서명이 이미 URL에 들어 있다.
      request.add(bytes);

      final HttpClientResponse response = await request.close();
      // 바이트를 비워야 연결이 반환된다.
      await response.drain<void>();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // 서버를 거치지 않은 실패라 GraphQL 응답에 안 나온다 — 여기서만 보인다.
        GraphqlDebugLog.clientThrew(
          'uploadPostImage',
          HttpException('status ${response.statusCode}'),
        );
        throw CommunityFailure.network;
      }
    } on CommunityFailure {
      rethrow;
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew('uploadPostImage', error);
      throw CommunityFailure.network;
    } finally {
      if (_ownsHttpClient) client.close();
    }
  }

  @override
  Future<PostImageConfirmation> confirmPostImageUploads(
    List<String> objectKeys,
  ) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationConfirmPostImageUploads,
      Variables$Mutation$ConfirmPostImageUploads(
        objectKeys: objectKeys,
      ).toJson(),
      'confirmPostImageUploads',
    );
    final Mutation$ConfirmPostImageUploads$confirmPostImageUploads payload =
        Mutation$ConfirmPostImageUploads.fromJson(data).confirmPostImageUploads;

    // **`_check`를 부르지 않는다.** 이 뮤테이션은 장별로 성패가 갈려서, `failed`가
    // 하나라도 있으면 `success: false`지만 `confirmed`의 키는 여전히 유효하다.
    // 실패로 던지면 통과한 장까지 버려져 사용자가 전부 다시 올려야 한다(가이드 §4).
    //
    // 다만 `userErrors`가 온 경우는 요청 자체가 거부된 것이라 실패로 다룬다.
    final List<({String code, String? field})> userErrors = payload.userErrors
        .map(
          (
            Mutation$ConfirmPostImageUploads$confirmPostImageUploads$userErrors
            e,
          ) => (code: e.code, field: e.field),
        )
        .toList(growable: false);
    if (userErrors.isNotEmpty) {
      GraphqlDebugLog.userErrors('confirmPostImageUploads', userErrors);
      throw CommunityFailure.userError(userErrors.first.code);
    }

    return PostImageConfirmation(
      confirmed: payload.confirmed,
      failed: payload.failed
          .map(
            (
              Mutation$ConfirmPostImageUploads$confirmPostImageUploads$failed f,
            ) => PostImageUploadFailure(objectKey: f.objectKey, code: f.code),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> deletePostImage(String objectKey) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationDeletePostImage,
      Variables$Mutation$DeletePostImage(objectKey: objectKey).toJson(),
      'deletePostImage',
    );
    final Mutation$DeletePostImage$deletePostImage payload =
        Mutation$DeletePostImage.fromJson(data).deletePostImage;
    _check(
      'deletePostImage',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$DeletePostImage$deletePostImage$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> hidePost(String postId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationHidePost,
      Variables$Mutation$HidePost(postId: postId).toJson(),
      'hidePost',
    );
    final Mutation$HidePost$hidePost payload = Mutation$HidePost.fromJson(
      data,
    ).hidePost;
    _check(
      'hidePost',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$HidePost$hidePost$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> unhidePost(String postId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationUnhidePost,
      Variables$Mutation$UnhidePost(postId: postId).toJson(),
      'unhidePost',
    );
    final Mutation$UnhidePost$unhidePost payload = Mutation$UnhidePost.fromJson(
      data,
    ).unhidePost;
    _check(
      'unhidePost',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$UnhidePost$unhidePost$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> blockUser(String targetMemberId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationBlockUser,
      Variables$Mutation$BlockUser(targetMemberId: targetMemberId).toJson(),
      'blockUser',
    );
    final Mutation$BlockUser$blockUser payload = Mutation$BlockUser.fromJson(
      data,
    ).blockUser;
    _check(
      'blockUser',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$BlockUser$blockUser$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> unblockUser(String targetMemberId) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationUnblockUser,
      Variables$Mutation$UnblockUser(targetMemberId: targetMemberId).toJson(),
      'unblockUser',
    );
    final Mutation$UnblockUser$unblockUser payload =
        Mutation$UnblockUser.fromJson(data).unblockUser;
    _check(
      'unblockUser',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$UnblockUser$unblockUser$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> reportContent({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
    String? detail,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationReportContent,
      Variables$Mutation$ReportContent(
        targetType: _reportTargetTypeInput(targetType),
        targetId: targetId,
        reason: _reportReasonInput(reason),
        // 공백뿐인 상세는 없는 것과 같다 — 서버가 `REPORT_DETAIL_REQUIRED`로 본다.
        detail: (detail?.trim().isEmpty ?? true) ? null : detail!.trim(),
      ).toJson(),
      'reportContent',
    );
    final Mutation$ReportContent$reportContent payload =
        Mutation$ReportContent.fromJson(data).reportContent;
    _check(
      'reportContent',
      payload.success,
      payload.userErrors
          .map(
            (Mutation$ReportContent$reportContent$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList(growable: false),
    );
  }

  // --- 매핑 (생성 타입 → 도메인) ---------------------------------------------

  /// 카드 필드 fragment → 도메인 [Post]. 목록과 상세가 같은 fragment를 쓰므로 매핑도
  /// 하나다 — 댓글은 루트 쿼리가 따로 받는다(가이드 §2).
  Post _postFromCard(Fragment$PostCardFields n) => Post(
    id: n.id,
    title: n.title,
    body: n.body,
    tags: n.tags,
    category: _categoryFromEnum(n.category),
    // **null일 수 있다** — 장소 없는 글이 허용된다(가이드 §5).
    spot: n.spot == null
        ? null
        : PostSpot(
            id: n.spot!.id,
            title: n.spot!.title,
            thumbnailImageUrl: n.spot!.thumbnailImageUrl,
            category: n.spot!.category == null
                ? null
                : _categoryFromEnum(n.spot!.category!),
          ),
    author: _authorFromNode(
      id: n.author.id,
      nickname: n.author.nickname,
      profileImageUrl: n.author.profileImageUrl,
    ),
    createdAt: _parseTime(n.createdAt),
    photoKeys: n.photoKeys,
    likeCount: n.likeCount,
    commentCount: n.commentCount,
    viewCount: n.viewCount,
    likedByViewer: n.likedByViewer,
    ownedByViewer: n.ownedByViewer,
    hidden: n.hidden,
    edited: n.edited,
  );

  /// 최상위 댓글 하나와 그 답글들.
  ///
  /// **답글 순서를 건드리지 않는다** — 서버가 오래된 순으로 주고, 대화 흐름이라
  /// 뒤집으면 문맥이 끊긴다(2차 가이드 §1). 최상위 목록만 최신순이다.
  Comment _commentFromNode(Query$Comments$comments$edges$node n) => Comment(
    id: n.id,
    body: n.body,
    author: _authorFromNode(
      id: n.author.id,
      nickname: n.author.nickname,
      profileImageUrl: n.author.profileImageUrl,
    ),
    createdAt: _parseTime(n.createdAt),
    ownedByViewer: n.ownedByViewer,
    hidden: n.hidden,
    parentCommentId: n.parentCommentId,
    replies: n.replies.map(_replyFromNode).toList(growable: false),
  );

  /// 답글 하나. **답글의 `replies`는 요청하지 않는다** — 깊이가 2단계라 항상 빈
  /// 목록이며, 도메인 모델에서도 기본값 그대로 비워 둔다.
  Comment _replyFromNode(Query$Comments$comments$edges$node$replies n) =>
      Comment(
        id: n.id,
        body: n.body,
        author: _authorFromNode(
          id: n.author.id,
          nickname: n.author.nickname,
          profileImageUrl: n.author.profileImageUrl,
        ),
        createdAt: _parseTime(n.createdAt),
        ownedByViewer: n.ownedByViewer,
        hidden: n.hidden,
        parentCommentId: n.parentCommentId,
      );

  PostAuthor _authorFromNode({
    required String id,
    required String nickname,
    required String? profileImageUrl,
  }) =>
      PostAuthor(id: id, nickname: nickname, profileImageUrl: profileImageUrl);

  /// 서버가 준 ISO-8601 문자열을 시각으로 파싱한다. 형식이 어긋나면 글 전체를
  /// 실패시키지 않고 epoch로 떨어뜨린다 — 상대 시각 하나 때문에 피드가 비면 손해가
  /// 더 크다.
  DateTime _parseTime(String raw) =>
      DateTime.tryParse(raw)?.toUtc() ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  /// 생성 enum → 도메인 enum. 서버가 새 값을 추가하면 `$unknown`이 되어 null이며,
  /// 그 글은 카테고리 라벨만 빠지고 나머지는 정상 표시된다.
  TargetCategory? _categoryFromEnum(Enum$TargetCategory value) =>
      switch (value) {
        Enum$TargetCategory.TOURIST_SPOT => TargetCategory.touristSpot,
        Enum$TargetCategory.CULTURAL_FACILITY =>
          TargetCategory.culturalFacility,
        Enum$TargetCategory.FESTIVAL_EVENT => TargetCategory.festivalEvent,
        Enum$TargetCategory.TRAVEL_COURSE => TargetCategory.travelCourse,
        Enum$TargetCategory.LEISURE_SPORTS => TargetCategory.leisureSports,
        Enum$TargetCategory.LODGING => TargetCategory.lodging,
        Enum$TargetCategory.SHOPPING => TargetCategory.shopping,
        Enum$TargetCategory.RESTAURANT => TargetCategory.restaurant,
        Enum$TargetCategory.TRANSPORT => TargetCategory.transport,
        Enum$TargetCategory.$unknown => null,
      };

  Enum$TargetCategory _categoryInput(TargetCategory category) =>
      switch (category) {
        TargetCategory.touristSpot => Enum$TargetCategory.TOURIST_SPOT,
        TargetCategory.culturalFacility =>
          Enum$TargetCategory.CULTURAL_FACILITY,
        TargetCategory.festivalEvent => Enum$TargetCategory.FESTIVAL_EVENT,
        TargetCategory.travelCourse => Enum$TargetCategory.TRAVEL_COURSE,
        TargetCategory.leisureSports => Enum$TargetCategory.LEISURE_SPORTS,
        TargetCategory.lodging => Enum$TargetCategory.LODGING,
        TargetCategory.shopping => Enum$TargetCategory.SHOPPING,
        TargetCategory.restaurant => Enum$TargetCategory.RESTAURANT,
        TargetCategory.transport => Enum$TargetCategory.TRANSPORT,
      };

  /// 서버 카테고리 `code` → 커뮤니티 도메인 enum. 모르는 코드는 null이라 카테고리
  /// 줄에서 빠지고, 나머지 칩은 그대로 그려진다.
  ///
  /// **SPEC-0020에서 서버 `SpotCategory`가 enum에서 객체(`code`/`label`/`iconUrl`)로
  /// 바뀌었다.** 커뮤니티는 이 스펙의 전환 대상이 아니므로(spec §범위 밖) 도메인
  /// 타입은 [NearbySpotCategory] 그대로 두고, 매핑 기준만 생성 enum에서 코드
  /// 문자열로 옮긴다 — 시트가 그리는 값 집합은 달라지지 않는다.
  NearbySpotCategory? _spotCategoryFromCode(String code) => switch (code) {
    'TOURIST_SPOT' => NearbySpotCategory.touristSpot,
    'CULTURAL_FACILITY' => NearbySpotCategory.culturalFacility,
    'FESTIVAL_EVENT' => NearbySpotCategory.festivalEvent,
    'TRAVEL_COURSE' => NearbySpotCategory.travelCourse,
    'LEISURE_SPORTS' => NearbySpotCategory.leisureSports,
    'LODGING' => NearbySpotCategory.lodging,
    'SHOPPING' => NearbySpotCategory.shopping,
    'RESTAURANT' => NearbySpotCategory.restaurant,
    'TRANSPORT' => NearbySpotCategory.transport,
    _ => null,
  };

  /// 도메인 enum → 서버 코드. **단일 선택을 1원소 리스트로 감싼다** — 서버 인자가
  /// `categories: [String!]`(복수 OR 필터)로 바뀌었으나 장소 선택 시트는 여전히
  /// 칩 하나만 고르는 UI라, 다중 선택은 이 스펙에서 spot 도메인만 받는다.
  List<String> _spotCategoryInput(NearbySpotCategory category) => <String>[
    switch (category) {
      NearbySpotCategory.touristSpot => 'TOURIST_SPOT',
      NearbySpotCategory.culturalFacility => 'CULTURAL_FACILITY',
      NearbySpotCategory.festivalEvent => 'FESTIVAL_EVENT',
      NearbySpotCategory.travelCourse => 'TRAVEL_COURSE',
      NearbySpotCategory.leisureSports => 'LEISURE_SPORTS',
      NearbySpotCategory.lodging => 'LODGING',
      NearbySpotCategory.shopping => 'SHOPPING',
      NearbySpotCategory.restaurant => 'RESTAURANT',
      NearbySpotCategory.transport => 'TRANSPORT',
    },
  ];

  /// 도메인 정렬 → 생성 enum. 서버 기본값이 `LATEST`라 호출부가 null을 주면 이
  /// 매핑을 거치지 않고 변수 자체를 생략한다.
  Enum$PostSortOrder _sortInput(PostSortOrder sort) => switch (sort) {
    PostSortOrder.latest => Enum$PostSortOrder.LATEST,
    PostSortOrder.distance => Enum$PostSortOrder.DISTANCE,
  };

  Enum$ReportReason _reportReasonInput(ReportReason reason) => switch (reason) {
    ReportReason.spam => Enum$ReportReason.SPAM,
    ReportReason.abuse => Enum$ReportReason.ABUSE,
    ReportReason.inappropriateContent =>
      Enum$ReportReason.INAPPROPRIATE_CONTENT,
    ReportReason.other => Enum$ReportReason.OTHER,
  };

  Enum$ReportTargetType _reportTargetTypeInput(ReportTargetType type) =>
      switch (type) {
        ReportTargetType.post => Enum$ReportTargetType.POST,
        ReportTargetType.comment => Enum$ReportTargetType.COMMENT,
        ReportTargetType.member => Enum$ReportTargetType.MEMBER,
        // SPEC-0026이 더한 세 값. 서버가 `reportContent`를 그대로 재사용한다(R11).
        ReportTargetType.spotQuestion => Enum$ReportTargetType.SPOT_QUESTION,
        ReportTargetType.spotAnswer => Enum$ReportTargetType.SPOT_ANSWER,
        ReportTargetType.spotAnswerReply =>
          Enum$ReportTargetType.SPOT_ANSWER_REPLY,
      };

  // --- 전송/실행 (spot repository와 동일한 2단계 실패 검사) -------------------

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.query(QueryOptions(document: document, variables: variables)),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _mutate(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.mutate(
      MutationOptions(document: document, variables: variables),
    ),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _run(
    Future<QueryResult<Object?>> Function() call,
    String operation,
    Map<String, dynamic> variables,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await call();
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      throw CommunityFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    // 범위 판별은 `path`로 한다 — `operation`이 곧 최상위 필드 이름이다. 하위 필드만
    // 실패한 응답은 통과시키고 매핑이 빈 값으로 접는다(공용 `hasRootFailure`).
    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw CommunityFailure.fromQueryErrorCode(
        _rootErrorCode(result, operation),
      );
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw CommunityFailure.unknown;
    return data;
  }

  /// 전체 실패로 판정된 오류의 코드 문자열. `extensions.code`가 관례이고, 없으면
  /// 코드처럼 보이는 메시지(SCREAMING_SNAKE)를 폴백으로 본다. 못 찾으면 null이라
  /// [CommunityFailure.network]로 떨어진다.
  String? _rootErrorCode(QueryResult<Object?> result, String rootField) {
    final GraphQLError? error = firstRootError(result, rootField);
    if (error == null) return null;
    final Object? code = error.extensions?['code'];
    if (code is String && code.isNotEmpty) return code;
    final String message = error.message;
    return RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(message) ? message : null;
  }

  /// 뮤테이션 도메인 실패 검사(가이드 §7): `userErrors`가 비어 있지 않거나
  /// `success == false`면 실패. **코드만** 로깅한다 — 서버 message는 PII를 담을 수
  /// 있다(POL-013).
  void _check(
    String operation,
    bool success,
    List<({String code, String? field})> userErrors,
  ) {
    if (userErrors.isNotEmpty) {
      GraphqlDebugLog.userErrors(operation, userErrors);
      throw CommunityFailure.userError(userErrors.first.code);
    }
    if (!success) throw CommunityFailure.unknown;
  }
}
