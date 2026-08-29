import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../coordinates.dart';
import '../location_providers.dart';
import '../location_refresh_policy.dart';

/// 앱이 앞으로 돌아올 때 조회 좌표를 다시 받을지 판단한다.
///
/// **조회 좌표는 세션 동안 고정된다**(`currentCoordinatesProvider`). 걸을 때마다
/// 갱신하면 목록이 제멋대로 바뀌기 때문인데, 그 고정이 지하철로 몇 정거장을 이동한
/// 경우까지 붙잡아 예전 동네의 관광지를 계속 보여줬다(사용자 지적 2026-08-27).
///
/// 여기서 앞으로 돌아온 시점에만 GPS를 한 번 읽고, [LocationRefreshPolicy]가 정한
/// 거리를 넘었을 때만 provider를 무효화한다. **넘지 않으면 아무 일도 일어나지 않아**
/// 알림을 확인하고 돌아온 정도로는 화면이 흔들리지 않는다.
///
/// 실패는 삼킨다 — 위치를 못 받았다고 앱을 막을 이유가 없고, 기존 좌표가 그대로
/// 남아 화면은 계속 동작한다.
class LocationRefreshGate extends ConsumerStatefulWidget {
  const LocationRefreshGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<LocationRefreshGate> createState() =>
      _LocationRefreshGateState();
}

class _LocationRefreshGateState extends ConsumerState<LocationRefreshGate>
    with WidgetsBindingObserver {
  /// 갱신 판정이 겹치지 않게 한다. GPS 조회가 수 초 걸릴 수 있는데 그 사이 다시
  /// 앞으로 오면 두 번 돌게 된다.
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshIfMoved();
  }

  Future<void> _refreshIfMoved() async {
    if (_checking) return;
    _checking = true;
    try {
      final AsyncValue<Coordinates> snapshot = ref.read(
        currentCoordinatesProvider,
      );

      // **실패한 채로 돌아왔으면 무조건 다시 받는다**(2026-08-29).
      //
      // 위치를 끈 사용자가 설정에서 켜고 돌아오는 경우다. 이때 provider는 오류
      // 상태로 캐시돼 있어 화면을 다시 그려도 같은 오류가 나온다 — 무효화하지
      // 않으면 앱을 재시작할 때까지 풀리지 않는다(실기기 확인).
      //
      // 아래 이동 거리 판정은 **이미 좌표가 있는** 경우의 절약이지 없는 경우까지
      // 덮는 규칙이 아니었다. 예전에는 값이 없으면 그대로 돌아가 버려서, 설정에서
      // 켜고 와도 화면이 오류인 채 남았다.
      if (snapshot.hasError) {
        ref.invalidate(currentCoordinatesProvider);
        return;
      }

      // **아직 좌표를 받은 적이 없으면 아무것도 하지 않는다.** 첫 조회는 화면이
      // 알아서 하며, 여기서 끼어들면 부팅 중에 조회가 두 번 나간다.
      final Coordinates? previous = snapshot.value;
      if (previous == null) return;

      final Coordinates current = await ref
          .read(locationServiceProvider)
          .currentCoordinates();
      if (!mounted) return;

      if (LocationRefreshPolicy.shouldRefresh(previous, current)) {
        ref.invalidate(currentCoordinatesProvider);
      }
    } on Object {
      // 권한 거부·GPS 꺼짐·타임아웃. 기존 좌표를 그대로 쓴다.
    } finally {
      _checking = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
