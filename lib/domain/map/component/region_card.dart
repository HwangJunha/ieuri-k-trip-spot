import 'package:flutter/material.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/model/distance_format.dart';
import '../../../l10n/gen/app_localizations.dart';
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
    this.origin,
    super.key,
  });

  final RegionRecommendation region;

  /// 목록에서의 순위(1부터). **서버가 순위 필드를 주지 않으므로 화면이 목록 위치로
  /// 매긴다** — 목록은 총점 내림차순이 보장된다(R22).
  final int rank;

  /// 거리를 재는 기준 좌표. null이면 거리를 적지 않는다.
  ///
  /// **서버는 실제 거리를 주지 않는다** — 거리 점수(0~100)는 정규화된 값이라 km로
  /// 되돌릴 수 없다. 대신 기준 좌표와 지역 대표 좌표가 둘 다 있어 직접 계산한다.
  final Coordinates? origin;

  final VoidCallback onTap;

  /// 기준점에서 이 지역까지의 거리. 기준을 모르면 null이다.
  double? get _distanceMeters {
    final Coordinates? from = origin;
    if (from == null) return null;
    return distanceMetersBetween(
      lat1: from.latitude,
      lng1: from.longitude,
      lat2: region.centerLat,
      lng2: region.centerLng,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

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
                        // 시도명과 거리를 한 줄에 둔다 — "어디인지"와 "얼마나
                        // 먼지"는 함께 읽혀야 판단이 된다. 거리 점수 막대는
                        // 정규화된 값이라 실제 거리감을 주지 못한다.
                        Text(
                          switch (_distanceMeters) {
                            final double meters => l10n.mapRegionProvinceAndDistance(
                              region.provinceName,
                              formatDistance(l10n, meters),
                            ),
                            null => region.provinceName,
                          },
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
              // **기준일 줄을 두지 않는다**(사용자 결정, 2026-08-12).
              //
              // 카드마다 같은 날짜가 반복돼 노이즈였다. R24("실시간으로 읽히게 하지
              // 말 것")는 항목 라벨이 이미 지고 있다 — "예상 혼잡도"가 예측임을
              // 말하고, 어디에도 "지금·현재·실시간"에 해당하는 표현이 없다.
              //
              // 값 자체는 [RegionRecommendation.oldestBasisAt]에 살아 있어, 필요해지면
              // 목록 상단에 한 번만 적는 식으로 되살릴 수 있다.
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
