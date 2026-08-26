import 'cell_geometry.dart';
import 'map_cell.dart';

/// 칸 도형을 만드는 데 **실제로 필요한 것만** 담은 값(SPEC-0031).
///
/// [MapCell]에는 `visited`·`representativeImage`처럼 사진 스캔 중 계속 바뀌는
/// 필드가 함께 들어 있다. 도형 조립은 그중 아무것도 쓰지 않는데도 `MapCell`
/// 목록을 통째로 watch하면 **방문 표시 하나에 161칸 도형이 다시 만들어졌다**
/// (사용자 지적 2026-08-26 — 사진 스캔 중 지역이 칠해질 때마다 지도가 통째로
/// 사라지고 로딩 스피너가 떴다).
///
/// 그래서 도형이 쓰는 세 필드만 잘라 낸 값을 두고, 동등성도 이 셋으로만 정한다.
/// 방문 표시가 바뀌어도 키는 같으므로 조립이 아예 다시 돌지 않는다.
class CellShapeKey {
  const CellShapeKey({
    required this.id,
    required this.provinceCode,
    required this.districtCodes,
  });

  CellShapeKey.of(MapCell cell)
    : id = cell.id,
      provinceCode = cell.provinceCode,
      districtCodes = cell.districtCodes;

  final String id;
  final String provinceCode;
  final List<String> districtCodes;

  /// 도형 조립기가 받는 형태로 되돌린다.
  ///
  /// 조립기는 [MapCell]을 받으므로 껍데기를 만들어 준다. 조립에 쓰이지 않는
  /// 필드는 채우지 않는다 — 여기서 채운 값이 화면에 쓰이는 일은 없다.
  MapCell toCell() => MapCell(
    id: id,
    districtCodes: districtCodes,
    name: '',
    provinceName: '',
    provinceCode: provinceCode,
    visited: false,
    center: const GeoPoint(0, 0),
  );

  @override
  bool operator ==(Object other) =>
      other is CellShapeKey &&
      other.id == id &&
      other.provinceCode == provinceCode &&
      _sameCodes(other.districtCodes, districtCodes);

  @override
  int get hashCode => Object.hash(id, provinceCode, Object.hashAll(districtCodes));

  static bool _sameCodes(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
