import 'cell_geometry.dart';
import 'district_boundary.dart';

/// 좌표 -> 시군구 코드 판정(SPEC-0030 v1.2 §0).
///
/// **서버의 `resolveDistricts`를 대체한다.** 좌표가 서버로 나가지 않으므로
/// POL-045가 약속이 아니라 구조로 지켜진다.
///
/// 사진 수만 건을 판정하므로 격자 인덱스를 둔다. 인덱스 없이 좌표마다 252개
/// 시군구를 훑으면 사진 한 장당 13만 점을 계산하게 된다.
class DistrictResolver {
  DistrictResolver(this.districts) {
    for (final DistrictBoundary d in districts) {
      final int minX = _cellOf(d.bounds.minLng);
      final int maxX = _cellOf(d.bounds.maxLng);
      final int minY = _cellOf(d.bounds.minLat);
      final int maxY = _cellOf(d.bounds.maxLat);
      for (int x = minX; x <= maxX; x++) {
        for (int y = minY; y <= maxY; y++) {
          (_index[(x, y)] ??= <DistrictBoundary>[]).add(d);
        }
      }
    }
  }

  /// 인덱스 격자 크기(도). 시군구 하나가 대개 몇 칸에 걸치는 정도로 잡는다.
  static const double _gridSize = 0.5;

  final List<DistrictBoundary> districts;

  final Map<(int, int), List<DistrictBoundary>> _index =
      <(int, int), List<DistrictBoundary>>{};

  static int _cellOf(double degrees) => (degrees / _gridSize).floor();

  /// [point]가 속한 시군구. 어디에도 속하지 않으면 null이다.
  ///
  /// 바다·해외 좌표가 null인 것은 **오류가 아니다**(R2·R35).
  DistrictBoundary? districtAt(GeoPoint point) {
    final List<DistrictBoundary>? candidates =
        _index[(_cellOf(point.lng), _cellOf(point.lat))];
    if (candidates == null) return null;
    for (final DistrictBoundary d in candidates) {
      if (d.contains(point)) return d;
    }
    return null;
  }

  /// 좌표 목록을 판정해 **중복 없는** 시군구 코드 집합을 만든다.
  ///
  /// 서버가 하던 것과 같은 축약이다 — 같은 시군구의 좌표가 몇 건이든 코드는
  /// 하나다. 그래서 사진이 몇 장이든 `recordVisits`는 1회다.
  DistrictResolution resolve(Iterable<GeoPoint> points) {
    final Set<String> codes = <String>{};
    int unresolved = 0;
    for (final GeoPoint p in points) {
      final DistrictBoundary? d = districtAt(p);
      if (d == null) {
        unresolved++;
      } else {
        codes.add(d.code);
      }
    }
    return DistrictResolution(
      districtCodes: List<String>.unmodifiable(codes.toList()..sort()),
      unresolvedCount: unresolved,
    );
  }
}

/// 판정 결과. 서버 `ResolveDistrictsResult`가 하던 역할이다.
class DistrictResolution {
  const DistrictResolution({
    required this.districtCodes,
    required this.unresolvedCount,
  });

  /// 판정된 시군구 코드. 중복이 없고 오름차순이다.
  final List<String> districtCodes;

  /// 어느 시군구에도 속하지 않은 좌표 수. 사용자 안내에 쓴다(R32).
  final int unresolvedCount;

  bool get isEmpty => districtCodes.isEmpty;

  @override
  bool operator ==(Object other) =>
      other is DistrictResolution &&
      other.unresolvedCount == unresolvedCount &&
      _same(other.districtCodes, districtCodes);

  @override
  int get hashCode =>
      Object.hash(unresolvedCount, Object.hashAll(districtCodes));

  static bool _same(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
