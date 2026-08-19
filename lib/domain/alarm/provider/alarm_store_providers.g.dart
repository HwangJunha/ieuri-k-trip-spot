// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_store_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 알림 도메인의 로컬 저장소 provider(SPEC-0028 R20).
///
/// 저장소 배선만 이 파일에 모은다 — 등록 판단은 `push_registration_controller.dart`가
/// 하고, 그쪽은 인터페이스만 안다(CLAUDE.md §3).
///
/// 두 저장소 모두 비밀값을 담지 않는다: 하나는 기기 식별자, 하나는 되돌릴 수 없는
/// 지문이다. 비밀값은 `common/storage/SecureStorage`가 담당한다(CLAUDE.md §7).

@ProviderFor(deviceIdStore)
const deviceIdStoreProvider = DeviceIdStoreProvider._();

/// 알림 도메인의 로컬 저장소 provider(SPEC-0028 R20).
///
/// 저장소 배선만 이 파일에 모은다 — 등록 판단은 `push_registration_controller.dart`가
/// 하고, 그쪽은 인터페이스만 안다(CLAUDE.md §3).
///
/// 두 저장소 모두 비밀값을 담지 않는다: 하나는 기기 식별자, 하나는 되돌릴 수 없는
/// 지문이다. 비밀값은 `common/storage/SecureStorage`가 담당한다(CLAUDE.md §7).

final class DeviceIdStoreProvider
    extends $FunctionalProvider<DeviceIdStore, DeviceIdStore, DeviceIdStore>
    with $Provider<DeviceIdStore> {
  /// 알림 도메인의 로컬 저장소 provider(SPEC-0028 R20).
  ///
  /// 저장소 배선만 이 파일에 모은다 — 등록 판단은 `push_registration_controller.dart`가
  /// 하고, 그쪽은 인터페이스만 안다(CLAUDE.md §3).
  ///
  /// 두 저장소 모두 비밀값을 담지 않는다: 하나는 기기 식별자, 하나는 되돌릴 수 없는
  /// 지문이다. 비밀값은 `common/storage/SecureStorage`가 담당한다(CLAUDE.md §7).
  const DeviceIdStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceIdStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceIdStoreHash();

  @$internal
  @override
  $ProviderElement<DeviceIdStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceIdStore create(Ref ref) {
    return deviceIdStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceIdStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceIdStore>(value),
    );
  }
}

String _$deviceIdStoreHash() => r'b51be69bcf436af90b502d6d7d07f87bbd444d74';

@ProviderFor(sentRegistrationStore)
const sentRegistrationStoreProvider = SentRegistrationStoreProvider._();

final class SentRegistrationStoreProvider
    extends
        $FunctionalProvider<
          SentRegistrationStore,
          SentRegistrationStore,
          SentRegistrationStore
        >
    with $Provider<SentRegistrationStore> {
  const SentRegistrationStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sentRegistrationStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sentRegistrationStoreHash();

  @$internal
  @override
  $ProviderElement<SentRegistrationStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SentRegistrationStore create(Ref ref) {
    return sentRegistrationStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SentRegistrationStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SentRegistrationStore>(value),
    );
  }
}

String _$sentRegistrationStoreHash() =>
    r'9b4c774e87ccd20fe2dc01b93e7a8d0e2b55f7df';
