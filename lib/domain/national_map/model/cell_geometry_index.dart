import 'cell_geometry.dart';
import 'map_cell.dart';

/// 서버 칸([MapCell])과 렌더링 도형([CellGeometry])을 잇는다.
///
/// **둘을 잇는 열쇠는 `districtCodes`다.** 서버 칸 id는 `1`~`161`이고 도형 자산의
/// `code`는 `"11"`·`"41_수원시"`라 직접 대응하는 값이 없다 — 서버가 "칸은 표시
/// 단위라 대응하는 공식 코드가 없다"고 못박았기 때문이다.
///
/// 두 자산이 같은 시군구 코드 체계를 쓰는 것이 전제다. 도형을 서버 경계 파일에서
/// 생성하는 이유가 그것이다(`asset/geo/README.md`).
class CellGeometryIndex {
  const CellGeometryIndex._(this._geometryByCellId, this.unmatchedCellIds);

  /// [cells]와 [geometries]를 시군구 코드로 맞춘다.
  ///
  /// 도형이 없는 칸은 그리지 않는다 — 조용히 빠지는 것이 낫다. 대신 어떤 칸이
  /// 빠졌는지 [unmatchedCellIds]에 남겨 테스트가 잡을 수 있게 한다.
  factory CellGeometryIndex.build({
    required Iterable<MapCell> cells,
    required Iterable<CellGeometry> geometries,
  }) {
    // 시군구 코드 -> 도형. 한 도형이 여러 시군구를 갖는다.
    final Map<String, CellGeometry> byDistrict = <String, CellGeometry>{};
    for (final CellGeometry g in geometries) {
      for (final String code in g.districtCodes) {
        byDistrict[code] = g;
      }
    }

    final Map<String, CellGeometry> result = <String, CellGeometry>{};
    final List<String> unmatched = <String>[];
    for (final MapCell cell in cells) {
      CellGeometry? hit;
      for (final String code in cell.districtCodes) {
        hit = byDistrict[code];
        if (hit != null) break;
      }
      if (hit == null) {
        unmatched.add(cell.id);
      } else {
        result[cell.id] = hit;
      }
    }

    return CellGeometryIndex._(
      Map<String, CellGeometry>.unmodifiable(result),
      List<String>.unmodifiable(unmatched),
    );
  }

  final Map<String, CellGeometry> _geometryByCellId;

  /// 도형을 찾지 못한 칸 id. 정상이면 비어 있다.
  final List<String> unmatchedCellIds;

  CellGeometry? geometryOf(String cellId) => _geometryByCellId[cellId];

  /// 칸 id -> 도형. 그리는 쪽이 순회할 목록이다.
  Iterable<MapEntry<String, CellGeometry>> get entries =>
      _geometryByCellId.entries;

  int get length => _geometryByCellId.length;

  /// 도형 -> 칸 id 역인덱스. 지도를 탭했을 때 어떤 칸인지 찾는 데 쓴다.
  Map<String, String> get cellIdByGeometryCode => <String, String>{
    for (final MapEntry<String, CellGeometry> e in _geometryByCellId.entries)
      e.value.code: e.key,
  };
}
