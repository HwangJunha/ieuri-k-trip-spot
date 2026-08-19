// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_registration_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 알림 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지 않는다).
/// 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.

@ProviderFor(alarmRepository)
const alarmRepositoryProvider = AlarmRepositoryProvider._();

/// 알림 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지 않는다).
/// 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.

final class AlarmRepositoryProvider
    extends
        $FunctionalProvider<AlarmRepository, AlarmRepository, AlarmRepository>
    with $Provider<AlarmRepository> {
  /// 알림 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지 않는다).
  /// 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
  const AlarmRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alarmRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alarmRepositoryHash();

  @$internal
  @override
  $ProviderElement<AlarmRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AlarmRepository create(Ref ref) {
    return alarmRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlarmRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlarmRepository>(value),
    );
  }
}

String _$alarmRepositoryHash() => r'aa939525f2c35106e939f9155df9ce32f6265bd8';

/// FCM 플러그인 경계.
///
/// **Firebase 초기화 여부로 구현체가 갈린다.** 설정 파일이 없으면 초기화가 실패하고
/// (`PushInitializer`가 삼킨다) 스텁이 선택되어 토큰을 발급하지 않는다 — 그 상태는
/// 사용자가 알림 권한을 거부했을 때와 같은 경로를 탄다(R14).
///
/// 초기화가 끝나기 전에 이 provider가 먼저 읽히면 스텁이 굳어 버리므로, `main()`이
/// `PushInitializer.ensureInitialized()`를 `runApp` 전에 기다린다.

@ProviderFor(pushMessagingService)
const pushMessagingServiceProvider = PushMessagingServiceProvider._();

/// FCM 플러그인 경계.
///
/// **Firebase 초기화 여부로 구현체가 갈린다.** 설정 파일이 없으면 초기화가 실패하고
/// (`PushInitializer`가 삼킨다) 스텁이 선택되어 토큰을 발급하지 않는다 — 그 상태는
/// 사용자가 알림 권한을 거부했을 때와 같은 경로를 탄다(R14).
///
/// 초기화가 끝나기 전에 이 provider가 먼저 읽히면 스텁이 굳어 버리므로, `main()`이
/// `PushInitializer.ensureInitialized()`를 `runApp` 전에 기다린다.

final class PushMessagingServiceProvider
    extends
        $FunctionalProvider<
          PushMessagingService,
          PushMessagingService,
          PushMessagingService
        >
    with $Provider<PushMessagingService> {
  /// FCM 플러그인 경계.
  ///
  /// **Firebase 초기화 여부로 구현체가 갈린다.** 설정 파일이 없으면 초기화가 실패하고
  /// (`PushInitializer`가 삼킨다) 스텁이 선택되어 토큰을 발급하지 않는다 — 그 상태는
  /// 사용자가 알림 권한을 거부했을 때와 같은 경로를 탄다(R14).
  ///
  /// 초기화가 끝나기 전에 이 provider가 먼저 읽히면 스텁이 굳어 버리므로, `main()`이
  /// `PushInitializer.ensureInitialized()`를 `runApp` 전에 기다린다.
  const PushMessagingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushMessagingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushMessagingServiceHash();

  @$internal
  @override
  $ProviderElement<PushMessagingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushMessagingService create(Ref ref) {
    return pushMessagingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushMessagingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushMessagingService>(value),
    );
  }
}

String _$pushMessagingServiceHash() =>
    r'3bf2afbc1aa6379c6d0f665d3dcb5528ba45be7b';

/// 기기 OS 언어 코드. 앱 언어 설정이 아니다 — 알림은 앱 밖에서 표시되므로 사용자가
/// 그 순간 읽는 언어는 OS 언어다(설계 §8).

@ProviderFor(deviceLanguageCode)
const deviceLanguageCodeProvider = DeviceLanguageCodeProvider._();

/// 기기 OS 언어 코드. 앱 언어 설정이 아니다 — 알림은 앱 밖에서 표시되므로 사용자가
/// 그 순간 읽는 언어는 OS 언어다(설계 §8).

final class DeviceLanguageCodeProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 기기 OS 언어 코드. 앱 언어 설정이 아니다 — 알림은 앱 밖에서 표시되므로 사용자가
  /// 그 순간 읽는 언어는 OS 언어다(설계 §8).
  const DeviceLanguageCodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceLanguageCodeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceLanguageCodeHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return deviceLanguageCode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$deviceLanguageCodeHash() =>
    r'b707d0bc28d91794ee04de1f922fb9e89216a7e5';

/// 이 기기의 플랫폼. 테스트가 갈아 끼울 수 있게 provider로 둔다 — `Platform`은
/// 위젯 테스트에서 흉내 낼 수 없다.

@ProviderFor(devicePlatform)
const devicePlatformProvider = DevicePlatformProvider._();

/// 이 기기의 플랫폼. 테스트가 갈아 끼울 수 있게 provider로 둔다 — `Platform`은
/// 위젯 테스트에서 흉내 낼 수 없다.

final class DevicePlatformProvider
    extends $FunctionalProvider<DevicePlatform, DevicePlatform, DevicePlatform>
    with $Provider<DevicePlatform> {
  /// 이 기기의 플랫폼. 테스트가 갈아 끼울 수 있게 provider로 둔다 — `Platform`은
  /// 위젯 테스트에서 흉내 낼 수 없다.
  const DevicePlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devicePlatformProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devicePlatformHash();

  @$internal
  @override
  $ProviderElement<DevicePlatform> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DevicePlatform create(Ref ref) {
    return devicePlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DevicePlatform value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DevicePlatform>(value),
    );
  }
}

String _$devicePlatformHash() => r'8f88cb9f28817a201f2858af05a00d971bef420d';

/// 기기 푸시 등록의 수명주기(SPEC-0028 R1·R2·R20).
///
/// **인증 전이는 이 notifier가 듣지 않는다.** `auth_controller`가 alarm을 알 이유가
/// 없으므로 방향을 뒤집어, 이것을 구독하는 쪽(`PushRegistrationGate`)이 인증 상태를
/// 보고 [register]·[unregister]를 부른다(설계 §3.2).
///
/// **실패는 전부 조용하다.** 등록이 실패해도 사용자에게 아무것도 보여주지 않고 로그만
/// 남기며, 즉시 재시도 루프를 만들지 않는다 — 재시도는 다음 기동 시점이다
/// (R12·AC12.3 · POL-040).

@ProviderFor(PushRegistrationController)
const pushRegistrationControllerProvider =
    PushRegistrationControllerProvider._();

/// 기기 푸시 등록의 수명주기(SPEC-0028 R1·R2·R20).
///
/// **인증 전이는 이 notifier가 듣지 않는다.** `auth_controller`가 alarm을 알 이유가
/// 없으므로 방향을 뒤집어, 이것을 구독하는 쪽(`PushRegistrationGate`)이 인증 상태를
/// 보고 [register]·[unregister]를 부른다(설계 §3.2).
///
/// **실패는 전부 조용하다.** 등록이 실패해도 사용자에게 아무것도 보여주지 않고 로그만
/// 남기며, 즉시 재시도 루프를 만들지 않는다 — 재시도는 다음 기동 시점이다
/// (R12·AC12.3 · POL-040).
final class PushRegistrationControllerProvider
    extends
        $NotifierProvider<PushRegistrationController, PushRegistrationOutcome> {
  /// 기기 푸시 등록의 수명주기(SPEC-0028 R1·R2·R20).
  ///
  /// **인증 전이는 이 notifier가 듣지 않는다.** `auth_controller`가 alarm을 알 이유가
  /// 없으므로 방향을 뒤집어, 이것을 구독하는 쪽(`PushRegistrationGate`)이 인증 상태를
  /// 보고 [register]·[unregister]를 부른다(설계 §3.2).
  ///
  /// **실패는 전부 조용하다.** 등록이 실패해도 사용자에게 아무것도 보여주지 않고 로그만
  /// 남기며, 즉시 재시도 루프를 만들지 않는다 — 재시도는 다음 기동 시점이다
  /// (R12·AC12.3 · POL-040).
  const PushRegistrationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRegistrationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRegistrationControllerHash();

  @$internal
  @override
  PushRegistrationController create() => PushRegistrationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushRegistrationOutcome value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushRegistrationOutcome>(value),
    );
  }
}

String _$pushRegistrationControllerHash() =>
    r'1bff004102066f4de111466c154636ec67479aac';

/// 기기 푸시 등록의 수명주기(SPEC-0028 R1·R2·R20).
///
/// **인증 전이는 이 notifier가 듣지 않는다.** `auth_controller`가 alarm을 알 이유가
/// 없으므로 방향을 뒤집어, 이것을 구독하는 쪽(`PushRegistrationGate`)이 인증 상태를
/// 보고 [register]·[unregister]를 부른다(설계 §3.2).
///
/// **실패는 전부 조용하다.** 등록이 실패해도 사용자에게 아무것도 보여주지 않고 로그만
/// 남기며, 즉시 재시도 루프를 만들지 않는다 — 재시도는 다음 기동 시점이다
/// (R12·AC12.3 · POL-040).

abstract class _$PushRegistrationController
    extends $Notifier<PushRegistrationOutcome> {
  PushRegistrationOutcome build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<PushRegistrationOutcome, PushRegistrationOutcome>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PushRegistrationOutcome, PushRegistrationOutcome>,
              PushRegistrationOutcome,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
