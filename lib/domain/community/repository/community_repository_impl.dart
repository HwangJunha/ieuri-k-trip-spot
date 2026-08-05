import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../../../common/pagination/page.dart';
import '../model/comment.dart';
import '../model/community_failure.dart';
import '../model/discovery_tile.dart';
import '../model/post.dart';
import '../model/post_author.dart';
import '../model/post_target.dart';
import '../model/post_topic.dart';
import 'community_operations.graphql.dart';
import 'community_repository.dart';
import 'community_schema.graphql.dart';

/// GraphQL 기반 [CommunityRepository](SPEC-0010). graphql_codegen이 만든 타입 연산을
/// 공용 클라이언트로 실행하고 응답을 도메인 모델로 매핑한다. 생성 타입
/// (`*.graphql.dart`)은 **이 파일 밖으로 나가지 않는다**(CLAUDE.md §3, POL-020).
///
/// 실패 판정은 두 갈래다(가이드 §7):
///  - 조회: 최상위 `errors[]`. `path`로 전체/부분 실패를 가른다(`hasRootFailure`).
///  - 뮤테이션: payload의 `success`·`userErrors[]`. **HTTP는 실패해도 200이다.**
class CommunityRepositoryImpl implements CommunityRepository {
  CommunityRepositoryImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<CursorPage<Post>> fetchNearbyPosts({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    PostTopic? topic,
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryNearbyPosts,
      Variables$Query$NearbyPosts(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        topic: topic == null ? null : _topicInput(topic),
        first: first,
        after: after,
      ).toJson(),
      'nearbyPosts',
    );
    final Query$NearbyPosts$nearbyPosts result = Query$NearbyPosts.fromJson(
      data,
    ).nearbyPosts;
    return CursorPage<Post>(
      items: result.edges
          .map((Query$NearbyPosts$nearbyPosts$edges e) => _postFromCard(e.node))
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<CursorPage<Post>> fetchTargetPosts({
    required String targetType,
    required String targetId,
    PostTopic? topic,
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryTargetPosts,
      Variables$Query$TargetPosts(
        targetType: _targetTypeInput(targetType),
        targetId: targetId,
        topic: topic == null ? null : _topicInput(topic),
        first: first,
        after: after,
      ).toJson(),
      'targetPosts',
    );
    final Query$TargetPosts$targetPosts result = Query$TargetPosts.fromJson(
      data,
    ).targetPosts;
    return CursorPage<Post>(
      items: result.edges
          .map((Query$TargetPosts$targetPosts$edges e) => _postFromCard(e.node))
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<Post?> fetchPost(String id, {int? commentCount}) async {
    final Query$PostDetail$post? result = await _fetchPostDetail(
      id,
      commentCount: commentCount,
      withComments: true,
    );

    // null은 두 가지를 뜻할 수 있다. 하나는 계약대로 "차단·숨김이라 볼 수 없음"이고
    // (가이드 §6), 다른 하나는 **댓글 해소가 실패해 글까지 통째로 날아간 경우**다 —
    // `comments: CommentConnection!`이 non-null이라 하위 실패가 부모를 null로 만든다.
    //
    // 둘을 응답만으로 구분할 수 없으므로 **댓글 없이 한 번 더 조회해 본다.** 그때
    // 글이 나오면 원인은 댓글이었던 것이고, 본문만이라도 보여주는 편이 멀쩡한 글을
    // "볼 수 없는 글"로 잘못 안내하는 것보다 낫다. 여전히 null이면 진짜로 볼 수 없는
    // 글이다.
    if (result == null) {
      final Query$PostDetail$post? withoutComments = await _fetchPostDetail(
        id,
        commentCount: commentCount,
        withComments: false,
      );
      if (withoutComments == null) return null;
      // 댓글은 못 받았다. null로 두면 화면이 "댓글 없음"과 구분해 다룰 수 있다.
      return _postFromCard(withoutComments);
    }

    return _postFromCard(
      result,
      comments:
          result.comments?.edges
              .map(
                (Query$PostDetail$post$comments$edges e) =>
                    _commentFromNode(e.node),
              )
              .toList(growable: false) ??
          const <Comment>[],
    );
  }

  Future<Query$PostDetail$post?> _fetchPostDetail(
    String id, {
    required int? commentCount,
    required bool withComments,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryPostDetail,
      Variables$Query$PostDetail(
        id: id,
        commentCount: commentCount,
        withComments: withComments,
      ).toJson(),
      'post',
    );
    return Query$PostDetail.fromJson(data).post;
  }

  @override
  Future<List<DiscoveryTile>> fetchDiscoveryTiles() async {
    // 언어는 인자가 아니라 Accept-Language 헤더로 전달된다(가이드 §10). 활성 언어의
    // 타일이 없으면 빈 목록이며 그것이 정상이다(§15).
    final Map<String, dynamic> data = await _query(
      documentNodeQueryDiscoveryTiles,
      const <String, dynamic>{},
      'discoveryTiles',
    );
    return Query$DiscoveryTiles.fromJson(
      data,
    ).discoveryTiles.map(_tileFromNode).toList(growable: false);
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

  // --- 매핑 (생성 타입 → 도메인) ---------------------------------------------

  /// 카드 필드 fragment → 도메인 [Post]. 목록과 상세가 같은 fragment를 쓰므로 매핑도
  /// 하나다 — 상세만 [comments]를 덧붙인다(가이드 §4).
  Post _postFromCard(Fragment$PostCardFields n, {List<Comment>? comments}) =>
      Post(
        id: n.id,
        body: n.body,
        topic: _topicFromEnum(n.topic),
        target: PostTarget(
          type: _targetTypeFromEnum(n.target.type),
          id: n.target.id,
          title: n.target.title,
          thumbnailImageUrl: n.target.thumbnailImageUrl,
        ),
        author: PostAuthor(
          id: n.author.id,
          nickname: n.author.nickname,
          profileImageUrl: n.author.profileImageUrl,
        ),
        createdAt: _parseTime(n.createdAt),
        photoKeys: n.photoKeys,
        likeCount: n.likeCount,
        commentCount: n.commentCount,
        likedByViewer: n.likedByViewer,
        ownedByViewer: n.ownedByViewer,
        hidden: n.hidden,
        comments: comments,
      );

  Comment _commentFromNode(Query$PostDetail$post$comments$edges$node n) =>
      Comment(
        id: n.id,
        body: n.body,
        author: PostAuthor(
          id: n.author.id,
          nickname: n.author.nickname,
          profileImageUrl: n.author.profileImageUrl,
        ),
        createdAt: _parseTime(n.createdAt),
        ownedByViewer: n.ownedByViewer,
        hidden: n.hidden,
      );

  DiscoveryTile _tileFromNode(Query$DiscoveryTiles$discoveryTiles n) =>
      DiscoveryTile(
        id: n.id,
        // 서버 문자열 그대로 — 매핑하지 않는다(가이드 §10).
        title: n.title,
        imageUrl: n.imageUrl,
        filterTopic: n.filterTopic == null
            ? null
            : _topicFromEnum(n.filterTopic!),
        filterTargetType: n.filterTargetType == null
            ? null
            : _targetTypeFromEnum(n.filterTargetType!),
      );

  /// 서버가 준 ISO-8601 문자열을 시각으로 파싱한다. 형식이 어긋나면 글 전체를
  /// 실패시키지 않고 epoch로 떨어뜨린다 — 상대 시각 하나 때문에 피드가 비면 손해가
  /// 더 크다.
  DateTime _parseTime(String raw) =>
      DateTime.tryParse(raw)?.toUtc() ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  /// 생성 enum → 도메인 enum. 서버가 새 값을 추가하면 `$unknown`이 되어 null이며,
  /// 그 글은 태그 pill만 빠지고 나머지는 정상 표시된다.
  PostTopic? _topicFromEnum(Enum$PostTopic value) => switch (value) {
    Enum$PostTopic.QUESTION => PostTopic.question,
    Enum$PostTopic.TIP => PostTopic.tip,
    Enum$PostTopic.REVIEW => PostTopic.review,
    Enum$PostTopic.COMPANION => PostTopic.companion,
    Enum$PostTopic.PHOTO => PostTopic.photo,
    Enum$PostTopic.$unknown => null,
  };

  Enum$PostTopic _topicInput(PostTopic topic) => switch (topic) {
    PostTopic.question => Enum$PostTopic.QUESTION,
    PostTopic.tip => Enum$PostTopic.TIP,
    PostTopic.review => Enum$PostTopic.REVIEW,
    PostTopic.companion => Enum$PostTopic.COMPANION,
    PostTopic.photo => Enum$PostTopic.PHOTO,
  };

  PostTargetType? _targetTypeFromEnum(Enum$PostTargetType value) =>
      switch (value) {
        Enum$PostTargetType.SPOT => PostTargetType.spot,
        Enum$PostTargetType.$unknown => null,
      };

  /// 대상 종류는 **문자열로 받아** 생성 enum으로 옮긴다. 인터페이스가 값으로 다루기
  /// 때문이며(가이드 §1), 아직 클라이언트가 모르는 값이면 `$unknown`으로 보내 서버가
  /// 판정하게 한다 — 클라이언트가 미리 거부하면 서버가 값을 늘렸을 때 앱만 막힌다.
  Enum$PostTargetType _targetTypeInput(String value) => switch (value) {
    'SPOT' => Enum$PostTargetType.SPOT,
    _ => Enum$PostTargetType.$unknown,
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
