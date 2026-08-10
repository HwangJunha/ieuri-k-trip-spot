import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// "종합 점수 순"임을 알리는 칩(설계 §4.2).
///
/// **거리순이 아님을 화면에서 드러낸다.** 거리는 필터가 아니라 점수 항목 하나라
/// (spec §7.6) 조금 멀어도 다른 항목이 뚜렷하게 나은 곳이 목록에 섞인다. 사용자가
/// 이 목록을 거리순으로 오해하면 "왜 더 가까운 데를 안 보여주지"로 읽힌다.
///
/// 목록 맨 위, 스크롤하기 전에 반드시 보이는 자리에 둔다.
class SortIndicatorChip extends StatelessWidget {
  const SortIndicatorChip({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.leaderboard_outlined,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            AppLocalizations.of(context).mapRegionRecommendationsSortedByScore,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
