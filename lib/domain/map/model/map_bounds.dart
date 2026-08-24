import 'dart:math' as math;

import 'map_tuning.dart';

/// 지도가 보여주는 사각 영역을 위경도 네 값으로 표현한 것(spec §3 — bbox).
///
/// 서버 계약의 `MapBoundsInput`과 같은 모양이지만 **도메인 모델이다** — 생성 타입은
/// repository 밖으로 나오지 않는다(POL-020). repository가 이 값을 입력 타입으로
/// 옮긴다.
///
/// SDK가 이 값을 직접 주지는 않는다. `CameraPosition`은 중심과 정수 줌만 담으므로,
/// 화면 두 모서리를 `fromScreenPoint`로 변환해 만든다(설계 §2.1). 그 산출은 화면이
/// 맡고, 여기서는 **이미 만들어진 네 값을 가공**하기만 한다 — 그래야 순수 계산으로
/// 남아 그대로 테스트된다.
class MapBounds {
  const MapBounds({
    required this.minLat,
    required this.minLng,
    required this.maxLat,
    required this.maxLng,
  });

  final double minLat;
  final double minLng;
  final double maxLat;
  final double maxLng;

  /// 위도 폭. 확장·포함 판정의 기본 단위다.
  double get latSpan => maxLat - minLat;

  /// 경도 폭.
  double get lngSpan => maxLng - minLng;

  /// 뒤집히지 않았고 위경도 유효 범위 안인지. 서버도 `INVALID_BBOX`로 같은 것을
  /// 검사하지만(R4), 보낼 필요 없는 요청을 미리 거르는 편이 낫다.
  ///
  /// 경계가 정확히 같은 경우(`minLat == maxLat`)도 유효하지 않다 — 면적이 0인
  /// 영역에는 걸치는 것이 없다.
  bool get isValid =>
      minLat < maxLat &&
      minLng < maxLng &&
      minLat >= -90 &&
      maxLat <= 90 &&
      minLng >= -180 &&
      maxLng <= 180;

  /// 화면보다 넓은 조회 영역을 만든다(R20).
  ///
  /// 중심을 유지한 채 각 변을 [factor]배로 늘린다. 1.5배면 상하좌우로 각각 원래
  /// 폭의 25%씩 넓어진다 — 작은 이동으로는 이 영역을 벗어나지 않으므로 재조회가
  /// 걸리지 않는다.
  ///
  /// **극점과 날짜변경선에서 잘라낸다.** 서울 기준으로는 닿을 일이 없지만, 잘라내지
  /// 않으면 위도 90을 넘는 bbox가 만들어져 서버가 `INVALID_BBOX`로 거절한다.
  MapBounds expanded([double factor = MapTuning.viewportExpansion]) {
    final double latPad = latSpan * (factor - 1) / 2;
    final double lngPad = lngSpan * (factor - 1) / 2;
    return MapBounds(
      minLat: (minLat - latPad).clamp(-90.0, 90.0),
      minLng: (minLng - lngPad).clamp(-180.0, 180.0),
      maxLat: (maxLat + latPad).clamp(-90.0, 90.0),
      maxLng: (maxLng + lngPad).clamp(-180.0, 180.0),
    );
  }

  /// 중심을 유지한 채 최소 반경 [radiusKm]를 담도록 넓힌다.
  ///
  /// **화면이 좁아도 주변을 함께 받기 위한 것이다.** 확대해서 볼 때 화면 bbox만
  /// 보내면 눈앞의 몇 곳만 오는데, 사용자는 "내 주변에 뭐가 있나"를 보고 싶어 한다.
  /// 이미 넓은 화면이면 그대로 둔다 — 줄이지 않는다.
  ///
  /// 위도 1도는 약 111km로 고정이고, 경도 1도는 위도에 따라 좁아지므로 중심 위도의
  /// 코사인으로 나눈다. 서울(위도 37.5)에서 경도 1도는 약 88km다.
  MapBounds withMinRadius(double radiusKm) {
    final double centerLat = (minLat + maxLat) / 2;
    final double latDelta = radiusKm / 111.0;
    final double lngDelta =
        radiusKm / (111.0 * math.cos(centerLat * math.pi / 180).abs());

    // 이미 그만큼 넓으면 손대지 않는다.
    if (latSpan >= latDelta * 2 && lngSpan >= lngDelta * 2) return this;

    final double centerLng = (minLng + maxLng) / 2;
    return MapBounds(
      minLat: (centerLat - latDelta).clamp(-90.0, 90.0),
      minLng: (centerLng - lngDelta).clamp(-180.0, 180.0),
      maxLat: (centerLat + latDelta).clamp(-90.0, 90.0),
      maxLng: (centerLng + lngDelta).clamp(-180.0, 180.0),
    );
  }

  /// 고정 격자에 맞춰 **바깥쪽으로** 넓힌다.
  ///
  /// ## 캐시 키를 안정시키기 위한 것이다
  ///
  /// bbox를 그대로 캐시 키로 쓰면 적중률이 사실상 0이다 — 지도를 1픽셀만 밀어도
  /// 소수점 아래가 달라져 매번 새 키가 된다(실기기 2026-08-25: 22초 동안 같은
  /// 강남 일대를 9번 조회했다). 격자에 맞추면 **같은 칸 안에서 움직이는 동안은
  /// 키가 그대로**라 요청이 나가지 않는다.
  ///
  /// **반올림이 아니라 바깥으로 넓힌다**(floor/ceil). 반올림하면 화면 가장자리가
  /// 격자 밖으로 잘려 그 부분의 데이터가 오지 않는다 — 넓히면 화면은 항상 결과
  /// 안에 들어간다.
  ///
  /// 격자 크기가 클수록 요청은 줄지만 한 번에 받는 범위가 넓어진다. 서울 전역이
  /// 위경도 0.3도 남짓이므로, 0.05도(약 5km)면 서울을 6×6칸 정도로 나눈다.
  MapBounds snappedToGrid(double cell) {
    if (cell <= 0) return this;
    return MapBounds(
      minLat: ((minLat / cell).floorToDouble() * cell).clamp(-90.0, 90.0),
      minLng: ((minLng / cell).floorToDouble() * cell).clamp(-180.0, 180.0),
      maxLat: ((maxLat / cell).ceilToDouble() * cell).clamp(-90.0, 90.0),
      maxLng: ((maxLng / cell).ceilToDouble() * cell).clamp(-180.0, 180.0),
    );
  }

  /// [other]가 이 영역 안에 완전히 들어오는지(R20).
  ///
  /// 새 뷰포트가 직전 조회 영역에 포함되면 **재조회하지 않는다** — 이미 받아 둔
  /// 결과로 충분하다. 이 판정이 확장 조회(→[expanded])를 실제 이득으로 바꾼다.
  ///
  /// 경계가 정확히 겹치는 경우도 포함으로 본다. 확장 영역의 가장자리에 딱 맞춘
  /// 뷰포트는 이미 가진 데이터로 그릴 수 있다.
  bool contains(MapBounds other) {
    // **미세한 흔들림은 같은 영역으로 본다.**
    //
    // 지도가 멈춰 있어도 SDK가 주는 화면 좌표는 소수점 6~7번째 자리에서 계속
    // 떨린다(실측: 37.32001698 → 37.32001761). 그걸 그대로 비교하면 "영역을
    // 벗어났다"로 읽혀 조회가 끝없이 반복됐다.
    //
    // 1e-5도는 약 1m다 — 그만큼의 차이로 새로 받을 이유가 없다.
    const double epsilon = 1e-5;
    return other.minLat >= minLat - epsilon &&
        other.maxLat <= maxLat + epsilon &&
        other.minLng >= minLng - epsilon &&
        other.maxLng <= maxLng + epsilon;
  }

  @override
  bool operator ==(Object other) =>
      other is MapBounds &&
      other.minLat == minLat &&
      other.minLng == minLng &&
      other.maxLat == maxLat &&
      other.maxLng == maxLng;

  @override
  int get hashCode => Object.hash(minLat, minLng, maxLat, maxLng);

  @override
  String toString() => 'MapBounds($minLat, $minLng, $maxLat, $maxLng)';
}
