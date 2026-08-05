import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/auth_route.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/post_moderation_sheet.dart';
import '../model/post.dart';
import '../model/report_reason.dart';
import '../provider/moderation_providers.dart';

/// 오버플로 → 시트 → 확인 → 뮤테이션 → 안내로 이어지는 모더레이션 흐름 하나
/// (R15·R16·R22, 디자인 §5).
///
/// **피드와 글 상세가 같은 흐름을 쓴다.** 두 화면에 같은 순서를 두 번 적으면 한쪽만
/// 고쳐지는 일이 생긴다 — 특히 "차단은 양방향임을 확인 문구에 명시한다"나
/// "`ALREADY_REPORTED`를 오류로 띄우지 않는다" 같은 규약이 그렇다.
///
/// [onChanged]는 **성공해서 목록이 달라졌을 때만** 불린다. 차단 후 서버가 필터링한
/// 결과를 받아야 하므로 로컬에서 지우는 것이 아니라 **재조회**가 정답이고(가이드 §6),
/// 호출부가 자기 provider를 invalidate한다.
///
/// **미인증이어도 진입을 막지 않는다**(가이드 §13, 디자인 §7). 시트를 열고 실행까지
/// 간 뒤 서버가 `UNAUTHENTICATED`를 주면 그때 로그인으로 보낸다 — 버튼을 감추면
/// 기능이 없는 것처럼 보인다.
Future<void> runPostModerationFlow(
  BuildContext context,
  WidgetRef ref, {
  required Post post,
  required VoidCallback onChanged,
}) async {
  final PostModerationAction? action = await showPostModerationSheet(
    context,
    ownedByViewer: post.ownedByViewer,
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case PostModerationAction.block:
      await _block(context, ref, post: post, onChanged: onChanged);
    case PostModerationAction.report:
      await _report(context, ref, post: post);
    case PostModerationAction.delete:
      await _delete(context, ref, post: post, onChanged: onChanged);
  }
}

/// 차단. **확인 단계를 반드시 거친다** — 양방향이라 되돌리기 전까지 서로 안 보이게
/// 되며, 유저가 그 결과를 알고 눌러야 한다(R15).
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
    // 신고가 아니므로 `ALREADY_REPORTED`는 오지 않는다. 온다면 일반 실패와 같이
    // 다룬다 — 차단은 멱등이라 이미 차단한 사람도 성공으로 온다(가이드 §8).
    case ModerationOutcome.alreadyReported:
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 신고. 사유 시트 → 뮤테이션 → **접수 사실만** 안내한다.
///
/// 처리 결과나 예상 시점을 약속하지 않는다 — 사용자 대상 신고는 기록만 되고 자동
/// 조치가 없으며(R22), 글·댓글도 서로 다른 5명이 모여야 숨겨진다(가이드 §9).
Future<void> _report(
  BuildContext context,
  WidgetRef ref, {
  required Post post,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final ReportSubmission? submission = await showReportSheet(context);
  if (submission == null || !context.mounted) return;

  final ModerationOutcome outcome = await ref
      .read(moderationControllerProvider.notifier)
      .report(
        targetType: ReportTargetType.post,
        targetId: post.id,
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
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 내 글 삭제. 글 수정 기능이 없어(가이드 §15) 삭제는 재작성을 뜻하므로 확인을 둔다.
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
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 로그인 유도(R17). 안내를 띄우고 로그인 화면으로 보낸다 — 버튼을 감추는 대신
/// 눌렀을 때 유도하는 쪽이다(설계 §3).
void _requireSignIn(BuildContext context, AppLocalizations l10n) {
  _toast(context, l10n.communitySignInRequired);
  context.pushNamed(loginRouteName);
}

void _toast(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
