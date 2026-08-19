// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_destination.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 보관 슬롯 하나의 출처. **state를 노출하지 않는다** — 객체만 공유하므로 리다이렉트가
/// 빌드 중에 이 안의 필드를 바꿔도 Riverpod이 관여하지 않는다.

@ProviderFor(pendingDestination)
const pendingDestinationProvider = PendingDestinationProvider._();

/// 보관 슬롯 하나의 출처. **state를 노출하지 않는다** — 객체만 공유하므로 리다이렉트가
/// 빌드 중에 이 안의 필드를 바꿔도 Riverpod이 관여하지 않는다.

final class PendingDestinationProvider
    extends
        $FunctionalProvider<
          PendingDestination,
          PendingDestination,
          PendingDestination
        >
    with $Provider<PendingDestination> {
  /// 보관 슬롯 하나의 출처. **state를 노출하지 않는다** — 객체만 공유하므로 리다이렉트가
  /// 빌드 중에 이 안의 필드를 바꿔도 Riverpod이 관여하지 않는다.
  const PendingDestinationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingDestinationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingDestinationHash();

  @$internal
  @override
  $ProviderElement<PendingDestination> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PendingDestination create(Ref ref) {
    return pendingDestination(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PendingDestination value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PendingDestination>(value),
    );
  }
}

String _$pendingDestinationHash() =>
    r'0862b71161c4af9031c27a6c9a6be388f4dd92c7';
