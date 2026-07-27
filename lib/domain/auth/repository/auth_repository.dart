import '../model/auth_session.dart';
import '../model/email_verification_handle.dart';
import '../model/me.dart';
import '../model/terms_code.dart';

/// Data-access contract for authentication (spec §6). Returns domain models;
/// GraphQL types never cross this boundary. On failure throws an `AuthFailure`.
abstract interface class AuthRepository {
  /// Registers an email member (spec §5.2/§6.2). Returns NO tokens — on success
  /// yields an [EmailVerificationHandle] (the `verificationId` the verify step
  /// needs). Throws `AuthFailure` on e.g. a taken email.
  Future<EmailVerificationHandle> registerEmailMember({
    required String email,
    required String password,
    required bool ageVerified,
    required List<Agreement> agreements,
  });

  /// Confirms an email with the code the user received (spec §5.3). Throws
  /// `AuthFailure` if the server reports failure or `verified != true`.
  Future<void> verifyEmail({
    required String verificationId,
    required String code,
  });

  /// Requests a fresh verification code, returning the (possibly new) handle
  /// with its `expiresAt` (spec §5.3). Throws `AuthFailure` on failure.
  Future<EmailVerificationHandle> resendVerification({
    required String verificationId,
  });

  /// Logs in with email/password (spec §5.1/§6.2). On success returns an
  /// [AuthSession] with the token pair and server-provided expiries — but NO
  /// user (login has none); the caller fetches [fetchMe]. Throws `AuthFailure`.
  Future<AuthSession> loginEmail({
    required String email,
    required String password,
  });

  /// Fetches the authenticated account via the `me` query (spec §6.2). Throws
  /// `AuthFailure` on transport failure or an unauthenticated response.
  Future<Me> fetchMe();

  /// Exchanges a refresh token for a fresh session (spec §6.3). Returns the new
  /// [AuthSession] (tokens only), or `null` if refresh failed (caller signs
  /// out).
  Future<AuthSession?> refresh({required String refreshToken});

  /// Invalidates the refresh token server-side (spec §6.3). Best-effort: never
  /// throws so local sign-out always completes.
  Future<void> logout({required String refreshToken});

  /// Step 1 of password reset (spec §5.4): request a code be emailed. Throws
  /// `AuthFailure` on failure.
  Future<void> requestPasswordReset({required String email});

  /// Step 2 of password reset (spec §5.4): confirm with the emailed code and a
  /// new password. Throws `AuthFailure` on failure.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
