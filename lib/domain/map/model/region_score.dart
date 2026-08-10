/// 추천 점수를 구성하는 항목(SPEC-0015 §6).
///
/// **생성 enum을 그대로 쓰지 않는다**(POL-020). 서버가 항목을 추가하면 생성 타입이
/// 바뀌는데, 그것이 provider·view까지 번지면 계약 변경이 곧 UI 변경이 된다.
/// repository가 생성 enum을 이 도메인 enum으로 옮긴다.
///
/// [congestion]만 향후 예측이고 나머지 셋은 측정된 과거 데이터다. [distance]는 요청
/// 시점에 계산되며 위치를 주지 않으면 아예 부재한다(R27).
enum RegionScoreFactor {
  /// 예상 혼잡도. 덜 붐빌수록 높다. **향후 30일 예측이며 실시간이 아니다**(R24).
  congestion,

  /// 방문자 규모·추세.
  visitorVolume,

  /// 체류 강도.
  stayIntensity,

  /// 소비 강도.
  spendingIntensity,

  /// 사용자 위치로부터의 거리. 가까울수록 높다.
  ///
  /// **필터가 아니라 점수 항목이다**(§4.2) — 반경으로 잘라내지 않으므로 조금 멀어도
  /// 다른 항목이 뚜렷하게 나은 곳이 목록에 섞인다.
  distance,

  /// 이 클라이언트가 모르는 항목. 서버가 항목을 추가해도 매핑이 깨지지 않게 둔다.
  ///
  /// 화면은 이 값을 **그리지 않는다** — 이름도 뜻도 모르는 막대를 그리면 사용자에게
  /// 의미 없는 축이 하나 생긴다.
  unknown,
}

/// 점수 항목 1개(0~100).
///
/// **산출할 수 없는 항목은 애초에 목록에 오지 않는다**(§2.2) — 서버가 결측 항목을 빼서
/// 주므로 여기에 0점으로 채워 넣지 않는다. 0으로 채우면 서버가 피한 왜곡을 클라이언트가
/// 되살린다.
class RegionScore {
  const RegionScore({required this.factor, required this.value});

  final RegionScoreFactor factor;

  /// 0~100으로 정규화된 값. 높을수록 추천에 유리하다.
  final double value;

  /// 막대 길이로 쓸 0.0~1.0 비율. 서버가 범위를 벗어난 값을 주더라도 화면이 넘치지
  /// 않도록 여기서 자른다.
  double get fraction => (value / 100).clamp(0.0, 1.0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionScore && other.factor == factor && other.value == value;

  @override
  int get hashCode => Object.hash(factor, value);
}
