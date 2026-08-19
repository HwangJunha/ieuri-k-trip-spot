import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // FCM 푸시(SPEC-0028). APNs가 발급한 기기 토큰을 받으려면 등록을 요청해야 한다.
    //
    // **권한 요청이 아니다** — 권한은 `permission_handler`가 이미 받는다(SPEC-0001의
    // 부팅 시퀀스). 이것은 "APNs에 이 기기를 등록해 달라"는 별개 요청이고, 이게 없으면
    // `FirebaseMessaging.getAPNSToken()`이 계속 nil이라 FCM 토큰도 나오지 않는다.
    //
    // 권한이 거부돼 있으면 시스템이 조용히 무시하므로 여기서 분기하지 않는다.
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
