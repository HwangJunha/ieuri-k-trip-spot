import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/typing_indicator.dart';

import '../dm_test_doubles.dart';

/// 가짜 시계 — **실제 시간을 기다리지 않는다**(설계 §테스트).
final DateTime _t0 = DateTime.utc(2026, 8, 12, 10);

TypingIndicator _event({Duration ago = Duration.zero}) =>
    TypingIndicator(sender: author('other'), emittedAt: _t0.subtract(ago));

void main() {
  group('타임아웃 자동 해제 (R10 — AC10-4)', () {
    const Duration timeout = Duration(seconds: 5);

    test('방금 온 이벤트는 유효하다', () {
      expect(_event().isActiveAt(_t0, timeout), isTrue);
    });

    test('타임아웃이 지나면 표시가 해제된다', () {
      // 후속 이벤트가 끊긴 채 시간이 흘렀다 — 서버의 "멈췄다" 이벤트를 기다리지
      // 않고 스스로 내린다.
      expect(
        _event().isActiveAt(_t0.add(const Duration(seconds: 6)), timeout),
        isFalse,
      );
    });

    test('경계에서는 아직 유효하다', () {
      expect(
        _event().isActiveAt(_t0.add(const Duration(seconds: 5)), timeout),
        isTrue,
      );
    });

    test('경계를 1밀리초라도 넘으면 해제된다', () {
      expect(
        _event().isActiveAt(
          _t0.add(const Duration(seconds: 5, milliseconds: 1)),
          timeout,
        ),
        isFalse,
      );
    });

    test('전달이 지연돼 이미 만료된 이벤트는 켜지지 않는다', () {
      // emittedAt이 수신 시각이 아니라 발생 시각이라 이 판정이 가능하다.
      expect(
        _event(ago: const Duration(seconds: 10)).isActiveAt(_t0, timeout),
        isFalse,
      );
    });
  });
}
