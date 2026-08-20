/// 칸 1개의 도형(SPEC-0030 §3). 앱에 내장한 `asset/geo/korea_cells.json`에서 읽는다.
///
/// **서버가 주는 것이 아니다.** 서버는 칸 목록과 방문 여부를 주고, 도형은 클라이언트
/// 자산이다. 둘은 [code]로 맞춘다.
class CellGeometry {
  const CellGeometry({
    required this.code,
    required this.nameKo,
    required this.nameEn,
    required this.provinceCode,
    required this.provinceNameKo,
    required this.provinceNameEn,
    required this.districtCodes,
    required this.center,
    required this.polygons,
    required this.bounds,
  });

  /// 칸 코드. 서버 `MapCell.code`와 대응시키는 키다.
  final String code;

  /// 자산에 담긴 한국어·영어 명칭.
  ///
  /// **화면 표시에는 쓰지 않는다** — 표시 명칭은 활성 언어로 서버가 준다(R8).
  /// 서버 응답과 칸을 맞추거나 디버깅할 때만 본다.
  final String nameKo;
  final String nameEn;

  final String provinceCode;
  final String provinceNameKo;
  final String provinceNameEn;

  /// 이 칸이 포함하는 시군구 행정표준코드 5자리 목록.
  final List<String> districtCodes;

  /// 칸의 대표 좌표(폴리곤 무게중심). `[경도, 위도]`가 아니라 [GeoPoint]다.
  final GeoPoint center;

  /// 외곽 링 목록. 섬이 있으면 2개 이상이다. 구멍은 담지 않는다.
  final List<List<GeoPoint>> polygons;

  /// 이 칸 전체를 감싸는 경위도 사각형. 히트 테스트의 1차 필터다.
  final GeoBounds bounds;

  @override
  bool operator ==(Object other) => other is CellGeometry && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

/// 경위도 한 점. `dart:ui`의 `Offset`과 섞이지 않게 별도 타입으로 둔다.
class GeoPoint {
  const GeoPoint(this.lng, this.lat);

  final double lng;
  final double lat;

  @override
  bool operator ==(Object other) =>
      other is GeoPoint && other.lng == lng && other.lat == lat;

  @override
  int get hashCode => Object.hash(lng, lat);

  @override
  String toString() => 'GeoPoint($lng, $lat)';
}

/// 경위도 사각형.
class GeoBounds {
  const GeoBounds({
    required this.minLng,
    required this.minLat,
    required this.maxLng,
    required this.maxLat,
  });

  /// 점 목록을 감싸는 최소 사각형. [points]는 비어 있지 않아야 한다.
  factory GeoBounds.of(Iterable<GeoPoint> points) {
    double minLng = double.infinity;
    double minLat = double.infinity;
    double maxLng = double.negativeInfinity;
    double maxLat = double.negativeInfinity;
    for (final GeoPoint p in points) {
      if (p.lng < minLng) minLng = p.lng;
      if (p.lat < minLat) minLat = p.lat;
      if (p.lng > maxLng) maxLng = p.lng;
      if (p.lat > maxLat) maxLat = p.lat;
    }
    return GeoBounds(
      minLng: minLng,
      minLat: minLat,
      maxLng: maxLng,
      maxLat: maxLat,
    );
  }

  final double minLng;
  final double minLat;
  final double maxLng;
  final double maxLat;

  bool contains(GeoPoint p) =>
      p.lng >= minLng && p.lng <= maxLng && p.lat >= minLat && p.lat <= maxLat;

  /// 두 사각형을 모두 감싸는 사각형.
  GeoBounds merge(GeoBounds other) => GeoBounds(
    minLng: minLng < other.minLng ? minLng : other.minLng,
    minLat: minLat < other.minLat ? minLat : other.minLat,
    maxLng: maxLng > other.maxLng ? maxLng : other.maxLng,
    maxLat: maxLat > other.maxLat ? maxLat : other.maxLat,
  );

  @override
  bool operator ==(Object other) =>
      other is GeoBounds &&
      other.minLng == minLng &&
      other.minLat == minLat &&
      other.maxLng == maxLng &&
      other.maxLat == maxLat;

  @override
  int get hashCode => Object.hash(minLng, minLat, maxLng, maxLat);
}
