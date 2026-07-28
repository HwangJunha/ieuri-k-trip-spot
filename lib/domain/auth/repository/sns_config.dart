/// SNS SDK keys, injected at build time via `--dart-define` (spec §7.4) so no
/// key is hardcoded or committed. These are public client identifiers (not
/// secrets), but the project keeps them out of source per its storage policy.
///
/// Required defines for SNS auth to work:
///   `--dart-define=GOOGLE_SERVER_CLIENT_ID=...` (Firebase web client id)
///   `--dart-define=KAKAO_NATIVE_APP_KEY=...` (Kakao native app key)
/// Optional:
///   `--dart-define=GOOGLE_IOS_CLIENT_ID=...` (iOS OAuth client id)
///
/// The Google server (web) client id is what the server verifies the Google
/// id_token's `aud` against (spec §6.1/§8.3), so it must be the WEB client id,
/// not the Android/iOS one. The iOS client id is a separate value the SDK needs
/// to present the sign-in on iOS; when unset the SDK reads `GIDClientID` from
/// Info.plist instead.
class SnsConfig {
  const SnsConfig._();

  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
  );

  static const String kakaoNativeAppKey = String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
  );
}
