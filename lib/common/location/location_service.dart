import 'package:geolocator/geolocator.dart';

import 'coordinates.dart';

/// 디바이스 현재 위치를 얻는 서비스 경계. geolocator 의존을 이 한 곳에 가둔다 —
/// provider·UI는 [Coordinates](순수 값)만 본다. 테스트는 이 인터페이스를 페이크로
/// 오버라이드해 GPS 없이 좌표를 주입한다.
abstract interface class LocationService {
  /// 현재 좌표를 한 번 얻는다. 권한이 없거나(설정에서만 허용) 위치 서비스가 꺼져
  /// 있으면 [LocationUnavailable]을 던진다.
  Future<Coordinates> currentCoordinates();

  /// 위치가 바뀔 때마다 좌표를 흘려보낸다(지도의 실시간 내 위치 표시용).
  ///
  /// [currentCoordinates]와 나누는 이유는 **쓰임이 다르기 때문**이다. 한 번 얻기는
  /// 조회 입력(주변 spot을 받을 좌표)이라 값이 고정되어야 하고, 여기는 화면에 찍힌
  /// 점을 따라 움직이게 하는 것이라 계속 와야 한다. 한쪽을 다른 쪽으로 대신하면
  /// 좌표가 바뀔 때마다 목록이 다시 조회되거나(전자), 점이 멈춘다(후자).
  ///
  /// 권한이 없으면 [LocationUnavailable]을 **스트림 오류로** 흘린다 — 구독자가
  /// `onError`에서 받는다.
  Stream<Coordinates> watchCoordinates();
}

/// 위치를 얻을 수 없는 상태(권한 없음·서비스 꺼짐). provider가 이를 오류
/// `AsyncValue`로 UI에 노출하면 SPEC-0001 권한 안내/설정 이동 CTA로 이어진다.
class LocationUnavailable implements Exception {
  const LocationUnavailable(this.reason);

  final LocationUnavailableReason reason;

  @override
  String toString() => 'LocationUnavailable($reason)';
}

enum LocationUnavailableReason {
  serviceDisabled,
  permissionDenied,

  /// 권한도 서비스도 살아 있는데 **좌표를 못 잡았다**(2026-08-29).
  ///
  /// 실내·시뮬레이터·기기 첫 부팅에서 일어난다. 예전에는 이 경우만
  /// `TimeoutException`으로 새어 나가 호출부의 `error is LocationUnavailable`
  /// 검사를 전부 빗겨갔고, 그래서 재시도 정책이 이것을 네트워크 오류로 보고
  /// 5회를 더 돌렸다 — fix 시한 10초까지 더하면 최악 60초 스피너다. 위치를 끈
  /// 심사자가 본 것이 이 화면일 수 있다.
  fixTimeout,
}

/// geolocator 기반 [LocationService]. 권한은 SPEC-0001 흐름이 이미 요청하므로 여기선
/// 상태만 확인하고, 필요한 경우 한 번 더 요청한다(거부면 예외).
class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<Coordinates> currentCoordinates() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationUnavailable(
        LocationUnavailableReason.serviceDisabled,
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationUnavailable(
        LocationUnavailableReason.permissionDenied,
      );
    }

    // **캐시된 위치가 있으면 그것을 먼저 쓴다**(2026-08-25).
    //
    // `getCurrentPosition`은 **새 fix를 기다린다.** 콜드 스타트나 실내에서는 그것이
    // 수 초가 되고, 홈 세 섹션이 전부 이 좌표를 기다리므로 그동안 화면이 통째로
    // 뼈대다 — 사용자가 "안드로이드는 시간이 좀 지나야 된다"고 한 증상이다.
    // (안드로이드 전용 문제는 아니지만 GPS 하드웨어 편차가 커 더 자주 드러난다.)
    //
    // 마지막으로 알려진 위치는 즉시 돌아온다(없으면 null). 반경 기반 추천에
    // 쓰기에 몇십 미터 오차는 무의미하고, 정확한 좌표가 필요한 지도는 별도로
    // [watchCoordinates]를 구독해 곧 갱신된 값을 받는다.
    final Position? lastKnown = await _lastKnownOrNull();
    if (lastKnown != null) {
      return Coordinates(
        latitude: lastKnown.latitude,
        longitude: lastKnown.longitude,
      );
    }

    // 캐시가 없으면(기기 첫 부팅 등) 새로 잡되 **무한정 기다리지 않는다.**
    //
    // **실패를 [LocationUnavailable]로 정규화한다**(2026-08-29). 시한을 넘기면
    // geolocator가 `TimeoutException`을, 플랫폼 사정에 따라 다른 예외를 던지는데
    // 그대로 새어 나가면 호출부의 `error is LocationUnavailable` 검사를 전부
    // 빗겨간다 — 재시도 정책이 네트워크 오류로 착각해 5회를 더 돌리고, 화면은
    // 위치 안내 대신 "다시 시도" 배너를 띄운다. 위치를 못 얻은 것은 하나의
    // 사실이고, 그 사실이 타입 하나로 표현되어야 한다.
    try {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: _fixTimeout,
        ),
      );
      return Coordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on LocationUnavailable {
      rethrow;
    } on Object {
      throw const LocationUnavailable(LocationUnavailableReason.fixTimeout);
    }
  }

  /// 새 fix를 기다리는 최대 시간. 넘기면 예외가 되어 화면이 실패를 그린다.
  static const Duration _fixTimeout = Duration(seconds: 10);

  /// 마지막으로 알려진 위치. **실패를 삼킨다** — 이것은 최적화일 뿐이라, 못 얻으면
  /// 새 fix 경로로 넘어가면 된다. 여기서 던지면 캐시가 없는 기기에서 위치 자체를
  /// 못 쓰게 된다.
  Future<Position?> _lastKnownOrNull() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } on Exception {
      return null;
    }
  }

  @override
  Stream<Coordinates> watchCoordinates() async* {
    // 권한 확인을 한 번 얻기와 공유한다 — 규칙이 갈리면 버튼은 되는데 점은 안
    // 나오는(혹은 반대) 상태가 생긴다. 여기서 던진 예외는 스트림 오류가 된다.
    //
    // **반환값은 쓰지 않는다.** 한 번 얻기가 캐시된 위치를 돌려줄 수 있게 됐지만
    // (2026-08-25) 지도에 찍히는 점은 아래 `getPositionStream`이 주는 실시간
    // 좌표라, 낡은 값이 화면에 새는 경로가 아니다.
    await currentCoordinates();

    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        // **정확도를 한 단계 올린다.** 조회 입력은 medium으로 족하지만, 화면에
        // 찍힌 점은 몇십 미터만 어긋나도 "내가 저기 있나?" 싶게 틀려 보인다.
        accuracy: LocationAccuracy.high,
        // **몇 미터를 움직여야 새 좌표를 줄지.** 0으로 두면 GPS 잡음만으로도
        // 점이 제자리에서 떨리고, 그때마다 아이콘을 다시 옮기느라 배터리를
        // 먹는다. 5m면 걸음은 따라오면서 서 있을 때는 조용하다.
        distanceFilter: 5,
      ),
    ).map(
      (Position position) => Coordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }
}
