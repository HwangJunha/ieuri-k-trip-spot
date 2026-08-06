import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../model/auth_failure.dart';
import '../model/sns_credential.dart';
import '../model/sns_provider.dart';
import 'sns_config.dart';

/// Thrown when the user cancels an SNS sign-in (spec §5.1). Distinct from
/// [AuthFailure] so the UI can silently revert instead of showing an error.
class SnsCancelledException implements Exception {
  const SnsCancelledException();
}

/// The single isolation point for the provider SDKs (spec §6.1, CLAUDE.md §3):
/// wraps google_sign_in / sign_in_with_apple / kakao_flutter_sdk_user and maps
/// each SDK's response to a domain [SnsCredential]. Nothing above the repository
/// imports the SDK types; the `view`/`provider` layers see only domain models.
///
/// On success returns the `idToken` plus any profile fields the provider gave
/// (used to prefill the sign-up form). On user cancellation throws
/// [SnsCancelledException]; on any other failure throws an [AuthFailure].
abstract interface class SnsAuthenticator {
  Future<SnsCredential> authenticate(SnsProvider provider);
}

class SnsAuthenticatorImpl implements SnsAuthenticator {
  const SnsAuthenticatorImpl();

  @override
  Future<SnsCredential> authenticate(SnsProvider provider) =>
      switch (provider) {
        SnsProvider.google => _google(),
        SnsProvider.apple => _apple(),
        SnsProvider.kakao => _kakao(),
      };

  // --- Google (google_sign_in v7) ------------------------------------------

  Future<SnsCredential> _google() async {
    try {
      // v7 requires initialize() exactly once before any other call; calling it
      // again is safe. clientId is the iOS OAuth client the SDK needs to present
      // sign-in (falls back to Info.plist GIDClientID when null); serverClientId
      // makes the id_token's `aud` the web client id the server verifies (§6.1).
      await GoogleSignIn.instance.initialize(
        clientId: SnsConfig.googleIosClientId.isEmpty
            ? null
            : SnsConfig.googleIosClientId,
        serverClientId: SnsConfig.googleServerClientId.isEmpty
            ? null
            : SnsConfig.googleServerClientId,
      );
      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate();
      final String? idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        // No id_token usually means serverClientId wasn't configured.
        throw const AuthFailure(AuthFailureKind.unknown);
      }
      return SnsCredential(
        provider: SnsProvider.google,
        idToken: idToken,
        email: account.email,
        // Google-verified emails are trustworthy, but the server re-decides;
        // we don't get a per-account verified flag here, so leave it false.
        nickname: account.displayName,
        profileImageUrl: account.photoUrl,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const SnsCancelledException();
      }
      throw const AuthFailure(AuthFailureKind.unknown);
    }
  }

  // --- Apple (sign_in_with_apple) ------------------------------------------

  Future<SnsCredential> _apple() async {
    try {
      final AuthorizationCredentialAppleID cred =
          await SignInWithApple.getAppleIDCredential(
            scopes: <AppleIDAuthorizationScopes>[
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );
      final String? idToken = cred.identityToken;
      if (idToken == null || idToken.isEmpty) {
        throw const AuthFailure(AuthFailureKind.unknown);
      }
      // Apple sends name/email only on the FIRST authorization; both may be
      // null — the sign-up form then asks the user to type an email (spec §5.2).
      final String name = <String?>[
        cred.givenName,
        cred.familyName,
      ].whereType<String>().join(' ');
      return SnsCredential(
        provider: SnsProvider.apple,
        idToken: idToken,
        email: cred.email,
        nickname: name.isEmpty ? null : name,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const SnsCancelledException();
      }
      throw const AuthFailure(AuthFailureKind.unknown);
    }
  }

  // --- Kakao (kakao_flutter_sdk_user) --------------------------------------

  Future<SnsCredential> _kakao() async {
    try {
      // Prefer the KakaoTalk app when installed, else the account web flow.
      final OAuthToken token = await (await isKakaoTalkInstalled()
          ? UserApi.instance.loginWithKakaoTalk()
          : UserApi.instance.loginWithKakaoAccount());
      final String? idToken = token.idToken;
      if (idToken == null || idToken.isEmpty) {
        // Null id_token means OIDC isn't enabled for the Kakao app.
        throw const AuthFailure(AuthFailureKind.unknown);
      }
      // Fetch profile for prefill; email/nickname require consent scopes and may
      // be absent — the server re-verifies from the id_token regardless.
      final User me = await UserApi.instance.me();
      return SnsCredential(
        provider: SnsProvider.kakao,
        idToken: idToken,
        email: me.kakaoAccount?.email,
        nickname: me.kakaoAccount?.profile?.nickname,
        profileImageUrl: me.kakaoAccount?.profile?.profileImageUrl,
      );
    } on KakaoAuthException catch (e) {
      if (e.error == AuthErrorCause.accessDenied) {
        throw const SnsCancelledException();
      }
      throw const AuthFailure(AuthFailureKind.unknown);
    } on KakaoException {
      throw const AuthFailure(AuthFailureKind.unknown);
    }
  }
}
