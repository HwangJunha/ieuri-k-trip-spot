/// 상대 시각의 단위. 표시 문자열은 이 값을 받아 **위젯 계층이 l10n으로** 만든다 —
/// 모델은 순수 Dart라 번역을 알지 못한다(CLAUDE.md §3).
enum RelativeTimeUnit {
  /// 1분 미만. [RelativeTime.count]는 0이며 화면은 "방금"을 그린다.
  justNow,
  minutes,
  hours,
  days,
  months,
  years,
}

/// "얼마나 지났는가"를 단위와 개수로 나눈 값(SPEC-0010).
///
/// **문자열을 만들지 않는다.** 모델에 l10n을 들이면 순수성이 깨지고(CLAUDE.md §3)
/// 언어를 바꿀 때 모델 테스트가 함께 깨진다. 여기서는 어느 버킷에 떨어지는지만
/// 정하고, `communityRelativeTimeLabel`이 그 값을 문구로 옮긴다.
class RelativeTime {
  const RelativeTime(this.unit, this.count);

  final RelativeTimeUnit unit;

  /// 단위 개수. [RelativeTimeUnit.justNow]면 0이다.
  final int count;

  @override
  bool operator ==(Object other) =>
      other is RelativeTime && other.unit == unit && other.count == count;

  @override
  int get hashCode => Object.hash(unit, count);

  @override
  String toString() => 'RelativeTime($unit, $count)';
}

/// 한 달을 며칠로 볼 것인가. 달력 연산이 아니라 **피드의 근사 표기**라 고정값을
/// 쓴다 — "3개월 전"이 하루 이틀 어긋나도 사용자가 얻는 정보는 같고, 달력을 따르면
/// 같은 글이 기준 시각에 따라 다른 개월로 보인다.
const int _daysPerMonth = 30;

/// 한 해를 며칠로 볼 것인가. 위와 같은 이유로 윤년을 따지지 않는다.
const int _daysPerYear = 365;

/// [createdAt]이 [now] 기준으로 얼마나 지났는지 버킷으로 나눈다.
///
/// 경계는 다음과 같다:
///
/// | 경과 | 결과 |
/// |---|---|
/// | 1분 미만 | [RelativeTimeUnit.justNow] |
/// | 1시간 미만 | 분 |
/// | 24시간 미만 | 시간 |
/// | 30일 미만 | 일 |
/// | 1년 미만 | 개월 |
/// | 1년 이상 | 년 |
///
/// **미래 시각은 "방금"으로 접는다** — 서버 시계가 앞서면 경과가 음수로 나오는데,
/// "-3분 전"을 보여주는 것보다 낫다.
RelativeTime relativeTimeSince(DateTime createdAt, DateTime now) {
  final Duration elapsed = now.difference(createdAt);
  if (elapsed.inMinutes < 1) {
    return const RelativeTime(RelativeTimeUnit.justNow, 0);
  }
  if (elapsed.inHours < 1) {
    return RelativeTime(RelativeTimeUnit.minutes, elapsed.inMinutes);
  }
  if (elapsed.inHours < 24) {
    return RelativeTime(RelativeTimeUnit.hours, elapsed.inHours);
  }

  final int days = elapsed.inDays;
  if (days < _daysPerMonth) return RelativeTime(RelativeTimeUnit.days, days);
  if (days < _daysPerYear) {
    return RelativeTime(RelativeTimeUnit.months, days ~/ _daysPerMonth);
  }
  return RelativeTime(RelativeTimeUnit.years, days ~/ _daysPerYear);
}
