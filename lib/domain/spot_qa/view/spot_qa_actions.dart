import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../community/component/post_moderation_sheet.dart';
import '../../community/model/report_reason.dart';
import '../../community/provider/moderation_providers.dart';
import '../../dm/provider/conversation_start_providers.dart';
import '../../dm/view/conversation_screen.dart';

/// 질문/답변/답글의 신고·DM 흐름(R11·R13).
///
/// **커뮤니티의 신고 시트를 그대로 재사용한다**(설계 §신고·차단) — 서버도 새 뮤테이션
/// 없이 `reportContent`에 대상 타입만 새 값(`SPOT_QUESTION`/`SPOT_ANSWER`/
/// `SPOT_ANSWER_REPLY`)을 더했다. 사유는 고정 4종이며 자유 입력을 받지 않는다.
///
/// **이 파일만 `domain/community`·`domain/dm`을 부른다.** 컴포넌트는 콜백만 받고,
/// 화면은 여기를 호출한다 — 기능 간 의존을 한곳에 모아 두면 나중에 공용으로 올릴 때
/// 옮길 자리가 하나다(CLAUDE.md §3·§4). DM 화면(`conversation_screen.dart`)이
/// 이미 같은 방식으로 커뮤니티 신고 시트를 쓰고 있다.
Future<void> runSpotQaReport(
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
    // 재신고는 서버가 막는 정상 흐름이다 — 오류로 띄우면 고장난 줄 안다.
    case ModerationOutcome.alreadyReported:
      _toast(context, l10n.communityReportAlready);
    case ModerationOutcome.unauthenticated:
      _toast(context, l10n.communitySignInRequired);
    case ModerationOutcome.notEditable:
    case ModerationOutcome.failure:
      _toast(context, l10n.communityActionFailed);
  }
}

/// 답변·답글 작성자에게 DM을 연다(R13).
///
/// [sourceAnswerId]는 **답변의 id**다 — 답글에서 시작해도 출처는 그 답글이 달린
/// 답변이며(계약이 답변만 출처로 받는다), 그래야 대화 화면의 맥락 카드가 질문·답변
/// 스냅샷을 갖춘다.
///
/// **출처를 만들지 못해도 실패가 아니다**(AC-13.4) — 답변이 이미 삭제됐으면 서버가
/// 출처 없이 대화를 연다. 대화가 열린 것이 본질이라 화면은 이것을 오류로 다루지 않는다.
Future<void> runSpotQaDirectMessage(
  BuildContext context,
  WidgetRef ref, {
  required String counterpartMemberId,
  required String sourceAnswerId,
  required String questionId,
  required String spotTitle,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final String? conversationId = await ref
      .read(conversationStarterProvider)
      .start(counterpartMemberId, sourceAnswerId: sourceAnswerId);
  if (!context.mounted) return;

  if (conversationId == null) {
    _toast(context, l10n.spotQaDmFailed);
    return;
  }
  // **어느 질문에서 들어왔는지 대화 화면에 넘긴다.**
  //
  // 대화는 상대별로 하나인데 서버가 남기는 출처는 최초 하나뿐이라(AC-13.3 — 기존
  // 대화의 출처는 바뀌지 않는다), 두 번째로 다른 질문에서 들어오면 상단 카드가 계속
  // 첫 질문을 가리킨다. 그 어긋남을 화면이 알아채려면 "지금 들어온 질문"을 알아야 한다.
  //
  // 쿼리 파라미터로 넘기는 이유는 **표시용 힌트**이기 때문이다(장소 상세의 `thumb`과
  // 같은 성격) — 없어도 대화는 정상이고, 프리필만 안 채워진다.
  context.pushNamed(
    ConversationScreen.routeName,
    pathParameters: <String, String>{'id': conversationId},
    queryParameters: <String, String>{
      'fromQuestion': questionId,
      'fromSpot': spotTitle,
    },
  );
}

void _toast(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
