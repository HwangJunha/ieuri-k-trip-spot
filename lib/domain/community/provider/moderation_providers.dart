import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/community_failure.dart';
import '../model/report_reason.dart';
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

  /// 내 글을 수정한다. **제목·본문·사진만 바뀐다**(가이드 §5).
  ///
  /// 숨겨진 글은 `POST_NOT_EDITABLE`로 거부되며 [ModerationOutcome.notEditable]로
  /// 온다 — 메뉴에서 미리 비활성화하지만 서버 판정도 함께 다룬다.
  Future<ModerationOutcome> editPost({
    required String postId,
    required String title,
    required String body,
    List<String>? photoKeys,
  }) => _run(
    () => _repository.editPost(
      postId: postId,
      title: title,
      body: body,
      photoKeys: photoKeys,
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
