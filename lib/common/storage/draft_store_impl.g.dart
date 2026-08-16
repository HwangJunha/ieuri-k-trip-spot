// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_store_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 초안 저장소. 화면 하나가 쓰는 자원이 아니라 앱 수명 내내 같은 디렉토리를 보므로
/// keepAlive다.

@ProviderFor(draftStore)
const draftStoreProvider = DraftStoreProvider._();

/// 초안 저장소. 화면 하나가 쓰는 자원이 아니라 앱 수명 내내 같은 디렉토리를 보므로
/// keepAlive다.

final class DraftStoreProvider
    extends $FunctionalProvider<DraftStore, DraftStore, DraftStore>
    with $Provider<DraftStore> {
  /// 초안 저장소. 화면 하나가 쓰는 자원이 아니라 앱 수명 내내 같은 디렉토리를 보므로
  /// keepAlive다.
  const DraftStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'draftStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$draftStoreHash();

  @$internal
  @override
  $ProviderElement<DraftStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DraftStore create(Ref ref) {
    return draftStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DraftStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DraftStore>(value),
    );
  }
}

String _$draftStoreHash() => r'74f963a62b949910f045e117e9959976d2025c0d';
