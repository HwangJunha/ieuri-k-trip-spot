import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth/provider/auth_controller.dart';
import '../../l10n/gen/app_localizations.dart';

/// An AppBar logout action. Lives in `common/` (not a feature) because it's a
/// cross-cutting app affordance and the auth state is app-global — a feature
/// screen must not import another feature's internals (CLAUDE.md §4), so the
/// shared shell/home reuses this instead of reaching into `domain/auth`.
///
/// Tapping calls `AuthController.signOut()` (server refresh-token revocation +
/// local token wipe + state reset). The router's redirect then sends the user
/// back to the login screen (spec §10.2) — no manual navigation needed here.
class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: l10n.logoutTooltip,
      onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
    );
  }
}
