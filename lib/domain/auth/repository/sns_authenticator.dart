import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:logger/logger.dart';

import '../../../common/log/app_log.dart';
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

/// 동의 창 없이 code를 얻어 보고, 빈손일 때만 창을 띄우는 쪽으로 넘어간다
/// (SPEC-0012 §1 — 로그인 한 번에 창도 한 번).
///
/// iOS는 [silently]가 로그인 때 캐시된 code를 UI 없이 돌려주므로 [withPrompt]에
/// 닿지 않는다. 안드로이드는 첫 로그인에서 [silently]가 빈손이라 [withPrompt]가
/// 필요하다. **[silently]가 값을 준 뒤에는 [withPrompt]를 부르지 않는다** —
/// 부르면 이미 가진 code를 두고 창이 한 번 더 뜬다.
///
/// 빈 문자열은 값이 아니라 "없음"으로 본다.
Future<String?> codeSilentlyOrPrompt({
  required Future<String?> Function() silently,
  required Future<String?> Function() withPrompt,
}) async {
  final String? silent = await silently();
  if (silent != null && silent.isNotEmpty) return silent;
  return withPrompt();
}

class SnsAuthenticatorImpl implements SnsAuthenticator {
  const SnsAuthenticatorImpl();

  static final Logger _log = appLogger('SnsAuthenticator');

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
        _log.e('google id_token 없음 — serverClientId(웹 클라이언트) 설정을 본다');
        throw const AuthFailure(AuthFailureKind.unknown);
      }
      return SnsCredential(
        provider: SnsProvider.google,
        idToken: idToken,
        authorizationCode: await _googleServerAuthCode(account),
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
      // **원인을 남긴다.** 예전에는 통째로 `unknown`으로 뭉개 화면에 "문제가
      // 발생했습니다"만 뜨고 무엇이 잘못됐는지 알 수 없었다 — 클라이언트 id
      // 불일치·콘솔 미등록이 전부 이 갈래로 온다.
      _log.e('google 로그인 실패: code=${e.code} ${e.description}');
      throw const AuthFailure(AuthFailureKind.unknown);
    } on AuthFailure {
      rethrow; // 위에서 이미 원인을 남겼다.
    } on Object catch (error, stackTrace) {
      // **SDK가 다른 예외를 던지는 경로가 있다.** `GoogleSignInException`만
      // 잡으면 그 예외는 그대로 위로 새어 화면에 "문제가 발생했습니다"만
      // 뜨고 원인이 사라진다(실기기 확인 2026-08-25).
      _log.e('google 로그인 실패(비 SDK 예외)', error: error, stackTrace: stackTrace);
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
  /// **동의 창을 다시 띄우지 않는 경로를 먼저 쓴다.** 스펙 §1이 "사용자에게
  /// 보이는 변화는 없다"이므로 로그인 한 번에 창도 한 번이어야 한다.
  ///
  /// iOS는 `authenticate()` 응답에 code가 이미 실려 오고 플러그인이 그것을
  /// 캐시해 둔다. 그래서 `promptIfUnauthorized: false`로 물으면 UI 없이 캐시된
  /// code가 나온다. 반면 `authorizationClient.authorizeServer()`는 이 값을
  /// `true`로 고정해 놓아, 이미 가진 code를 두고도 창을 한 번 더 띄운다.
  ///
  /// 안드로이드는 authenticate와 authorize가 서로 다른 SDK 호출이라 첫 로그인
  /// 때는 조용한 경로가 빈손으로 돌아온다. 그때만 창을 띄우는 쪽으로 넘어간다.
  ///
  /// 안드로이드에서 code를 받으려면 `initialize(serverClientId:)`에 **웹**
  /// 클라이언트 id가 들어가 있어야 한다. 없으면 네이티브가 `requestOfflineAccess`
  /// 를 호출하지 않아 code를 요청조차 하지 않는다 — 값은 `SnsConfig`가 빌드
  /// 시점에 받는다.
  Future<String?> _googleServerAuthCode(GoogleSignInAccount account) =>
      optionalCode(
        () => codeSilentlyOrPrompt(
          silently: () => _googleCodeWithoutPrompt(account),
          withPrompt: () async =>
              (await account.authorizationClient.authorizeServer(
                _googleServerScopes,
              ))?.serverAuthCode,
        ),
      );

  /// 동의 창 없이 server auth code를 묻는다. 없으면 null.
  ///
  /// `authorizeServer`에 대응하는 조용한 public API가 없어서(client authz에는
  /// silent/prompt 쌍이 있는데 server authz에는 prompt만 있다) 플랫폼 인터페이스를
  /// 직접 부른다. 두 심볼 모두 정식 public 선언이다.
  Future<String?> _googleCodeWithoutPrompt(GoogleSignInAccount account) async {
    final ServerAuthorizationTokenData? tokens = await GoogleSignInPlatform
        .instance
        .serverAuthorizationTokensForScopes(
          ServerAuthorizationTokensForScopesParameters(
            request: AuthorizationRequestDetails(
              scopes: _googleServerScopes,
              userId: account.id,
              email: account.email,
              promptIfUnauthorized: false,
            ),
          ),
        );
    return tokens?.serverAuthCode;
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
        _log.e('apple identityToken 없음 — App ID에 Sign in with Apple이 켜져 있는지 본다');
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
      // 구글과 같은 이유로 원인을 남긴다 — App ID 미등록·entitlement 누락이
      // 전부 이 갈래로 오는데, 뭉개면 화면에 "문제가 발생했습니다"만 뜬다.
      _log.e('apple 로그인 실패: code=${e.code} ${e.message}');
      throw const AuthFailure(AuthFailureKind.unknown);
    } on AuthFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      _log.e('apple 로그인 실패(비 SDK 예외)', error: error, stackTrace: stackTrace);
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
        // 로그인 자체는 성공했는데(access token은 받았다) id_token만 없는
        // 상태다 — 카카오 개발자 콘솔에서 OpenID Connect를 켜야 한다.
        _log.e(
          'kakao id_token 없음 — 개발자 콘솔에서 OpenID Connect를 '
          '활성화해야 한다 (accessToken은 받았다: ${token.accessToken.isNotEmpty})',
        );
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
    } on KakaoAuthException catch (e, stackTrace) {
      if (e.error == AuthErrorCause.accessDenied) {
        throw const SnsCancelledException();
      }
      // 사용자 취소가 아닌 인증 실패 — 앱 키·redirect URI 불일치, 콘솔 설정
      // 누락 등이 여기로 온다. 원인을 남기지 않으면 화면에 "문제가
      // 발생했습니다"만 뜨고 무엇이 잘못됐는지 알 수 없다.
      _log.e(
        'kakao 인증 실패: ${e.error} ${e.errorDescription}',
        error: e,
        stackTrace: stackTrace,
      );
      throw const AuthFailure(AuthFailureKind.unknown);
    } on KakaoException catch (e, stackTrace) {
      _log.e('kakao SDK 오류', error: e, stackTrace: stackTrace);
      throw const AuthFailure(AuthFailureKind.unknown);
    }
  }
}
