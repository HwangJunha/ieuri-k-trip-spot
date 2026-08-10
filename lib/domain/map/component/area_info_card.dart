import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/commercial_activity_level.dart';
import '../model/commercial_display_state.dart';
import '../model/congestion_area.dart';
import '../model/congestion_display.dart';
import '../model/congestion_level.dart';
import '../model/congestion_palette.dart';

/// 구역을 선택했을 때 뜨는 정보 카드(R27·R28, 디자인 §3).
///
/// 인구 항목은 **정확히 넷이다**(spec §7.8) — 구역명 · 혼잡 단계 · 추정 인구 범위 ·
/// 기준 시각. 늘리지 않는다. 업스트림의 한국어 설명 문장은 계약에서 제외됐다.
///
/// 상권은 구분선 아래 **별도 섹션**이다(사용자 결정). 인구와 기준 시각이 다르기
/// 때문에 합쳐 표시하지 않는다(설계 §6.1) — 상권은 야간에 갱신이 멈추는 것이
/// 관측됐고(spec §4.3), 하나로 묶으면 인구의 신선도가 상권에도 있는 것처럼 읽힌다.
class AreaInfoCard extends StatelessWidget {
  const AreaInfoCard({required this.area, required this.onClose, super.key});

  final CongestionArea area;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final String locale = Localizations.localeOf(context).toLanguageTag();
    final CongestionSnapshot snapshot = area.congestion;
    final ({String max, String min}) population =
        CongestionDisplay.populationRange(
          snapshot.populationMin,
          snapshot.populationMax,
          locale,
        );

    return Card(
      color: theme.colorScheme.surfaceContainer,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 구역명은 서버가 활성 언어로 내려준다(R31) — 앱 번역 파일에 121건을
                // 넣지 않는다.
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      area.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                ),
              ],
            ),
            const SizedBox(height: 4),
            // 단계는 **색과 라벨을 함께** 쓴다. 색만으로 표현하면 색각 이상 사용자가
            // 구분할 수 없다(설계 §6.1, 폴리곤 채색과 같은 이유).
            _LevelRow(
              color: Color(CongestionPalette.dotOf(snapshot.level)),
              label: _congestionLabel(l10n, snapshot.level),
              theme: theme,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.mapPopulationRange(population.min, population.max),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 2),
            // 기준 시각(R27). 데이터가 약 30분 지연되므로 "지금"으로 표기하지 않는다.
            Text(
              l10n.mapObservedAt(
                CongestionDisplay.observedAtLabel(snapshot.observedAt, locale),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 20),
            _CommercialSection(area: area, locale: locale),
          ],
        ),
      ),
    );
  }
}

/// 혼잡 단계 한 줄 — 색 점과 라벨.
class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.color,
    required this.label,
    required this.theme,
  });

  final Color color;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

/// 상권 3상태(R28).
///
/// 부재 · 기본값 · 실측을 **눈에 보이게 다르게** 그린다. 기본값을 실측과 같은 모양으로
/// 그리면 39곳의 자리표시자가 실측인 척한다 — 없는 정보를 있는 것으로 오해하게 만드는
/// 것은 안 보여주는 것보다 나쁘다(spec §7.5).
class _CommercialSection extends StatelessWidget {
  const _CommercialSection({required this.area, required this.locale});

  final CongestionArea area;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final CommercialStatus? status = area.commercial;
    final TextStyle? labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.mapCommercialLabel, style: labelStyle),
        const SizedBox(height: 4),
        switch (area.commercialState) {
          // 부재는 조회 실패가 아니다 — 121곳 중 39곳이 원래 값이 없다.
          CommercialDisplayState.unavailable => Text(
            l10n.mapCommercialUnavailable,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          // 실측이 아닌 값. 단계를 흐리게 두고 "실측되지 않은 지역"을 함께 적어,
          // 이 값을 신뢰 신호로 읽지 않게 한다.
          CommercialDisplayState.estimated => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _commercialLabel(l10n, status!.level),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.help_outline,
                    size: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      l10n.mapCommercialEstimated,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 실측값. 상권의 기준 시각은 인구와 다르므로 여기 따로 적는다.
          CommercialDisplayState.measured => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _commercialLabel(l10n, status!.level),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 2),
              Text(
                l10n.mapObservedAt(
                  CongestionDisplay.observedAtLabel(status.observedAt, locale),
                ),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        },
      ],
    );
  }
}

/// enum을 표시 문구로 옮긴다(POL-023 — enum은 식별자이지 표시 문자열이 아니다).
String _congestionLabel(AppLocalizations l10n, CongestionLevel level) =>
    switch (level) {
      CongestionLevel.relaxed => l10n.mapCongestionRelaxed,
      CongestionLevel.normal => l10n.mapCongestionNormal,
      CongestionLevel.slightlyCrowded => l10n.mapCongestionSlightlyCrowded,
      CongestionLevel.crowded => l10n.mapCongestionCrowded,
    };

String _commercialLabel(AppLocalizations l10n, CommercialActivityLevel level) =>
    switch (level) {
      CommercialActivityLevel.quiet => l10n.mapCommercialQuiet,
      CommercialActivityLevel.normal => l10n.mapCommercialNormal,
      CommercialActivityLevel.busy => l10n.mapCommercialBusy,
      CommercialActivityLevel.peak => l10n.mapCommercialVeryBusy,
    };
