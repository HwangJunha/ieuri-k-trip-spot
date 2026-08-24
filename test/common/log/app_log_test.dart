import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/log/app_log.dart';

void main() {
  group('LogLevel', () {
    test('수준이 logback과 같은 순서로 커진다', () {
      expect(LogLevel.debug.value, lessThan(LogLevel.info.value));
      expect(LogLevel.info.value, lessThan(LogLevel.warn.value));
      expect(LogLevel.warn.value, lessThan(LogLevel.error.value));
    });

    test('dart:developer/package:logging 관례 값을 쓴다', () {
      // DevTools가 이 눈금으로 색을 칠하므로 임의 값을 쓰면 안 된다.
      expect(LogLevel.debug.value, 500);
      expect(LogLevel.info.value, 800);
      expect(LogLevel.warn.value, 900);
      expect(LogLevel.error.value, 1000);
    });
  });

  group('AppLog', () {
    test('네 수준 모두 호출부에서 조건 없이 부를 수 있다', () {
      const AppLog log = AppLog('AppLogTest');
      // 던지지 않는 것 자체가 계약이다 — 호출부가 `if (kDebugMode)`로 감싸지
      // 않아도 되도록 만든 로거이므로, 어떤 수준이든 그냥 불릴 수 있어야 한다.
      expect(() => log.debug('debug'), returnsNormally);
      expect(() => log.info('info'), returnsNormally);
      expect(() => log.warn('warn'), returnsNormally);
      expect(() => log.error('error'), returnsNormally);
    });

    test('오류와 스택트레이스를 함께 넘겨도 던지지 않는다', () {
      const AppLog log = AppLog('AppLogTest');
      final StackTrace trace = StackTrace.current;
      expect(
        () => log.warn('실패', StateError('boom'), trace),
        returnsNormally,
      );
      expect(
        () => log.error('실패', StateError('boom'), trace),
        returnsNormally,
      );
    });

    test('const로 만들 수 있다 — 클래스마다 static const 필드로 두는 방식', () {
      // 호출부가 `static const AppLog _log = AppLog('X');`로 선언하므로
      // const 생성이 가능해야 한다.
      const AppLog a = AppLog('X');
      const AppLog b = AppLog('X');
      expect(identical(a, b), isTrue);
    });
  });
}
