import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/permission_kind.dart';
import '../model/permission_state.dart';
import '../provider/permission_providers.dart';

/// [kind]가 영구거부/restricted일 때 "설정 열기" 경로를 제공하는 인라인 안내 (R5).
/// 단순 거부는 앱을 막지 않으므로(R4), 권한이 실제로 [needsSettings]가 아니면 아무 것도
/// 그리지 않는다 — 이후 기능들이 권한이 필요한 어느 화면에나 이 위젯을 배치할 수 있게 한다.
class PermissionBlockedNotice extends ConsumerWidget {
  const PermissionBlockedNotice({super.key, required this.kind});

  final PermissionKind kind;

  String _message(AppLocalizations l10n) => switch (kind) {
    PermissionKind.location => l10n.permissionLocationBlockedMessage,
    PermissionKind.notification => l10n.permissionNotificationBlockedMessage,
    PermissionKind.photos => l10n.permissionPhotosBlockedMessage,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PermissionState? state = ref.watch(
      permissionControllerProvider.select((s) => s[kind]),
    );
    if (state == null || !state.needsSettings) return const SizedBox.shrink();

    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.info_outline,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_message(l10n), style: theme.textTheme.bodySmall),
            ),
            TextButton(
              onPressed: () => ref
                  .read(permissionControllerProvider.notifier)
                  .openSettings(),
              child: Text(l10n.permissionOpenSettings),
            ),
          ],
        ),
      ),
    );
  }
}
