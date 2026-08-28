import 'dart:math' show asin, cos, pi, sin, sqrt;

import 'coordinates.dart';

/// 조회 좌표를 다시 받을지 정하는 순수 계산.
///
/// **조회 좌표는 세션 동안 고정하는 것이 원칙이다**(`location_providers.dart`) —
/// 걸을 때마다 갱신되면 목록이 제멋대로 바뀐다. 그래서 앱을 켜 둔 채로는 첫 좌표를
/// 계속 쓴다.
///
/// 그런데 그 원칙이 **지하철로 몇 정거장을 이동한 경우까지** 붙잡았다. 앱을 완전히
/// 종료하지 않는 한 예전 동네의 관광지가 계속 보였다(사용자 지적 2026-08-27).
///
/// 두 상황을 가르는 것은 거리다. 걷는 정도는 무시하고 의미 있게 이동했을 때만 갱신
/// 한다. 판정 시점은 **앱이 앞으로 돌아올 때** 한 번뿐이다 — 주기적으로 GPS를 켜면
/// 가만히 있어도 배터리를 먹고, 이동 중에는 어차피 앱이 뒤에 있어 볼 사람이 없다.
abstract final class LocationRefreshPolicy {
  /// 이만큼 벗어났으면 다시 받는다(m).
  ///
  /// 지하철 한 정거장이 대개 800m~1km다. 500m면 한 정거장은 확실히 잡으면서 같은
  /// 동네 안에서 움직인 것은 흘려보낸다.
  static const double thresholdMeters = 500;

  /// [from]에서 [to]까지 이동했을 때 조회 좌표를 갱신해야 하는가.
  ///
  /// 둘 중 하나라도 없으면 **갱신하지 않는다** — 비교할 것이 없으면 기존 값을 그대로
  /// 두는 쪽이 안전하다. 좌표를 못 받은 상황에서 화면을 흔들 이유가 없다.
  static bool shouldRefresh(Coordinates? from, Coordinates? to) {
    if (from == null || to == null) return false;
    return distanceMeters(from, to) >= thresholdMeters;
  }

  /// 두 좌표 사이 대권 거리(m). 하버사인.
  ///
  /// **`Geolocator.distanceBetween`을 쓰지 않는다** — 이 계층은 도메인 값만 다루고
  /// 플러그인에 기대지 않는다(CLAUDE.md §3). 같은 이유로 이 함수가 그대로 단위
  /// 테스트가 된다.
  static double distanceMeters(Coordinates a, Coordinates b) {
    const double earthRadius = 6371000;
    final double dLat = _radians(b.latitude - a.latitude);
    final double dLon = _radians(b.longitude - a.longitude);
    final double lat1 = _radians(a.latitude);
    final double lat2 = _radians(b.latitude);

    final double h =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    return 2 * earthRadius * asin(sqrt(h).clamp(0.0, 1.0));
  }

  static double _radians(double degrees) => degrees * pi / 180;
}
