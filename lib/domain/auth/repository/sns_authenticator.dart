import 'package:flutter/foundation.dart';
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

/// authorization code 획득을 인증 흐름에서 떼어 낸다(SPEC-0012 R7).
///
/// [fetch]가 무엇을 하든 결과는 `String?` 하나다 — 값을 얻으면 그 값,
/// 못 얻으면 null이다. 실패는 **전부** 삼킨다:
///
/// - `Exception`(SDK가 던지는 대부분)
/// - `Error`(플러그인 미초기화의 `StateError` 등). `on Exception`은 이것을
///   잡지 못해 그대로 빠져나가고, 그러면 code를 못 얻었다는 이유로 로그인
///   자체가 실패한다 — R7이 정확히 금지하는 것이다.
/// - 응답 없음. 이 호출은 동의 화면을 띄울 수 있어(구글 SDK가
///   `promptIfUnauthorized: true`를 고정한다) 사용자가 응답하지 않으면
///   무한정 기다린다. 로그인을 보류시키는 것 역시 R7 위반이라 잘라 낸다.
///
/// code는 인증의 곁가지다. 여기서 나온 실패가 본류로 전파되어서는 안 된다.
Future<String?> optionalCode(
  Future<String?> Function() fetch, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  // `Future.timeout`이 아니라 `Future.any`인 이유: 전자는 테스트의 가짜 시계
  // 아래에서 타이머가 진행되지 않아 값이 준비돼 있어도 즉시 onTimeout으로
  // 떨어진다. 그러면 SNS 로그인을 태우는 위젯 테스트가 실제와 다른 것(code가
  // 항상 null)을 검증하게 된다. `any`는 먼저 끝나는 쪽을 그대로 쓴다.
  try {
    return await Future.any(<Future<String?>>[
      fetch(),
      Future<String?>.delayed(timeout),
    ]);
  } on Object {
    return null;
  }
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
      final String? serverAuthCode = await _googleServerAuthCode(account);
      if (kDebugMode && serverAuthCode == null) {
        // code 없이도 로그인은 진행된다(R7). 다만 서버가 연동 해제용 토큰을
        // 보충하지 못하므로, 원인을 짚을 수 있게 디버그 빌드에서만 남긴다 —
        // 가장 흔한 원인은 serverClientId(웹 클라이언트 id) 미주입이다.
        debugPrint(
          '[SNS] google server auth code 없음 '
          '(serverClientId ${SnsConfig.googleServerClientId.isEmpty ? "미설정" : "설정됨"})',
        );
      }
      return SnsCredential(
        provider: SnsProvider.google,
        idToken: idToken,
        authorizationCode: serverAuthCode,
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

  /// 구글이 서버에 넘길 code를 받기 위해 요청하는 scope.
  ///
  /// **비워 두면 안 된다.** 안드로이드 플러그인은 accessToken이 null이면
  /// serverAuthCode를 받았더라도 버리는데(`google_sign_in_android`), 빈 scope는
  /// access token을 만들 근거가 없어 정확히 그 상태가 된다. 로그인에 이미 쓰는
  /// 세 가지를 그대로 요청해 추가 동의를 만들지 않는다.
  static const List<String> _googleServerScopes = <String>[
    'openid',
    'email',
    'profile',
  ];

  /// 구글의 server auth code를 얻는다(SPEC-0012 R4). 없으면 null.
  ///
  /// v7에서 code는 `authenticate()` 결과에 담겨 오지 않고 별도 호출로 받는다.
  /// 이 호출은 **정상적으로도 null을 준다** — 플랫폼에 따라 최초 로그인에서만
  /// 발급되기 때문이다. 실패 처리는 [optionalCode]가 맡는다.
  ///
  /// 안드로이드에서 code를 받으려면 `initialize(serverClientId:)`에 **웹**
  /// 클라이언트 id가 들어가 있어야 한다. 없으면 네이티브가 `requestOfflineAccess`
  /// 를 호출하지 않아 code를 요청조차 하지 않는다 — 값은 `SnsConfig`가 빌드
  /// 시점에 받는다.
  Future<String?> _googleServerAuthCode(GoogleSignInAccount account) =>
      optionalCode(
        () async => (await account.authorizationClient.authorizeServer(
          _googleServerScopes,
        ))?.serverAuthCode,
      );

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
        // Apple은 code를 항상 준다(SDK가 non-nullable로 보장, 5분 내 만료).
        authorizationCode: cred.authorizationCode,
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

        // 카카오는 code를 노출하지 않는다(SPEC-0012 §7). `UserApi` 로그인이
        // 내부에서 code를 access token으로 교환하고 버리므로 `OAuthToken`에
        // 남지 않는다. 얻으려면 `AuthCodeClient` + PKCE + 서버 교환으로
        // 인증 구조를 바꿔야 해서, 서버가 어드민 키 경로를 택하는지 결론이
        // 날 때까지 null로 둔다 — null은 정상 경로다(R7).
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
