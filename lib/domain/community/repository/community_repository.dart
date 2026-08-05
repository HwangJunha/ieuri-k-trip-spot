import '../../../common/pagination/page.dart';
import '../model/discovery_tile.dart';
import '../model/post.dart';
import '../model/post_topic.dart';

/// 커뮤니티 데이터 접근(SPEC-0010). 도메인 모델만 돌려주며, 생성 타입
/// (`*.graphql.dart`)은 구현체 밖으로 나가지 않는다(CLAUDE.md §3, POL-020).
///
/// 페이징은 전부 **커서**다 — `common/pagination`의 [CursorPage]를 그대로 쓰고
/// 기능이 자기 페이지네이션을 새로 만들지 않는다(CLAUDE.md §4). 커서는 불투명
/// 문자열이라 파싱하거나 만들어 내면 `INVALID_INPUT`이다(가이드 §5).
///
/// 조회 4종은 **미인증으로도 된다**(가이드 §13). 그때 `likedByViewer`·`ownedByViewer`는
/// null이 아니라 false로 오므로 호출부에 별도 분기가 필요 없다.
abstract interface class CommunityRepository {
  /// 좌표 주변의 글 한 페이지(가이드 §14).
  ///
  /// [radiusMeters]는 기본 20000 / 상한 100000이며 초과해도 오류가 아니라 잘린다.
  /// **반경 안 대상 수에 상한(2000)이 있어 결과가 부분집합일 수 있다** — "반경 전체"를
  /// 보장하는 UI 문구는 쓰지 않는다.
  ///
  /// [topic]이 null이면 전체다. 필터링은 서버가 하고 클라이언트는 받은 페이지를
  /// 그대로 잇는다.
  Future<CursorPage<Post>> fetchNearbyPosts({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    PostTopic? topic,
    int? first,
    String? after,
  });

  /// 한 대상(관광지 등)에 달린 글 한 페이지.
  ///
  /// [targetType]은 **값으로 받는다** — 지금은 `SPOT` 하나뿐이지만 늘어날 자리가
  /// 열려 있다(가이드 §1).
  Future<CursorPage<Post>> fetchTargetPosts({
    required String targetType,
    required String targetId,
    PostTopic? topic,
    int? first,
    String? after,
  });

  /// 글 단건. 댓글 첫 페이지를 함께 받는다(가이드 §4).
  ///
  /// **차단·숨김이면 오류가 아니라 `null`을 돌려준다**(가이드 §6). 딥링크로 들어온
  /// 경우이므로 호출부는 "삭제되었거나 볼 수 없는 글" 안내로 처리한다 — `errors[]`를
  /// 기대하면 안 된다.
  Future<Post?> fetchPost(String id, {int? commentCount});

  /// 탐색 타일 전체. **빈 목록이 정상이다**(가이드 §15) — 어드민이 아직 없고,
  /// 활성 언어의 타일이 없으면 다른 언어로 대체되지 않는다.
  Future<List<DiscoveryTile>> fetchDiscoveryTiles();

  /// 좋아요. 멱등이라 이미 좋아요한 글에 다시 불러도 성공이다(가이드 §8).
  /// 서버가 돌려준 최종 `likeCount`를 반환하므로 **낙관적 값을 이 값으로 되맞춘다**.
  /// 서버가 값을 주지 않으면 null.
  Future<int?> likePost(String postId);

  /// 좋아요 해제. [likePost]와 같은 규약이며 0 아래로 내려가지 않는다.
  Future<int?> unlikePost(String postId);
}
