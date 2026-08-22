// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_scan_checkpoint_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 사진 스캔 중단 지점 저장소의 출처. 테스트는 이것만 오버라이드해 페이크를 준다.

@ProviderFor(photoScanCheckpointStore)
const photoScanCheckpointStoreProvider = PhotoScanCheckpointStoreProvider._();

/// 사진 스캔 중단 지점 저장소의 출처. 테스트는 이것만 오버라이드해 페이크를 준다.

final class PhotoScanCheckpointStoreProvider
    extends
        $FunctionalProvider<
          PhotoScanCheckpointStore,
          PhotoScanCheckpointStore,
          PhotoScanCheckpointStore
        >
    with $Provider<PhotoScanCheckpointStore> {
  /// 사진 스캔 중단 지점 저장소의 출처. 테스트는 이것만 오버라이드해 페이크를 준다.
  const PhotoScanCheckpointStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoScanCheckpointStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoScanCheckpointStoreHash();

  @$internal
  @override
  $ProviderElement<PhotoScanCheckpointStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PhotoScanCheckpointStore create(Ref ref) {
    return photoScanCheckpointStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoScanCheckpointStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoScanCheckpointStore>(value),
    );
  }
}

String _$photoScanCheckpointStoreHash() =>
    r'12b01003b12ad4e3fd95f30d2060f2258512d9e8';
