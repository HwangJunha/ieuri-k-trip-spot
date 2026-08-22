import 'cell_geometry.dart';

/// 시군구 1곳의 경계(SPEC-0030 v1.2 §0).
///
/// **서버가 준 원본이다.** 단순화하지 않았으므로 판정 결과가 서버 PostGIS와 같다.
/// 지도를 그리는 도형([CellGeometry])과 별개이며, 이쪽은 화면에 그리지 않는다.
class DistrictBoundary {
  const DistrictBoundary({
    required this.code,
    required this.provinceCode,
    required this.nameKo,
    required this.nameEn,
    required this.polygons,
    required this.bounds,
  });

  /// 시군구 행정표준코드 5자리. `recordVisits`에 보내는 값이다.
  final String code;

  /// 시도 코드 2자리(`areaCd`).
  final String provinceCode;

  /// 자산에 담긴 이름. **화면 표시에는 쓰지 않는다** — 표시 명칭은 서버가 준다(R8).
  /// 판정 결과를 사람이 확인할 때(동기화 확인 화면의 디버깅) 쓴다.
  final String nameKo;
  final String nameEn;

  /// 이 시군구를 이루는 폴리곤들.
  final List<DistrictPolygon> polygons;

  /// 전체를 감싸는 사각형. 판정의 1차 필터다.
  final GeoBounds bounds;

  /// 이 시군구가 [point]를 품는지.
  ///
  /// **구멍을 판다.** 외곽 안이어도 구멍 안이면 미포함이다 — 전국에 9개뿐이지만
  /// 빼먹으면 그 좌표가 엉뚱한 시군구로 간다.
  bool contains(GeoPoint point) {
    if (!bounds.contains(point)) return false;
    for (final DistrictPolygon polygon in polygons) {
      if (polygon.contains(point)) return true;
    }
    return false;
  }

  @override
  bool operator ==(Object other) =>
      other is DistrictBoundary && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

/// 외곽 링 하나와 그 안의 구멍들.
class DistrictPolygon {
  const DistrictPolygon({
    required this.outer,
    required this.holes,
    required this.bounds,
  });

  final List<GeoPoint> outer;

  /// 구멍. 대개 비어 있다.
  final List<List<GeoPoint>> holes;

  final GeoBounds bounds;

  bool contains(GeoPoint point) {
    if (!bounds.contains(point)) return false;
    if (!_ringContains(outer, point)) return false;
    for (final List<GeoPoint> hole in holes) {
      if (_ringContains(hole, point)) return false;
    }
    return true;
  }

  /// 링이 점을 품는지(ray casting). 링은 닫혀 있다고 본다.
  static bool _ringContains(List<GeoPoint> ring, GeoPoint p) {
    if (ring.length < 3) return false;
    bool inside = false;
    for (int i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final GeoPoint a = ring[i];
      final GeoPoint b = ring[j];
      // 한쪽만 크거나 같아야 꼭짓점을 두 번 세지 않는다.
      if ((a.lat > p.lat) == (b.lat > p.lat)) continue;
      final double x =
          (b.lng - a.lng) * (p.lat - a.lat) / (b.lat - a.lat) + a.lng;
      if (p.lng < x) inside = !inside;
    }
    return inside;
  }
}
