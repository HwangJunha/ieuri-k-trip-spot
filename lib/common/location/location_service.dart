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

enum LocationUnavailableReason { serviceDisabled, permissionDenied }

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

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
    return Coordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Stream<Coordinates> watchCoordinates() async* {
    // 권한 확인을 한 번 얻기와 공유한다 — 규칙이 갈리면 버튼은 되는데 점은 안
    // 나오는(혹은 반대) 상태가 생긴다. 여기서 던진 예외는 스트림 오류가 된다.
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
