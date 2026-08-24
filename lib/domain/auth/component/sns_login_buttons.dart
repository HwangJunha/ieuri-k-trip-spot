import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.providers,
  });

  final ValueChanged<SnsProvider> onProvider;
  final bool loading;

  /// 보여줄 provider. 생략하면 플랫폼에 맞춰 고른다 — 안드로이드에서는 애플이
  /// 빠진다([snsProvidersFor]). 테스트는 이 인자로 플랫폼을 고정한다.
  final List<SnsProvider>? providers;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final List<SnsProvider> shown =
        providers ??
        snsProvidersFor(isApplePlatform: Platform.isIOS || Platform.isMacOS);

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
        for (final SnsProvider provider in shown) ...<Widget>[
          _button(provider, l10n, theme),
          if (provider != shown.last) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _button(
    SnsProvider provider,
    AppLocalizations l10n,
    ThemeData theme,
  ) => switch (provider) {
    SnsProvider.google => _SnsButton(
      label: l10n.continueWithGoogle,
      // Google's multicolor mark is drawn as-is (no tint).
      icon: SvgPicture.asset(
        'asset/icon/sns_google.svg',
        width: 20,
        height: 20,
      ),
      background: Colors.white,
      foreground: Colors.black87,
      side: BorderSide(color: theme.dividerColor),
      onPressed: loading ? null : () => onProvider(SnsProvider.google),
    ),
    SnsProvider.apple => _SnsButton(
      label: l10n.continueWithApple,
      // Monochrome marks use currentColor → tinted to the button foreground.
      icon: SvgPicture.asset(
        'asset/icon/sns_apple.svg',
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      background: Colors.black,
      foreground: Colors.white,
      onPressed: loading ? null : () => onProvider(SnsProvider.apple),
    ),
    SnsProvider.kakao => _SnsButton(
      label: l10n.continueWithKakao,
      icon: SvgPicture.asset(
        'asset/icon/sns_kakao.svg',
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(Color(0xFF3C1E1E), BlendMode.srcIn),
      ),
      background: const Color(0xFFFEE500),
      foreground: const Color(0xFF3C1E1E),
      onPressed: loading ? null : () => onProvider(SnsProvider.kakao),
    ),
  };
}

class _SnsButton extends StatelessWidget {
  const _SnsButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.side,
  });

  final String label;
  final Widget icon;
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
        // Icon at the leading edge, label centered in the remaining space so the
        // three buttons align regardless of label width.
        child: Row(
          children: <Widget>[
            icon,
            Expanded(child: Text(label, textAlign: TextAlign.center)),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
