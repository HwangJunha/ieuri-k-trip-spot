// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_deep_link_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 백그라운드에서 알림을 탭해 돌아온 경우의 목적지(R16).
///
/// 포그라운드 수신은 여기 흐르지 않는다 — 배너도 띄우지 않고 화면도 바꾸지 않는다
/// (R15·AC15.2).

@ProviderFor(pushNotificationTaps)
const pushNotificationTapsProvider = PushNotificationTapsProvider._();

/// 백그라운드에서 알림을 탭해 돌아온 경우의 목적지(R16).
///
/// 포그라운드 수신은 여기 흐르지 않는다 — 배너도 띄우지 않고 화면도 바꾸지 않는다
/// (R15·AC15.2).

final class PushNotificationTapsProvider
    extends $FunctionalProvider<PushTapStream, PushTapStream, PushTapStream>
    with $Provider<PushTapStream> {
  /// 백그라운드에서 알림을 탭해 돌아온 경우의 목적지(R16).
  ///
  /// 포그라운드 수신은 여기 흐르지 않는다 — 배너도 띄우지 않고 화면도 바꾸지 않는다
  /// (R15·AC15.2).
  const PushNotificationTapsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushNotificationTapsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotificationTapsHash();

  @$internal
  @override
  $ProviderElement<PushTapStream> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushTapStream create(Ref ref) {
    return pushNotificationTaps(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushTapStream value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushTapStream>(value),
    );
  }
}

String _$pushNotificationTapsHash() =>
    r'c95c8088ed33316e6ad9defb804295d338a8f04c';

/// 앱이 **종료 상태**에서 알림 탭으로 기동된 경우의 목적지(R17). 그런 경우가 아니면
/// null이다.

@ProviderFor(pushInitialDestination)
const pushInitialDestinationProvider = PushInitialDestinationProvider._();

/// 앱이 **종료 상태**에서 알림 탭으로 기동된 경우의 목적지(R17). 그런 경우가 아니면
/// null이다.

final class PushInitialDestinationProvider
    extends
        $FunctionalProvider<
          AsyncValue<PushDestination?>,
          PushDestination?,
          FutureOr<PushDestination?>
        >
    with $FutureModifier<PushDestination?>, $FutureProvider<PushDestination?> {
  /// 앱이 **종료 상태**에서 알림 탭으로 기동된 경우의 목적지(R17). 그런 경우가 아니면
  /// null이다.
  const PushInitialDestinationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushInitialDestinationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushInitialDestinationHash();

  @$internal
  @override
  $FutureProviderElement<PushDestination?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PushDestination?> create(Ref ref) {
    return pushInitialDestination(ref);
  }
}

String _$pushInitialDestinationHash() =>
    r'c2fc20c3ac21393a7a8b3a5b58ed2ba28a202a7d';
