import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../permission/model/permission_kind.dart';
import '../../permission/model/permission_state.dart';
import '../../permission/provider/permission_providers.dart';
import '../../widget/failure_notice.dart';

/// 좌표가 필요한 화면이 좌표를 얻지 못했을 때 그리는 안내(2026-08-29).
///
/// **왜 재시도 배너가 아닌가.** 위치 실패에 "다시 시도"를 주면 눌러도 같은 실패가
/// 돌아온다 — 원인이 네트워크가 아니라 기기 설정이라 앱이 스스로 고칠 수 없다.
/// 실제로 Discover·검색이 그 상태였고, App Store 심사에서 "위치를 끄면 앱이
/// 동작하지 않는다"로 거절됐다(Guideline 5.1.5). 사용자가 할 수 있는 일을
/// 제시해야 안내다.
///
/// **버튼은 상태에 따라 달라진다.** 아직 OS에 물어볼 수 있으면(거부·미결정)
/// 권한 요청을, 설정에서만 바꿀 수 있으면(영구거부·restricted·위치 서비스 꺼짐)
/// 설정 이동을 건다. 후자에 권한 요청을 걸면 iOS는 다이얼로그를 띄우지 않아
/// 누르면 아무 일도 안 일어나는 버튼이 된다.
class LocationNeededNotice extends ConsumerWidget {
  const LocationNeededNotice({super.key, required this.message, this.onRetry});

  /// 이 화면에서 위치가 왜 필요한지. 화면마다 다르므로 호출부가 준다.
  final String message;

  /// 위치를 켠 뒤 다시 조회할 방법. 주면 권한 허용 직후 호출한다.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PermissionState? state = ref.watch(
      permissionControllerProvider.select((s) => s[PermissionKind.location]),
    );

    // 상태를 아직 모르면 설정 이동으로 둔다 — 요청을 걸었다가 조용히 실패하는
    // 것보다, 사용자가 확실히 바꿀 수 있는 곳으로 보내는 편이 낫다.
    final bool needsSettings = state?.needsSettings ?? true;

    return FailureNotice.terminal(
      title: l10n.locationNeededTitle,
      body: message,
      actionLabel: needsSettings
          ? l10n.permissionOpenSettings
          : l10n.mapRegionRecommendationsAllowLocation,
      onAction: () => _act(ref, needsSettings),
      icon: Icons.location_off_outlined,
    );
  }

  Future<void> _act(WidgetRef ref, bool needsSettings) async {
    final PermissionController controller = ref.read(
      permissionControllerProvider.notifier,
    );
    if (needsSettings) {
      await controller.openSettings();
      // 설정에서 돌아오는 것은 `PermissionBootGate`의 resume 훅이 잡아 상태를
      // 갱신한다 — 여기서 결과를 기다릴 수 없다(앱이 백그라운드로 간다).
      return;
    }
    final PermissionState next = await controller.request(
      PermissionKind.location,
    );
    if (next == PermissionState.granted) onRetry?.call();
  }
}
