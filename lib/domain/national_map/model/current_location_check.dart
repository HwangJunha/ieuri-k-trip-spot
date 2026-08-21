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

  /// 확인 문구에 쓸 이름. 자산의 한국어 이름이라 활성 언어와 다를 수 있으나,
  /// 서버 칸 이름은 아직 어느 칸인지 모르므로 이것이 유일한 단서다.
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
class LocationUnavailable extends CurrentLocationCheck {
  const LocationUnavailable();

  @override
  bool operator ==(Object other) => other is LocationUnavailable;

  @override
  int get hashCode => 1;
}
