import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_answer_reply.dart';
import 'spot_qa_action_row.dart';
import 'spot_qa_author_line.dart';
import 'spot_qa_photos.dart';

/// 답변에 딸린 답글 한 줄(디자인 §2).
///
/// **답글 액션이 없다.** [SpotAnswerReply]에 `replies`가 없어 타입 수준에서도 답글에
/// 답글을 달 수 없으므로(R7), 버튼 자체를 그리지 않는다 — 눌렀다가 서버가
/// `REPLY_TO_REPLY_NOT_ALLOWED`로 거절하는 경로를 만들지 않는다.
///
/// 들여쓰기와 작은 아바타로 부모 답변에 딸린 것임을 나타낸다.
class SpotAnswerReplyTile extends StatelessWidget {
  const SpotAnswerReplyTile({
    super.key,
    required this.reply,
    required this.now,
    this.onMessage,
    this.onReport,
  });

  final SpotAnswerReply reply;

  /// 상대 시각 계산 기준(화면 전체가 같은 값을 쓴다).
  final DateTime now;

  /// 작성자에게 DM. **내 답글이면 null이다** — 자기 자신과는 대화하지 않는다.
  final VoidCallback? onMessage;

  /// 신고. 내 답글이면 null이다.
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Padding(
      // 왼쪽을 한 단계 더 들여 부모 답변에 딸린 것으로 읽히게 한다.
      padding: const EdgeInsets.fromLTRB(40, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SpotQaAuthorLine(
            author: reply.author,
            createdAt: reply.createdAt,
            now: now,
            compact: true,
          ),
          const SizedBox(height: 4),
          Text(reply.body, style: theme.textTheme.bodyMedium),
          // 첨부 사진(R9). 들여쓴 자리라 낮게 그린다.
          SpotQaPhotos(photoKeys: reply.photoKeys, compact: true),
          // 숨김은 작성자 본인에게만 온다(모델 주석).
          if (reply.hidden) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              l10n.communityHiddenBadge,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          // **onReply를 넘기지 않는다** — 답글에는 답글을 달 수 없다.
          SpotQaActionRow(onMessage: onMessage, onReport: onReport),
        ],
      ),
    );
  }
}
