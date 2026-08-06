// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_picker_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 기본 구현은 **아무것도 고르지 않는다.** 화면은 이 결과(null)를 "고를 수 없음"으로
/// 안내하고, 사진 없이 글을 쓰는 경로는 그대로 열려 있다(`photoKeys: []`).

@ProviderFor(photoPicker)
const photoPickerProvider = PhotoPickerProvider._();

/// 기본 구현은 **아무것도 고르지 않는다.** 화면은 이 결과(null)를 "고를 수 없음"으로
/// 안내하고, 사진 없이 글을 쓰는 경로는 그대로 열려 있다(`photoKeys: []`).

final class PhotoPickerProvider
    extends $FunctionalProvider<PhotoPicker, PhotoPicker, PhotoPicker>
    with $Provider<PhotoPicker> {
  /// 기본 구현은 **아무것도 고르지 않는다.** 화면은 이 결과(null)를 "고를 수 없음"으로
  /// 안내하고, 사진 없이 글을 쓰는 경로는 그대로 열려 있다(`photoKeys: []`).
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

String _$photoPickerHash() => r'4586585790b88aa57b4612043a559d6cc6ed697c';
