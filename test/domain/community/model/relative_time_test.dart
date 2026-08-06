import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/relative_time.dart';

/// 버킷 경계만 검증한다. 표시 문자열은 위젯 계층(l10n)의 몫이라 여기서 다루지 않는다.
void main() {
  final DateTime now = DateTime.utc(2026, 8, 6, 12);

  RelativeTime at(Duration ago) => relativeTimeSince(now.subtract(ago), now);

  test('1분 미만은 방금이다', () {
    expect(
      at(const Duration(seconds: 59)),
      const RelativeTime(RelativeTimeUnit.justNow, 0),
    );
  });

  test('서버 시계가 앞서 미래 시각이 와도 방금으로 접는다', () {
    expect(
      relativeTimeSince(now.add(const Duration(minutes: 5)), now),
      const RelativeTime(RelativeTimeUnit.justNow, 0),
    );
  });

  test('1시간 미만은 분 단위다', () {
    expect(
      at(const Duration(minutes: 59)),
      const RelativeTime(RelativeTimeUnit.minutes, 59),
    );
  });

  test('정확히 1시간이면 시간 단위로 넘어간다', () {
    expect(
      at(const Duration(hours: 1)),
      const RelativeTime(RelativeTimeUnit.hours, 1),
    );
  });

  test('24시간 미만은 시간 단위다', () {
    expect(
      at(const Duration(hours: 23)),
      const RelativeTime(RelativeTimeUnit.hours, 23),
    );
  });

  test('정확히 24시간이면 일 단위로 넘어간다', () {
    expect(
      at(const Duration(hours: 24)),
      const RelativeTime(RelativeTimeUnit.days, 1),
    );
  });

  test('30일 미만은 일 단위다', () {
    expect(
      at(const Duration(days: 29)),
      const RelativeTime(RelativeTimeUnit.days, 29),
    );
  });

  test('30일부터는 개월 단위다', () {
    expect(
      at(const Duration(days: 30)),
      const RelativeTime(RelativeTimeUnit.months, 1),
    );
  });

  test('1년 미만은 개월 단위로 남는다', () {
    // 364일 ÷ 30 = 12개월. 아직 해를 넘기지 않았다.
    expect(
      at(const Duration(days: 364)),
      const RelativeTime(RelativeTimeUnit.months, 12),
    );
  });

  test('365일부터는 년 단위다', () {
    expect(
      at(const Duration(days: 365)),
      const RelativeTime(RelativeTimeUnit.years, 1),
    );
  });

  test('2년이 지나면 2년으로 센다', () {
    expect(
      at(const Duration(days: 800)),
      const RelativeTime(RelativeTimeUnit.years, 2),
    );
  });
}
