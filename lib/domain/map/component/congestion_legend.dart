import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/congestion_level.dart';
import '../model/congestion_palette.dart';

/// 혼잡도 4단계 범례(R24, 디자인 §4).
///
/// **기본은 접혀 있다.** 네 단계를 늘 펼쳐 두었더니 좌상단을 크게 차지해 정작 지도가
/// 안 보였다 — 지도 화면에서 가장 중요한 것은 지도다. 색의 뜻이 궁금할 때만 펴서
/// 보면 되고, 한 번 알면 다시 볼 일이 드물다.
///
/// 접힌 상태에서도 **네 색을 띠로 보여 준다** — 무엇에 대한 범례인지는 그것으로
/// 충분히 드러나고, 출처 표기(R30)도 접힌 채로 함께 붙어 의무를 지킨다.
///
/// **혼잡도 레이어가 실제로 보일 때만 띄운다.** 판정은 화면이 하고 이 위젯은 그리기만
/// 한다.
class CongestionLegend extends StatefulWidget {
  const CongestionLegend({super.key});

  @override
  State<CongestionLegend> createState() => _CongestionLegendState();
}

class _CongestionLegendState extends State<CongestionLegend> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: _expanded
              ? _ExpandedLegend(theme: theme)
              : _CollapsedLegend(theme: theme),
        ),
      ),
    );
  }
}

/// 접힌 모습 — 색 띠와 화살표만. 지도를 거의 가리지 않는다.
class _CollapsedLegend extends StatelessWidget {
  const _CollapsedLegend({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      for (final CongestionLevel level in CongestionLevel.values)
        Padding(
          padding: const EdgeInsets.only(right: 3),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Color(CongestionPalette.dotOf(level)),
              shape: BoxShape.circle,
            ),
          ),
        ),
      const SizedBox(width: 2),
      Icon(
        Icons.keyboard_arrow_down,
        size: 14,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    ],
  );
}

/// 펼친 모습 — 단계별 라벨과 출처.
class _ExpandedLegend extends StatelessWidget {
  const _ExpandedLegend({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final CongestionLevel level in CongestionLevel.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(CongestionPalette.dotOf(level)),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(_label(l10n, level), style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        const SizedBox(height: 4),
        // 출처(R30). 공공누리 제1유형은 표시가 **의무**라 생략할 수 없다.
        Text(
          l10n.mapAttribution,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

String _label(AppLocalizations l10n, CongestionLevel level) => switch (level) {
  CongestionLevel.relaxed => l10n.mapCongestionRelaxed,
  CongestionLevel.normal => l10n.mapCongestionNormal,
  CongestionLevel.slightlyCrowded => l10n.mapCongestionSlightlyCrowded,
  CongestionLevel.crowded => l10n.mapCongestionCrowded,
};
