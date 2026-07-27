import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// Placeholder for the Discover (swipe) tab; the real screen lands in a later
/// step (spec §2.2).
class DiscoverPlaceholderScreen extends StatelessWidget {
  const DiscoverPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDiscover)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
