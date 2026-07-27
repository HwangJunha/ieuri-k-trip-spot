import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../../../common/storage/secure_storage.dart';
import '../model/auth_session.dart';
import '../model/auth_state.dart';
import '../model/email_verification_handle.dart';
import '../model/me.dart';
import '../model/terms_code.dart';
import '../repository/auth_repository.dart';
import 'auth_repository_provider.dart';

part 'auth_controller.g.dart';

/// Owns the app-global authentication state (spec §7). Restores the session
/// from secure storage on build, then exposes `AsyncValue<AuthState>` to the UI
/// and the router.
///
/// keepAlive: the auth state must survive navigation and outlive any single
/// screen — the router reads it on every redirect and the GraphQL refresh
/// bridge points at this notifier (CLAUDE.md §5 justification).
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    // Register the refresh hook so the network layer can renew an expired
    // access token without importing this provider (breaks the cycle, §8).
    ref.read(tokenRefreshBridgeProvider).refresher = _refreshAccessToken;
    return _restoreSession();
  }

  SecureStorage get _storage => ref.read(secureStorageProvider);
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Session restore (spec §4.2): load the stored tokens. If an access token is
  /// present, confirm it by fetching `me`; if that fails, try a refresh; if
  /// neither works, fall back to unauthenticated.
  Future<AuthState> _restoreSession() async {
    final String? accessToken = await _storage.readAccessToken();
    final String? refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) return AuthState.unauthenticated;

    if (accessToken != null) {
      final AuthState? confirmed = await _tryEstablish(
        AuthSession(accessToken: accessToken, refreshToken: refreshToken),
      );
      if (confirmed != null) return confirmed;
    }

    // Access token missing or rejected — try one refresh before giving up.
    final AuthSession? refreshed = await _repo.refresh(
      refreshToken: refreshToken,
    );
    if (refreshed == null) {
      await _storage.clearSession();
      return AuthState.unauthenticated;
    }
    await _persist(refreshed);
    final AuthState? established = await _tryEstablish(refreshed);
    return established ?? AuthState.unauthenticated;
  }

  /// Fetches `me` for [session] and builds an authenticated [AuthState], or
  /// `null` if `me` fails (e.g. the access token is stale). Never throws.
  Future<AuthState?> _tryEstablish(AuthSession session) async {
    try {
      final Me me = await _repo.fetchMe();
      final AuthSession full = session.copyWith(user: me);
      await _persistUser(me);
      final bool onboarded = await _storage.isOnboardingCompleted(me.id);
      return AuthState(session: full, onboardingCompleted: onboarded);
    } on Object {
      return null;
    }
  }

  /// Logs in (spec §5.1): `loginEmail` for tokens, then `me` to establish the
  /// account. Emits loading → data/error.
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue<AuthState>.loading();
    state = await AsyncValue.guard(() async {
      final AuthSession tokens = await _repo.loginEmail(
        email: email,
        password: password,
      );
      // Persist tokens BEFORE fetching `me`: AuthLink reads the access token
      // from secure storage on every request, so `me` is unauthenticated
      // unless the token is already stored.
      await _persist(tokens);
      final Me me = await _repo.fetchMe();
      final AuthSession session = tokens.copyWith(user: me);
      await _persistUser(me);
      final bool onboarded = await _storage.isOnboardingCompleted(me.id);
      return AuthState(session: session, onboardingCompleted: onboarded);
    });
  }

  /// Registers a member (spec §4.2/§5.2). Returns the [EmailVerificationHandle]
  /// so the caller routes to the verification screen. Deliberately NOT wrapped
  /// in `state`/`AsyncValue.guard`: registration doesn't authenticate, so it
  /// must not flip the app-global auth state (the router observes it). Failures
  /// rethrow for the sign-up view to show locally.
  Future<EmailVerificationHandle> signUp({
    required String email,
    required String password,
    required bool ageVerified,
    required List<Agreement> agreements,
  }) => _repo.registerEmailMember(
    email: email,
    password: password,
    ageVerified: ageVerified,
    agreements: agreements,
  );

  Future<void> verifyEmail({
    required String verificationId,
    required String code,
  }) => _repo.verifyEmail(verificationId: verificationId, code: code);

  Future<EmailVerificationHandle> resendVerification({
    required String verificationId,
  }) => _repo.resendVerification(verificationId: verificationId);

  Future<void> requestPasswordReset({required String email}) =>
      _repo.requestPasswordReset(email: email);

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _repo.resetPassword(email: email, code: code, newPassword: newPassword);

  /// Signs out (spec §6.3): invalidate the refresh token server-side, then
  /// clear local tokens and reset state — regardless of the server call's
  /// outcome.
  Future<void> signOut() async {
    final String? refreshToken = await _storage.readRefreshToken();
    if (refreshToken != null) {
      await _repo.logout(refreshToken: refreshToken);
    }
    await _storage.clearSession();
    state = const AsyncValue<AuthState>.data(AuthState.unauthenticated);
  }

  /// Marks onboarding done for the current account and updates state so the
  /// router lets the user through to home (spec §4.3-B local fallback).
  Future<void> completeOnboarding() async {
    final AuthState? current = state.value;
    final String? userId = current?.userId;
    if (current == null || userId == null) return;
    await _storage.setOnboardingCompleted(userId);
    state = AsyncValue<AuthState>.data(
      current.copyWith(onboardingCompleted: true),
    );
  }

  Future<void> _persist(AuthSession session) => _storage.writeTokens(
    accessToken: session.accessToken,
    refreshToken: session.refreshToken,
  );

  Future<void> _persistUser(Me me) =>
      _storage.writeUser(userId: me.id, userEmail: me.email);

  /// Called by the network refresh bridge on an auth error. Renews the token
  /// pair; on failure clears the session and signs out (spec §6.3).
  Future<String?> _refreshAccessToken() async {
    final String? refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) {
      await signOut();
      return null;
    }
    final AuthSession? refreshed = await _repo.refresh(
      refreshToken: refreshToken,
    );
    if (refreshed == null) {
      await signOut();
      return null;
    }
    await _persist(refreshed);
    return refreshed.accessToken;
  }
}
