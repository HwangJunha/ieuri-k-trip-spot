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
@riverpod
Future<Coordinates> currentCoordinates(Ref ref) =>
    ref.watch(locationServiceProvider).currentCoordinates();
