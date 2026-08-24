import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/auth_route.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/post_moderation_sheet.dart';
import '../../../common/model/comment.dart';
import '../../../common/model/post.dart';
import '../model/report_reason.dart';
import '../provider/moderation_providers.dart';
import 'post_composer_screen.dart';

/// ⋮ → 시트 → 확인 → 뮤테이션 → 안내로 이어지는 모더레이션 흐름 하나(가이드 §5·§6).
///
/// **피드와 글 상세가 같은 흐름을 쓴다.** 두 화면에 같은 순서를 두 번 적으면 한쪽만
/// 고쳐지는 일이 생긴다 — 특히 "차단은 양방향임을 확인 문구에 명시한다"나
/// "`ALREADY_REPORTED`를 오류로 띄우지 않는다" 같은 규약이 그렇다.
///
/// [onChanged]는 **성공해서 목록이 달라졌을 때만** 불린다. 차단 후 서버가 필터링한
/// 결과를 받아야 하므로 로컬에서 지우는 것이 아니라 **재조회**가 정답이고(가이드 §6),
/// 호출부가 자기 provider를 invalidate한다.
Future<void> runPostModerationFlow(
  BuildContext context,
  WidgetRef ref, {
  required Post post,
  required VoidCallback onChanged,
}) async {
  final PostModerationAction? action = await showPostModerationSheet(
    context,
    ownedByViewer: post.ownedByViewer,
    hidden: post.hidden,
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case PostModerationAction.block:
      await _block(context, ref, post: post, onChanged: onChanged);
    case PostModerationAction.report:
      await _report(
        context,
        ref,
        targetType: ReportTargetType.post,
        targetId: post.id,
      );
    case PostModerationAction.hide:
      await _hide(context, ref, post: post, onChanged: onChanged);
    case PostModerationAction.edit:
      await _edit(context, post: post, onChanged: onChanged);
    case PostModerationAction.delete:
      await _delete(context, ref, post: post, onChanged: onChanged);
  }
}

/// 댓글의 ⋮ 흐름. 내 댓글이면 삭제, 남의 댓글이면 신고다.
Future<void> runCommentModerationFlow(
  BuildContext context,
  WidgetRef ref, {
  required Comment comment,
  required VoidCallback onChanged,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final PostModerationAction? action = await showCommentModerationSheet(
    context,
    ownedByViewer: comment.ownedByViewer,
  );
  if (action == null || !context.mounted) return;

  if (action == PostModerationAction.report) {
    await _report(
      context,
      ref,
      targetType: ReportTargetType.comment,
      targetId: comment.id,
    );
    return;
  }

  final ModerationOutcome outcome = await ref
      .read(moderationControllerProvider.notifier)
      .deleteComment(comment.id);
  if (!context.mounted) return;

  switch (outcome) {
    case ModerationOutcome.success:
      _toast(context, l10n.communityCommentDeleteDone);
      onChanged();
    case ModerationOutcome.unauthenticated:
      _requireSignIn(context, l10n);
    case ModerationOutcome.alreadyReported:
    case ModerationOutcome.notEditable:
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 차단. **확인 단계를 반드시 거친다** — 양방향이라 되돌리기 전까지 서로 안 보이게
/// 되며, 유저가 그 결과를 알고 눌러야 한다(가이드 §6).
Future<void> _block(
  BuildContext context,
  WidgetRef ref, {
  required Post post,
  required VoidCallback onChanged,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  if (!await confirmBlock(context, post.author.nickname)) return;
  if (!context.mounted) return;

  final ModerationOutcome outcome = await ref
      .read(moderationControllerProvider.notifier)
      .block(post.author.id);
  if (!context.mounted) return;

  switch (outcome) {
    case ModerationOutcome.success:
      _toast(context, l10n.communityBlockDone);
      // 서버가 필터링하므로 로컬 제거가 아니라 재조회다(가이드 §6).
      onChanged();
    case ModerationOutcome.unauthenticated:
      _requireSignIn(context, l10n);
    // 차단은 멱등이라 이미 차단한 사람도 성공으로 온다(가이드 §7) — 아래 둘은
    // 차단 경로에서 나오지 않지만, 나오면 일반 실패와 같이 다룬다.
    case ModerationOutcome.alreadyReported:
    case ModerationOutcome.notEditable:
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 이 글 숨기기(2차 가이드 §2). **확인 단계를 두지 않는다** — 되돌릴 수 있고 내
/// 화면에만 영향을 주는 화면 설정이라, 확인을 물으면 차단만큼 무거운 조치로 보인다.
///
/// 성공하면 **피드를 다시 불러온다** — 서버가 필터링하므로 로컬에서 지우는 것이
/// 아니다(차단과 같은 규약). 멱등이라 이미 숨긴 글에 다시 불러도 성공이다.
Future<void> _hide(
  BuildContext context,
  WidgetRef ref, {
  required Post post,
  required VoidCallback onChanged,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final ModerationOutcome outcome = await ref
      .read(moderationControllerProvider.notifier)
      .hidePost(post.id);
  if (!context.mounted) return;

  switch (outcome) {
    case ModerationOutcome.success:
      _toast(context, l10n.communityHidePostDone);
      onChanged();
    case ModerationOutcome.unauthenticated:
      _requireSignIn(context, l10n);
    case ModerationOutcome.alreadyReported:
    case ModerationOutcome.notEditable:
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 신고. 사유 시트 → 뮤테이션 → **접수 사실만** 안내한다.
///
/// 처리 결과나 예상 시점을 약속하지 않는다 — 사용자 대상 신고는 기록만 되고 자동
/// 조치가 없으며, 글·댓글도 서로 다른 5명이 모여야 숨겨진다(가이드 §6).
Future<void> _report(
  BuildContext context,
  WidgetRef ref, {
  required ReportTargetType targetType,
  required String targetId,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final ReportSubmission? submission = await showReportSheet(context);
  if (submission == null || !context.mounted) return;

  final ModerationOutcome outcome = await ref
      .read(moderationControllerProvider.notifier)
      .report(
        targetType: targetType,
        targetId: targetId,
        reason: submission.reason,
        detail: submission.detail,
      );
  if (!context.mounted) return;

  switch (outcome) {
    case ModerationOutcome.success:
      _toast(context, l10n.communityReportDone);
    // 재신고는 서버가 막는 정상 흐름이다 — 오류로 띄우면 무언가 고장난 줄 안다.
    case ModerationOutcome.alreadyReported:
      _toast(context, l10n.communityReportAlready);
    case ModerationOutcome.unauthenticated:
      _requireSignIn(context, l10n);
    case ModerationOutcome.notEditable:
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 내 글 수정. 제목·본문·사진만 바뀌므로 컴포저를 **수정 모드**로 연다(가이드 §5).
///
/// **id만 넘긴다** — 컴포저가 그 id로 글을 다시 조회해 제목·본문·사진을 채운다.
/// 여기서 [post]의 값을 실어 보내면 사진 키가 빠져(URL에 담기 어렵다) 수정 화면이
/// 사진 없는 새 글처럼 열린다.
///
/// 숨겨진 글은 시트에서 이미 비활성이라 여기 오지 않는다.
Future<void> _edit(
  BuildContext context, {
  required Post post,
  required VoidCallback onChanged,
}) async {
  final bool? edited = await context.pushNamed<bool>(
    PostComposerScreen.routeName,
    queryParameters: <String, String>{'editPostId': post.id},
  );
  if ((edited ?? false) && context.mounted) onChanged();
}

/// 내 글 삭제. 되돌릴 수 없으므로 확인을 둔다.
Future<void> _delete(
  BuildContext context,
  WidgetRef ref, {
  required Post post,
  required VoidCallback onChanged,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  if (!await confirmDeletePost(context)) return;
  if (!context.mounted) return;

  final ModerationOutcome outcome = await ref
      .read(moderationControllerProvider.notifier)
      .deletePost(post.id);
  if (!context.mounted) return;

  switch (outcome) {
    case ModerationOutcome.success:
      _toast(context, l10n.communityDeleteDone);
      onChanged();
    case ModerationOutcome.unauthenticated:
      _requireSignIn(context, l10n);
    case ModerationOutcome.alreadyReported:
    case ModerationOutcome.notEditable:
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 로그인 유도. 안내를 띄우고 로그인 화면으로 보낸다.
void _requireSignIn(BuildContext context, AppLocalizations l10n) {
  _toast(context, l10n.communitySignInRequired);
  context.pushNamed(loginRouteName);
}

void _toast(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
