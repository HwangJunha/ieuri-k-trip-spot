// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [AuthRepository] built over the shared GraphQL client. Widgets
/// never construct the repository directly (CLAUDE.md §5); the controller reads
/// it from here.

@ProviderFor(authRepository)
const authRepositoryProvider = AuthRepositoryProvider._();

/// Exposes the [AuthRepository] built over the shared GraphQL client. Widgets
/// never construct the repository directly (CLAUDE.md §5); the controller reads
/// it from here.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Exposes the [AuthRepository] built over the shared GraphQL client. Widgets
  /// never construct the repository directly (CLAUDE.md §5); the controller reads
  /// it from here.
  const AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'1769c5febc2e0977af963bf9f349ea6109b1b66a';

/// Exposes the [SnsAuthenticator] (the provider-SDK isolation point). Kept
/// behind a provider so tests can override it with a fake instead of driving
/// the real Google/Apple/Kakao SDKs.

@ProviderFor(snsAuthenticator)
const snsAuthenticatorProvider = SnsAuthenticatorProvider._();

/// Exposes the [SnsAuthenticator] (the provider-SDK isolation point). Kept
/// behind a provider so tests can override it with a fake instead of driving
/// the real Google/Apple/Kakao SDKs.

final class SnsAuthenticatorProvider
    extends
        $FunctionalProvider<
          SnsAuthenticator,
          SnsAuthenticator,
          SnsAuthenticator
        >
    with $Provider<SnsAuthenticator> {
  /// Exposes the [SnsAuthenticator] (the provider-SDK isolation point). Kept
  /// behind a provider so tests can override it with a fake instead of driving
  /// the real Google/Apple/Kakao SDKs.
  const SnsAuthenticatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'snsAuthenticatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$snsAuthenticatorHash();

  @$internal
  @override
  $ProviderElement<SnsAuthenticator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SnsAuthenticator create(Ref ref) {
    return snsAuthenticator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SnsAuthenticator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SnsAuthenticator>(value),
    );
  }
}

String _$snsAuthenticatorHash() => r'6c96e908b0c35011d022ae31c82ba28a2f24f336';
