import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/region_recommendation.dart';
import '../model/region_score.dart';

/// 지역의 강점 라벨들(계약 변경 2026-08-12 · 사용자 결정 2026-08-12).
///
/// **시·도 안에서 3위 안에 든 항목만 붙인다.** 모든 지역에 무언가를 붙이면 라벨이
/// 변별력을 잃는다 — 3위 안에 드는 항목이 하나도 없는 지역은 라벨 없이 둔다(실측:
/// 10곳 중 2곳). 없는 강점을 지어내지 않는 편이 정직하다.
///
/// **순위 숫자를 적지 않는다.** "가까운 곳"이면 충분하고, "시·도 1위"는 목록 안
/// 순위로 오해되기 쉬웠다. 순위의 정확한 뜻은 산출 근거 고지가 설명한다.
///
/// **시제가 factor마다 다르다.** 데이터 성격이 달라서다 — 예상 혼잡도는 향후 30일
/// 예측이라 미래형이어야 하고("지금 한산"은 거짓이다), 방문자 규모는 약 30일 지연
/// 공개라 과거형이어야 정직하다. 체류·소비는 월 단위 지표로 지역의 고유 성격에
/// 가까워 시제를 두지 않는다. 문구는 l10n이 쥐고 여기서는 factor만 고른다.
class RegionStrengthLabels extends StatelessWidget {
  const RegionStrengthLabels({required this.region, super.key});

  final RegionRecommendation region;

  /// factor에 맞는 강점 문구. **[RegionScoreFactor.unknown]은 문구가 없다.**
  static String? strengthText(AppLocalizations l10n, RegionScoreFactor factor) =>
      switch (factor) {
        RegionScoreFactor.congestion => l10n.mapRegionStrengthCongestion,
        RegionScoreFactor.visitorVolume => l10n.mapRegionStrengthVisitorVolume,
        RegionScoreFactor.stayIntensity => l10n.mapRegionStrengthStayIntensity,
        RegionScoreFactor.spendingIntensity =>
          l10n.mapRegionStrengthSpendingIntensity,
        RegionScoreFactor.distance => l10n.mapRegionStrengthDistance,
        RegionScoreFactor.unknown => null,
      };

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<RegionScore> top = region.topRankedScores;
    if (top.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: <Widget>[
        for (final RegionScore score in top)
          if (strengthText(l10n, score.factor) case final String text)
            _StrengthChip(text: text),
      ],
    );
  }
}

class _StrengthChip extends StatelessWidget {
  const _StrengthChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
