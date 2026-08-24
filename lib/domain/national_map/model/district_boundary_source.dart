import 'dart:convert';

import 'cell_geometry.dart';
import 'district_boundary.dart';

/// `asset/geo/district-boundaries.geojson`을 [DistrictBoundary] 목록으로 읽는다.
///
/// 순수 Dart다 — 자산을 실제로 읽는 것은 provider가 한다(CLAUDE.md §3).
class DistrictBoundarySource {
  const DistrictBoundarySource._();

  /// GeoJSON FeatureCollection을 파싱한다.
  ///
  /// **좌표는 `[경도, 위도]`다**(GeoJSON 표준). 뒤집으면 전 국토가 엉뚱한 곳으로
  /// 간다.
  ///
  /// 형식이 어긋나면 [FormatException]을 던진다 — 앱에 내장한 자산이라 깨져
  /// 있으면 조용히 넘어가는 것보다 즉시 드러나는 편이 낫다.
  static List<DistrictBoundary> parse(String source) {
    final Object? decoded = json.decode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('경계 자산의 최상위가 객체가 아니다');
    }
    final Object? features = decoded['features'];
    if (features is! List) {
      throw const FormatException('경계 자산에 features 배열이 없다');
    }

    return <DistrictBoundary>[
      for (final Object? raw in features) _boundary(raw),
    ];
  }

  static DistrictBoundary _boundary(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('feature가 객체가 아니다');
    }
    final Object? props = raw['properties'];
    if (props is! Map<String, dynamic>) {
      throw const FormatException('feature에 properties가 없다');
    }
    final Object? geometry = raw['geometry'];
    if (geometry is! Map<String, dynamic>) {
      throw const FormatException('feature에 geometry가 없다');
    }

    final List<DistrictPolygon> polygons = <DistrictPolygon>[
      for (final Object? poly in _polygonList(geometry)) _polygon(poly),
    ];
    if (polygons.isEmpty) {
      throw FormatException('시군구 ${props['code']}에 폴리곤이 없다');
    }

    GeoBounds bounds = polygons.first.bounds;
    for (int i = 1; i < polygons.length; i++) {
      bounds = bounds.merge(polygons[i].bounds);
    }

    return DistrictBoundary(
      code: props['code'] as String,
      provinceCode: props['areaCd'] as String,
      nameKo: props['nameKo'] as String,
      nameEn: props['nameEn'] as String? ?? props['nameKo'] as String,
      polygons: polygons,
      bounds: bounds,
    );
  }

  /// Polygon과 MultiPolygon을 폴리곤 목록으로 통일한다.
  static List<Object?> _polygonList(Map<String, dynamic> geometry) {
    final Object? type = geometry['type'];
    final Object? coords = geometry['coordinates'];
    if (coords is! List) {
      throw const FormatException('geometry에 coordinates가 없다');
    }
    return switch (type) {
      'MultiPolygon' => coords,
      'Polygon' => <Object?>[coords],
      _ => throw FormatException('다루지 않는 geometry 타입: $type'),
    };
  }

  /// `polygon[0]`이 외곽 링, `polygon[1:]`이 구멍이다.
  static DistrictPolygon _polygon(Object? raw) {
    if (raw is! List || raw.isEmpty) {
      throw const FormatException('폴리곤에 링이 없다');
    }
    final List<GeoPoint> outer = _ring(raw.first);
    return DistrictPolygon(
      outer: outer,
      holes: <List<GeoPoint>>[
        for (int i = 1; i < raw.length; i++) _ring(raw[i]),
      ],
      bounds: GeoBounds.of(outer),
    );
  }

  static List<GeoPoint> _ring(Object? raw) {
    if (raw is! List) throw const FormatException('링이 배열이 아니다');
    return <GeoPoint>[
      for (final Object? pt in raw) _point(pt),
    ];
  }

  static GeoPoint _point(Object? raw) {
    if (raw is! List || raw.length < 2) {
      throw const FormatException('좌표가 [경도, 위도] 형태가 아니다');
    }
    return GeoPoint((raw[0] as num).toDouble(), (raw[1] as num).toDouble());
  }
}
