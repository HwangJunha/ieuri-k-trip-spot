import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/log/app_log.dart';
import 'package:logger/logger.dart';

void main() {
  group('appLogger', () {
    test('여섯 수준 모두 호출부에서 조건 없이 부를 수 있다', () {
      final Logger log = appLogger('AppLogTest');
      // 던지지 않는 것 자체가 계약이다 — 호출부가 `if (kDebugMode)`로 감싸지
      // 않아도 되도록 필터가 판단을 맡는다.
      expect(() => log.t('trace'), returnsNormally);
      expect(() => log.d('debug'), returnsNormally);
      expect(() => log.i('info'), returnsNormally);
      expect(() => log.w('warning'), returnsNormally);
      expect(() => log.e('error'), returnsNormally);
      expect(() => log.f('fatal'), returnsNormally);
    });

    test('오류와 스택트레이스를 명명 인자로 넘겨도 던지지 않는다', () {
      final Logger log = appLogger('AppLogTest');
      final StackTrace trace = StackTrace.current;
      expect(
        () => log.w('실패', error: StateError('boom'), stackTrace: trace),
        returnsNormally,
      );
      expect(
        () => log.e('실패', error: StateError('boom'), stackTrace: trace),
        returnsNormally,
      );
    });
  });

  group('AppLogPrinter', () {
    test('출처 이름을 대괄호로 앞에 붙인다', () {
      final List<String> lines = AppLogPrinter(
        'SwipeController',
      ).log(LogEvent(Level.warning, '큐가 비었다'));

      expect(lines.first, '[SwipeController] 큐가 비었다');
    });

    test('오류가 있으면 줄을 잇는다', () {
      final List<String> lines = AppLogPrinter(
        'Repo',
      ).log(LogEvent(Level.error, '조회 실패', error: StateError('boom')));

      expect(lines.first, '[Repo] 조회 실패');
      expect(lines[1], contains('boom'));
    });

    test('오류가 없으면 그 줄을 만들지 않는다', () {
      // 여러 줄로 늘어나면 실기기 로그에서 다른 로그와 뒤섞인다 — 필요한
      // 줄만 낸다.
      final List<String> lines = AppLogPrinter(
        'Repo',
      ).log(LogEvent(Level.info, '정상'));

      expect(lines, hasLength(1));
    });

    test('스택트레이스가 있으면 마지막 줄로 잇는다', () {
      final StackTrace trace = StackTrace.current;
      final List<String> lines = AppLogPrinter('Repo').log(
        LogEvent(
          Level.error,
          '실패',
          error: StateError('boom'),
          stackTrace: trace,
        ),
      );

      expect(lines, hasLength(3));
      expect(lines.last, trace.toString());
    });
  });
}
