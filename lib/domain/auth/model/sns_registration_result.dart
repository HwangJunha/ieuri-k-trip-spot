/// The outcome of a successful `registerSnsMember` (spec §4/§5.2). SNS sign-up
/// issues NO tokens — like email sign-up, the user logs in afterwards. This
/// carries only what the caller needs to route next:
///
///   - [emailVerified] true  → the submitted email matched the provider's
///     verified email; skip verification, go to login.
///   - [emailVerified] false → the user edited the email or the provider didn't
///     verify it; [verificationId] is set and the caller routes to the shared
///     email-verification screen.
class SnsRegistrationResult {
  const SnsRegistrationResult({
    required this.emailVerified,
    this.verificationId,
  });

  final bool emailVerified;

  /// Present only when [emailVerified] is false — the handle the verify step
  /// needs.
  final String? verificationId;

  /// Whether the caller must route to email verification before login.
  bool get needsVerification => !emailVerified && verificationId != null;

  @override
  bool operator ==(Object other) =>
      other is SnsRegistrationResult &&
      other.emailVerified == emailVerified &&
      other.verificationId == verificationId;

  @override
  int get hashCode => Object.hash(emailVerified, verificationId);
}
