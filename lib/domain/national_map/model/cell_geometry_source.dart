import 'dart:convert';

import 'cell_geometry.dart';

/// `asset/geo/korea_cells.json`을 [CellGeometry] 목록으로 읽는다.
///
/// 자산 로딩(`rootBundle`)은 여기서 하지 않는다 — 이 파일은 순수 Dart로 남기고
/// 문자열을 받는다(CLAUDE.md §3의 model 규칙). 자산을 실제로 읽는 쪽은 provider다.
class CellGeometrySource {
  const CellGeometrySource._();

  /// 자산의 현재 형식 버전. 형식을 바꾸면 올린다.
  static const int supportedVersion = 1;

  /// 자산 JSON 문자열을 파싱한다.
  ///
  /// 형식이 어긋나면 [FormatException]을 던진다 — 앱에 내장한 자산이라
  /// 깨져 있으면 조용히 넘어가는 것보다 즉시 드러나는 편이 낫다.
  static List<CellGeometry> parse(String source) {
    final Object? decoded = json.decode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('칸 자산의 최상위가 객체가 아니다');
    }

    final Object? version = decoded['version'];
    if (version != supportedVersion) {
      throw FormatException('지원하지 않는 칸 자산 버전: $version');
    }

    final Object? cells = decoded['cells'];
    if (cells is! List) {
      throw const FormatException('칸 자산에 cells 배열이 없다');
    }

    return <CellGeometry>[
      for (final Object? raw in cells) _cell(raw),
    ];
  }

  static CellGeometry _cell(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('칸 항목이 객체가 아니다');
    }

    final List<List<GeoPoint>> polygons = <List<GeoPoint>>[
      for (final Object? poly in raw['polygons'] as List<Object?>)
        <GeoPoint>[
          for (final Object? pt in poly as List<Object?>) _point(pt),
        ],
    ];
    if (polygons.isEmpty) {
      throw FormatException('칸 ${raw['code']}에 폴리곤이 없다');
    }

    return CellGeometry(
      code: raw['code'] as String,
      nameKo: raw['nameKo'] as String,
      nameEn: raw['nameEn'] as String,
      provinceCode: raw['provinceCode'] as String,
      provinceNameKo: raw['provinceNameKo'] as String,
      provinceNameEn: raw['provinceNameEn'] as String,
      districtCodes: <String>[
        for (final Object? c in raw['districtCodes'] as List<Object?>)
          c as String,
      ],
      center: _point(raw['center']),
      polygons: polygons,
      bounds: GeoBounds.of(polygons.expand((List<GeoPoint> p) => p)),
    );
  }

  /// 자산은 `[경도, 위도]` 순서로 담는다(GeoJSON 관례).
  static GeoPoint _point(Object? raw) {
    if (raw is! List || raw.length < 2) {
      throw const FormatException('좌표가 [경도, 위도] 형태가 아니다');
    }
    return GeoPoint(
      (raw[0] as num).toDouble(),
      (raw[1] as num).toDouble(),
    );
  }
}
