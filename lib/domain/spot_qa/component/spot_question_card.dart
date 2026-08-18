import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_question.dart';
import 'spot_qa_author_line.dart';
import 'spot_qa_resolution_badge.dart';

/// 질문 목록의 카드 한 장(디자인 §1).
///
/// ```
/// (avatar) 닉네임 · 2h ago
/// 질문 본문 (3줄 truncate)
///                         💬 답변 3개   ✓ 해결됨
/// ```
///
/// **해결된 질문은 낮은 명도로 구분하되 숨기지 않는다**(설계 §질문 목록 화면) —
/// 지난 질문의 답변도 다음 방문자에게 정보다. 비활성처럼 보일 만큼 낮추지 않는다:
/// 여전히 탭할 수 있고 내용도 읽힌다.
///
/// **`hidden`은 작성자 본인에게만 온다**(모델 주석) — 남의 숨겨진 질문은 애초에
/// 목록에 없으므로, 이 배지가 보이면 그것은 항상 내 질문이다.
class SpotQuestionCard extends StatelessWidget {
  const SpotQuestionCard({
    super.key,
    required this.question,
    required this.now,
    required this.onTap,
  });

  final SpotQuestion question;

  /// 상대 시각 계산 기준(목록 전체가 같은 값을 쓴다).
  final DateTime now;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 해결된 질문의 본문 톤. 읽을 수는 있어야 하므로 onSurfaceVariant까지만 낮춘다.
    final Color? bodyColor = question.resolved
        ? theme.colorScheme.onSurfaceVariant
        : null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SpotQaAuthorLine(
              author: question.author,
              createdAt: question.createdAt,
              now: now,
            ),
            const SizedBox(height: 8),
            Text(
              question.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(color: bodyColor),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Icon(
                  Icons.mode_comment_outlined,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  // 서버가 준 answerCount 그대로다 — 목록 길이로 다시 계산하지
                  // 않는다(숨김 규칙이 서로 달라 어긋날 수 있다).
                  l10n.spotQaAnswerCount(question.answerCount),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (question.hidden) ...<Widget>[
                  Text(
                    l10n.communityHiddenBadge,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // 해결/미해결을 같은 자리에서 그린다 — 미해결은 강조색으로 떠서
                // 답을 기다리는 질문이 눈에 띈다(`SpotQaResolutionBadge`).
                SpotQaResolutionBadge(resolved: question.resolved),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "해결됨" 배지. 체크 아이콘 + 라벨이며 낮은 명도다.
