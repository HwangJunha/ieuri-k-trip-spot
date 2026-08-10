import 'dart:ui' show Locale;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/locale_controller.dart';
import '../../../common/network/graphql_client.dart';
import '../model/congestion_area.dart';
import '../model/map_bounds.dart';
import '../model/map_viewport_result.dart';
import '../model/seoul_congestion_result.dart';
import '../repository/map_repository.dart';
import '../repository/map_repository_impl.dart';

part 'map_providers.g.dart';

@riverpod
MapRepository mapRepository(Ref ref) =>
    MapRepositoryImpl(ref.watch(graphqlClientProvider));

/// 뷰포트 안의 마커·클러스터(R1·R2·R3·R12).
///
/// **혼잡도와 별도 provider다**(설계 §6.3). 하나로 묶으면 혼잡도 실패가 마커까지
/// 끌고 내려가 R29를 어긴다 — 지도는 혼잡도가 죽어도 정상 동작해야 한다.
///
/// bbox와 zoom을 인자로 받아 family가 된다. 뷰포트가 바뀌면 새 인자가 되므로 이전
/// 조회는 자동으로 버려진다 — 늦게 도착한 응답이 현재 뷰포트를 덮어쓰지 않는다
/// (설계 §3.3).
@riverpod
Future<MapViewportResult> mapViewport(Ref ref, MapBounds bbox, int zoom) =>
    ref.watch(mapRepositoryProvider).fetchViewport(bbox: bbox, zoom: zoom);

/// 뷰포트에 걸치는 구역의 실시간 혼잡도(R6~R11).
///
/// **줌 게이트를 통과했을 때만 이 provider를 watch한다**(R25). 게이트 미만에서
/// 호출하지 않는 것이 일일 쿼터 1000건을 지키는 실질적 장치다(설계 §5.1) —
/// 게이트를 렌더링에만 두면 의미가 없다.
@riverpod
Future<SeoulCongestionResult> seoulCongestion(Ref ref, MapBounds bbox) =>
    ref.watch(mapRepositoryProvider).fetchCongestion(bbox: bbox);

/// 121곳의 정적 폴리곤 경계(R17·R26).
///
/// **앱 수명 동안 유지한다**(`keepAlive`). 경계는 서울시가 구역을 재획정하지 않는 한
/// 바뀌지 않는데, 121개 폴리곤을 지도에 들어올 때마다 다시 받는 것은 낭비다
/// (spec §7.3).
///
/// **언어를 인자로 받아 캐시 키에 포함한다**(R31). 구역명이 활성 언어로 오므로,
/// 언어를 무시하고 캐싱하면 설정에서 언어를 바꿔도 이전 언어 이름이 그대로 남는다
/// (설계 §5.2). 언어별로 따로 보관되고, 전환하면 그 언어의 캐시가 새로 채워진다.
///
/// 좌표만 공유하고 이름만 다시 받는 방식도 가능하지만, 121건 한 번의 왕복이라
/// 복잡도를 더할 이득이 없다.
@Riverpod(keepAlive: true)
Future<List<CongestionAreaBoundary>> congestionBoundaries(
  Ref ref,
  String languageTag,
) => ref.watch(mapRepositoryProvider).fetchBoundaries();

/// 현재 활성 언어로 경계를 조회한다. 화면은 이 provider만 보면 된다 — 언어가 바뀌면
/// 인자가 바뀌어 자동으로 새 캐시를 탄다.
@riverpod
Future<List<CongestionAreaBoundary>> currentCongestionBoundaries(Ref ref) {
  final Locale locale = ref.watch(localeControllerProvider);
  return ref.watch(congestionBoundariesProvider(locale.languageCode).future);
}
