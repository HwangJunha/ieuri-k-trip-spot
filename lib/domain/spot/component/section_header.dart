import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// Row with a section title and an optional "View all" link. The caller passes
/// an already-localized [title]; [onViewAll] null hides the trailing link
/// (Happening Now / Popular Spots have no "View all" per the design reference).
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(AppLocalizations.of(context).viewAll),
          ),
      ],
    );
  }
}
