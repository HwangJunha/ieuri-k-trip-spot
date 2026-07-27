import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// Placeholder for the Chat tab; the real screen lands in a later step
/// (spec §2.2).
class ChatPlaceholderScreen extends StatelessWidget {
  const ChatPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navChat)),
      body: Center(child: Text(l10n.comingSoon)),
    );
  }
}
