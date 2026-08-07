// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 닉네임 변경(R5).
///
/// **중복을 미리 조회하지 않는다.** 제출 전에는 형식만 보고, 중복은 서버가
/// `NICKNAME_ALREADY_TAKEN`으로 답한 것을 입력란 오류로 옮긴다 — 미리 조회해도 조회와
/// 제출 사이에 선점당할 수 있어 어차피 서버 오류를 처리해야 한다(설계 §4).

@ProviderFor(ProfileEditController)
const profileEditControllerProvider = ProfileEditControllerProvider._();

/// 닉네임 변경(R5).
///
/// **중복을 미리 조회하지 않는다.** 제출 전에는 형식만 보고, 중복은 서버가
/// `NICKNAME_ALREADY_TAKEN`으로 답한 것을 입력란 오류로 옮긴다 — 미리 조회해도 조회와
/// 제출 사이에 선점당할 수 있어 어차피 서버 오류를 처리해야 한다(설계 §4).
final class ProfileEditControllerProvider
    extends $NotifierProvider<ProfileEditController, ProfileEditState> {
  /// 닉네임 변경(R5).
  ///
  /// **중복을 미리 조회하지 않는다.** 제출 전에는 형식만 보고, 중복은 서버가
  /// `NICKNAME_ALREADY_TAKEN`으로 답한 것을 입력란 오류로 옮긴다 — 미리 조회해도 조회와
  /// 제출 사이에 선점당할 수 있어 어차피 서버 오류를 처리해야 한다(설계 §4).
  const ProfileEditControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditControllerHash();

  @$internal
  @override
  ProfileEditController create() => ProfileEditController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileEditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileEditState>(value),
    );
  }
}

String _$profileEditControllerHash() =>
    r'e5f798f0f6d42a1cabff528de585ecfb1bb1ad17';

/// 닉네임 변경(R5).
///
/// **중복을 미리 조회하지 않는다.** 제출 전에는 형식만 보고, 중복은 서버가
/// `NICKNAME_ALREADY_TAKEN`으로 답한 것을 입력란 오류로 옮긴다 — 미리 조회해도 조회와
/// 제출 사이에 선점당할 수 있어 어차피 서버 오류를 처리해야 한다(설계 §4).

abstract class _$ProfileEditController extends $Notifier<ProfileEditState> {
  ProfileEditState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProfileEditState, ProfileEditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileEditState, ProfileEditState>,
              ProfileEditState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
