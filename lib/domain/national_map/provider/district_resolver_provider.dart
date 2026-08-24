import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/district_boundary.dart';
import '../model/district_boundary_source.dart';
import '../model/district_resolver.dart';

part 'district_resolver_provider.g.dart';

/// 시군구 경계 자산의 경로.
const String districtBoundaryAssetPath =
    'asset/geo/district-boundaries.geojson';

/// 252개 시군구 원본 경계.
///
/// 3.8MB를 파싱하므로 **한 번만 읽는다.** 칸 도형 조립과 좌표 판정이 둘 다 이걸
/// 쓴다.
///
/// 파싱은 isolate에서 한다 — 측정으로는 수십 ms지만 저사양 기기에서 프레임을
/// 떨어뜨릴 이유가 없다. 자산 로딩(`rootBundle`)만 메인에서 하고 무거운
/// 디코딩·객체화를 넘긴다.
@Riverpod(keepAlive: true)
Future<List<DistrictBoundary>> districtBoundaries(Ref ref) async {
  final String raw = await rootBundle.loadString(districtBoundaryAssetPath);
  return compute(DistrictBoundarySource.parse, raw);
}

/// 좌표 -> 시군구 판정기(SPEC-0030 v1.2 §0).
///
/// 서버의 `resolveDistricts`를 대체한다. 격자 인덱스를 세우므로 한 번만 만든다.
@Riverpod(keepAlive: true)
Future<DistrictResolver> districtResolver(Ref ref) async {
  final List<DistrictBoundary> boundaries = await ref.watch(
    districtBoundariesProvider.future,
  );
  return DistrictResolver(boundaries);
}
