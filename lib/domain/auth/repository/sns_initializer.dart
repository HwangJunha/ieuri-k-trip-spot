import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'sns_config.dart';

/// One-time SNS SDK setup, called from `main()` before the app runs (spec §7).
///
/// Only Kakao needs eager init (`KakaoSdk.init` with the native app key). Google
/// v7 initializes lazily inside [SnsAuthenticator], and Apple needs no init. If
/// the Kakao key isn't injected, init is skipped so a build without Kakao
/// configured still starts (Kakao login then fails gracefully at use).
class SnsInitializer {
  const SnsInitializer._();

  static void ensureInitialized() {
    if (SnsConfig.kakaoNativeAppKey.isNotEmpty) {
      KakaoSdk.init(nativeAppKey: SnsConfig.kakaoNativeAppKey);
    }
  }
}
