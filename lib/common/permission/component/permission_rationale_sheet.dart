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
/// **모든 시트는 닫을 수 있다**(2026-08-29). 2026-08-26에 위치 시트만 "나중에"를
/// 없애고 스와이프·배리어·뒤로가기를 전부 막았는데, 닫을 수 없는 사전설명 모달은
/// 그 자체로 App Store 심사 위험이고(Guideline 5.1.1 — 권한은 거부할 수 있어야
/// 한다) 위치를 필수로 본 전제도 5.1.5로 거절됐다. SPEC-0001 R3·R4대로 돌아간다.
class PermissionRationaleSheet extends StatelessWidget {
  const PermissionRationaleSheet({super.key, required this.kind});

  final PermissionKind kind;

  /// 사전설명을 모달 바텀시트로 띄운다. 사용자가 "계속"을 누르면 `true`, 아니면 `false`.
  static Future<bool> show(BuildContext context, PermissionKind kind) async {
    final bool? proceed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => PermissionRationaleSheet(kind: kind),
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
            // 어떤 권한이든 거부할 수 있다 — 위치도 예외가 아니다(위 클래스 주석).
            const SizedBox(height: 8),
            TextButton(
              key: const Key('permission_rationale_not_now'),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.permissionNotNow),
            ),
          ],
        ),
      ),
    );
  }
}
