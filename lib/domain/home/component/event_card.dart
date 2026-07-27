import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/tour_event.dart';
import 'spot_image_placeholder.dart';

/// List-row card for "Happening Now": a placeholder thumbnail, the event title,
/// and a category badge (icon + label on `tertiaryContainer`, the events accent
/// per DESIGN.md §3).
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final TourEvent event;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 72,
            height: 72,
            child: SpotImagePlaceholder(imageRef: event.imageRef),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _CategoryBadge(category: event.category, l10n: l10n),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category, required this.l10n});

  final EventCategory category;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            _iconFor(category),
            size: 14,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            _labelFor(category, l10n),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  static IconData _iconFor(EventCategory category) => switch (category) {
    EventCategory.festival => Icons.festival,
    EventCategory.live => Icons.music_note,
    EventCategory.art => Icons.palette,
  };

  static String _labelFor(EventCategory category, AppLocalizations l10n) =>
      switch (category) {
        EventCategory.festival => l10n.eventCategoryFestival,
        EventCategory.live => l10n.eventCategoryLive,
        EventCategory.art => l10n.eventCategoryArt,
      };
}
