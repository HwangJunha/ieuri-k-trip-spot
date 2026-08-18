import 'dart:async';
import '../../../common/model/post_author.dart';
import '../../dm/provider/conversation_providers.dart';
import '../../dm/provider/viewer_providers.dart';
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
/// [sourceAnswerId]는 **답변의 id**다 — 답글에서 시작해도 인용은 그 답글이 달린
/// 답변이다(계약이 답변만 인용 대상으로 받는다).
///
/// **대화를 연 뒤 인용을 첫 메시지로 보낸다**(2026-08-18 서버 변경). 예전에는 대화를
/// 열 때 인용을 붙였는데, 그러면 대화당 하나뿐이라 나중에 다른 질문에서 말을 걸어도
/// 첫 인용이 계속 남아 화면이 거짓말을 했다. 이제 인용이 메시지에 붙어 **몇 번이든,
/// 서로 다른 질문을 인용할 수 있고 앞선 인용은 그대로 보존된다.**
///
/// **본문 없이 인용만 보낸다**(`body: ''`). 사용자가 아직 할 말을 쓰지 않았는데 문장을
/// 지어 보내는 것은 월권이다 — 인용만 먼저 놓고 무슨 말을 할지는 사용자가 정한다.
///
/// **인용을 만들지 못해도 실패가 아니다** — 답변이 삭제됐거나 작성자가 대화 상대가
/// 아니면 서버가 조용히 무시하고 일반 메시지로 보낸다. 대화가 열린 것이 본질이다.
Future<void> runSpotQaDirectMessage(
  BuildContext context,
  WidgetRef ref, {
  required String counterpartMemberId,
  required String sourceAnswerId,
}) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final String? conversationId = await ref
      .read(conversationStarterProvider)
      .start(counterpartMemberId);
  if (!context.mounted) return;

  if (conversationId == null) {
    _toast(context, l10n.spotQaDmFailed);
    return;
  }

  // 인용 메시지를 보낸다. **화면으로 이동하기 전에 건다** — 낙관적 말풍선이 이미
  // 목록에 있어야 대화가 열리는 순간 인용이 보인다.
  //
  // 발신자 정보가 없으면(비로그인) 보내지 않는다. 여기까지 온 이상 드문 경우이며,
  // 그때는 대화만 열리고 사용자가 직접 말을 건다.
  final PostAuthor? me = ref.read(viewerAuthorProvider);
  if (me != null) {
    // 낙관적 스냅샷을 만들지 않는다 — 스냅샷의 출처는 서버이고, 여기서 지어내면
    // 서버가 인용을 만들지 못했을 때(답변 삭제) 없는 인용이 잠깐 보인다.
    // 서버 응답이 오면 그때 인용이 붙는다.
    unawaited(
      ref
          .read(conversationControllerProvider(conversationId).notifier)
          .send(me: me, sourceAnswerId: sourceAnswerId),
    );
  }

  context.pushNamed(
    ConversationScreen.routeName,
    pathParameters: <String, String>{'id': conversationId},
  );
}

void _toast(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
