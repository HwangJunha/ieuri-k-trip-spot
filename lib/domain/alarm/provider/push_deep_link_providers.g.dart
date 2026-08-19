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

/// FCM이 토큰을 새로 발급했을 때 흐른다(서버 안내 §2 — 재등록 시점 중 하나).

@ProviderFor(pushTokenRefreshes)
const pushTokenRefreshesProvider = PushTokenRefreshesProvider._();

/// FCM이 토큰을 새로 발급했을 때 흐른다(서버 안내 §2 — 재등록 시점 중 하나).

final class PushTokenRefreshesProvider
    extends
        $FunctionalProvider<
          PushTokenRefreshStream,
          PushTokenRefreshStream,
          PushTokenRefreshStream
        >
    with $Provider<PushTokenRefreshStream> {
  /// FCM이 토큰을 새로 발급했을 때 흐른다(서버 안내 §2 — 재등록 시점 중 하나).
  const PushTokenRefreshesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTokenRefreshesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTokenRefreshesHash();

  @$internal
  @override
  $ProviderElement<PushTokenRefreshStream> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushTokenRefreshStream create(Ref ref) {
    return pushTokenRefreshes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushTokenRefreshStream value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushTokenRefreshStream>(value),
    );
  }
}

String _$pushTokenRefreshesHash() =>
    r'970641f12953c0caf6b2414cbb2c6a72a935aa0a';

/// 앱 전체에 한 번 하는 알림 준비 — Android 채널 2개 생성과 포그라운드 알림 표시
/// (설계 §5·§6).
///
/// **인증과 무관하다.** 로그인하지 않아도 채널은 있어야 하고, 표시 설정은 앱 전체
/// 설정이다. 그래서 등록 흐름(R1)이 아니라 별도 provider로 둔다.
///
/// 실패는 서비스 구현이 이미 삼킨다 — 채널이 없으면 Android에서 알림이 표시되지 않을
/// 뿐 앱은 정상 동작한다.

@ProviderFor(pushNotificationSetup)
const pushNotificationSetupProvider = PushNotificationSetupProvider._();

/// 앱 전체에 한 번 하는 알림 준비 — Android 채널 2개 생성과 포그라운드 알림 표시
/// (설계 §5·§6).
///
/// **인증과 무관하다.** 로그인하지 않아도 채널은 있어야 하고, 표시 설정은 앱 전체
/// 설정이다. 그래서 등록 흐름(R1)이 아니라 별도 provider로 둔다.
///
/// 실패는 서비스 구현이 이미 삼킨다 — 채널이 없으면 Android에서 알림이 표시되지 않을
/// 뿐 앱은 정상 동작한다.

final class PushNotificationSetupProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// 앱 전체에 한 번 하는 알림 준비 — Android 채널 2개 생성과 포그라운드 알림 표시
  /// (설계 §5·§6).
  ///
  /// **인증과 무관하다.** 로그인하지 않아도 채널은 있어야 하고, 표시 설정은 앱 전체
  /// 설정이다. 그래서 등록 흐름(R1)이 아니라 별도 provider로 둔다.
  ///
  /// 실패는 서비스 구현이 이미 삼킨다 — 채널이 없으면 Android에서 알림이 표시되지 않을
  /// 뿐 앱은 정상 동작한다.
  const PushNotificationSetupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushNotificationSetupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotificationSetupHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return pushNotificationSetup(ref);
  }
}

String _$pushNotificationSetupHash() =>
    r'3ee65fb87f296f55a6c11f695836be9727e40844';

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
