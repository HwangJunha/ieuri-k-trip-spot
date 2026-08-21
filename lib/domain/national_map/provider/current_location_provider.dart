import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../model/cell_geometry.dart';
import '../model/current_location_check.dart';
import '../model/district_boundary.dart';
import '../model/district_resolver.dart';
import '../model/map_cell.dart';
import 'district_resolver_provider.dart';
import 'national_map_providers.dart';

part 'current_location_provider.g.dart';

/// 현재 위치로 등록할 수 있는지 판정한다(R33~R35).
///
/// 사진 동기화와 **같은 경로**다 — 좌표가 1건일 뿐이다. 여기서도 좌표는 기기를
/// 떠나지 않는다.
///
/// 등록을 하지는 않는다. 사용자 확인을 받은 뒤 `VisitController.record`를 부르는
/// 것은 화면의 몫이다(R33: 확인 없이 자동 등록 금지).
@riverpod
Future<CurrentLocationCheck> currentLocationCheck(Ref ref) async {
  final Coordinates coords;
  try {
    coords = await ref.watch(currentCoordinatesProvider.future);
  } on Object {
    // 권한 거부·GPS 꺼짐·타임아웃을 구분하지 않는다 — 화면에서 할 일이 같다.
    return const LocationUnavailable();
  }

  final DistrictResolver resolver = await ref.watch(
    districtResolverProvider.future,
  );
  final DistrictBoundary? district = resolver.districtAt(
    GeoPoint(coords.longitude, coords.latitude),
  );
  // 국내 시군구 어디에도 속하지 않으면 해외이거나 바다다(R35).
  if (district == null) return const LocationOutsideKorea();

  final List<MapCell> cells = await ref.watch(mapCellsProvider.future);
  final MapCell? owning = cells
      .where((MapCell c) => c.districtCodes.contains(district.code))
      .firstOrNull;

  // 이미 방문한 칸이면 알리고 등록하지 않는다(R34).
  if (owning != null && owning.visited) {
    return LocationAlreadyVisited(cellName: owning.name);
  }

  return LocationRegistrable(
    districtCode: district.code,
    districtName: district.nameKo,
  );
}
