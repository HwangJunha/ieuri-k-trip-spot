// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_picker_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 갤러리에서 사진을 고른다.
///
/// **리사이즈·품질 옵션을 주지 않는다.** `maxWidth`/`imageQuality`를 주면 패키지가
/// 재인코딩하는데, 그러면 1단계에 선언한 `contentLength`와 실제 PUT 바이트 수가
/// 어긋나 스토리지가 `403 SignatureDoesNotMatch`로 거부한다(가이드 §4). 크기 상한
/// (10 MiB)은 고른 뒤 바이트 수로 판정한다.

@ProviderFor(photoPicker)
const photoPickerProvider = PhotoPickerProvider._();

/// 갤러리에서 사진을 고른다.
///
/// **리사이즈·품질 옵션을 주지 않는다.** `maxWidth`/`imageQuality`를 주면 패키지가
/// 재인코딩하는데, 그러면 1단계에 선언한 `contentLength`와 실제 PUT 바이트 수가
/// 어긋나 스토리지가 `403 SignatureDoesNotMatch`로 거부한다(가이드 §4). 크기 상한
/// (10 MiB)은 고른 뒤 바이트 수로 판정한다.

final class PhotoPickerProvider
    extends $FunctionalProvider<PhotoPicker, PhotoPicker, PhotoPicker>
    with $Provider<PhotoPicker> {
  /// 갤러리에서 사진을 고른다.
  ///
  /// **리사이즈·품질 옵션을 주지 않는다.** `maxWidth`/`imageQuality`를 주면 패키지가
  /// 재인코딩하는데, 그러면 1단계에 선언한 `contentLength`와 실제 PUT 바이트 수가
  /// 어긋나 스토리지가 `403 SignatureDoesNotMatch`로 거부한다(가이드 §4). 크기 상한
  /// (10 MiB)은 고른 뒤 바이트 수로 판정한다.
  const PhotoPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoPickerHash();

  @$internal
  @override
  $ProviderElement<PhotoPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoPicker create(Ref ref) {
    return photoPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoPicker>(value),
    );
  }
}

String _$photoPickerHash() => r'ffe254fb730d95cef3c1eeda31c72b8df3c96ae4';
