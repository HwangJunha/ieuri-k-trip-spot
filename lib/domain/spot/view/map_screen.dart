import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// The Map tab. The congestion-map screen lands in a later step (spec §2.2);
/// this keeps the shell's Map tab navigable meanwhile. Part of the spot domain —
/// the map plots spots and their congestion.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static String get routeName => 'map';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMap)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
