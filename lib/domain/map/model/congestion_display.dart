import 'package:intl/intl.dart';

/// 구역 정보 표시에 쓰는 순수 포맷팅(R27).
///
/// **로케일 포맷팅은 클라이언트 몫이다**(spec §7.10) — 서버는 구역명 같은 데이터
/// 고유명사를 내려주고, 천 단위 구분과 시각 표기는 여기서 한다.
///
/// `intl`은 순수 Dart 패키지라 model에 둬도 계층 규칙에 어긋나지 않는다. 위젯 타입을
/// 들이지 않는다는 것이 §3의 요구다.
abstract final class CongestionDisplay {
  /// 기준 시각을 시:분으로 만든다(R27).
  ///
  /// **"지금"·"현재"에 해당하는 표현을 쓰지 않는다.** 데이터는 약 30분 지연되어
  /// 도착하므로(spec §4.2), 도착 시각을 현재로 읽히게 두면 사용자가 지금 붐빈다고
  /// 오해한다. 화면에서는 이 값을 `mapObservedAt`("{time} 기준")에 넣는다.
  ///
  /// 24시간제로 고정하지 않고 [locale]의 규칙을 따른다 — EN은 `3:30 PM`, KO는
  /// `오후 3:30`이 자연스럽다.
  static String observedAtLabel(DateTime observedAt, String locale) =>
      DateFormat.jm(locale).format(observedAt);

  /// 기준 시점을 **날짜와 함께** 만든다(SPEC-0015 R24).
  ///
  /// **[observedAtLabel]과 나누는 이유는 데이터의 성질이 다르기 때문이다.** 혼잡도는
  /// 약 30분 지연이라 항상 같은 날이지만, 지역 추천은 배치가 쌓은 데이터를 쓰므로
  /// 며칠 전이 기준일 수 있다. 시각만 보여주면 "오늘 오후 2시 30분"으로 읽혀 오히려
  /// 실시간이라는 오해를 키운다 — R24가 막으려는 바로 그 지점이다.
  static String dataBasisLabel(DateTime basisAt, String locale) =>
      DateFormat.yMMMd(locale).add_jm().format(basisAt);

  /// 추정 인구 범위의 하한·상한을 각각 천 단위로 끊어 준다(R27).
  ///
  /// 하나의 문자열로 합치지 않고 둘로 돌려주는 이유는, 구분자(`–`)와 단위(`명`)가
  /// 언어마다 다르기 때문이다 — 조립은 l10n의 `mapPopulationRange`가 한다.
  static ({String min, String max}) populationRange(
    int populationMin,
    int populationMax,
    String locale,
  ) {
    final NumberFormat format = NumberFormat.decimalPattern(locale);
    return (
      min: format.format(populationMin),
      max: format.format(populationMax),
    );
  }
}
