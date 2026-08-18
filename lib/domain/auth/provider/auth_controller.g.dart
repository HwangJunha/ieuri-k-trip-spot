// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the app-global authentication state (spec §7). Restores the session
/// from secure storage on build, then exposes `AsyncValue<AuthState>` to the UI
/// and the router.
///
/// keepAlive: the auth state must survive navigation and outlive any single
/// screen — the router reads it on every redirect and the GraphQL refresh
/// bridge points at this notifier (CLAUDE.md §5 justification).

@ProviderFor(AuthController)
const authControllerProvider = AuthControllerProvider._();

/// Owns the app-global authentication state (spec §7). Restores the session
/// from secure storage on build, then exposes `AsyncValue<AuthState>` to the UI
/// and the router.
///
/// keepAlive: the auth state must survive navigation and outlive any single
/// screen — the router reads it on every redirect and the GraphQL refresh
/// bridge points at this notifier (CLAUDE.md §5 justification).
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, AuthState> {
  /// Owns the app-global authentication state (spec §7). Restores the session
  /// from secure storage on build, then exposes `AsyncValue<AuthState>` to the UI
  /// and the router.
  ///
  /// keepAlive: the auth state must survive navigation and outlive any single
  /// screen — the router reads it on every redirect and the GraphQL refresh
  /// bridge points at this notifier (CLAUDE.md §5 justification).
  const AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'216a8a836097436260c5a285c2cd40e04544ab75';

/// Owns the app-global authentication state (spec §7). Restores the session
/// from secure storage on build, then exposes `AsyncValue<AuthState>` to the UI
/// and the router.
///
/// keepAlive: the auth state must survive navigation and outlive any single
/// screen — the router reads it on every redirect and the GraphQL refresh
/// bridge points at this notifier (CLAUDE.md §5 justification).

abstract class _$AuthController extends $AsyncNotifier<AuthState> {
  FutureOr<AuthState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AuthState>, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthState>, AuthState>,
              AsyncValue<AuthState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
