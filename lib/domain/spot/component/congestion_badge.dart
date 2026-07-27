import 'package:flutter/material.dart';

import '../../../common/theme/congestion_colors.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/congestion_level.dart';

/// Pill badge showing a spot's [CongestionLevel]. Color comes from the shared
/// `CongestionColors` theme extension; label comes from l10n. Reused by the
/// recommended spot card and (as an inline color) the popular spot card.
class CongestionBadge extends StatelessWidget {
  const CongestionBadge({super.key, required this.level});

  final CongestionLevel level;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CongestionColors colors =
        theme.extension<CongestionColors>() ?? CongestionColors.brand;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: congestionColor(colors, level),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        congestionLabel(AppLocalizations.of(context), level),
        style: theme.textTheme.labelSmall?.copyWith(color: colors.onCongestion),
      ),
    );
  }
}

/// Maps a level to its shared semantic color.
Color congestionColor(CongestionColors colors, CongestionLevel level) =>
    switch (level) {
      CongestionLevel.low => colors.low,
      CongestionLevel.moderate => colors.moderate,
      CongestionLevel.high => colors.high,
    };

/// Maps a level to its localized label (Low / Moderate / High).
String congestionLabel(AppLocalizations l10n, CongestionLevel level) =>
    switch (level) {
      CongestionLevel.low => l10n.congestionLow,
      CongestionLevel.moderate => l10n.congestionModerate,
      CongestionLevel.high => l10n.congestionHigh,
    };
