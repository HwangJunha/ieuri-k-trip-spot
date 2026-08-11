import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/region_score.dart';

/// 지역의 강점 한 줄(계약 변경 2026-08-12).
///
/// **총점 자리를 대신한다.** `totalScore`가 계약에서 빠진 이유는 가중평균 구조상 총점이
/// 늘 항목 점수들 사이 값이라 1위가 60점으로 나왔기 때문이다 — 절대 점수 자체가 이
/// 데이터에 맞지 않는다. 대신 "이 지역이 무엇으로 뽑혔는가"를 말한다.
///
/// **시제가 factor마다 다르다.** 데이터 성격이 달라서다 — 예상 혼잡도는 향후 30일
/// 예측이라 미래형이어야 하고("지금 한산"은 거짓이다), 방문자 규모는 약 30일 지연
/// 공개라 과거형이어야 정직하다. 체류·소비는 월 단위 지표로 지역의 고유 성격에
/// 가까워 시제를 두지 않는다. 문구는 l10n이 쥐고 여기서는 factor만 고른다.
class RegionStrengthLabel extends StatelessWidget {
  const RegionStrengthLabel({required this.score, super.key});

  final RegionScore score;

  /// factor에 맞는 강점 문구. **[RegionScoreFactor.unknown]은 문구가 없다** —
  /// 이름도 뜻도 모르는 항목을 강점이라 부를 수 없다.
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
    final ThemeData theme = Theme.of(context);
    final String? strength = strengthText(l10n, score.factor);
    if (strength == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        // **순위를 함께 적는다.** 강점만 있으면 "얼마나 강한지"가 빠지고, 순위만
        // 있으면 "무엇이" 빠진다. 순위는 시·도 전체 후보 기준이라 그 사실을 문구가
        // 밝힌다("시·도 n위") — 목록 안 순위로 읽히면 곤란하다.
        l10n.mapRegionStrengthWithRank(strength, score.rank),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
