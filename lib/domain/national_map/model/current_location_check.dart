import '../../../common/location/location_service.dart';

/// 현재 위치로 등록을 시도했을 때의 판정 결과(R33~R35).
///
/// 화면이 무엇을 보여줄지가 여기서 갈린다. 순수 값이라 위젯 없이 검증할 수 있다.
sealed class CurrentLocationCheck {
  const CurrentLocationCheck();
}

/// 등록할 수 있다. 사용자 확인을 받아야 실제로 등록한다(R33).
class LocationRegistrable extends CurrentLocationCheck {
  const LocationRegistrable({
    required this.districtCode,
    required this.districtName,
  });

  /// 판정된 시군구 코드. `recordVisits`에 보낼 값이다.
  final String districtCode;

  /// 확인 문구에 쓸 이름.
  ///
  /// **칸 이름이다**(예: "서울특별시"). 등록하면 칸 전체가 칠해지므로 시군구
  /// 이름("강남구")을 보여주면 결과와 어긋난다. 칸을 못 찾은 경우에만 시군구
  /// 이름이 들어온다.
  final String districtName;

  @override
  bool operator ==(Object other) =>
      other is LocationRegistrable && other.districtCode == districtCode;

  @override
  int get hashCode => districtCode.hashCode;
}

/// 이미 방문한 지역이다(R34). 알리기만 하고 등록하지 않는다.
class LocationAlreadyVisited extends CurrentLocationCheck {
  const LocationAlreadyVisited({required this.cellName});

  /// 이미 방문으로 표시된 칸의 이름(서버가 준 활성 언어 표기).
  final String cellName;

  @override
  bool operator ==(Object other) =>
      other is LocationAlreadyVisited && other.cellName == cellName;

  @override
  int get hashCode => cellName.hashCode;
}

/// 한국 밖이라 등록할 수 없다(R35).
class LocationOutsideKorea extends CurrentLocationCheck {
  const LocationOutsideKorea();

  @override
  bool operator ==(Object other) => other is LocationOutsideKorea;

  @override
  int get hashCode => 0;
}

/// 위치를 얻지 못했다(R35). 버튼을 비활성화하고 사유를 보여준다.
///
/// 이름이 `LocationUnavailable`이 아닌 이유는 `common/location`의 **예외**가 그
/// 이름을 이미 쓰기 때문이다. 이쪽은 화면 상태이고 그쪽은 던져지는 오류라, 같은
/// 이름을 두면 import가 충돌한다.
class LocationNotAvailable extends CurrentLocationCheck {
  const LocationNotAvailable(this.reason);

  /// 왜 못 얻었는지. 위치 서비스가 꺼진 것과 권한이 없는 것은 사용자가 할 일이
  /// 다르다. 원인을 모르면 null이다.
  final LocationUnavailableReason? reason;

  @override
  bool operator ==(Object other) =>
      other is LocationNotAvailable && other.reason == reason;

  @override
  int get hashCode => reason.hashCode;
}
