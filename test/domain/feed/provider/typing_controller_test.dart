import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/typing_indicator.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/feed_providers.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/typing_providers.dart';

import '../feed_test_doubles.dart';

const String _cid = 'c1';

/// 가짜 시계 — 테스트가 손으로 시간을 옮긴다. **실제 시간을 기다리지 않는다.**
class _FakeClock {
  DateTime now = DateTime.utc(2026, 8, 12, 10);

  void advance(Duration d) => now = now.add(d);

  DateTime call() => now;
}

ProviderContainer _container(FakeFeedRepository repo, _FakeClock clock) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      feedRepositoryProvider.overrideWithValue(repo),
      typingClockProvider.overrideWithValue(clock.call),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('타이핑 표시 (R10)', () {
    test('이벤트를 받으면 표시가 켜진다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final _FakeClock clock = _FakeClock();
      final ProviderContainer container = _container(repo, clock);
      container.listen(
        typingIndicatorControllerProvider(_cid),
        (_, _) {},
        fireImmediately: true,
      );

      repo.typingEvents.add(
        TypingIndicator(sender: author('other'), emittedAt: clock.now),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(typingIndicatorControllerProvider(_cid))?.sender.id,
        'other',
      );
    });

    test('타임아웃이 지나면 refresh가 표시를 내린다 (AC10-4)', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final _FakeClock clock = _FakeClock();
      final ProviderContainer container = _container(repo, clock);
      container.listen(
        typingIndicatorControllerProvider(_cid),
        (_, _) {},
        fireImmediately: true,
      );

      repo.typingEvents.add(
        TypingIndicator(sender: author('other'), emittedAt: clock.now),
      );
      await Future<void>.delayed(Duration.zero);
      expect(container.read(typingIndicatorControllerProvider(_cid)), isNotNull);

      // 후속 이벤트 없이 시간만 흘렀다 — 서버의 "멈췄다" 이벤트를 기다리지 않는다.
      clock.advance(typingIndicatorTimeout + const Duration(seconds: 1));
      container.read(typingIndicatorControllerProvider(_cid).notifier).refresh();

      expect(container.read(typingIndicatorControllerProvider(_cid)), isNull);
    });

    test('이미 만료된 이벤트는 표시를 켜지 않는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final _FakeClock clock = _FakeClock();
      final ProviderContainer container = _container(repo, clock);
      container.listen(
        typingIndicatorControllerProvider(_cid),
        (_, _) {},
        fireImmediately: true,
      );

      // 전달이 지연돼 도착한 낡은 이벤트.
      repo.typingEvents.add(
        TypingIndicator(
          sender: author('other'),
          emittedAt: clock.now.subtract(const Duration(minutes: 1)),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(container.read(typingIndicatorControllerProvider(_cid)), isNull);
    });

    test('구독이 끊기면 표시를 켠 채 두지 않는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final _FakeClock clock = _FakeClock();
      final ProviderContainer container = _container(repo, clock);
      container.listen(
        typingIndicatorControllerProvider(_cid),
        (_, _) {},
        fireImmediately: true,
      );
      repo.typingEvents.add(
        TypingIndicator(sender: author('other'), emittedAt: clock.now),
      );
      await Future<void>.delayed(Duration.zero);

      repo.typingEvents.addError(StateError('socket closed'));
      await Future<void>.delayed(Duration.zero);

      expect(container.read(typingIndicatorControllerProvider(_cid)), isNull);
    });
  });

  group('타이핑 알림 throttle (설계 §5)', () {
    test('간격 안에서는 한 번만 보낸다 — 키 입력마다 보내지 않는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final _FakeClock clock = _FakeClock();
      final ProviderContainer container = _container(repo, clock);
      final TypingSignal notifier = container.read(
        typingSignalProvider(_cid).notifier,
      );

      await notifier.notify();
      await notifier.notify();
      await notifier.notify();

      expect(repo.notifyTypingCalls, 1);
    });

    test('간격이 지나면 다시 보낸다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final _FakeClock clock = _FakeClock();
      final ProviderContainer container = _container(repo, clock);
      final TypingSignal notifier = container.read(
        typingSignalProvider(_cid).notifier,
      );

      await notifier.notify();
      clock.advance(typingNotifyThrottle + const Duration(seconds: 1));
      await notifier.notify();

      expect(repo.notifyTypingCalls, 2);
    });
  });
}
