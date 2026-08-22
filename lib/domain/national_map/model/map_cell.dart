import 'cell_geometry.dart';
import 'cell_image.dart';

/// 전국 지도의 표시 칸 1개(계약 `MapCell`).
///
/// 행정구역 시군구와 1:1이 아니다 — 광역시는 전체가 1칸, 구를 가진 일반시 12곳도
/// 시 단위로 1칸이다. 전국 252개 시군구가 161칸이 된다(R7).
///
/// 도형은 여기 없다. 칸의 모양은 [districtCodes]로 원본 경계를 합쳐 런타임에
/// 만들며(`CellShapeBuilder`), 결과는 [id]로 이 칸과 이어진다.
class MapCell {
  const MapCell({
    required this.id,
    required this.districtCodes,
    required this.name,
    required this.provinceName,
    required this.provinceCode,
    required this.visited,
    required this.center,
    this.landmarkCaption,
    this.representativeImage,
  });

  /// 칸 id. **행정구역 코드가 아니다** — 칸은 서버가 정한 표시 단위라 대응하는
  /// 공식 코드가 없다. 상세 진입·해제·공유가 이 값을 쓴다.
  final String id;

  /// 이 칸이 포함하는 시군구 행정표준코드 5자리 목록.
  ///
  /// **등록은 이쪽이다.** 로컬 판정 결과(시군구 코드)를 `recordVisits`로 보내고,
  /// 해제만 [id]로 한다. 비대칭이 의도다 — 저장이 시군구 단위여야 나중에 칸
  /// 규칙이 바뀌어도 기록이 살아남는다.
  final List<String> districtCodes;

  /// 활성 언어 표기(R8). 서버가 폴백까지 끝낸 값이다.
  final String name;

  final String provinceName;

  /// 상위 시도 코드 2자리. 시도 단위 진척을 계산할 때 쓴다(R21).
  final String provinceCode;

  /// 뷰어가 이 칸을 방문했는지. 비인증 조회에서는 항상 false다.
  ///
  /// 칸에 속한 시군구 중 **하나라도** 방문했으면 참이다 — 종로구를 방문하면
  /// 서울 칸 전체가 칠해진다. 의도된 동작이다(R6).
  final bool visited;

  /// 지도를 이 칸으로 옮길 때 쓰는 대표 좌표. 항상 이 칸의 경계 안이다.
  final GeoPoint center;

  /// 대표 이미지의 **이름만**(예: 경복궁). 지도에 그릴 도형 유형을 여기서 뽑는다.
  ///
  /// `mapCells`는 이 값만 받고 [representativeImage]는 null이다 — 지도의 칸에는
  /// 실사진을 그리지 않으므로 URL을 받을 이유가 없다. 상세 조회에서는 둘 다 온다.
  final String? landmarkCaption;

  /// 대표 이미지. **없을 수 있다**(R10) — 특산품 14건이 아직 없어 실제로
  /// 발생한다. 없어도 칸은 그리고 지역명만 표시한다.
  final CellImage? representativeImage;

  MapCell copyWith({bool? visited, CellImage? representativeImage}) => MapCell(
    id: id,
    districtCodes: districtCodes,
    name: name,
    provinceName: provinceName,
    provinceCode: provinceCode,
    visited: visited ?? this.visited,
    center: center,
    landmarkCaption: landmarkCaption,
    representativeImage: representativeImage ?? this.representativeImage,
  );

  @override
  bool operator ==(Object other) =>
      other is MapCell &&
      other.id == id &&
      other.name == name &&
      other.provinceName == provinceName &&
      other.provinceCode == provinceCode &&
      other.visited == visited &&
      other.representativeImage == representativeImage;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    provinceName,
    provinceCode,
    visited,
    representativeImage,
  );
}
