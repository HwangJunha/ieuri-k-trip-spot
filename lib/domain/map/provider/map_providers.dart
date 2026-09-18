import 'dart:async' show Timer;
import 'dart:ui' show Locale;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/locale_controller.dart';
import '../../../common/network/graphql_client.dart';
import '../../../common/network/network_retry_policy.dart';
import '../model/congestion_area.dart';
import '../model/map_bounds.dart';
import '../model/map_tuning.dart';
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
/// **조회는 뷰포트당 한 번이다**(SPEC-0029). 원문/번역을 갈라 두 번 받던 `hasOrigin`이
/// 계약에서 사라져, 서버가 활성 언어의 장소만 한 번에 준다.
///
/// **카테고리 필터를 받지 않는다**(사용자 결정, 2026-08-16). 서버 인자는 있지만
/// 지도는 오버레이가 가장 많은 화면이라 바를 하나 더 얹으면 가독성이 떨어진다.
///
/// **이제 여기서 쓰는 것은 문화행사뿐이다**(SPEC-0036). spot은 추천 순서로 받으므로
/// (`MapMarkerController.loadNextBatch`) 이 조회의 `spots`는 화면이 걸러 버린다 —
/// 행사는 이 변경의 대상이 아니라 기존대로 표시되어야 해서(FR-012) 조회 자체는
/// 남는다.
@Riverpod(retry: defaultNetworkRetry)
Future<MapViewportResult> mapViewport(Ref ref, MapBounds bbox, int zoom) =>
    ref.watch(mapRepositoryProvider).fetchViewport(bbox: bbox, zoom: zoom);

/// 뷰포트에 걸치는 구역의 실시간 혼잡도(R6~R11).
///
/// **줌 게이트를 통과했을 때만 이 provider를 watch한다**(R25). 게이트 미만에서
/// 호출하지 않는 것이 일일 쿼터 1000건을 지키는 실질적 장치다(설계 §5.1) —
/// 게이트를 렌더링에만 두면 의미가 없다.
///
/// ## 결과를 [MapTuning.congestionCacheTtl] 동안 붙들어 둔다
///
/// **원본이 실시간이 아니다.** 서울시 열린데이터의 관측 시각은 10분 단위로 떨어지고
/// (실기기 로그 2026-08-25: `05:10`, `05:20`), 구역에 따라 몇 시간 전 값이 그대로
/// 오기도 한다(`02:50`, `04:30`). 그런 값을 몇 초 간격으로 다시 받아 봐야 같은
/// 숫자가 온다.
///
/// 붙들지 않으면 지도를 옮길 때마다 요청이 나간다 — codegen 기본값이 `autoDispose`라
/// 화면이 잠깐이라도 놓으면 즉시 버려지기 때문이다. 실측으로 22초에 9번이었다.
///
/// **호출부가 bbox를 격자에 맞춰 넘겨야 이 캐시가 실제로 맞는다**(→ `MapScreen`).
/// family 키가 bbox 자체라, 소수점이 매번 달라지면 붙들어 둔 것과 다른 키가 되어
/// 캐시가 있으나 마나다.
@Riverpod(retry: defaultNetworkRetry)
Future<SeoulCongestionResult> seoulCongestion(Ref ref, MapBounds bbox) async {
  // **링크는 await 전에 잡는다**(→[congestionBoundaries]의 같은 주석).
  final link = ref.keepAlive();

  // 오래된 값을 영원히 붙들지는 않는다. 만료되면 다음 조회가 서버를 다시 친다.
  final Timer expiry = Timer(MapTuning.congestionCacheTtl, link.close);
  ref.onDispose(expiry.cancel);

  try {
    return await ref.watch(mapRepositoryProvider).fetchCongestion(bbox: bbox);
  } on Object {
    // 실패한 결과는 붙들지 않는다 — 한 번 실패했다고 TTL 동안 폴리곤이 사라져
    // 있으면 안 된다.
    expiry.cancel();
    link.close();
    rethrow;
  }
}

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
@Riverpod(retry: defaultNetworkRetry)
Future<List<CongestionAreaBoundary>> congestionBoundaries(
  Ref ref,
  String languageTag,
) async {
  // **링크는 await 전에 잡는다.** await 뒤에 `ref.keepAlive()`를 부르면, 그 사이
  // provider가 폐기됐을 때 죽은 Ref를 만져 "Cannot use the Ref … after it has been
  // disposed"로 터진다.
  final link = ref.keepAlive();
  final MapRepository repository = ref.watch(mapRepositoryProvider);

  try {
    return await repository.fetchBoundaries();
  } on Object {
    // **실패한 결과는 붙들지 않는다.** 그대로 캐시되면 첫 조회가 한 번 실패했을 때
    // 앱을 다시 켤 때까지 폴리곤이 영영 안 나오고, 재시도가 아예 일어나지 않아
    // 로그에도 아무것도 남지 않는다(실기기에서 그 상태였다).
    link.close();
    rethrow;
  }
}

/// 현재 활성 언어로 경계를 조회한다. 화면은 이 provider만 보면 된다 — 언어가 바뀌면
/// 인자가 바뀌어 자동으로 새 캐시를 탄다.
@riverpod
Future<List<CongestionAreaBoundary>> currentCongestionBoundaries(Ref ref) {
  final Locale locale = ref.watch(localeControllerProvider);
  return ref.watch(congestionBoundariesProvider(locale.languageCode).future);
}
