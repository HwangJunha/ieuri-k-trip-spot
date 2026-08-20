import 'cell_geometry.dart';
import 'national_map_config.dart';

/// 사진에서 뽑은 좌표를 서버로 보내기 전에 줄이는 세 단계(설계 §4, R25~R27).
///
/// 사진 20만 장에서 나온 좌표를 그대로 보내면 안 된다. 순서대로 적용한다.
///
/// 1. 한국 영역 밖 좌표를 버린다(R25)
/// 2. 격자로 반올림해 중복을 없앤다(R26)
/// 3. 이미 방문 확정된 칸 안의 좌표를 버린다(R27)
///
/// 전부 순수 함수다.
class CoordinateReduction {
  const CoordinateReduction._();

  /// 한국 영역 안의 좌표만 남긴다(R25).
  static List<GeoPoint> withinKorea(
    Iterable<GeoPoint> points, {
    GeoBounds bounds = NationalMapConfig.koreaBounds,
  }) =>
      points.where(bounds.contains).toList(growable: false);

  /// 격자로 반올림해 중복을 없앤다(R26).
  ///
  /// 같은 격자에 든 좌표는 **처음 것 하나만** 남는다 — 격자 중심으로 옮기지 않는다.
  /// 판정은 서버가 실제 좌표로 하는 편이 경계에서 안전하다.
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
  /// **bounding box로만 거른다.** 폴리곤까지 정확히 보지 않는 이유는, 여기서
  /// 잘못 버려도 "이미 방문한 칸을 다시 확인하지 않을 뿐"이라 손해가 없고,
  /// 잘못 남겨도 서버가 정상 판정하기 때문이다. 설계 §4가 정한 대로다.
  static List<GeoPoint> excludingVisited(
    Iterable<GeoPoint> points,
    Iterable<CellGeometry> visitedCells,
  ) {
    final List<GeoBounds> boxes = visitedCells
        .map((CellGeometry c) => c.bounds)
        .toList(growable: false);
    if (boxes.isEmpty) return points.toList(growable: false);
    return points
        .where((GeoPoint p) => !boxes.any((GeoBounds b) => b.contains(p)))
        .toList(growable: false);
  }

  /// 세 단계를 순서대로 적용한다.
  static List<GeoPoint> reduce(
    Iterable<GeoPoint> points, {
    required Iterable<CellGeometry> visitedCells,
    double grid = NationalMapConfig.dedupeGridDegrees,
    GeoBounds bounds = NationalMapConfig.koreaBounds,
  }) => excludingVisited(
    dedupeByGrid(withinKorea(points, bounds: bounds), grid: grid),
    visitedCells,
  );

  /// 요청당 상한에 맞춰 나눈다(R26의 마지막 단계, 계약 §7.4).
  static List<List<GeoPoint>> chunk(
    List<GeoPoint> points, {
    int size = NationalMapConfig.resolveBatchSize,
  }) {
    assert(size > 0, '배치 크기는 양수여야 한다');
    if (points.isEmpty) return const <List<GeoPoint>>[];
    return <List<GeoPoint>>[
      for (int i = 0; i < points.length; i += size)
        points.sublist(i, i + size > points.length ? points.length : i + size),
    ];
  }
}
