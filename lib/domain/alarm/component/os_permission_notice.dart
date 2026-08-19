import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/permission/model/permission_kind.dart';
import '../../../common/permission/model/permission_state.dart';
import '../../../common/permission/provider/permission_providers.dart';
import '../../../l10n/gen/app_localizations.dart';

/// OS 알림이 꺼져 있을 때 그 사실을 알리고 OS 설정으로 보낸다(SPEC-0028 R21).
///
/// **두 스위치가 직렬로 걸린다**(설계 §7). 앱 토글은 서버 **발송**을 막고, OS 권한·채널은
/// **표시**를 막는다. 앱 토글이 켜져 있는데 OS가 꺼져 있으면 알림이 오지 않고 사용자는
/// 이것을 고장으로 오해한다 — 그래서 설정 화면이 OS 상태를 읽어 안내한다.
///
/// **`PermissionBlockedNotice`를 쓰지 않는 이유.** 그 위젯은 영구거부·restricted
/// (`needsSettings`)일 때만 그린다. 여기서는 **단순 거부도 알려야 한다** — 사용자가
/// 최초 시퀀스에서 "허용 안 함"을 한 번 누른 상태가 정확히 그것이고, 그 상태에서도
/// 알림은 오지 않기 때문이다. 앱을 막지 않는 위치(설정 화면 안)이므로 안내를 띄워도
/// R14의 "재요청하지 않는다"와 충돌하지 않는다 — 다이얼로그가 아니라 안내다.
///
/// **앱이 채널을 켤 수는 없다.** 구글이 막아 둔 동작이라(앱이 사용자가 끈 알림을 몰래
/// 되켜는 것 방지) 안내와 이동이 할 수 있는 전부다(설계 §7).
class OsPermissionNotice extends ConsumerWidget {
  const OsPermissionNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PermissionState? state = ref.watch(
      permissionControllerProvider.select(
        (Map<PermissionKind, PermissionState> s) =>
            s[PermissionKind.notification],
      ),
    );

    // 아직 조회하지 않았거나(null) 켜져 있으면 아무것도 그리지 않는다(AC21.3).
    if (state == null || state == PermissionState.granted) {
      return const SizedBox.shrink();
    }

    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.notifications_off_outlined,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.alarmOsDisabledNotice,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              TextButton(
                // OS의 앱 알림 설정으로 보낸다(AC21.2). 돌아오면 권한 게이트의
                // resume 훅이 상태를 다시 읽어 이 안내가 저절로 사라진다.
                onPressed: () => ref
                    .read(permissionControllerProvider.notifier)
                    .openSettings(),
                child: Text(l10n.permissionOpenSettings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
