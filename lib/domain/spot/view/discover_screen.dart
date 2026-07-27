import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// The Discover (swipe) tab; the real screen lands in a later step (spec §2.2).
/// Part of the spot domain — Discover surfaces spots.
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  static String get routeName => 'discover';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDiscover)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
