import 'commercial_activity_level.dart';

/// 상권 정보를 화면에 어떻게 다룰지 정하는 3상태(R28, 설계 §6.2).
///
/// 서버는 두 값으로 말한다 — `commercial`의 부재 여부와 `isDefaulted`. 그 조합을
/// **여기서 한 번만 해석**하고 화면은 결과만 쓴다. 호출부마다 `commercial == null`과
/// `isDefaulted`를 다시 조합하게 두면, 한 곳만 빠뜨려도 39곳의 가짜 "보통"이 실측인
/// 척 새어 나간다(spec §4.5).
enum CommercialDisplayState {
  /// 서버 응답에 상권 정보가 없다. 121곳 중 39곳이 여기 해당한다.
  ///
  /// **조회 실패가 아니다** — "정보 없음"으로 표시하고 오류로 다루지 않는다.
  unavailable,

  /// 값은 왔지만 실측이 아니다(`isDefaulted: true`). 업스트림이 기준선 없는 구역에
  /// `보통 시간대`를 고정 반환한 자리표시자다.
  ///
  /// **단계를 신뢰 신호로 쓰지 않는다.** 실측과 같은 모양으로 그리면 사용자는 없는
  /// 정보를 있는 것으로 읽는다 — 그건 안 보여주는 것보다 나쁘다(spec §7.5).
  estimated,

  /// 실측값(`isDefaulted: false`). 단계를 그대로 표시한다.
  measured,
}

/// 구역의 상권 현황. 3상태 해석을 [state]로 확정해 들고 다닌다.
class CommercialStatus {
  const CommercialStatus({
    required this.level,
    required this.isDefaulted,
    required this.observedAt,
  });

  final CommercialActivityLevel level;
  final bool isDefaulted;

  /// 이 값이 갱신된 시각. **인구 블록과 다른 주기로 갱신된다**(spec §4.3) —
  /// 야간에는 전날 밤에 멈춰 있는 것이 관측됐다. 혼잡도의 기준 시각과 합쳐 하나로
  /// 표시하지 않는다(설계 §6.1).
  final DateTime observedAt;

  @override
  bool operator ==(Object other) =>
      other is CommercialStatus &&
      other.level == level &&
      other.isDefaulted == isDefaulted &&
      other.observedAt == observedAt;

  @override
  int get hashCode => Object.hash(level, isDefaulted, observedAt);
}

/// 서버가 준 상권 정보를 3상태로 해석한다(R28).
///
/// [status]가 null이면 [CommercialDisplayState.unavailable] — 부재는 실패가 아니다.
CommercialDisplayState commercialDisplayStateOf(CommercialStatus? status) {
  if (status == null) return CommercialDisplayState.unavailable;
  return status.isDefaulted
      ? CommercialDisplayState.estimated
      : CommercialDisplayState.measured;
}
