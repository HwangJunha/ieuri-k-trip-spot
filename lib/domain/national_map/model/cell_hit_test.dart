import 'cell_geometry.dart';

/// 경위도 한 점이 어느 칸에 속하는지 찾는다(설계 §3의 point-in-polygon).
///
/// 순수 함수라 위젯 없이 검증할 수 있다.
class CellHitTest {
  const CellHitTest._();

  /// [point]를 품는 첫 칸. 없으면 null.
  ///
  /// bounds로 먼저 거른 뒤 폴리곤을 본다 — 161칸 전부에 대해 폴리곤을 훑으면
  /// 탭 한 번에 7천 점을 계산하게 된다.
  static CellGeometry? cellAt(
    Iterable<CellGeometry> cells,
    GeoPoint point,
  ) {
    for (final CellGeometry cell in cells) {
      if (!cell.bounds.contains(point)) continue;
      for (final List<GeoPoint> ring in cell.polygons) {
        if (containsPoint(ring, point)) return cell;
      }
    }
    return null;
  }

  /// 링이 점을 품는지(ray casting).
  ///
  /// 링은 닫혀 있다고 본다 — 마지막 점과 첫 점을 잇는 변도 검사한다.
  static bool containsPoint(List<GeoPoint> ring, GeoPoint p) {
    if (ring.length < 3) return false;
    bool inside = false;
    for (int i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final GeoPoint a = ring[i];
      final GeoPoint b = ring[j];
      // 변이 점의 위도를 가로지르는가. 한쪽만 크거나 같아야 꼭짓점을 두 번 세지 않는다.
      final bool straddles = (a.lat > p.lat) != (b.lat > p.lat);
      if (!straddles) continue;
      final double x =
          (b.lng - a.lng) * (p.lat - a.lat) / (b.lat - a.lat) + a.lng;
      if (p.lng < x) inside = !inside;
    }
    return inside;
  }
}
