// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// 약관의 `settingsRepositoryProvider`와 **따로 둔다** — 둘을 한 인터페이스로 합치면
/// 약관 화면 테스트가 프로필 메서드까지 전부 스텁해야 한다.

@ProviderFor(profileRepository)
const profileRepositoryProvider = ProfileRepositoryProvider._();

/// 프로필 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// 약관의 `settingsRepositoryProvider`와 **따로 둔다** — 둘을 한 인터페이스로 합치면
/// 약관 화면 테스트가 프로필 메서드까지 전부 스텁해야 한다.

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  /// 프로필 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
  /// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
  ///
  /// 약관의 `settingsRepositoryProvider`와 **따로 둔다** — 둘을 한 인터페이스로 합치면
  /// 약관 화면 테스트가 프로필 메서드까지 전부 스텁해야 한다.
  const ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'0ed7d34bf0b62c2b7b6a790613dfff71c3f47b92';
