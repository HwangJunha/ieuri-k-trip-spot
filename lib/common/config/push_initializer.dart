import 'package:firebase_core/firebase_core.dart';

import '../log/app_log.dart';

/// Firebase 초기화(SPEC-0028 §3.1).
///
/// **`MapSdkInitializer`와 같은 규칙을 따른다: 설정이 없으면 조용히 건너뛰고 앱 기동을
/// 막지 않는다.** 알림을 못 받는 것은 앱을 막을 이유가 되지 않는다(설계 §9 · R14).
///
/// 설정 파일(`android/app/google-services.json` ·
/// `ios/Runner/GoogleService-Info.plist`)은 환경마다 값이 달라 커밋하지 않는다
/// (.gitignore — SNS 설정·`.env`와 같은 취급). 그래서 **파일이 없는 상태가 정상적으로
/// 일어날 수 있고**, 그때 [initializeApp]은 던진다.
///
/// - Android: 파일이 없으면 Gradle 플러그인 자체가 붙지 않아(`app/build.gradle.kts`)
///   네이티브 설정이 비고, 초기화가 실패한다
/// - iOS: 파일이 없으면 초기화가 실패한다
///
/// 두 경우 모두 여기서 예외를 삼키고 [isReady]가 거짓으로 남는다. 그러면
/// `pushMessagingServiceProvider`가 스텁 구현을 골라 토큰을 발급하지 않고, 앱은 사용자가
/// 알림 권한을 거부했을 때와 **같은 경로**를 탄다.
abstract final class PushInitializer {
  static const AppLog _log = AppLog('PushInitializer');

  /// Firebase가 실제로 초기화됐는지. 설정 파일이 없으면 거짓이다.
  static bool get isReady => _isReady;
  static bool _isReady = false;

  static Future<void> ensureInitialized() async {
    if (_isReady) return;
    try {
      await Firebase.initializeApp();
      _isReady = true;
    } on Object catch (error, stackTrace) {
      // 앱 기동을 막지 않는다. 알림만 빠지고 나머지는 그대로 동작한다(설계 §3.1).
      _log.warn(
        'Firebase 초기화를 건너뛴다 — 설정 파일이 없거나 잘못됐다. '
        '앱은 알림 없이 정상 동작한다(설계 §11)',
        error,
        stackTrace,
      );
    }
  }
}
