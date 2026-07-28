import 'sns_provider.dart';

/// The result of authenticating with an SNS provider's SDK (spec §6.1): the
/// `idToken` to send to the server, plus the profile fields the provider
/// volunteered. Pure domain type — the provider SDKs are isolated in the
/// repository's `SnsAuthenticator`, which maps their responses to this.
///
/// The trust boundary is the server: [email]/[emailVerified]/[nickname]/
/// [profileImageUrl] are used only to prefill/display the sign-up form. The
/// server independently re-verifies [idToken] and decides the real email-
/// verification state.
class SnsCredential {
  const SnsCredential({
    required this.provider,
    required this.idToken,
    this.email,
    this.emailVerified = false,
    this.nickname,
    this.profileImageUrl,
  });

  final SnsProvider provider;
  final String idToken;

  /// The email the provider volunteered, if any. Null when the provider gave
  /// none (Kakao without email scope, Apple after the first sign-in) — the
  /// sign-up form then requires the user to type one (spec §5.2).
  final String? email;

  /// Whether the provider says it verified [email]. Advisory only — the server
  /// makes the final call.
  final bool emailVerified;

  final String? nickname;
  final String? profileImageUrl;

  @override
  bool operator ==(Object other) =>
      other is SnsCredential &&
      other.provider == provider &&
      other.idToken == idToken &&
      other.email == email &&
      other.emailVerified == emailVerified &&
      other.nickname == nickname &&
      other.profileImageUrl == profileImageUrl;

  @override
  int get hashCode => Object.hash(
    provider,
    idToken,
    email,
    emailVerified,
    nickname,
    profileImageUrl,
  );
}
