import 'package:geolocator/geolocator.dart';

import 'coordinates.dart';

/// 디바이스 현재 위치를 얻는 서비스 경계. geolocator 의존을 이 한 곳에 가둔다 —
/// provider·UI는 [Coordinates](순수 값)만 본다. 테스트는 이 인터페이스를 페이크로
/// 오버라이드해 GPS 없이 좌표를 주입한다.
abstract interface class LocationService {
  /// 현재 좌표를 한 번 얻는다. 권한이 없거나(설정에서만 허용) 위치 서비스가 꺼져
  /// 있으면 [LocationUnavailable]을 던진다.
  Future<Coordinates> currentCoordinates();
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
}
