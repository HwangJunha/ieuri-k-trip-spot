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

  /// [other]가 이 영역 안에 완전히 들어오는지(R20).
  ///
  /// 새 뷰포트가 직전 조회 영역에 포함되면 **재조회하지 않는다** — 이미 받아 둔
  /// 결과로 충분하다. 이 판정이 확장 조회(→[expanded])를 실제 이득으로 바꾼다.
  ///
  /// 경계가 정확히 겹치는 경우도 포함으로 본다. 확장 영역의 가장자리에 딱 맞춘
  /// 뷰포트는 이미 가진 데이터로 그릴 수 있다.
  bool contains(MapBounds other) =>
      other.minLat >= minLat &&
      other.maxLat <= maxLat &&
      other.minLng >= minLng &&
      other.maxLng <= maxLng;

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
