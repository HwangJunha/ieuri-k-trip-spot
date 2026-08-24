import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/community_failure.dart';
import '../model/report_reason.dart';
import '../../../common/model/target_category.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'moderation_providers.g.dart';

/// 모더레이션 동작 하나의 결과. 화면이 어떤 안내를 띄울지 이 값으로 고른다.
///
/// **`ALREADY_REPORTED`를 실패로 취급하지 않는 것**이 이 enum의 존재 이유다 —
/// 재신고는 서버가 막는 정상 흐름이고(가이드 §7), 오류 토스트로 띄우면 사용자는
/// 무언가 고장난 줄 안다.
enum ModerationOutcome {
  /// 성공. 차단이면 피드를 다시 불러온다(가이드 §6).
  success,

  /// 이미 같은 대상을 신고했다(`ALREADY_REPORTED`). 오류가 아니라 안내다.
  alreadyReported,

  /// 숨겨진 글을 수정하려 했다(`POST_NOT_EDITABLE`). 메뉴에서 미리 막지만 서버
  /// 판정도 함께 다룬다(가이드 §5).
  notEditable,

  /// 로그인이 필요하다. 화면이 로그인으로 유도한다(가이드 §1).
  unauthenticated,

  /// 그 밖의 실패. 화면은 일반 오류 안내를 띄운다.
  failure,
}

/// 차단·신고·삭제·수정을 실행하는 컨트롤러.
///
/// 상태를 들고 있지 않고 **동작만 노출한다** — 이 기능들은 결과가 피드 재조회로
/// 나타나지 자체 화면 상태를 만들지 않기 때문이다. 그래서 `build()`는 void를
/// 돌려주고, 각 메서드가 [ModerationOutcome]을 반환해 호출한 화면이 안내를 고른다.
///
/// **전부 인증 필수 뮤테이션이다.** 미인증이면 서버가 최상위 `errors[]`로
/// `UNAUTHENTICATED`를 주고 repository가 [CommunityFailureKind.unauthenticated]로
/// 번역한다 — 그때 [ModerationOutcome.unauthenticated]가 나와 화면이 로그인으로
/// 보낸다.
@riverpod
class ModerationController extends _$ModerationController {
  @override
  void build() {}

  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  /// 사용자를 차단한다. **양방향이라** 성공 후 서로의 글이 모든 피드에서 사라진다
  /// (가이드 §6). 화면은 성공 시 피드를 **재조회**한다 — 로컬에서 지우는 것이
  /// 아니다.
  Future<ModerationOutcome> block(String memberId) =>
      _run(() => _repository.blockUser(memberId));

  /// 차단을 푼다. 차단하지 않은 사람에게 불러도 멱등하게 성공한다(가이드 §7).
  Future<ModerationOutcome> unblock(String memberId) =>
      _run(() => _repository.unblockUser(memberId));

  /// 글 하나를 **내 화면에서만** 감춘다(2차 가이드 §2).
  ///
  /// **차단·신고와 다르다** — 사람이 아니라 글 하나가 대상이고, 되돌릴 수 있으며,
  /// 소유권을 보지 않아 내 글도 숨길 수 있다. 조치가 아니라 화면 설정이라 확인
  /// 단계도 두지 않는다(차단은 양방향이라 확인이 필요했다).
  ///
  /// 성공하면 화면이 피드를 **재조회한다** — 서버가 필터링하므로 로컬 제거가 아니다.
  Future<ModerationOutcome> hidePost(String postId) =>
      _run(() => _repository.hidePost(postId));

  /// 숨김을 푼다. 멱등이며 **삭제된 글에도 동작한다** — 그래야 숨김 목록에 남지
  /// 않는다(2차 가이드 §2).
  Future<ModerationOutcome> unhidePost(String postId) =>
      _run(() => _repository.unhidePost(postId));

  /// 신고한다. [reason]이 [ReportReason.other]면 [detail]이 필수이며, 폼이 미리
  /// 막지만 서버가 `REPORT_DETAIL_REQUIRED`를 줄 수도 있다(가이드 §6).
  ///
  /// 재신고는 [ModerationOutcome.alreadyReported]로 접힌다.
  Future<ModerationOutcome> report({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
    String? detail,
  }) => _run(
    () => _repository.reportContent(
      targetType: targetType,
      targetId: targetId,
      reason: reason,
      detail: detail,
    ),
  );

  /// 내 글을 지운다. 성공하면 화면이 피드를 다시 불러온다.
  Future<ModerationOutcome> deletePost(String postId) =>
      _run(() => _repository.deletePost(postId));

  /// 내 댓글을 지운다. 남의 댓글이면 `NOT_COMMENT_OWNER`다.
  Future<ModerationOutcome> deleteComment(String commentId) =>
      _run(() => _repository.deleteComment(commentId));

  /// 내 글을 수정한다. 제목·본문·사진에 더해 **카테고리·장소·태그도 바뀐다** —
  /// 서버가 뒤늦게 받기 시작했다(1차 가이드 §5의 서술은 낡았다).
  ///
  /// [changeSpot]은 장소를 실제로 바꿨을 때만 true다. false면 [catalogId]를 무시하고
  /// 서버가 붙어 있던 장소를 그대로 둔다 — `catalogId: null` 하나로는 "그대로"와
  /// "떼기"가 구분되지 않기 때문이다.
  ///
  /// 숨겨진 글은 `POST_NOT_EDITABLE`로 거부되며 [ModerationOutcome.notEditable]로
  /// 온다 — 메뉴에서 미리 비활성화하지만 서버 판정도 함께 다룬다.
  Future<ModerationOutcome> editPost({
    required String postId,
    required String title,
    required String body,
    List<String>? photoKeys,
    TargetCategory? category,
    bool changeSpot = false,
    String? catalogId,
    List<String>? tags,
  }) => _run(
    () => _repository.editPost(
      postId: postId,
      title: title,
      body: body,
      photoKeys: photoKeys,
      category: category,
      changeSpot: changeSpot,
      catalogId: catalogId,
      tags: tags,
    ),
  );

  /// 실패 번역을 한 곳에 모은다 — 여러 동작이 같은 규약을 따르므로 분기가 흩어지면
  /// `ALREADY_REPORTED`를 한 군데서만 놓치는 일이 생긴다.
  Future<ModerationOutcome> _run(Future<void> Function() call) async {
    try {
      await call();
      return ModerationOutcome.success;
    } on CommunityFailure catch (failure) {
      if (failure.kind == CommunityFailureKind.unauthenticated) {
        return ModerationOutcome.unauthenticated;
      }
      return switch (failure.code) {
        'ALREADY_REPORTED' => ModerationOutcome.alreadyReported,
        'POST_NOT_EDITABLE' => ModerationOutcome.notEditable,
        _ => ModerationOutcome.failure,
      };
    } on Object {
      return ModerationOutcome.failure;
    }
  }
}
