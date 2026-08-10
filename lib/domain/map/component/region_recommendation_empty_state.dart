import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/region_recommendation.dart';

/// 빈 결과 안내(R15 · R20 · 설계 §5.1).
///
/// **빈 결과는 오류가 아니다.** 배치가 데이터를 쌓기 전에는 추천이 성립하지 않는데,
/// 이것을 오류 화면으로 그리면 사용자가 해결되지 않는 재시도를 반복한다. 그래서
/// 오류 색(`error` 롤)도, 재시도 버튼도 쓰지 않는다.
///
/// **두 상태를 다른 문구로 가른다**(R20). 기준 시점이 없으면 아직 모으는 중이고,
/// 있으면 데이터는 쌓였으나 조건을 만족한 지역이 없는 것이다 — 뭉뚱그리면 사용자가
/// 기다려야 하는 상황인지 조건을 바꿔야 하는 상황인지 알 수 없다.
class RegionRecommendationEmptyState extends StatelessWidget {
  const RegionRecommendationEmptyState({required this.result, super.key});

  final RegionRecommendationResult result;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    final bool awaiting = result.isAwaitingData;
    final IconData icon = awaiting
        ? Icons.hourglass_empty
        : Icons.search_off_outlined;
    final String title = awaiting
        ? l10n.mapRegionRecommendationsGatheringTitle
        : l10n.mapRegionRecommendationsNoMatchTitle;
    final String body = awaiting
        ? l10n.mapRegionRecommendationsGathering
        : l10n.mapRegionRecommendationsNoMatch;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 56, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
