import '../network/network_retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'coordinates.dart';
import 'location_service.dart';

part 'location_providers.g.dart';

/// [LocationService]를 노출한다. 위젯·다른 provider는 직접 생성하지 않고 이 provider를
/// 통해 접근하며(CLAUDE.md §5), 테스트는 이 한 provider만 오버라이드해 페이크를 주입한다.
@riverpod
LocationService locationService(Ref ref) => const GeolocatorLocationService();

/// 디바이스 현재 좌표(SPEC-0002 spots 쿼리 입력). 위치를 얻지 못하면 오류
/// `AsyncValue`가 되어 SPEC-0001 권한 안내/설정 이동 흐름으로 이어진다.
///
/// keepAlive 아님(codegen 기본). 다만 keepAlive인 [SwipeController]가 이 provider를
/// watch하므로, 스와이프 세션이 살아 있는 동안에는 함께 유지되고 좌표도 그 세션의 첫
/// 조회 값으로 고정된다. 의도한 동작이다 — 걸어 다닐 때마다 좌표가 갱신돼 피드가 다시
/// 조회되면 사용자에겐 목록이 제멋대로 바뀌는 것으로 보인다. 피드를 새로 받는 계기는
/// 앱 재시작·언어 전환·명시적 재시도뿐이다.
///
/// **재시도 정책을 붙인다**(2026-08-26). 이 provider는 화면 컨트롤러들이
/// `watch`하는 입력인데, 여기에 정책이 없으면 Riverpod 기본값 **10회**가 돌고
/// 그 오류가 컨트롤러로 전파된다 — 컨트롤러 쪽 5회 정책과 어긋나, 화면이 자기
/// 재시도를 다 쓰기도 전에 오류로 넘어간다(실기기 확인).
///
/// `defaultNetworkRetry`는 [LocationUnavailable]을 재시도 없이 끊으므로 권한
/// 거부·GPS 꺼짐에서는 곧바로 안내 경로로 간다.
@Riverpod(retry: defaultNetworkRetry)
Future<Coordinates> currentCoordinates(Ref ref) =>
    ref.watch(locationServiceProvider).currentCoordinates();

/// 실시간 현재 위치. 지도의 "내 위치" 점이 이것을 따라 움직인다(카카오맵·네이버지도가
/// 파란 점으로 보여 주는 그것).
///
/// **[currentCoordinates]와 별개로 둔다.** 그쪽은 조회 입력이라 세션 동안 고정되는
/// 것이 의도이고(위 주석), 여기는 계속 흘러야 한다. 하나로 합치면 걸을 때마다 스와이프
/// 피드와 홈 섹션이 다시 조회된다.
///
/// **keepAlive를 두지 않는다**(codegen 기본 autoDispose). 구독자가 없으면 GPS 스트림이
/// 끊겨야 한다 — 지도 탭을 벗어난 뒤에도 위치를 계속 받으면 배터리만 먹는다. 지도
/// 화면이 이 provider의 유일한 구독자다.
@riverpod
Stream<Coordinates> liveCoordinates(Ref ref) =>
    ref.watch(locationServiceProvider).watchCoordinates();
