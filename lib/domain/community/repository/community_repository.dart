import '../../../common/pagination/page.dart';
import '../model/discovery_tile.dart';
import '../model/post.dart';
import '../model/post_topic.dart';
import '../model/report_reason.dart';

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

  /// 글 작성(R1). **`postId`만 돌아오고 `post`는 항상 null이다**(가이드 §11) —
  /// 지연 필드 때문에 생성 응답에서 조립할 수 없다. 작성 직후 상세로 가려면 그 id로
  /// `post(id:)`를 다시 조회하고, 피드로 돌아간다면 목록을 새로 고친다.
  ///
  /// [targetType]은 **값으로 받는다**(가이드 §1). [photoKeys]는 3단계 업로드가 준
  /// **최종 키**(`images/...`)여야 하며, 1단계의 `pending/...`을 넘기면 서버가
  /// `PHOTO_NOT_UPLOADED`로 거부한다(§3-(2)).
  ///
  /// 실패는 `userErrors`의 코드를 담은 [CommunityFailure]로 던져진다 —
  /// `POST_BODY_REQUIRED`·`POST_BODY_LENGTH_INVALID`·`SPOT_NOT_FOUND`·
  /// `TOO_MANY_PHOTOS`를 화면이 필드별 메시지로 옮긴다.
  Future<String?> createPost({
    required String targetType,
    required String targetId,
    required PostTopic topic,
    required String body,
    List<String> photoKeys,
  });

  /// 내 글 삭제. 남의 글이면 `NOT_POST_OWNER`, 이미 지워졌으면 `POST_NOT_FOUND`다.
  Future<void> deletePost(String postId);

  /// 사용자 차단(R15). **양방향이다** — 이 호출 하나로 서로의 글·댓글이 모든 피드에서
  /// 사라진다(가이드 §6). 성공 후에는 로컬에서 지우는 것이 아니라 **피드를 다시
  /// 불러온다**: 필터링은 서버가 한다.
  ///
  /// 멱등이라 이미 차단한 사람에게 다시 불러도 성공이다(§8). 자기 자신이면
  /// `CANNOT_BLOCK_SELF`가 오므로 UI에서 미리 막는다.
  Future<void> blockUser(String targetMemberId);

  /// 차단 해제. 차단하지 않은 사람에게 불러도 멱등하게 성공한다(가이드 §8).
  Future<void> unblockUser(String targetMemberId);

  /// 신고(R16). [reason]이 [ReportReason.other]면 [detail]이 **필수**이며, 비면
  /// 서버가 `REPORT_DETAIL_REQUIRED`로 거부한다 — 폼에서 미리 막는다(가이드 §9).
  ///
  /// 같은 대상 재신고는 `ALREADY_REPORTED`다. 호출부는 그것을 오류가 아니라
  /// "이미 신고했다"는 안내로 접는다.
  ///
  /// **`member` 신고는 기록만 된다** — 자동 조치는 글·댓글에만 있으므로 화면은
  /// "접수되었다" 이상을 약속하지 않는다.
  Future<void> reportContent({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
    String? detail,
  });
}
