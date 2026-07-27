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
