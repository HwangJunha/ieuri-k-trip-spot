import 'cell_image.dart';

/// 전국 지도의 표시 칸 1개(계약 `MapCell`).
///
/// 행정구역 시군구와 1:1이 아니다 — 광역시는 전체가 1칸, 구를 가진 일반시 12곳도
/// 시 단위로 1칸이다. 전국 252개 시군구가 161칸이 된다(R7).
///
/// 도형은 여기 없다. 칸의 모양은 앱 자산(`CellGeometry`)이고 [code]로 맞춘다.
class MapCell {
  const MapCell({
    required this.code,
    required this.districtCodes,
    required this.name,
    required this.provinceName,
    required this.provinceCode,
    required this.visited,
    this.representativeImage,
  });

  /// 칸 코드. 이 칸을 가리키는 안정 식별자다.
  final String code;

  /// 이 칸이 포함하는 시군구 행정표준코드 5자리 목록.
  ///
  /// 좌표 판정 결과를 칸에 대응시킬 때 쓴다.
  final List<String> districtCodes;

  /// 활성 언어 표기(R8). 서버가 폴백까지 끝낸 값이다.
  final String name;

  final String provinceName;

  /// 상위 시도 코드 2자리. 시도 단위 진척을 계산할 때 쓴다(R21).
  final String provinceCode;

  /// 뷰어가 이 칸을 방문했는지. 비인증 조회에서는 항상 false다.
  ///
  /// 칸에 속한 시군구 중 **하나라도** 방문했으면 참이다 — 수원시 장안구를
  /// 방문하면 수원시 칸 전체가 방문으로 표시된다.
  final bool visited;

  /// 대표 이미지. **없을 수 있다**(R10) — 없어도 칸은 그린다.
  final CellImage? representativeImage;

  MapCell copyWith({bool? visited, CellImage? representativeImage}) => MapCell(
    code: code,
    districtCodes: districtCodes,
    name: name,
    provinceName: provinceName,
    provinceCode: provinceCode,
    visited: visited ?? this.visited,
    representativeImage: representativeImage ?? this.representativeImage,
  );

  @override
  bool operator ==(Object other) =>
      other is MapCell &&
      other.code == code &&
      other.name == name &&
      other.provinceName == provinceName &&
      other.provinceCode == provinceCode &&
      other.visited == visited &&
      other.representativeImage == representativeImage;

  @override
  int get hashCode => Object.hash(
    code,
    name,
    provinceName,
    provinceCode,
    visited,
    representativeImage,
  );
}
