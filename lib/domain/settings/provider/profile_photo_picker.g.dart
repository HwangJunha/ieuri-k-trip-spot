// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_photo_picker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 갤러리에서 프로필 사진 한 장을 고른다.
///
/// **리사이즈·품질 옵션을 주지 않는다.** `maxWidth`/`imageQuality`를 주면 패키지가
/// 재인코딩하는데, 그러면 업로드 1단계에 선언한 `contentLength`와 실제 PUT 바이트 수가
/// 어긋나 스토리지가 서명 불일치로 거부한다(설계 §4).
///
/// 커뮤니티의 `photoPicker`와 **따로 둔다** — 그쪽은 여러 장을 고르고 초안용 식별자를
/// 붙이며, 무엇보다 기능 간 import가 금지돼 있다(CLAUDE.md §3). 공유할 만큼 자란다면
/// 그때 `common/`으로 올린다.

@ProviderFor(profilePhotoPicker)
const profilePhotoPickerProvider = ProfilePhotoPickerProvider._();

/// 갤러리에서 프로필 사진 한 장을 고른다.
///
/// **리사이즈·품질 옵션을 주지 않는다.** `maxWidth`/`imageQuality`를 주면 패키지가
/// 재인코딩하는데, 그러면 업로드 1단계에 선언한 `contentLength`와 실제 PUT 바이트 수가
/// 어긋나 스토리지가 서명 불일치로 거부한다(설계 §4).
///
/// 커뮤니티의 `photoPicker`와 **따로 둔다** — 그쪽은 여러 장을 고르고 초안용 식별자를
/// 붙이며, 무엇보다 기능 간 import가 금지돼 있다(CLAUDE.md §3). 공유할 만큼 자란다면
/// 그때 `common/`으로 올린다.

final class ProfilePhotoPickerProvider
    extends
        $FunctionalProvider<
          ProfilePhotoPicker,
          ProfilePhotoPicker,
          ProfilePhotoPicker
        >
    with $Provider<ProfilePhotoPicker> {
  /// 갤러리에서 프로필 사진 한 장을 고른다.
  ///
  /// **리사이즈·품질 옵션을 주지 않는다.** `maxWidth`/`imageQuality`를 주면 패키지가
  /// 재인코딩하는데, 그러면 업로드 1단계에 선언한 `contentLength`와 실제 PUT 바이트 수가
  /// 어긋나 스토리지가 서명 불일치로 거부한다(설계 §4).
  ///
  /// 커뮤니티의 `photoPicker`와 **따로 둔다** — 그쪽은 여러 장을 고르고 초안용 식별자를
  /// 붙이며, 무엇보다 기능 간 import가 금지돼 있다(CLAUDE.md §3). 공유할 만큼 자란다면
  /// 그때 `common/`으로 올린다.
  const ProfilePhotoPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profilePhotoPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profilePhotoPickerHash();

  @$internal
  @override
  $ProviderElement<ProfilePhotoPicker> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfilePhotoPicker create(Ref ref) {
    return profilePhotoPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfilePhotoPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfilePhotoPicker>(value),
    );
  }
}

String _$profilePhotoPickerHash() =>
    r'12b26079b62a0ae024fbda991bb6c9bcd5781202';
