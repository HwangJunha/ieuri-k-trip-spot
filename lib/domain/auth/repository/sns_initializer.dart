import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../../common/log/app_log.dart';
import 'sns_config.dart';

/// One-time SNS SDK setup, called from `main()` before the app runs (spec §7).
///
/// Only Kakao needs eager init (`KakaoSdk.init` with the native app key). Google
/// v7 initializes lazily inside [SnsAuthenticator], and Apple needs no init. If
/// the Kakao key isn't injected, init is skipped so a build without Kakao
/// configured still starts (Kakao login then fails gracefully at use).
class SnsInitializer {
  const SnsInitializer._();

  static const AppLog _log = AppLog('SnsInitializer');

  static void ensureInitialized() {
    if (SnsConfig.kakaoNativeAppKey.isNotEmpty) {
      KakaoSdk.init(nativeAppKey: SnsConfig.kakaoNativeAppKey);
      return;
    }
    // 키가 없으면 카카오 로그인은 반드시 실패한다. 조용히 넘어가면 실기기에서
    // 원인을 짚을 수 없으므로 남긴다 — `--dart-define-from-file` 인자가 빠졌을 때
    // 가장 먼저 확인할 신호다.
    _log.warn(
      'KAKAO_NATIVE_APP_KEY가 비어 카카오 SDK 초기화를 건너뛴다 — '
      '카카오 로그인은 동작하지 않는다',
    );
  }
}
