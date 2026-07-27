import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// Placeholder for the Map tab. The congestion-map screen lands in a later step
/// (spec §2.2); this keeps the shell's Map tab navigable meanwhile.
class MapPlaceholderScreen extends StatelessWidget {
  const MapPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMap)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
