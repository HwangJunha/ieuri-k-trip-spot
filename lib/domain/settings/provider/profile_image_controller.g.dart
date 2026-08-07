// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_image_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 이미지 업로드·제거(R6).
///
/// **3단계다**: URL 발급 → 스토리지 직접 PUT → 확정. 선언한 `contentType`·
/// `contentLength`가 실제 PUT과 정확히 일치해야 서명이 유효하므로, 바이트를 먼저
/// 확보한 뒤 그 길이로 발급을 요청한다(설계 §4).
///
/// **바이트를 인자로 받는다 — 사진을 고르는 일은 여기 관심사가 아니다.** 화면이
/// picker에서 받은 바이트를 넘기고, 테스트는 고정 바이트를 넘긴다. 그래서 이 notifier는
/// 기기 없이도 3단계 전이를 전부 검증할 수 있다.

@ProviderFor(ProfileImageController)
const profileImageControllerProvider = ProfileImageControllerProvider._();

/// 프로필 이미지 업로드·제거(R6).
///
/// **3단계다**: URL 발급 → 스토리지 직접 PUT → 확정. 선언한 `contentType`·
/// `contentLength`가 실제 PUT과 정확히 일치해야 서명이 유효하므로, 바이트를 먼저
/// 확보한 뒤 그 길이로 발급을 요청한다(설계 §4).
///
/// **바이트를 인자로 받는다 — 사진을 고르는 일은 여기 관심사가 아니다.** 화면이
/// picker에서 받은 바이트를 넘기고, 테스트는 고정 바이트를 넘긴다. 그래서 이 notifier는
/// 기기 없이도 3단계 전이를 전부 검증할 수 있다.
final class ProfileImageControllerProvider
    extends $NotifierProvider<ProfileImageController, ProfileImageState> {
  /// 프로필 이미지 업로드·제거(R6).
  ///
  /// **3단계다**: URL 발급 → 스토리지 직접 PUT → 확정. 선언한 `contentType`·
  /// `contentLength`가 실제 PUT과 정확히 일치해야 서명이 유효하므로, 바이트를 먼저
  /// 확보한 뒤 그 길이로 발급을 요청한다(설계 §4).
  ///
  /// **바이트를 인자로 받는다 — 사진을 고르는 일은 여기 관심사가 아니다.** 화면이
  /// picker에서 받은 바이트를 넘기고, 테스트는 고정 바이트를 넘긴다. 그래서 이 notifier는
  /// 기기 없이도 3단계 전이를 전부 검증할 수 있다.
  const ProfileImageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileImageControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileImageControllerHash();

  @$internal
  @override
  ProfileImageController create() => ProfileImageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileImageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileImageState>(value),
    );
  }
}

String _$profileImageControllerHash() =>
    r'a1eb733cebd98be6a54bca86368911db42bc9465';

/// 프로필 이미지 업로드·제거(R6).
///
/// **3단계다**: URL 발급 → 스토리지 직접 PUT → 확정. 선언한 `contentType`·
/// `contentLength`가 실제 PUT과 정확히 일치해야 서명이 유효하므로, 바이트를 먼저
/// 확보한 뒤 그 길이로 발급을 요청한다(설계 §4).
///
/// **바이트를 인자로 받는다 — 사진을 고르는 일은 여기 관심사가 아니다.** 화면이
/// picker에서 받은 바이트를 넘기고, 테스트는 고정 바이트를 넘긴다. 그래서 이 notifier는
/// 기기 없이도 3단계 전이를 전부 검증할 수 있다.

abstract class _$ProfileImageController extends $Notifier<ProfileImageState> {
  ProfileImageState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProfileImageState, ProfileImageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileImageState, ProfileImageState>,
              ProfileImageState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
