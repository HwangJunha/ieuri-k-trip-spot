import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/sns_provider.dart';

/// The three SNS sign-in buttons shown on the login screen (spec §5.1), plus an
/// "or" divider separating them from the email form. Each button reports its
/// [SnsProvider] to [onProvider]; the screen drives the SDK + login.
///
/// Brand styling is kept simple and legible (color + label); full brand assets
/// can replace these later without touching the flow. Buttons are disabled while
/// [loading].
class SnsLoginButtons extends StatelessWidget {
  const SnsLoginButtons({
    super.key,
    required this.onProvider,
    this.loading = false,
  });

  final ValueChanged<SnsProvider> onProvider;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                l10n.orDivider,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        _SnsButton(
          label: l10n.continueWithGoogle,
          background: Colors.white,
          foreground: Colors.black87,
          side: BorderSide(color: theme.dividerColor),
          onPressed: loading ? null : () => onProvider(SnsProvider.google),
        ),
        const SizedBox(height: 12),
        _SnsButton(
          label: l10n.continueWithApple,
          background: Colors.black,
          foreground: Colors.white,
          onPressed: loading ? null : () => onProvider(SnsProvider.apple),
        ),
        const SizedBox(height: 12),
        _SnsButton(
          label: l10n.continueWithKakao,
          background: const Color(0xFFFEE500),
          foreground: Colors.black87,
          onPressed: loading ? null : () => onProvider(SnsProvider.kakao),
        ),
      ],
    );
  }
}

class _SnsButton extends StatelessWidget {
  const _SnsButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.side,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: side,
          minimumSize: const Size.fromHeight(48),
        ),
        child: Text(label),
      ),
    );
  }
}
