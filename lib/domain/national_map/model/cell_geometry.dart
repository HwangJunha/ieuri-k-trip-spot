import 'landmark_category.dart';

/// 칸 1개의 **화면에 그릴 도형**(SPEC-0030 §3).
///
/// `CellShapeBuilder`가 서버 칸 정의와 원본 경계로 런타임에 조립한다. 이름·시군구
/// 코드 같은 속성은 여기 없다 — 그건 서버 [MapCell]이 갖고, 이 타입은 [cellId]로
/// 그것과 이어진다.
///
/// 단순화된 도형이라 **판정에 쓰지 않는다.** 좌표 판정은 언제나 원본
/// (`DistrictBoundary`)으로 한다.
class CellGeometry {
  const CellGeometry({
    required this.cellId,
    required this.provinceCode,
    required this.polygons,
    required this.center,
    required this.bounds,
    this.landmarkSlug,
    this.landmarkCategory,
  });

  /// 서버 `MapCell.id`. 방문 여부·이름을 찾는 열쇠다.
  final String cellId;

  /// 상위 시도 코드 2자리.
  final String provinceCode;

  /// 이 칸에 그릴 아이콘의 파일명(SPEC-0031). 결합 테이블에 없는 칸이면 null이고,
  /// 그 칸은 면만 칠하고 아이콘을 생략한다(R19).
  final String? landmarkSlug;

  /// 칸의 면 색을 정하는 카테고리. 결합 테이블에 없으면 null이다.
  final LandmarkCategory? landmarkCategory;

  /// 외곽 링 목록. 섬이 있으면 2개 이상이다. 구멍은 담지 않는다 —
  /// 구멍이 중요한 것은 판정이고 그건 원본이 담당한다.
  final List<List<GeoPoint>> polygons;

  /// 대표 좌표(가장 큰 폴리곤의 무게중심). 지도를 이 칸으로 옮길 때 쓴다.
  final GeoPoint center;

  /// 이 칸 전체를 감싸는 사각형. 탭 히트 테스트의 1차 필터다.
  final GeoBounds bounds;

  @override
  bool operator ==(Object other) =>
      other is CellGeometry && other.cellId == cellId;

  @override
  int get hashCode => cellId.hashCode;
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
