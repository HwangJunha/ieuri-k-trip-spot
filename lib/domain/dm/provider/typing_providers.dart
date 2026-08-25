import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/typing_indicator.dart';
import 'dm_providers.dart';

part 'typing_providers.g.dart';

/// 마지막 타이핑 이벤트 이후 이만큼 지나면 표시를 내린다(AC10-4).
///
/// 서버가 "멈췄다"는 이벤트를 보내주기를 기다리지 않는다 — 그 이벤트는 유실될 수
/// 있고, 그러면 화면이 영원히 "입력 중"에 갇힌다.
const Duration typingIndicatorTimeout = Duration(seconds: 5);

/// `notifyTyping`을 보내는 최소 간격(설계 §5).
///
/// **키 입력마다 보내지 않는다.** 타이핑은 초당 여러 번 발생하고, 그때마다 뮤테이션을
/// 보내면 유실 허용 기능 하나가 대역폭을 독차지한다.
const Duration typingNotifyThrottle = Duration(seconds: 3);

/// 지금 시각. 테스트가 가짜 시계로 갈아끼우는 지점이다(설계 §테스트 —
/// **실제 시간을 기다리지 않는다**).
@riverpod
DateTime Function() typingClock(Ref ref) => DateTime.now;

/// 상대의 "입력 중" 표시(R10).
///
/// **표시 해제를 이벤트가 아니라 타임아웃으로 판정한다**(AC10-4). 타이핑 이벤트는
/// 전달 보장이 없어 마지막 이벤트가 유실될 수 있고, 이벤트로만 켜고 끄면 그 순간
/// 화면이 "입력 중"에 갇힌다.
///
/// 구독 자체는 [DmRepository.typingIndicator]가 준다. 재연결 후 과거 이벤트는
/// 오지 않는다 — 정상이다.
@riverpod
class TypingIndicatorController extends _$TypingIndicatorController {
  Timer? _expiry;

  @override
  TypingIndicator? build(String conversationId) {
    final StreamSubscription<TypingIndicator> subscription = ref
        .watch(dmRepositoryProvider)
        .typingIndicator(conversationId)
        .listen(_onEvent, onError: _onStreamError);

    ref.onDispose(() {
      _expiry?.cancel();
      subscription.cancel();
    });

    // 처음에는 아무도 입력 중이 아니다.
    return null;
  }

  void _onEvent(TypingIndicator event) {
    final DateTime now = ref.read(typingClockProvider)();

    // 이미 만료된 이벤트는 켜지 않는다 — 전달이 지연된 이벤트로 표시를 되살리면
    // 상대가 멈춘 뒤에도 "입력 중"이 다시 뜬다.
    if (!event.isActiveAt(now, typingIndicatorTimeout)) return;

    state = event;
    _scheduleExpiry(now.difference(event.emittedAt));
  }

  /// 구독이 끊겨도 **표시를 켠 채 두지 않는다.** 스트림 오류는 재연결 대상이지
  /// 입력 중 상태의 근거가 아니다.
  ///
  /// **여기서 재구독을 시도하지 않는다.** 소켓이 다시 붙으면 라이브러리가 구독을
  /// 자동으로 복원하므로 이쪽이 따로 셀 것이 없고, 재연결 상한은 소켓 계층이
  /// 쥔다(`graphql_socket_client.dart`의 `pauseSocketReconnect`) — 상한에 닿으면
  /// 소켓이 멈추므로 이 구독도 함께 조용해진다.
  void _onStreamError(Object error, StackTrace stackTrace) {
    _expiry?.cancel();
    state = null;
  }

  /// 남은 시간만큼만 타이머를 잡는다. 이벤트가 늦게 도착했으면 그만큼 빨리 꺼진다.
  void _scheduleExpiry(Duration elapsed) {
    _expiry?.cancel();
    final Duration remaining = typingIndicatorTimeout - elapsed;
    if (remaining <= Duration.zero) {
      state = null;
      return;
    }
    _expiry = Timer(remaining, () => state = null);
  }

  /// 타임아웃이 지났는지 지금 시각으로 다시 판정한다.
  ///
  /// 타이머와 **중복이 아니다** — 앱이 백그라운드에 있는 동안 타이머가 지연되면
  /// 복귀 시점에 만료된 표시가 남아 있을 수 있다. 화면이 다시 보일 때 이걸 부른다.
  void refresh() {
    final TypingIndicator? current = state;
    if (current == null) return;
    final DateTime now = ref.read(typingClockProvider)();
    if (!current.isActiveAt(now, typingIndicatorTimeout)) {
      _expiry?.cancel();
      state = null;
    }
  }
}

/// 내가 입력 중임을 상대에게 알린다(R10).
///
/// **일정 간격으로 throttle한다**(설계 §5) — 키 입력마다 보내지 않는다. 실패해도
/// 재시도하지 않는 것이 정상이다(AC10-2): 받을 사람이 없는 것은 실패가 아니고,
/// 유실 허용 기능을 살리려고 큐를 두지 않는다(POL-048).
@riverpod
class TypingSignal extends _$TypingSignal {
  /// 마지막으로 실제 전송한 시각(UTC epoch 마이크로초). 0이면 아직 보낸 적이 없다.
  ///
  /// `DateTime?`이 아니라 정수인 것은 생성기가 nullable 상태의 notifier를 만들지
  /// 못해서다 — 표현이 아니라 도구의 제약이다.
  @override
  int build(String conversationId) => 0;

  Future<void> notify() async {
    final DateTime now = ref.read(typingClockProvider)();
    if (state != 0) {
      final DateTime last = DateTime.fromMicrosecondsSinceEpoch(
        state,
        isUtc: true,
      );
      if (now.toUtc().difference(last) < typingNotifyThrottle) return;
    }
    state = now.toUtc().microsecondsSinceEpoch;

    try {
      await ref.read(dmRepositoryProvider).notifyTyping(conversationId);
    } on Object {
      // 삼킨다 — 타이핑 알림 실패는 사용자에게 알릴 것이 없다.
    }
  }
}
