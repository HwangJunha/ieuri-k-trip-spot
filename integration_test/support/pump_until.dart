import 'package:flutter_test/flutter_test.dart';

/// 조건이 참이 될 때까지 짧게 반복 pump한다(e2e-flow-testing skill §5 — 고정 시간
/// 대기 금지). 조건이 [timeout] 안에 참이 되지 않으면 테스트가 실패한다(응답 없는
/// 네트워크에 무기한 매달리지 않는다).
extension PumpUntilExtension on WidgetTester {
  Future<void> pumpUntilFinder(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration step = const Duration(milliseconds: 100),
  }) => pumpUntil(() => any(finder), timeout: timeout, step: step);

  Future<void> pumpUntil(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 10),
    Duration step = const Duration(milliseconds: 100),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (!condition()) {
      if (DateTime.now().isAfter(deadline)) {
        fail('pumpUntil timed out after $timeout waiting for condition');
      }
      await pump(step);
    }
  }

  bool any(Finder finder) => finder.evaluate().isNotEmpty;
}
