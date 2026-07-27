/// A pending email-verification, returned by `registerEmailMember` /
/// `resendVerification` (spec §5.3/§6.2). Carries the server `verificationId`
/// the verify step needs, plus an optional `expiresAt` (ISO string from the
/// server) for resend. Pure domain model.
class EmailVerificationHandle {
  const EmailVerificationHandle({required this.verificationId, this.expiresAt});

  final String verificationId;
  final String? expiresAt;

  @override
  bool operator ==(Object other) =>
      other is EmailVerificationHandle &&
      other.verificationId == verificationId &&
      other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(verificationId, expiresAt);
}
