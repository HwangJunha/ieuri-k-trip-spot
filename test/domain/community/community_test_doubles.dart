import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/comment.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/discovery_tile.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_author.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_target.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_topic.dart';
import 'package:ieuri_k_trip_spot/domain/community/repository/community_repository.dart';

/// 테스트용 [Post] 하나. 값을 지정하지 않은 필드는 검증에 쓰이지 않는 자리채움이다.
Post fakePost({
  String id = 'p1',
  String body = 'A nice walk around the palace.',
  PostTopic? topic = PostTopic.review,
  int likeCount = 3,
  int commentCount = 2,
  bool likedByViewer = false,
  bool hidden = false,
  List<String> photoKeys = const <String>[],
  List<Comment>? comments,
}) => Post(
  id: id,
  body: body,
  topic: topic,
  target: const PostTarget(
    type: PostTargetType.spot,
    id: '11094',
    title: 'Gyeongbokgung',
    thumbnailImageUrl: 'https://img/spot.jpg',
  ),
  author: const PostAuthor(id: '20', nickname: 'Traveler'),
  createdAt: DateTime.utc(2026, 8, 5, 9),
  photoKeys: photoKeys,
  likeCount: likeCount,
  commentCount: commentCount,
  likedByViewer: likedByViewer,
  hidden: hidden,
  comments: comments,
);

Comment fakeComment({String id = 'c1', String body = 'Nice!'}) => Comment(
  id: id,
  body: body,
  author: const PostAuthor(id: '12', nickname: 'Minji'),
  createdAt: DateTime.utc(2026, 8, 5, 10),
);

/// 정형 응답을 돌려주는 [CommunityRepository]. provider·위젯 테스트가 이 하나만
/// 오버라이드해 네트워크 없이 상태 전이를 검증한다.
class FakeCommunityRepository implements CommunityRepository {
  FakeCommunityRepository({
    this.posts = const <Post>[],
    this.tiles = const <DiscoveryTile>[],
    this.post,
    this.hasNextPage = false,
    this.nextPagePosts = const <Post>[],
    this.feedError,
    this.likeError,
    this.serverLikeCount,
  });

  final List<Post> posts;
  final List<DiscoveryTile> tiles;
  final Post? post;
  final bool hasNextPage;

  /// `after`가 주어진 두 번째 조회에서 돌려줄 항목들.
  final List<Post> nextPagePosts;

  /// 설정하면 피드 조회가 이 오류를 던진다.
  final Object? feedError;

  /// 설정하면 좋아요 뮤테이션이 이 오류를 던진다.
  final Object? likeError;

  /// 좋아요 성공 시 서버가 돌려주는 최종 수(되맞춤 검증용).
  final int? serverLikeCount;

  /// 마지막 조회에 넘어간 topic — 필터가 서버로 전달되는지 확인한다.
  PostTopic? lastTopic;

  /// 마지막 조회에 넘어간 커서.
  String? lastAfter;

  int likeCalls = 0;
  int unlikeCalls = 0;

  @override
  Future<CursorPage<Post>> fetchNearbyPosts({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    PostTopic? topic,
    int? first,
    String? after,
  }) async {
    if (feedError != null) throw feedError!;
    lastTopic = topic;
    lastAfter = after;
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
  Future<CursorPage<Post>> fetchTargetPosts({
    required String targetType,
    required String targetId,
    PostTopic? topic,
    int? first,
    String? after,
  }) async {
    if (feedError != null) throw feedError!;
    lastTopic = topic;
    return CursorPage<Post>(items: posts, hasNextPage: false);
  }

  @override
  Future<Post?> fetchPost(String id, {int? commentCount}) async {
    if (feedError != null) throw feedError!;
    return post;
  }

  @override
  Future<List<DiscoveryTile>> fetchDiscoveryTiles() async => tiles;

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
}
