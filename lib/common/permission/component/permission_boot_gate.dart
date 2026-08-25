import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../navigation/root_navigator_key.dart';
import '../model/permission_kind.dart';
import '../model/permission_state.dart';
import '../provider/permission_providers.dart';
import '../repository/rationale_shown_store.dart';
import 'permission_rationale_sheet.dart';

/// 최초 실행 권한 시퀀스를 구동한다 (SPEC-0001 §최초실행). `MaterialApp.router`의
/// builder에서 마운트되어 세션 전체에 걸쳐 살아 있으므로 resume 재조회를 담당한다. 앱
/// Navigator보다 *위에* 있어서, 사전설명 시트는 이 위젯이 아니라 [rootNavigatorKey]의
/// context로 띄운다.
///
/// 흐름은 첫 프레임 이후 한 번 실행된다:
///   위치 → (사전설명 → OS 요청) 그다음 알림 → (사전설명 → OS 요청). 엄격히 순차라 두
///   OS 다이얼로그가 겹치지 않는다 (R2). 각 kind는 상태가 이미 결정됐으면 건너뛴다 (R6).
///   결과는 앱을 막지 않는다 — 허용이든 거부든 [child]로 흘러간다 (R4). 앱 `resumed` 시
///   이미 조회했던 권한을 다시 읽어, 설정에서 바꾼 값이 재시작 없이 반영된다 (R5).
class PermissionBootGate extends ConsumerStatefulWidget {
  PermissionBootGate({
    super.key,
    required this.child,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? rootNavigatorKey;

  final Widget child;

  /// 사전설명 시트를 띄울 context를 가진 navigator. 기본값은 앱의 [rootNavigatorKey],
  /// 테스트가 자체 키를 주입할 수 있게 열어둔다.
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  ConsumerState<PermissionBootGate> createState() => _PermissionBootGateState();
}

class _PermissionBootGateState extends ConsumerState<PermissionBootGate>
    with WidgetsBindingObserver {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runSequence());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // OS 설정 앱에서 복귀: 바뀐 권한을 재시작 없이 반영하려고 다시 읽는다 (R5 두 번째
    // criterion). resume이 시퀀스 도중(사전설명 시트에서 백그라운드로 감)에 들어와도,
    // 최악의 경우는 상태 조회 한 번 중복 + 무해한 덮어쓰기 — 잘못된 결정은 없다.
    if (state == AppLifecycleState.resumed && _started) {
      ref.read(permissionControllerProvider.notifier).refreshAll();
    }
  }

  /// 위치 다음 알림을 순차 실행한다. 첫 프레임 콜백이 두 번 이상 예약돼도 한 번만 돌도록
  /// 가드한다. 끝에서 부트 완료를 신호해, 스플래시가 두 프롬프트가 모두 실행된 뒤에만
  /// 라우팅하게 한다 — 위치가 허용되는 순간(선택 권한인 알림 프롬프트를 건너뛰게 됨)이
  /// 아니라 (R2).
  Future<void> _runSequence() async {
    if (_started) return;
    _started = true;
    await _requestLocation();
    await _requestNotification();
    ref.read(permissionBootCompleteProvider.notifier).complete();
  }

  /// 위치는 필수 ([AMEND] SPEC-0001). 이미 허용됐으면 끝. 설정에서만 바꿀 수 있는
  /// 상태(`permanentlyDenied`/restricted)면 스플래시의 "설정 열기" 경로에 넘긴다 (R5).
  /// 그 외에는 (닫을 수 없는) 사전설명을 한 번 띄우고 OS 다이얼로그를 발동한다. 그래도
  /// 허용 안 하면 설정 필요 상태로 승격시켜, 앱이 스플래시에 영영 머무는 대신 스플래시가
  /// 그 경로를 노출하게 한다.
  ///
  /// 반복이 아니라 1회 프롬프트: iOS는 OS 다이얼로그를 설치당 최대 1회만 띄우므로 재요청은
  /// 소용없다 — 남은 길은 설정뿐이다.
  Future<void> _requestLocation() async {
    final PermissionController controller = ref.read(
      permissionControllerProvider.notifier,
    );
    final PermissionState current = await controller.check(
      PermissionKind.location,
    );
    if (current == PermissionState.granted || current.needsSettings) return;

    final BuildContext? navContext = widget.navigatorKey.currentContext;
    if (navContext == null || !navContext.mounted) return;
    // 위치 시트에는 "나중에"가 없으므로 항상 true로 돌아온다.
    await PermissionRationaleSheet.show(navContext, PermissionKind.location);

    final PermissionState next = await controller.request(
      PermissionKind.location,
    );
    // 여전히 허용 안 됨 → 앱이 다시 프롬프트할 수 없다; 스플래시를 통해 사용자를 설정으로
    // 안내한다.
    if (next != PermissionState.granted) {
      controller.markNeedsSettings(PermissionKind.location);
    }
  }

  /// R6 + R3: 알림은 선택. 상태를 조회해 이미 결정됐으면 아무 것도 안 한다. 그 외에는 닫을
  /// 수 있는 사전설명을 띄우고, 사용자가 진행할 때만 OS 요청을 발동한다.
  Future<void> _requestNotification() async {
    final PermissionController controller = ref.read(
      permissionControllerProvider.notifier,
    );
    final PermissionState current = await controller.check(
      PermissionKind.notification,
    );
    if (current.isDecided) return;

    // **한 번 물어봤으면 다시 묻지 않는다**(2026-08-26).
    //
    // 알림은 선택 권한이라 "나중에"도 정당한 답이다. 그런데 그 답은 OS에 남지
    // 않아(요청 자체를 안 했으므로) 다음 부팅에서 `isDecided`가 여전히 거짓이고,
    // 사용자는 앱을 켤 때마다 같은 시트를 봤다 — 사용자 지적.
    //
    // 마음이 바뀌면 설정에서 켤 수 있다. 앱을 지웠다 다시 깔면 기록도 사라져
    // 새로 한 번 물어본다.
    final RationaleShownStore shown = ref.read(rationaleShownStoreProvider);
    if (shown.wasShown(PermissionKind.notification)) return;

    final BuildContext? navContext = widget.navigatorKey.currentContext;
    if (navContext == null || !navContext.mounted) return;
    // **띄우기 직전에 적는다.** 버튼을 누르지 않고 배리어 탭이나 뒤로가기로 닫아도
    // "물어본" 것이다 — 누른 경우만 적으면 그 경로로 매번 다시 뜬다.
    //
    // 기다리지 않는다 — 여기서 `await`하면 그 뒤 `navContext` 사용이 async gap을
    // 건너뛰게 된다. 디스크 기록이 늦어져도 이 세션의 판단에는 영향이 없다.
    unawaited(shown.markShown(PermissionKind.notification));
    final bool proceed = await PermissionRationaleSheet.show(
      navContext,
      PermissionKind.notification,
    );
    if (!proceed) return;

    await controller.request(PermissionKind.notification);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
