import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_answer.dart';
import '../model/spot_answer_reply.dart';
import 'spot_qa_action_row.dart';
import 'spot_qa_author_line.dart';
import 'spot_answer_reply_tile.dart';

/// 답변 하나와 거기 딸린 답글들(디자인 §2).
///
/// ```
/// (avatar) 닉네임 · 1h ago
/// 답변 본문 전문
/// [답글 달기] [메시지 보내기] [신고]
///    └ SpotAnswerReplyTile × N
///    └ (답글 인라인 컴포저)
/// ```
///
/// **답글은 이 타일 안에 그린다.** 서버가 [SpotAnswer.replies]로 함께 내려주고
/// 페이지네이션이 없으므로(깊이가 2단계뿐이라 화면을 넘길 만큼 커지지 않는다) 부모
/// 답변 아래에 그대로 붙인다.
///
/// [replyComposer]는 "이 답변에 답글을 다는 중"일 때만 넘어오는 인라인 입력이다 —
/// 어느 답변에 다는지는 화면 상태이고, 타일은 자리만 내준다.
class SpotAnswerTile extends StatelessWidget {
  const SpotAnswerTile({
    super.key,
    required this.answer,
    required this.now,
    this.onMessage,
    this.onReport,
    this.onReply,
    this.replyComposer,
    this.onReplyMessage,
    this.onReplyReport,
  });

  final SpotAnswer answer;

  /// 상대 시각 계산 기준(화면 전체가 같은 값을 쓴다).
  final DateTime now;

  /// 답변 작성자에게 DM. **내 답변이면 null이다.**
  final VoidCallback? onMessage;

  /// 답변 신고. 내 답변이면 null이다.
  final VoidCallback? onReport;

  /// 이 답변에 답글 달기. null이면 버튼을 그리지 않는다.
  final VoidCallback? onReply;

  /// 열려 있는 답글 입력. 이 답변이 대상일 때만 non-null이다.
  final Widget? replyComposer;

  /// 답글 작성자에게 DM. 내 답글이면 null을 돌려준다.
  final VoidCallback? Function(SpotAnswerReply reply)? onReplyMessage;

  /// 답글 신고. 내 답글이면 null을 돌려준다.
  final VoidCallback? Function(SpotAnswerReply reply)? onReplyReport;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SpotQaAuthorLine(
            author: answer.author,
            createdAt: answer.createdAt,
            now: now,
          ),
          const SizedBox(height: 6),
          // 답변은 목록이 아니라 상세라 **자르지 않는다**(디자인 §2).
          Text(answer.body, style: theme.textTheme.bodyMedium),
          if (answer.hidden) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              l10n.communityHiddenBadge,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          SpotQaActionRow(
            onReply: onReply,
            onMessage: onMessage,
            onReport: onReport,
          ),
          for (final SpotAnswerReply reply in answer.replies)
            SpotAnswerReplyTile(
              reply: reply,
              now: now,
              onMessage: onReplyMessage?.call(reply),
              onReport: onReplyReport?.call(reply),
            ),
          if (replyComposer != null)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 4),
              child: replyComposer,
            ),
        ],
      ),
    );
  }
}
