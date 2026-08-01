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
/// keepAlive 아님(codegen 기본): 화면을 벗어나면 폐기되고 다시 진입하면 최신 좌표를
/// 다시 얻는다.
@riverpod
Future<Coordinates> currentCoordinates(Ref ref) =>
    ref.watch(locationServiceProvider).currentCoordinates();
