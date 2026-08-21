import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/district_boundary.dart';
import '../model/district_boundary_source.dart';
import '../model/district_resolver.dart';

part 'district_resolver_provider.g.dart';

/// 시군구 경계 자산의 경로.
const String districtBoundaryAssetPath = 'asset/geo/district-boundaries.geojson';

/// 좌표 -> 시군구 판정기(SPEC-0030 v1.2 §0).
///
/// 3.8MB 자산을 파싱하고 격자 인덱스를 세우므로 **한 번만 만든다.** 화면을
/// 드나들 때마다 다시 하면 안 된다.
///
/// 사진 동기화를 시작할 때까지 필요 없으므로 미리 읽지 않는다 — 지도 탭에
/// 들어왔다고 3.8MB를 파싱하지는 않는다.
@Riverpod(keepAlive: true)
Future<DistrictResolver> districtResolver(Ref ref) async {
  final String raw = await rootBundle.loadString(districtBoundaryAssetPath);
  final List<DistrictBoundary> boundaries = DistrictBoundarySource.parse(raw);
  return DistrictResolver(boundaries);
}
