import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/permission_kind.dart';

/// OS 권한 다이얼로그 *이전에* 보여주는 인앱 사전설명 (R3). 앱이 [kind]를 왜 필요로
/// 하는지 설명해 사용자가 정보를 갖고 선택하게 한다. iOS는 OS 다이얼로그가 설치당 1회만
/// 뜨므로, 사용자가 여기서 "계속"을 눌렀을 때만 OS 권한을 요청한다.
///
/// [show]로 표시하며, 사용자가 진행을 택하면 `true`, 닫으면 `false`/`null`로 완료된다
/// (R3 실패 경로 — OS 요청 안 함).
///
/// 위치는 필수라([AMEND] SPEC-0001), 위치 시트에는 "나중에" 버튼이 없고 스와이프/배리어로
/// 닫을 수도 없다 — 나아가는 길은 "계속"뿐이다. 알림 시트는 닫을 수 있게 유지한다.
class PermissionRationaleSheet extends StatelessWidget {
  const PermissionRationaleSheet({super.key, required this.kind});

  final PermissionKind kind;

  /// 진행하지 않고 닫는 걸 허용하는지 여부. 위치는 필수라 사전설명에 "계속"만 둔다.
  bool get _dismissible => kind != PermissionKind.location;

  /// 사전설명을 모달 바텀시트로 띄운다. 사용자가 "계속"을 누르면 `true`, 아니면 `false`
  /// (닫음 — 닫을 수 있는 kind에서만 가능).
  static Future<bool> show(BuildContext context, PermissionKind kind) async {
    final bool dismissible = kind != PermissionKind.location;
    final bool? proceed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: dismissible,
      isDismissible: dismissible,
      enableDrag: dismissible,
      builder: (_) => PopScope<bool>(
        // 필수 시트는 뒤로가기로도 닫을 수 없다.
        canPop: dismissible,
        child: PermissionRationaleSheet(kind: kind),
      ),
    );
    return proceed ?? false;
  }

  IconData get _icon => switch (kind) {
    PermissionKind.location => Icons.location_on_outlined,
    PermissionKind.notification => Icons.notifications_active_outlined,
    PermissionKind.photos => Icons.photo_library_outlined,
  };

  String _title(AppLocalizations l10n) => switch (kind) {
    PermissionKind.location => l10n.permissionLocationRationaleTitle,
    PermissionKind.notification => l10n.permissionNotificationRationaleTitle,
    PermissionKind.photos => l10n.permissionPhotosRationaleTitle,
  };

  String _body(AppLocalizations l10n) => switch (kind) {
    PermissionKind.location => l10n.permissionLocationRationaleBody,
    PermissionKind.notification => l10n.permissionNotificationRationaleBody,
    PermissionKind.photos => l10n.permissionPhotosRationaleBody,
  };

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(_icon, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              _title(l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _body(l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('permission_rationale_continue'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.permissionContinue),
            ),
            // 위치는 필수 — 거부 선택지 없음. 알림은 "나중에"를 유지.
            if (_dismissible) ...<Widget>[
              const SizedBox(height: 8),
              TextButton(
                key: const Key('permission_rationale_not_now'),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.permissionNotNow),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
