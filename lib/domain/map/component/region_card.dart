import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/congestion_display.dart';
import '../model/region_recommendation.dart';
import 'score_breakdown.dart';

/// 추천된 시군구 한 곳(설계 §2.1).
///
/// 카드 하나가 시군구 하나다. 탭하면 지도로 돌아가 그 지역으로 카메라가 움직인다.
///
/// **시도명을 지역명 바로 아래 붙인다**(§2.1). 같은 이름의 시군구가 실제로 여럿이라
/// (중구·남구·동구) 지역명만으로는 어디인지 알 수 없다 — 둘이 한 덩어리로 읽히도록
/// 간격을 좁게 둔다.
class RegionCard extends StatelessWidget {
  const RegionCard({
    required this.region,
    required this.rank,
    required this.onTap,
    super.key,
  });

  final RegionRecommendation region;

  /// 목록에서의 순위(1부터). **서버가 순위 필드를 주지 않으므로 화면이 목록 위치로
  /// 매긴다** — 목록은 총점 내림차순이 보장된다(R22).
  final int rank;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final String locale = Localizations.localeOf(context).toLanguageTag();

    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _RankBadge(rank: rank),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 지역명·시도명은 서버가 활성 언어로 내려준다(POL-039) —
                        // 앱이 별도 번역 테이블을 두지 않는다.
                        Text(
                          region.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          region.provinceName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _TotalScoreBadge(score: region.totalScore),
                ],
              ),
              const SizedBox(height: 12),
              ScoreBreakdown(region: region),
              // 항목 수가 다섯보다 적으면 근거가 얕다는 뜻이다(R31 · §2.2).
              // **숫자를 그대로 노출하지 않는다** — 스펙이 그렇게 요구했고, 필요한
              // 것은 "이 점수는 다른 카드와 근거의 두께가 다르다"는 인지뿐이다.
              if (region.scoreFactorCount < _fullFactorCount) ...<Widget>[
                const SizedBox(height: 4),
                _NoteRow(
                  icon: Icons.info_outline,
                  text: l10n.mapRegionRecommendationPartialData,
                ),
              ],
              // 기준 시점(R24 · POL-038). "지금·현재"가 아니라 "(시점) 기준"이다 —
              // 이 값이 실시간이 아님을 드러내는 유일한 장치다.
              //
              // 기준일(R24 · POL-038). **항목마다 다르므로 가장 오래된 것을 적는다**
              // — 집중률은 오늘이고 월 지표는 해당 월 1일이라, 최신 날짜를 고르면
              // 전체가 그만큼 새것처럼 읽힌다. 가장 오래된 값이 "이 카드가 최소한
              // 얼마나 묵은 근거 위에 서 있는가"를 정직하게 말해 준다.
              //
              // 날짜까지 붙이는 이유는 배치 데이터라 며칠 전이 기준일 수 있어서다.
              // 시각만 보이면 오늘로 읽혀 실시간이라는 오해를 키운다.
              if (region.oldestBasisAt case final DateTime basis) ...<Widget>[
                const SizedBox(height: 4),
                _NoteRow(
                  icon: Icons.schedule,
                  text: l10n.mapRegionRecommendationsDataBasis(
                    CongestionDisplay.dataBasisLabel(basis, locale),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 다섯 항목이 모두 산출됐을 때의 항목 수. 이보다 적으면 "일부 데이터 기준"이다.
const int _fullFactorCount = 5;

/// 순위 배지. 목록 위치로 매긴 숫자다.
class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$rank',
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// 총점 배지.
///
/// **점수 구간별 색을 두지 않는다**(디자인 §1 갭). 스펙에 임계값 규칙이 없어 임의로
/// 만들면 없는 기준을 화면이 지어내는 셈이 된다. 단일 `primary` 톤으로 둔다.
class _TotalScoreBadge extends StatelessWidget {
  const _TotalScoreBadge({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${score.round()}',
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// 카드 하단의 보조 안내 한 줄 — 작은 아이콘과 짧은 문구.
class _NoteRow extends StatelessWidget {
  const _NoteRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
