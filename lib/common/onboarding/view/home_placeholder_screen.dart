import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// Placeholder landing shown after onboarding. Login (Step 2) and the real
/// home (Step 3) replace this later.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            l10n.homePlaceholder,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
