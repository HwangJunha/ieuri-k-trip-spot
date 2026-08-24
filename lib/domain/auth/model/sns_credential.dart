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
    this.authorizationCode,
    this.email,
    this.emailVerified = false,
    this.nickname,
    this.profileImageUrl,
  });

  final SnsProvider provider;
  final String idToken;

  /// provider가 내려준 authorization code (SPEC-0012 R4). 서버가 이것으로
  /// refresh token을 받아 탈퇴 시 연동 해제에 쓴다.
  ///
  /// **null이 정상 경로다** — provider가 code를 노출하지 않거나 획득에 실패해도
  /// 인증 흐름을 막지 않는다(R7). 값이 없으면 요청에서 비워 보내고, 서버가
  /// 토큰을 보충하지 않을 뿐이다.
  ///
  /// 일회용이고 짧게 만료되므로 저장하지 않는다 — 획득 즉시 요청에 실어 보낸다.
  final String? authorizationCode;

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
      other.authorizationCode == authorizationCode &&
      other.email == email &&
      other.emailVerified == emailVerified &&
      other.nickname == nickname &&
      other.profileImageUrl == profileImageUrl;

  @override
  int get hashCode => Object.hash(
    provider,
    idToken,
    authorizationCode,
    email,
    emailVerified,
    nickname,
    profileImageUrl,
  );
}
