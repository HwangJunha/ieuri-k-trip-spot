// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 지금 시각. 테스트가 가짜 시계로 갈아끼우는 지점이다(설계 §테스트 —
/// **실제 시간을 기다리지 않는다**).

@ProviderFor(typingClock)
const typingClockProvider = TypingClockProvider._();

/// 지금 시각. 테스트가 가짜 시계로 갈아끼우는 지점이다(설계 §테스트 —
/// **실제 시간을 기다리지 않는다**).

final class TypingClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// 지금 시각. 테스트가 가짜 시계로 갈아끼우는 지점이다(설계 §테스트 —
  /// **실제 시간을 기다리지 않는다**).
  const TypingClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'typingClockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$typingClockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return typingClock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$typingClockHash() => r'79fd143b6dd9192044cd22b49f7c74c79ad0ea3a';

/// 상대의 "입력 중" 표시(R10).
///
/// **표시 해제를 이벤트가 아니라 타임아웃으로 판정한다**(AC10-4). 타이핑 이벤트는
/// 전달 보장이 없어 마지막 이벤트가 유실될 수 있고, 이벤트로만 켜고 끄면 그 순간
/// 화면이 "입력 중"에 갇힌다.
///
/// 구독 자체는 [FeedRepository.typingIndicator]가 준다. 재연결 후 과거 이벤트는
/// 오지 않는다 — 정상이다.

@ProviderFor(TypingIndicatorController)
const typingIndicatorControllerProvider = TypingIndicatorControllerFamily._();

/// 상대의 "입력 중" 표시(R10).
///
/// **표시 해제를 이벤트가 아니라 타임아웃으로 판정한다**(AC10-4). 타이핑 이벤트는
/// 전달 보장이 없어 마지막 이벤트가 유실될 수 있고, 이벤트로만 켜고 끄면 그 순간
/// 화면이 "입력 중"에 갇힌다.
///
/// 구독 자체는 [FeedRepository.typingIndicator]가 준다. 재연결 후 과거 이벤트는
/// 오지 않는다 — 정상이다.
final class TypingIndicatorControllerProvider
    extends $NotifierProvider<TypingIndicatorController, TypingIndicator?> {
  /// 상대의 "입력 중" 표시(R10).
  ///
  /// **표시 해제를 이벤트가 아니라 타임아웃으로 판정한다**(AC10-4). 타이핑 이벤트는
  /// 전달 보장이 없어 마지막 이벤트가 유실될 수 있고, 이벤트로만 켜고 끄면 그 순간
  /// 화면이 "입력 중"에 갇힌다.
  ///
  /// 구독 자체는 [FeedRepository.typingIndicator]가 준다. 재연결 후 과거 이벤트는
  /// 오지 않는다 — 정상이다.
  const TypingIndicatorControllerProvider._({
    required TypingIndicatorControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'typingIndicatorControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$typingIndicatorControllerHash();

  @override
  String toString() {
    return r'typingIndicatorControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TypingIndicatorController create() => TypingIndicatorController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TypingIndicator? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TypingIndicator?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TypingIndicatorControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$typingIndicatorControllerHash() =>
    r'5ad4411a1da170b1b5bf57ae70c3a906a7a71cfd';

/// 상대의 "입력 중" 표시(R10).
///
/// **표시 해제를 이벤트가 아니라 타임아웃으로 판정한다**(AC10-4). 타이핑 이벤트는
/// 전달 보장이 없어 마지막 이벤트가 유실될 수 있고, 이벤트로만 켜고 끄면 그 순간
/// 화면이 "입력 중"에 갇힌다.
///
/// 구독 자체는 [FeedRepository.typingIndicator]가 준다. 재연결 후 과거 이벤트는
/// 오지 않는다 — 정상이다.

final class TypingIndicatorControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TypingIndicatorController,
          TypingIndicator?,
          TypingIndicator?,
          TypingIndicator?,
          String
        > {
  const TypingIndicatorControllerFamily._()
    : super(
        retry: null,
        name: r'typingIndicatorControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 상대의 "입력 중" 표시(R10).
  ///
  /// **표시 해제를 이벤트가 아니라 타임아웃으로 판정한다**(AC10-4). 타이핑 이벤트는
  /// 전달 보장이 없어 마지막 이벤트가 유실될 수 있고, 이벤트로만 켜고 끄면 그 순간
  /// 화면이 "입력 중"에 갇힌다.
  ///
  /// 구독 자체는 [FeedRepository.typingIndicator]가 준다. 재연결 후 과거 이벤트는
  /// 오지 않는다 — 정상이다.

  TypingIndicatorControllerProvider call(String conversationId) =>
      TypingIndicatorControllerProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'typingIndicatorControllerProvider';
}

/// 상대의 "입력 중" 표시(R10).
///
/// **표시 해제를 이벤트가 아니라 타임아웃으로 판정한다**(AC10-4). 타이핑 이벤트는
/// 전달 보장이 없어 마지막 이벤트가 유실될 수 있고, 이벤트로만 켜고 끄면 그 순간
/// 화면이 "입력 중"에 갇힌다.
///
/// 구독 자체는 [FeedRepository.typingIndicator]가 준다. 재연결 후 과거 이벤트는
/// 오지 않는다 — 정상이다.

abstract class _$TypingIndicatorController extends $Notifier<TypingIndicator?> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  TypingIndicator? build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<TypingIndicator?, TypingIndicator?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TypingIndicator?, TypingIndicator?>,
              TypingIndicator?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 내가 입력 중임을 상대에게 알린다(R10).
///
/// **일정 간격으로 throttle한다**(설계 §5) — 키 입력마다 보내지 않는다. 실패해도
/// 재시도하지 않는 것이 정상이다(AC10-2): 받을 사람이 없는 것은 실패가 아니고,
/// 유실 허용 기능을 살리려고 큐를 두지 않는다(POL-048).

@ProviderFor(TypingSignal)
const typingSignalProvider = TypingSignalFamily._();

/// 내가 입력 중임을 상대에게 알린다(R10).
///
/// **일정 간격으로 throttle한다**(설계 §5) — 키 입력마다 보내지 않는다. 실패해도
/// 재시도하지 않는 것이 정상이다(AC10-2): 받을 사람이 없는 것은 실패가 아니고,
/// 유실 허용 기능을 살리려고 큐를 두지 않는다(POL-048).
final class TypingSignalProvider extends $NotifierProvider<TypingSignal, int> {
  /// 내가 입력 중임을 상대에게 알린다(R10).
  ///
  /// **일정 간격으로 throttle한다**(설계 §5) — 키 입력마다 보내지 않는다. 실패해도
  /// 재시도하지 않는 것이 정상이다(AC10-2): 받을 사람이 없는 것은 실패가 아니고,
  /// 유실 허용 기능을 살리려고 큐를 두지 않는다(POL-048).
  const TypingSignalProvider._({
    required TypingSignalFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'typingSignalProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$typingSignalHash();

  @override
  String toString() {
    return r'typingSignalProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TypingSignal create() => TypingSignal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TypingSignalProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$typingSignalHash() => r'685253e31c5c95111e58f87e99df1cf7029d938d';

/// 내가 입력 중임을 상대에게 알린다(R10).
///
/// **일정 간격으로 throttle한다**(설계 §5) — 키 입력마다 보내지 않는다. 실패해도
/// 재시도하지 않는 것이 정상이다(AC10-2): 받을 사람이 없는 것은 실패가 아니고,
/// 유실 허용 기능을 살리려고 큐를 두지 않는다(POL-048).

final class TypingSignalFamily extends $Family
    with $ClassFamilyOverride<TypingSignal, int, int, int, String> {
  const TypingSignalFamily._()
    : super(
        retry: null,
        name: r'typingSignalProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 내가 입력 중임을 상대에게 알린다(R10).
  ///
  /// **일정 간격으로 throttle한다**(설계 §5) — 키 입력마다 보내지 않는다. 실패해도
  /// 재시도하지 않는 것이 정상이다(AC10-2): 받을 사람이 없는 것은 실패가 아니고,
  /// 유실 허용 기능을 살리려고 큐를 두지 않는다(POL-048).

  TypingSignalProvider call(String conversationId) =>
      TypingSignalProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'typingSignalProvider';
}

/// 내가 입력 중임을 상대에게 알린다(R10).
///
/// **일정 간격으로 throttle한다**(설계 §5) — 키 입력마다 보내지 않는다. 실패해도
/// 재시도하지 않는 것이 정상이다(AC10-2): 받을 사람이 없는 것은 실패가 아니고,
/// 유실 허용 기능을 살리려고 큐를 두지 않는다(POL-048).

abstract class _$TypingSignal extends $Notifier<int> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  int build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
