import 'package:flutter/material.dart';

import '../../../common/widget/post_labels.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../provider/my_questions_providers.dart';
import 'spot_qa_resolution_badge.dart';
import '../../../common/widget/spot_thumbnail.dart';

/// 「내 질문」 목록의 한 줄.
///
/// ```
/// 장소명                                   [새 답변 2개]
/// 질문 본문 (2줄 truncate)
/// 답변 3개 · 3시간 전
/// ```
///
/// **새 답변 배지가 이 화면의 존재 이유다.** 서버에 알림이 없어 "내 질문에 답이
/// 달렸다"를 알릴 경로가 이것뿐이라(`MyQuestionItem.hasNewAnswers`) 목록에서 바로
/// 눈에 띄어야 한다 — 상세로 들어가야 보이면 알림 역할을 못 한다.
///
/// 목록은 서버(`spotQuestions(mine:)`)가 주므로 **항상 실제 질문이 있다** — 예전
/// 로컬 기록 방식에 있던 "못 찾음" 상태가 사라졌다.
class MyQuestionTile extends StatelessWidget {
  const MyQuestionTile({
    super.key,
    required this.item,
    required this.now,
    required this.onTap,
  });

  final MyQuestionItem item;

  /// 상대 시각 계산 기준(목록 전체가 같은 값을 쓴다).
  final DateTime now;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String title = item.question.spot.title;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 장소 썸네일. **어느 장소에 물었는지 글자보다 먼저 알아본다** — 목록이
            // 장소를 가로지르므로 여기서 구분이 가장 빨리 된다.
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: SpotThumbnail(
                  imageRef: item.question.spot.thumbnailImageUrl,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                      if (item.hasNewAnswers) ...<Widget>[
                        const SizedBox(width: 8),
                        _NewAnswerBadge(
                          label: l10n.spotQaNewAnswerBadge(item.newAnswerCount),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.question.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.mode_comment_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.spotQaAnswerCount(item.question.answerCount),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        relativePostTime(l10n, item.question.createdAt, now),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      // 해결 여부를 오른쪽 끝에 붙인다 — 미해결이 눈에 띄어야 한다.
                      SpotQaResolutionBadge(resolved: item.question.resolved),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 「새 답변 N개」 배지. 알림을 대신하는 신호라 강조색(primary) 칩으로 그린다 —
/// 해결됨 배지처럼 낮은 명도로 두면 목록을 훑을 때 지나친다.
class _NewAnswerBadge extends StatelessWidget {
  const _NewAnswerBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
