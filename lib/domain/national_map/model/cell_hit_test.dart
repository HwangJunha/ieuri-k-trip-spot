import 'cell_geometry.dart';

/// 경위도 한 점이 어느 칸에 속하는지 찾는다(R22의 탭 히트 테스트).
///
/// **단순화된 도형으로 한다.** 화면에 그린 것과 같은 도형을 써야 누른 곳과 잡히는
/// 칸이 일치한다 — 여기서 원본을 쓰면 화면상 칸 밖을 눌렀는데 잡히거나 그 반대가
/// 된다. 정확도가 필요한 좌표 판정은 `DistrictResolver`가 원본으로 한다.
class CellHitTest {
  const CellHitTest._();

  /// [point]를 품는 첫 칸. 없으면 null.
  ///
  /// bounds로 먼저 거른 뒤 폴리곤을 본다 — 161칸 전부에 대해 폴리곤을 훑으면
  /// 탭 한 번에 수만 점을 계산하게 된다.
  static CellGeometry? cellAt(Iterable<CellGeometry> cells, GeoPoint point) {
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
      // 한쪽만 크거나 같아야 꼭짓점을 두 번 세지 않는다.
      if ((a.lat > p.lat) == (b.lat > p.lat)) continue;
      final double x =
          (b.lng - a.lng) * (p.lat - a.lat) / (b.lat - a.lat) + a.lng;
      if (p.lng < x) inside = !inside;
    }
    return inside;
  }
}
