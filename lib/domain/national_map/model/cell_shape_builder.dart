import 'dart:math' as math;

import 'cell_geometry.dart';
import 'district_boundary.dart';
import 'landmark_icon_binding.dart';
import 'map_cell.dart';

/// 서버가 정한 칸([MapCell])과 원본 시군구 경계로 **칸 도형을 조립한다.**
///
/// 도형의 출처는 `district-boundaries.geojson` 하나뿐이고, 무엇을 한 칸으로 묶을지는
/// **서버의 `districtCodes`가 정한다.** 클라이언트가 묶음 규칙을 따로 갖지 않는
/// 이유가 이것이다 — 규칙은 서버 소유라 여기서 추측하면 서버가 규칙을 바꿀 때
/// 조용히 어긋난다.
///
/// 측정된 비용(실기기 아닌 테스트 환경): 전국 조립 ~250ms. 앱 세션당 한 번만 한다.
class CellShapeBuilder {
  const CellShapeBuilder._();

  /// 화면에 그릴 때 정점을 줄이는 기준(도). 약 400m.
  ///
  /// 판정에는 쓰지 않는다 — 판정은 언제나 원본으로 한다.
  static const double defaultTolerance = 0.004;

  /// 아주 작은 섬은 그리지 않는다. 화면에서 한 점보다 작고 개수만 늘린다.
  static const double defaultMinArea = 0.0006;

  /// [cells]마다 도형을 만든다.
  ///
  /// 서버 칸의 `districtCodes`로 [boundaries]를 골라 합치고(dissolve) 단순화한다.
  /// 대응하는 시군구가 하나도 없는 칸은 결과에서 빠진다.
  static List<CellGeometry> build({
    required Iterable<MapCell> cells,
    required Iterable<DistrictBoundary> boundaries,
    double tolerance = defaultTolerance,
    double minArea = defaultMinArea,
  }) {
    final Map<String, DistrictBoundary> byCode = <String, DistrictBoundary>{
      for (final DistrictBoundary b in boundaries) b.code: b,
    };

    final List<CellGeometry> out = <CellGeometry>[];
    for (final MapCell cell in cells) {
      final List<List<GeoPoint>> rings = <List<GeoPoint>>[];
      for (final String code in cell.districtCodes) {
        final DistrictBoundary? b = byCode[code];
        if (b == null) continue;
        for (final DistrictPolygon p in b.polygons) {
          rings.add(p.outer);
        }
      }
      if (rings.isEmpty) continue;

      // 칸 안의 시군구 경계를 지운다 — 칸이 채워졌을 때 내부에 선이 보이면 안 된다.
      List<List<GeoPoint>> merged = rings.length > 1
          ? dissolve(rings)
          : rings;
      if (merged.isEmpty) merged = rings;

      final List<List<GeoPoint>> polygons = <List<GeoPoint>>[];
      for (final List<GeoPoint> ring in merged) {
        if (ringArea(ring) < minArea) continue;
        final List<GeoPoint> s = simplify(ring, tolerance);
        if (s.length >= 4) polygons.add(s);
      }
      if (polygons.isEmpty) {
        // 전부 걸러졌으면 가장 큰 링을 하나 남긴다(울릉군 등 작은 섬).
        final List<GeoPoint> biggest = merged.reduce(
          (List<GeoPoint> a, List<GeoPoint> b) =>
              ringArea(a) >= ringArea(b) ? a : b,
        );
        polygons.add(simplify(biggest, tolerance / 4));
      }
      polygons.sort(
        (List<GeoPoint> a, List<GeoPoint> b) =>
            ringArea(b).compareTo(ringArea(a)),
      );

      // 그릴 아이콘은 **결합 테이블이 정한다**(SPEC-0031 §0). 서버 칸 id가 곧
      // 결합 키다. caption 정규식 분류를 쓰지 않는다 — 같은 이름이 여러 유형에
      // 걸리고, 무엇보다 칸에 보이는 사진과 아이콘이 같은 장소여야 한다.
      final LandmarkIconBinding? binding = landmarkIconBindingOf(
        int.tryParse(cell.id) ?? -1,
      );

      out.add(
        CellGeometry(
          cellId: cell.id,
          provinceCode: cell.provinceCode,
          landmarkSlug: binding?.slug,
          landmarkCategory: binding?.category,
          polygons: polygons,
          center: centroid(polygons.first),
          bounds: GeoBounds.of(polygons.expand((List<GeoPoint> p) => p)),
        ),
      );
    }
    return out;
  }

  /// 여러 링을 공유 변 상쇄로 합친다.
  ///
  /// 인접 시군구가 경계에서 **정확히 같은 정점**을 쓴다는 성질에 기댄다. 방향을
  /// 무시한 변이 짝수 번 나오면 내부 경계이고 홀수 번이면 외곽이다.
  ///
  /// **정점이 아니라 변을 소비하며 걷는다.** 정점을 방문 표시하면 두 경로가 한
  /// 점에서 만나는 곳에서 걷기가 일찍 끊겨 도형이 조각난다.
  static List<List<GeoPoint>> dissolve(List<List<GeoPoint>> rings) {
    final Map<_Edge, int> count = <_Edge, int>{};
    for (final List<GeoPoint> raw in rings) {
      final List<GeoPoint> r = _open(raw);
      if (r.length < 3) continue;
      for (int i = 0; i < r.length; i++) {
        final GeoPoint a = r[i];
        final GeoPoint b = r[(i + 1) % r.length];
        if (a == b) continue;
        final _Edge e = _Edge(a, b);
        count[e] = (count[e] ?? 0) + 1;
      }
    }

    final Map<GeoPoint, List<GeoPoint>> adj = <GeoPoint, List<GeoPoint>>{};
    for (final MapEntry<_Edge, int> e in count.entries) {
      if (e.value.isEven) continue;
      (adj[e.key.a] ??= <GeoPoint>[]).add(e.key.b);
      (adj[e.key.b] ??= <GeoPoint>[]).add(e.key.a);
    }
    if (adj.isEmpty) return const <List<GeoPoint>>[];

    final Set<_Edge> used = <_Edge>{};
    final List<List<GeoPoint>> out = <List<GeoPoint>>[];

    for (final GeoPoint start in adj.keys.toList(growable: false)) {
      while (true) {
        GeoPoint? first;
        for (final GeoPoint p in adj[start]!) {
          if (!used.contains(_Edge(start, p))) {
            first = p;
            break;
          }
        }
        if (first == null) break;

        final List<GeoPoint> ring = <GeoPoint>[start];
        used.add(_Edge(start, first));
        GeoPoint cur = first;
        GeoPoint prev = start;

        while (cur != start) {
          ring.add(cur);
          GeoPoint? next;
          // 되돌아가는 변은 막다른 길에서만 쓴다.
          for (final GeoPoint p in adj[cur] ?? const <GeoPoint>[]) {
            if (p != prev && !used.contains(_Edge(cur, p))) {
              next = p;
              break;
            }
          }
          next ??= _anyUnused(adj[cur], cur, used);
          if (next == null) break; // 열린 경로 — 데이터가 깨진 경우
          used.add(_Edge(cur, next));
          prev = cur;
          cur = next;
        }

        if (ring.length >= 4) out.add(ring);
      }
    }
    return out;
  }

  static GeoPoint? _anyUnused(
    List<GeoPoint>? neighbours,
    GeoPoint cur,
    Set<_Edge> used,
  ) {
    for (final GeoPoint p in neighbours ?? const <GeoPoint>[]) {
      if (!used.contains(_Edge(cur, p))) return p;
    }
    return null;
  }

  static List<GeoPoint> _open(List<GeoPoint> ring) =>
      ring.length > 1 && ring.first == ring.last
      ? ring.sublist(0, ring.length - 1)
      : ring;

  /// Douglas-Peucker. 재귀 대신 스택으로 돈다 — 링 하나가 수천 점이다.
  static List<GeoPoint> simplify(List<GeoPoint> points, double eps) {
    final int n = points.length;
    if (n < 3) return points;

    final List<bool> keep = List<bool>.filled(n, false);
    keep[0] = true;
    keep[n - 1] = true;
    final List<List<int>> stack = <List<int>>[
      <int>[0, n - 1],
    ];

    while (stack.isNotEmpty) {
      final List<int> seg = stack.removeLast();
      final int lo = seg[0];
      final int hi = seg[1];
      if (hi <= lo + 1) continue;

      double dmax = 0;
      int idx = lo;
      for (int i = lo + 1; i < hi; i++) {
        final double d = _perpendicular(points[i], points[lo], points[hi]);
        if (d > dmax) {
          dmax = d;
          idx = i;
        }
      }
      if (dmax > eps) {
        keep[idx] = true;
        stack.add(<int>[lo, idx]);
        stack.add(<int>[idx, hi]);
      }
    }

    return <GeoPoint>[
      for (int i = 0; i < n; i++)
        if (keep[i]) points[i],
    ];
  }

  static double _perpendicular(GeoPoint p, GeoPoint a, GeoPoint b) {
    final double dx = b.lng - a.lng;
    final double dy = b.lat - a.lat;
    if (dx == 0 && dy == 0) {
      return math.sqrt(
        math.pow(p.lng - a.lng, 2) + math.pow(p.lat - a.lat, 2),
      );
    }
    double t =
        ((p.lng - a.lng) * dx + (p.lat - a.lat) * dy) / (dx * dx + dy * dy);
    t = t.clamp(0.0, 1.0);
    final double cx = a.lng + t * dx;
    final double cy = a.lat + t * dy;
    return math.sqrt(math.pow(p.lng - cx, 2) + math.pow(p.lat - cy, 2));
  }

  /// 링의 면적(제곱도). 크기 비교에만 쓴다.
  static double ringArea(List<GeoPoint> ring) {
    double s = 0;
    final int n = ring.length;
    for (int i = 0; i < n; i++) {
      final GeoPoint p1 = ring[i];
      final GeoPoint p2 = ring[(i + 1) % n];
      s += p1.lng * p2.lat - p2.lng * p1.lat;
    }
    return s.abs() / 2;
  }

  /// 링의 무게중심. 칸으로 지도를 옮길 때 쓴다.
  static GeoPoint centroid(List<GeoPoint> ring) {
    double a = 0;
    double cx = 0;
    double cy = 0;
    final int n = ring.length;
    for (int i = 0; i < n; i++) {
      final GeoPoint p1 = ring[i];
      final GeoPoint p2 = ring[(i + 1) % n];
      final double cross = p1.lng * p2.lat - p2.lng * p1.lat;
      a += cross;
      cx += (p1.lng + p2.lng) * cross;
      cy += (p1.lat + p2.lat) * cross;
    }
    if (a == 0) return ring.first;
    a *= 0.5;
    return GeoPoint(cx / (6 * a), cy / (6 * a));
  }
}

/// 방향을 무시한 변. dissolve의 상쇄 키다.
class _Edge {
  _Edge(GeoPoint p, GeoPoint q)
    : a = _before(p, q) ? p : q,
      b = _before(p, q) ? q : p;

  final GeoPoint a;
  final GeoPoint b;

  static bool _before(GeoPoint p, GeoPoint q) =>
      p.lng < q.lng || (p.lng == q.lng && p.lat <= q.lat);

  @override
  bool operator ==(Object other) =>
      other is _Edge && other.a == a && other.b == b;

  @override
  int get hashCode => Object.hash(a, b);
}
