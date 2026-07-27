import 'package:flutter/material.dart';

import '../../../common/theme/congestion_colors.dart';
import '../../../common/widget/image_placeholder.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/tourist_spot.dart';
import 'congestion_badge.dart';

/// Vertical card for "Popular Spots": image, title, star rating, location, and a
/// combined congestion + distance line (e.g. "Very Busy · 2.4km away") where the
/// congestion word is colored via the shared theme extension.
class PopularSpotCard extends StatelessWidget {
  const PopularSpotCard({super.key, required this.spot});

  final TouristSpot spot;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final CongestionColors congestion =
        theme.extension<CongestionColors>() ?? CongestionColors.brand;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // IntrinsicHeight lets the image column stretch to match the text
      // column's natural height without an unbounded-height Row.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 96,
              child: ImagePlaceholder(imageRef: spot.imageRef),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      spot.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (spot.rating != null)
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 16,
                            color: theme.colorScheme.tertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            spot.rating!.toStringAsFixed(1),
                            style: theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    const SizedBox(height: 4),
                    Text(
                      spot.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _CongestionDistanceLine(
                      spot: spot,
                      l10n: l10n,
                      congestion: congestion,
                      baseStyle: theme.textTheme.labelLarge,
                      mutedColor: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CongestionDistanceLine extends StatelessWidget {
  const _CongestionDistanceLine({
    required this.spot,
    required this.l10n,
    required this.congestion,
    required this.baseStyle,
    required this.mutedColor,
  });

  final TouristSpot spot;
  final AppLocalizations l10n;
  final CongestionColors congestion;
  final TextStyle? baseStyle;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final String label = congestionLabel(l10n, spot.congestion);
    final Color color = congestionColor(congestion, spot.congestion);

    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: label,
            style: baseStyle?.copyWith(color: color),
          ),
          if (spot.distanceKm != null) ...<InlineSpan>[
            TextSpan(
              text: '  ·  ',
              style: baseStyle?.copyWith(color: mutedColor),
            ),
            TextSpan(
              text: l10n.distanceAway(spot.distanceKm!.toStringAsFixed(1)),
              style: baseStyle?.copyWith(color: mutedColor),
            ),
          ],
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
