import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/region_recommendation.dart';
import '../model/region_score.dart';

/// 항목별 점수 막대 그룹(R23 · 설계 §2.2).
///
/// **총점만으로는 왜 추천됐는지 알 수 없다**는 것이 이 위젯의 존재 이유다. "여기가
/// 추천됐다"와 "덜 붐빌 것으로 예상되고 가까워서 추천됐다"는 사용자에게 전혀 다른
/// 정보다.
///
/// **결측 항목을 0점 막대로 그리지 않는다**(§2.2 · R31). 서버가 산출하지 못한 항목을
/// 목록에서 빼서 주므로, 여기서 0으로 채우면 서버가 피한 왜곡을 화면이 되살린다 —
/// "이 지역은 소비가 바닥이다"로 읽힌다. 그래서 [RegionRecommendation.lacks]가 참인
/// 항목은 **행 자체를 렌더링하지 않는다**.
///
/// 행 생략을 택한 이유(디자인 §2 갭): 위치 권한이 없으면 모든 카드에서 거리 항목이
/// 빠지는데, 카드마다 "정보 없음" 회색 행을 반복하면 목록 전체가 부재 안내로 뒤덮인다.
/// 조용히 네 항목만 보이는 편이 노이즈가 적고, 부재 사실은 카드의 "일부 데이터 기준"
/// 칩이 이미 말한다.
class ScoreBreakdown extends StatelessWidget {
  const ScoreBreakdown({required this.region, super.key});

  final RegionRecommendation region;

  /// 그리는 항목과 그 순서. **enum 선언 순서를 고정으로 쓴다** — 카드마다 순서가
  /// 바뀌면 여러 지역을 나란히 훑을 수 없다.
  ///
  /// [RegionScoreFactor.unknown]은 여기 없다. 이름도 뜻도 모르는 막대를 그리면
  /// 사용자에게 의미 없는 축이 하나 생긴다(모델 주석 참조).
  static const List<RegionScoreFactor> _order = <RegionScoreFactor>[
    RegionScoreFactor.congestion,
    RegionScoreFactor.visitorVolume,
    RegionScoreFactor.stayIntensity,
    RegionScoreFactor.spendingIntensity,
    RegionScoreFactor.distance,
  ];

  @override
  Widget build(BuildContext context) {
    final List<RegionScore> shown = <RegionScore>[
      for (final RegionScoreFactor factor in _order)
        if (!region.lacks(factor)) _scoreOf(factor),
    ];
    // 그릴 것이 하나도 없으면 빈 여백을 남기지 않는다.
    if (shown.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final RegionScore score in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _ScoreRow(score: score),
          ),
      ],
    );
  }

  /// 해당 항목의 점수. [region]에 없으면 호출되지 않는다(`lacks`로 걸렀다).
  RegionScore _scoreOf(RegionScoreFactor factor) =>
      region.scores.firstWhere((RegionScore s) => s.factor == factor);
}

/// 항목 한 줄 — 라벨 · 막대 · 값.
class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.score});

  final RegionScore score;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String label = _factorLabel(l10n, score.factor);

    return Row(
      children: <Widget>[
        // 라벨 폭을 고정한다 — 항목마다 막대 시작점이 달라지면 길이를 눈으로
        // 비교할 수 없다.
        SizedBox(
          width: 108,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              // 0~100을 모델이 이미 0.0~1.0으로 잘라 준다 — 서버가 범위를 벗어난
              // 값을 줘도 막대가 넘치지 않는다.
              value: score.fraction,
              minHeight: 6,
              // 강점 라벨의 primary와 색을 나눈다 — 강점 한 줄과 항목별 막대는
              // 다른 종류의 정보라 같은 색으로 묶이면 안 된다.
              color: theme.colorScheme.secondary,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 점수를 적는다(사용자 결정, 2026-08-12).
        //
        // **이 값은 시·도 후보 안에서의 상대 위치다** — 정규화가 그 집합의
        // 최솟값~최댓값을 0~100에 맞추는 방식이라, 다른 시·도의 같은 숫자와 견주면
        // 뜻이 달라진다. 그 사실은 산출 근거 고지가 밝힌다.
        SizedBox(
          width: 28,
          child: Text(
            '${score.value.round()}',
            textAlign: TextAlign.end,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

/// enum을 표시 문구로 옮긴다(POL-023 — enum은 식별자이지 표시 문자열이 아니다).
///
/// **"지금 한산함"·"현재 여유" 류 표현을 쓰지 않는다**(R24). 혼잡도 항목은 향후
/// 예측이므로 "예상 혼잡도"로 둔다. 막대가 길수록 좋다는 것은 다섯 항목이 공유하는
/// 시각 언어로 전해지므로 항목마다 설명을 달지 않는다.
String _factorLabel(AppLocalizations l10n, RegionScoreFactor factor) =>
    switch (factor) {
      RegionScoreFactor.congestion => l10n.mapScoreFactorCongestion,
      RegionScoreFactor.visitorVolume => l10n.mapScoreFactorVisitorVolume,
      RegionScoreFactor.stayIntensity => l10n.mapScoreFactorStayIntensity,
      RegionScoreFactor.spendingIntensity =>
        l10n.mapScoreFactorSpendingIntensity,
      RegionScoreFactor.distance => l10n.mapScoreFactorDistance,
      // 그리지 않는 항목이라 여기 닿지 않는다. switch를 닫기 위한 가지다.
      RegionScoreFactor.unknown => '',
    };
