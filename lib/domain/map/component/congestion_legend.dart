import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/congestion_level.dart';
import '../model/congestion_palette.dart';

/// 혼잡도 4단계 범례(R24, 디자인 §4).
///
/// **혼잡도 레이어가 실제로 보일 때만 띄운다.** 줌 게이트 미만이거나 `degraded`면
/// 숨긴다 — 화면에 색이 하나도 없는데 범례만 떠 있으면 무엇을 설명하는지 알 수 없다.
/// 판정은 화면이 하고 이 위젯은 그리기만 한다.
///
/// 반투명 배경을 까는 이유는 [CongestionAttribution]과 같다 — 지도 무늬 위에서
/// 글자만 올리면 묻힌다.
class CongestionLegend extends StatelessWidget {
  const CongestionLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (final CongestionLevel level in CongestionLevel.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
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
                    Text(
                      _label(l10n, level),
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _label(AppLocalizations l10n, CongestionLevel level) => switch (level) {
  CongestionLevel.relaxed => l10n.mapCongestionRelaxed,
  CongestionLevel.normal => l10n.mapCongestionNormal,
  CongestionLevel.slightlyCrowded => l10n.mapCongestionSlightlyCrowded,
  CongestionLevel.crowded => l10n.mapCongestionCrowded,
};
