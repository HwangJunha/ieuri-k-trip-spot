/// 로딩 중 뼈대를 그리기 위한 더미 칸. **화면에 값이 보이지는 않는다** —
/// `AppSkeleton`이 텍스트와 아이콘을 뼈대로 덮으므로 글자 수만 레이아웃에 남는다.
///
/// ## 왜 값이 이렇게 생겼는가
///
/// - `representativeImage`가 **null**이다. 겹침 목록은 이름만 그리므로 이미지가
///   필요 없고, 넣으면 뼈대가 CDN 요청을 내게 된다.
/// - 칸 이름과 시도명 길이가 제각각이다. 전부 같은 길이면 뼈대가 표처럼 보인다.
/// - `center`는 아무 좌표나 좋다 — 겹침 목록은 좌표를 그리지 않는다.
library;

import 'cell_geometry.dart';
import 'map_cell.dart';

const GeoPoint _center = GeoPoint(126.9780, 37.5665);

MapCell _cell({
  required String id,
  required String name,
  required String provinceName,
}) => MapCell(
  id: id,
  districtCodes: const <String>[],
  name: name,
  provinceName: provinceName,
  provinceCode: '11',
  visited: true,
  center: _center,
);

/// 겹침 목록(`OverlapListSheet`)용.
final List<MapCell> mapCellSkeletonSamples = <MapCell>[
  _cell(id: '_skeleton_c0', name: '종로구', provinceName: '서울특별시'),
  _cell(id: '_skeleton_c1', name: '해운대구', provinceName: '부산광역시'),
  _cell(id: '_skeleton_c2', name: '경주시', provinceName: '경상북도'),
];

/// 겹침 목록 뼈대 한 칸. 목록이 같은 줄을 반복하므로 하나만 있으면 된다.
final MapCell mapCellSkeletonSample = mapCellSkeletonSamples.first;
