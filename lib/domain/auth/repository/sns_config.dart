/// SNS SDK keys, injected at build time via `--dart-define` (spec §7.4) so no
/// key is hardcoded or committed. These are public client identifiers (not
/// secrets), but the project keeps them out of source per its storage policy.
///
/// Required defines for SNS auth to work:
///   `--dart-define=GOOGLE_SERVER_CLIENT_ID=...` (Firebase web client id)
///   `--dart-define=KAKAO_NATIVE_APP_KEY=...` (Kakao native app key)
///
/// The Google server (web) client id is what the server verifies the Google
/// id_token's `aud` against (spec §6.1/§8.3), so it must be the WEB client id,
/// not the Android/iOS one.
class SnsConfig {
  const SnsConfig._();

  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  static const String kakaoNativeAppKey = String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
  );
}
