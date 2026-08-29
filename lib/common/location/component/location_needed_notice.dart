import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../permission/model/permission_kind.dart';
import '../../permission/model/permission_state.dart';
import '../../permission/provider/permission_providers.dart';
import '../../widget/failure_notice.dart';
import '../location_providers.dart';

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

    // 세 갈래다.
    //
    //   granted        — 권한은 있는데 좌표를 못 얻었다(위치 서비스 꺼짐,
    //                    실내에서 fix 실패, 혹은 설정에서 막 켜고 돌아온 직후).
    //                    OS에 다시 물어도 다이얼로그가 안 뜨므로 **다시 시도**다.
    //   needsSettings  — 영구거부·restricted. 설정에서만 바꿀 수 있다.
    //   그 외          — 아직 물어볼 수 있다. 권한 요청을 건다.
    //
    // 상태를 모르면(null) 설정 이동으로 둔다 — 요청을 걸었다가 조용히 실패하는
    // 것보다 사용자가 확실히 바꿀 수 있는 곳으로 보내는 편이 낫다.
    final _NoticeAction action = switch (state) {
      PermissionState.granted => _NoticeAction.retry,
      null => _NoticeAction.openSettings,
      _ when state.needsSettings => _NoticeAction.openSettings,
      _ => _NoticeAction.requestPermission,
    };

    return FailureNotice.terminal(
      title: l10n.locationNeededTitle,
      body: message,
      actionLabel: switch (action) {
        _NoticeAction.retry => l10n.discoverRetryButton,
        _NoticeAction.openSettings => l10n.permissionOpenSettings,
        _NoticeAction.requestPermission =>
          l10n.mapRegionRecommendationsAllowLocation,
      },
      onAction: () => _act(ref, action),
      icon: Icons.location_off_outlined,
    );
  }

  Future<void> _act(WidgetRef ref, _NoticeAction action) async {
    final PermissionController controller = ref.read(
      permissionControllerProvider.notifier,
    );

    switch (action) {
      case _NoticeAction.openSettings:
        await controller.openSettings();
        // 설정에서 돌아오는 것은 `LocationRefreshGate`의 resume 훅이 잡아
        // 좌표를 다시 받는다 — 여기서 결과를 기다릴 수 없다(앱이 백그라운드로
        // 간다).
        return;

      case _NoticeAction.requestPermission:
        final PermissionState next = await controller.request(
          PermissionKind.location,
        );
        if (next != PermissionState.granted) return;
        _retry(ref);

      case _NoticeAction.retry:
        // 권한은 이미 있다 — 실패한 것은 좌표 조회다.
        _retry(ref);
    }
  }

  /// 캐시된 실패를 버리고 좌표를 다시 받는다.
  ///
  /// **[onRetry]만으로는 부족하다.** 화면의 재조회는 좌표 provider를 다시
  /// `watch`할 뿐인데, 그것이 오류 상태로 남아 있으면 같은 오류가 그대로 돌아온다
  /// — 버튼을 눌러도 아무 일이 없는 것처럼 보인다(실기기 확인 2026-08-29).
  /// 좌표부터 무효화해야 다음 조회가 실제로 GPS를 다시 읽는다.
  void _retry(WidgetRef ref) {
    ref.invalidate(currentCoordinatesProvider);
    onRetry?.call();
  }
}

/// 버튼이 무엇을 하는지. 권한 상태에 따라 갈린다.
enum _NoticeAction { openSettings, requestPermission, retry }
