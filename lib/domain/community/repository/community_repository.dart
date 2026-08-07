import 'dart:typed_data';

import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
import '../model/blocked_user.dart';
import '../../../common/model/comment.dart';
import '../model/community_chip.dart';
import '../model/nearby_spot.dart';
import '../model/nearby_spot_category.dart';
import '../../../common/model/post.dart';
import '../model/post_image_upload.dart';
import '../model/post_sort_order.dart';
import '../model/report_reason.dart';
import '../../../common/model/target_category.dart';

/// 커뮤니티 데이터 접근(SPEC-0010). 도메인 모델만 돌려주며, 생성 타입
/// (`*.graphql.dart`)은 구현체 밖으로 나가지 않는다(CLAUDE.md §3, POL-020).
///
/// 페이징은 전부 **커서**다 — `common/pagination`의 [CursorPage]를 그대로 쓰고
/// 기능이 자기 페이지네이션을 새로 만들지 않는다(CLAUDE.md §4). 커서는 불투명
/// 문자열이라 파싱하거나 만들어 내면 `INVALID_INPUT`이다(가이드 §2).
///
/// **모든 요청이 인증을 요구한다**(가이드 §1). 비로그인 열람 경로는 없다.
abstract interface class CommunityRepository {
  /// 글 목록 한 페이지. **피드 쿼리는 이것 하나뿐이고 인자 조합이 범위를 정한다**
  /// (가이드 §2):
  ///
  /// | 하고 싶은 것 | 인자 |
  /// |---|---|
  /// | 장소 상세의 글 | `spotId` |
  /// | 커뮤니티 탭(내 주변) | `latitude`+`longitude`(+`radiusMeters`) |
  /// | 상단 칩 | `category` |
  /// | 태그 | `tag` |
  /// | 전체 피드 | 아무것도 안 줌 |
  ///
  /// 규칙:
  /// - [latitude]·[longitude]는 **함께** 줘야 한다. 하나만 주면 둘 다 무시된다
  /// - [spotId]와 좌표를 둘 다 주면 **[spotId]가 이긴다**
  /// - [radiusMeters]는 좌표를 줄 때만 의미가 있다(기본 20000 / 상한 100000이며
  ///   초과해도 오류가 아니라 잘린다)
  /// - **[category]·[tag]는 범위와 독립**이라 단독으로도 걸린다
  ///
  /// [first]는 기본 20 / 상한 50이며 초과해도 오류가 아니라 잘린다.
  ///
  /// [sort]는 기본 [PostSortOrder.latest]다(2차 가이드 §3). [PostSortOrder.distance]는
  /// 반경 안 **장소에 붙은 글만** 가까운 순으로 주므로 장소 없는 글이 빠지고,
  /// 좌표가 없으면 최신순처럼 동작한다(오류가 아니다).
  ///
  /// **두 정렬의 커서 형식이 다르다** — 정렬을 바꾸면 [after]를 버리고 첫 페이지부터
  /// 다시 조회해야 한다. 이전 커서를 그대로 넘기면 `INVALID_INPUT`이다.
  ///
  /// [hiddenByViewer]가 true면 **내가 숨긴 글만** 온다(2차 가이드 §2). 숨긴 글은 그
  /// 밖의 모든 조회에서 빠지므로 해제 화면이 이 인자를 쓴다. 이때도 [category]·[tag]
  /// 필터와 [sort]가 그대로 걸린다 — 별도 쿼리를 두지 않은 이유가 그것이다.
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
  });

  /// 글 단건.
  ///
  /// **차단·숨김·삭제면 오류가 아니라 `null`을 돌려준다**(가이드 §6). 딥링크로 들어온
  /// 경우이므로 호출부는 "삭제되었거나 볼 수 없는 글" 안내로 처리한다 — `errors[]`를
  /// 기대하면 안 된다.
  Future<Post?> fetchPost(String id);

  /// 글의 댓글 한 페이지. **루트 쿼리다** — 목록 안에 목록을 중첩해 페이지네이션하면
  /// 어느 카드의 커서인지 추적하기 어려워서 서버가 이렇게 갈랐다(가이드 §2).
  ///
  /// **`commentCount`와 이 목록의 길이는 다를 수 있다** — 숫자는 차단을 반영하지
  /// 않고 목록은 반영하기 때문이다(§6). 오류로 처리하지 않는다.
  Future<CursorPage<Comment>> fetchComments(
    String postId, {
    int? first,
    String? after,
  });

  /// 컴포저의 장소 선택 시트가 그리는 주변 장소 한 페이지.
  ///
  /// **좌표 기반이고 이름 검색 인자가 없다** — 서버 `spots`는 반경 안의 장소를
  /// 거리 오름차순으로 준다. 이름으로 좁히는 것은 이미 받아 둔 목록에 대해
  /// 클라이언트가 한다.
  ///
  /// [category]는 그와 달리 **서버가 거르는 진짜 필터다.** null이면 전체이며,
  /// 값을 바꾸면 페이지 0부터 다시 받아야 한다(오프셋이 카테고리마다 다르다).
  ///
  /// 피드와 달리 **오프셋 페이징**이라 [OffsetPage]로 돌려준다(`page`/`size` +
  /// `hasNext`). [page]는 0-based이고 [size] 50까지는 서버가 그대로 지킨다
  /// (라이브 확인).
  Future<OffsetPage<NearbySpot>> fetchNearbySpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    NearbySpotCategory? category,
    int? page,
    int? size,
  });

  /// 장소 선택 시트의 두 번째 출처 — 내가 좋아요한 장소 한 페이지.
  ///
  /// **주변 장소와 페이징 방식이 다르다**: [fetchNearbySpots]는 오프셋이고 이쪽은
  /// **커서**라 [CursorPage]로 돌려준다. 서버가 그렇게 갈라 놓았고, 각 컨트롤러가
  /// 자기 페이지 모델을 쓰면 그 차이가 화면까지 새지 않는다.
  ///
  /// [category]는 [fetchNearbySpots]와 **같은 필터다** — 시트의 카테고리 줄 하나가
  /// 두 출처에 함께 걸린다. null이면 전체다.
  ///
  /// **좌표를 받지 않으므로 거리가 없다** — 돌려주는 [NearbySpot]의
  /// `distanceMeters`는 null이고 시트가 그 자리에 주소를 그린다.
  ///
  /// **빈 목록이 정상이다** — 좋아요한 장소가 하나도 없는 계정이므로 오류가 아니라
  /// 빈 안내로 처리한다.
  Future<CursorPage<NearbySpot>> fetchLikedSpots({
    NearbySpotCategory? category,
    int? first,
    String? after,
  });

  /// 장소 선택 시트의 카테고리 줄 구성.
  ///
  /// **언어마다 다르다**(`Accept-Language`를 따른다) — ko에는 `TRAVEL_COURSE`가
  /// 있고 en에는 그 자리에 `TRANSPORT`가 있다(라이브 확인). 그래서 클라이언트가
  /// 전체 목록을 하드코딩하면 안 되고, [fetchCommunityChips]와 같이 서버가 준 것만
  /// 그린다.
  ///
  /// **빈 목록이 정상이다** — 그때는 카테고리 줄 자체를 그리지 않는다.
  Future<List<NearbySpotCategory>> fetchNearbySpotCategories();

  /// 상단 칩 구성. **빈 목록이 정상이다**(가이드 §2) — 구성이 없는 앱이면 비어 오고
  /// 오류가 아니므로 칩 영역이 비는 레이아웃을 허용해야 한다.
  ///
  /// `position` 오름차순으로 이미 정렬돼 오며 표시 문구는 클라이언트가 매핑한다.
  Future<List<CommunityChip>> fetchCommunityChips();

  /// 내가 차단한 사람 한 페이지. **나를 차단한 사람은 여기 없다**(가이드 §6).
  Future<CursorPage<BlockedUser>> fetchBlockedUsers({
    int? first,
    String? after,
  });

  /// 좋아요. 멱등이라 이미 좋아요한 글에 다시 불러도 성공이다(가이드 §7).
  /// 서버가 돌려준 최종 `likeCount`를 반환하므로 **낙관적 값을 이 값으로 되맞춘다**.
  /// 서버가 값을 주지 않으면 null.
  Future<int?> likePost(String postId);

  /// 좋아요 해제. [likePost]와 같은 규약이며 0 아래로 내려가지 않는다.
  Future<int?> unlikePost(String postId);

  /// 글 작성. **`postId`만 돌아오고 `post`는 항상 null이다**(가이드 §5) —
  /// 지연 필드 때문에 생성 응답에서 조립할 수 없다. 작성 직후 상세로 가려면 그 id로
  /// `post(id:)`를 다시 조회하고, 피드로 돌아간다면 목록을 새로 고친다.
  ///
  /// [category]는 필수이고 [spotId]는 선택이다. [photoKeys]는 3단계 확인이 준
  /// **최종 키**(`images/...`)여야 하며, 1단계의 `pending/...`을 넘기면 서버가
  /// `PHOTO_NOT_UPLOADED`로 거부한다.
  Future<String?> createPost({
    required TargetCategory category,
    required String title,
    required String body,
    String? spotId,
    List<String> tags,
    List<String> photoKeys,
  });

  /// 글 수정. 제목·본문·사진에 더해 **카테고리·장소·태그도 바꾼다** — 서버가 뒤늦게
  /// 받기 시작했다(1차 가이드 §5의 "못 바꾼다"는 낡은 서술이고, 라이브 스키마가
  /// 정본이다).
  ///
  /// [photoKeys]·[tags]를 주면 **전체 목록으로 교체**하고, null이면 건드리지 않는다.
  ///
  /// **장소는 [changeSpot]이 가른다.** 이 인자는 스키마에만 있고 문서에 없다:
  /// - false(기본) → 장소를 건드리지 않는다. [spotId]는 무시된다
  /// - true + [spotId] → 그 장소로 바꾼다
  /// - true + null → 장소를 뗀다(장소 없는 글이 된다)
  ///
  /// 사용자가 장소를 만지지 않았다면 false를 넘긴다 — `spotId: null` 하나로는
  /// "그대로 두기"와 "떼기"가 구분되지 않기 때문이다.
  ///
  /// 숨겨진 글은 수정할 수 없어 `POST_NOT_EDITABLE`이 온다.
  Future<void> editPost({
    required String postId,
    required String title,
    required String body,
    List<String>? photoKeys,
    TargetCategory? category,
    bool changeSpot,
    String? spotId,
    List<String>? tags,
  });

  /// 내 글 삭제. 남의 글이면 `NOT_POST_OWNER`, 이미 지워졌으면 `POST_NOT_FOUND`다.
  Future<void> deletePost(String postId);

  /// 댓글 작성. `createPost`와 같이 **commentId만 온다**(가이드 §5).
  ///
  /// [parentCommentId]를 주면 그 댓글의 답글이고, 생략하면 최상위 댓글이다
  /// (2차 가이드 §1). **답글에 답글을 달아도 거부되지 않고** 서버가 최상위 부모로
  /// 눕히므로 실제 부모가 넘긴 값과 다를 수 있다 — 그래서 화면은 답글에 답글 버튼을
  /// 두지 않고, 성공 후에는 목록을 다시 받는다.
  ///
  /// 다른 글의 댓글을 [parentCommentId]로 주면 `COMMENT_NOT_FOUND`다.
  Future<String?> createComment({
    required String postId,
    required String body,
    String? parentCommentId,
  });

  /// 내 댓글 삭제. 남의 댓글이면 `NOT_COMMENT_OWNER`다.
  Future<void> deleteComment(String commentId);

  /// 사진 업로드 1단계 — 서명 URL 발급(가이드 §4).
  ///
  /// **하나라도 어긋나면 전부 발급되지 않는다**(빈 목록). 응답 순서는 요청 순서와
  /// 같다. 한 번에 최대 5장이며 넘으면 `TOO_MANY_PHOTOS`다.
  Future<List<PostImageUploadUrl>> createPostImageUploadUrls(
    List<PostImageUploadRequest> images,
  );

  /// 사진 업로드 2단계 — **스토리지로 직접 PUT한다. GraphQL이 아니다.**
  ///
  /// `Content-Type`·`Content-Length`가 1단계 선언과 **정확히 같아야 한다** — 두 값이
  /// 서명에 들어 있어 다르면 스토리지가 `403 SignatureDoesNotMatch`로 거부한다.
  /// 인증 헤더는 붙이지 않는다(서명이 이미 URL에 있다).
  ///
  /// 서버를 거치지 않으므로 **이 실패는 GraphQL 응답에 안 나온다.**
  Future<void> uploadPostImage({
    required String uploadUrl,
    required String contentType,
    required Uint8List bytes,
  });

  /// 사진 업로드 3단계 — 확인. 서버가 실제 크기와 매직바이트를 다시 본다.
  ///
  /// **장별로 성패가 갈리므로 실패로 던지지 않고 값으로 돌려준다** — `failed`가
  /// 있어도 `confirmed`의 키는 유효하다(가이드 §4).
  Future<PostImageConfirmation> confirmPostImageUploads(
    List<String> objectKeys,
  );

  /// 사진 오브젝트 삭제. 없는 키를 지워도 오류가 아니다(멱등).
  ///
  /// **글에서 사진을 빼도 오브젝트는 남는다** — `editPost(photoKeys:)`는 연결만
  /// 바꾸므로 스토리지에서 지우려면 이걸 따로 부른다(가이드 §4).
  Future<void> deletePostImage(String objectKey);

  /// 글 하나를 **내 화면에서만** 감춘다(2차 가이드 §2).
  ///
  /// **차단·신고와 각각 다르다**: 차단은 사람 단위 양방향이고, 신고는 되돌릴 수 없는
  /// 운영 조치 요청이다. 이것은 글 하나에 대한 **화면 설정**이라 소유권을 보지 않으며
  /// 내 글도 숨길 수 있다.
  ///
  /// **[Post.hidden]과 다른 값이다.** 그쪽은 신고 5건 누적으로 **모두에게** 감춰진
  /// 글(작성자 본인에게만 보인다)이고, 이건 내가 나에게만 감춘 것이다.
  ///
  /// 멱등이라 이미 숨긴 글에 다시 불러도 성공이다. 성공 후에는 로컬에서 지우는 것이
  /// 아니라 **피드를 다시 불러온다** — 필터링은 서버가 한다(차단과 같은 규약).
  Future<void> hidePost(String postId);

  /// 숨김을 해제한다. 멱등이며 **삭제된 글에도 동작한다** — 그래야 숨김 목록에
  /// 남지 않는다(2차 가이드 §2).
  Future<void> unhidePost(String postId);

  /// 사용자 차단. **양방향이다** — 이 호출 하나로 서로의 글·댓글이 모든 피드에서
  /// 사라진다(가이드 §6). 성공 후에는 로컬에서 지우는 것이 아니라 **피드를 다시
  /// 불러온다**: 필터링은 서버가 한다.
  ///
  /// 멱등이라 이미 차단한 사람에게 다시 불러도 성공이다(§7). 자기 자신이면
  /// `CANNOT_BLOCK_SELF`가 오므로 UI에서 미리 막는다.
  Future<void> blockUser(String targetMemberId);

  /// 차단 해제. 차단하지 않은 사람에게 불러도 멱등하게 성공한다(가이드 §7).
  Future<void> unblockUser(String targetMemberId);

  /// 신고. [reason]이 [ReportReason.other]면 [detail]이 **필수**이며, 비면
  /// 서버가 `REPORT_DETAIL_REQUIRED`로 거부한다 — 폼에서 미리 막는다(가이드 §6).
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
