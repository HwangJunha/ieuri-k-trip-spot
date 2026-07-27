import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// The Events tab; the real screen lands in a later step (spec §2.2).
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  static String get routeName => 'events';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navEvents)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
