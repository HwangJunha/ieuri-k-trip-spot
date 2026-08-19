import 'package:flutter/foundation.dart';

/// Firebase 초기화 자리(SPEC-0028 §3.1).
///
/// **`MapSdkInitializer`와 같은 규칙을 따른다: 설정이 없으면 조용히 건너뛰고 앱 기동을
/// 막지 않는다.** 알림을 못 받는 것은 앱을 막을 이유가 되지 않는다(설계 §9).
///
/// **지금은 아무것도 하지 않는다.** `android/app/google-services.json`과
/// `ios/Runner/GoogleService-Info.plist`가 아직 저장소에 없기 때문이다(설계 §11).
/// 두 파일과 `firebase_core`·`firebase_messaging` 의존이 들어오면 여기서
/// `Firebase.initializeApp()`을 부르고, [isReady]가 참이 되며,
/// `pushMessagingServiceProvider`가 실제 구현으로 바뀐다.
///
/// 그때까지 앱은 `UnavailablePushMessagingService`를 써서 토큰을 발급받지 못하고,
/// 그 상태는 사용자가 알림 권한을 거부했을 때와 정확히 같은 경로를 탄다(R14).
abstract final class PushInitializer {
  /// 설정 파일이 저장소에 있는지(설계 §11).
  ///
  /// 지금은 상수 `false`다 — 두 파일이 아직 없다. 파일과 `firebase_core` 의존이
  /// 들어오면 이 값이 실제 초기화 결과를 반영하게 바뀐다.
  static const bool isReady = false;

  /// 설정 파일이 들어오면 이 자리에서 `Firebase.initializeApp()`을 부르고, 실패는
  /// `try/on Exception`으로 삼킨다 — 초기화 실패가 앱 기동을 막으면 안 된다
  /// (설계 §3.1, `MapSdkInitializer`와 같은 규칙).
  static Future<void> ensureInitialized() async {
    if (kDebugMode) {
      debugPrint(
        '[Alarm] Firebase 설정 파일이 없어 푸시 초기화를 건너뛴다 — '
        '앱은 알림 없이 정상 동작한다(설계 §11)',
      );
    }
  }
}
