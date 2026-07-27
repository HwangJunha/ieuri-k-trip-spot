import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// The Chat tab; the real screen lands in a later step (spec §2.2). Chat is a
/// spot-domain feature (spot-based guidance for visitors), not a domain of its
/// own — hence it lives under `spot/view/` alongside discover and map.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static String get routeName => 'chat';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navChat)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
