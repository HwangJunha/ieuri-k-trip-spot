import 'package:flutter/material.dart';

import '../model/tourist_spot.dart';
import 'congestion_badge.dart';
import 'spot_image_placeholder.dart';

/// Horizontal-scroll card for "Recommended for You": image, title, a location
/// badge, and a congestion badge. Fixed width so it lays out in a horizontal
/// list.
class SpotCard extends StatelessWidget {
  const SpotCard({super.key, required this.spot});

  final TouristSpot spot;

  static const double width = 240;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 120,
              child: SpotImagePlaceholder(imageRef: spot.imageRef),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    spot.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          spot.location,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CongestionBadge(level: spot.congestion),
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
