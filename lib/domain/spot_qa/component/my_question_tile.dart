import 'package:flutter/material.dart';

import '../../../common/widget/post_labels.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../provider/my_questions_providers.dart';

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
/// **서버에서 못 찾은 질문도 지우지 않는다.** 그때는 본문 대신 안내 문구를 그리고
/// 로컬 기록이 아는 장소명·작성 시각만 보여준다(provider 주석 참고).
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
    final bool missing = item.question == null;

    // 장소명은 서버 값을 우선한다 — 로컬 기록이 비어 있어도(작성 화면이 장소명을
    // 몰랐던 경우) 조회에 성공하면 채워진다.
    final String title = item.question?.spot.title.isNotEmpty ?? false
        ? item.question!.spot.title
        : item.ref.spotTitle;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
            const SizedBox(height: 6),
            Text(
              missing ? l10n.spotQaMyQuestionsUnavailable : item.question!.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                // 못 찾은 질문은 본문이 아니라 안내라 낮은 명도로 구분한다.
                color: missing ? theme.colorScheme.onSurfaceVariant : null,
                fontStyle: missing ? FontStyle.italic : null,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: <Widget>[
                // 못 찾았으면 답변 수를 모른다 — 0으로 단정하지 않고 아예 뺀다.
                if (!missing) ...<Widget>[
                  Icon(
                    Icons.mode_comment_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.spotQaAnswerCount(item.question!.answerCount),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  // 작성 시각은 **로컬 기록**이 출처다 — 서버에서 못 찾아도 언제
                  // 물었는지는 남아 있다.
                  relativePostTime(l10n, item.ref.askedAt, now),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
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
