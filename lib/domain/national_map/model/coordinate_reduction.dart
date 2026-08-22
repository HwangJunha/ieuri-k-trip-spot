import 'cell_geometry.dart';
import 'national_map_config.dart';

/// 사진에서 뽑은 좌표를 줄이는 단계(설계 §4, R25~R27).
///
/// v1.2에서 **목적이 바뀌었다.** `resolveDistricts`가 사라져 좌표를 서버로 보내지
/// 않으므로, 이건 전송량이 아니라 **로컬 판정 횟수**를 줄이는 최적화다. 사진
/// 20만 장을 그대로 point-in-polygon에 넣으면 느리다.
///
/// 전부 순수 함수다.
class CoordinateReduction {
  const CoordinateReduction._();

  /// 한국 영역 안의 좌표만 남긴다(R25).
  ///
  /// 판정기가 어차피 걸러 내지만, 해외 사진이 많은 사용자에게는 이 1차 필터가
  /// 훨씬 싸다(사각형 비교 vs 폴리곤 순회).
  static List<GeoPoint> withinKorea(
    Iterable<GeoPoint> points, {
    GeoBounds bounds = NationalMapConfig.koreaBounds,
  }) => points.where(bounds.contains).toList(growable: false);

  /// 격자로 반올림해 중복을 없앤다(R26).
  ///
  /// 같은 격자에 든 좌표는 **처음 것 하나만** 남는다 — 격자 중심으로 옮기지 않는다.
  /// 판정을 실제 좌표로 하는 편이 경계에서 안전하다.
  ///
  /// 입력 순서는 유지한다.
  static List<GeoPoint> dedupeByGrid(
    Iterable<GeoPoint> points, {
    double grid = NationalMapConfig.dedupeGridDegrees,
  }) {
    assert(grid > 0, '격자 크기는 양수여야 한다');
    final Set<({int lng, int lat})> seen = <({int lng, int lat})>{};
    final List<GeoPoint> out = <GeoPoint>[];
    for (final GeoPoint p in points) {
      final ({int lng, int lat}) key = (
        lng: (p.lng / grid).floor(),
        lat: (p.lat / grid).floor(),
      );
      if (seen.add(key)) out.add(p);
    }
    return List<GeoPoint>.unmodifiable(out);
  }

  /// 이미 방문한 칸에 드는 좌표를 버린다(R27).
  ///
  /// **bounding box로만 거른다.** 잘못 버려도 "이미 방문한 칸을 다시 판정하지
  /// 않을 뿐"이라 손해가 없고, 잘못 남겨도 판정이 정상 동작한다.
  static List<GeoPoint> excludingVisited(
    Iterable<GeoPoint> points,
    Iterable<GeoBounds> visitedBounds,
  ) {
    final List<GeoBounds> boxes = visitedBounds.toList(growable: false);
    if (boxes.isEmpty) return points.toList(growable: false);
    return points
        .where((GeoPoint p) => !boxes.any((GeoBounds b) => b.contains(p)))
        .toList(growable: false);
  }

  /// 세 단계를 순서대로 적용한다.
  static List<GeoPoint> reduce(
    Iterable<GeoPoint> points, {
    Iterable<GeoBounds> visitedBounds = const <GeoBounds>[],
    double grid = NationalMapConfig.dedupeGridDegrees,
    GeoBounds bounds = NationalMapConfig.koreaBounds,
  }) => excludingVisited(
    dedupeByGrid(withinKorea(points, bounds: bounds), grid: grid),
    visitedBounds,
  );
}
