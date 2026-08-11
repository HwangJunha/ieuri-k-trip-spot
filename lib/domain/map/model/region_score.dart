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
  const RegionScore({
    required this.factor,
    required this.value,
    required this.rank,
  });

  final RegionScoreFactor factor;

  /// 0~100으로 정규화된 값.
  ///
  /// **절대 점수가 아니라 후보 집합 안의 상대 위치다.** 막대 길이로는 쓰되 **숫자로
  /// 노출하지 않는다** — "48점"처럼 보이면 절대 평가로 읽힌다. 지역의 강점을 고를
  /// 때는 이 값이 기준이다(항목 간 비교라 rank로는 고를 수 없다 — 모수가 다르다).
  final double value;

  /// 이 항목의 순위. **1이 가장 좋다.**
  ///
  /// [RegionScoreFactor.congestion]은 값이 이미 뒤집혀 있어 1위가 가장 덜 붐비는
  /// 곳이다.
  ///
  /// **반환된 목록이 아니라 시도 전체 후보 기준이다** — 10개만 받아도 rank가 15일 수
  /// 있다. 화면이 "이 목록에서 몇 번째"로 읽히게 두면 안 된다.
  ///
  /// 동점은 표준 경쟁 순위(1, 2, 2, 4)이며 항목마다 모수가 다르다 — 그 항목을 산출할
  /// 수 있는 지역만 센다.
  final int rank;

  /// 막대 길이로 쓸 0.0~1.0 비율. 서버가 범위를 벗어난 값을 주더라도 화면이 넘치지
  /// 않도록 여기서 자른다.
  double get fraction => (value / 100).clamp(0.0, 1.0);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionScore &&
          other.factor == factor &&
          other.value == value &&
          other.rank == rank;

  @override
  int get hashCode => Object.hash(factor, value, rank);
}
