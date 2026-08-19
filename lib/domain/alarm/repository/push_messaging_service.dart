import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import '../model/device_registration.dart';
import '../model/push_destination.dart';

/// FCM 플러그인과 앱 사이의 경계(SPEC-0028).
///
/// **왜 포트를 두는가.** 두 가지 이유다.
///
/// 1. FCM 플러그인·OS 권한 다이얼로그·실제 알림 표시는 인프라라 검증하지 않는다
///    (설계 §10). 그 경계를 인터페이스로 그어야 등록 시점·언어 갱신·딥링크 복원 같은
///    **판단**을 단위 테스트로 확인할 수 있다.
/// 2. Firebase 설정 파일(`google-services.json`·`GoogleService-Info.plist`)이 아직
///    저장소에 없다(설계 §11). 플러그인을 직접 부르는 코드가 여기저기 흩어져 있으면
///    설정 파일이 들어오는 날 손댈 자리가 흩어진다.
///
/// 구현체 교체는 [pushMessagingServiceProvider] 하나를 덮어쓰는 것으로 끝난다.
abstract interface class PushMessagingService {
  /// 이 기기의 FCM 토큰. 발급받지 못했으면 null이다 — 권한 거부·설정 부재·플러그인
  /// 오류가 전부 여기로 모인다. **호출부는 null을 실패가 아니라 "지금은 없음"으로
  /// 다룬다**(R14·AC12.3).
  Future<String?> token();

  /// 토큰이 로테이션될 때마다 새 값을 흘린다. 재등록은 같은 `registerDeviceToken`을
  /// 다시 부르는 것이다 — 갱신 전용 연산이 없다(설계 §8).
  Stream<String> tokenRefreshes();

  /// 알림을 탭했을 때의 목적지.
  ///
  /// 백그라운드에서 깨어난 경우와, 포그라운드에서 띄운 알림을 탭한 경우가 모두
  /// 여기로 온다 — 사용자에게는 같은 동작이라 목적지 처리도 하나여야 한다.
  Stream<PushDestination> notificationTaps();

  /// 앱이 **종료 상태**에서 알림 탭으로 기동된 경우의 목적지. 그런 경우가 아니면
  /// null이다. 한 번만 유효하다(R17).
  Future<PushDestination?> initialDestination();

  /// Android 알림 채널을 만든다(설계 §6). Android 8+는 채널 없이 보낸 알림을 표시하지
  /// 않으므로 필수다. iOS에는 채널 개념이 없어 아무것도 하지 않는다.
  Future<void> ensureChannels();

  /// 포그라운드에서도 알림을 표시하도록 준비한다.
  ///
  /// **R15를 뒤집은 결과다(사용자 결정, 2026-08-19).** 원래 스펙은 "홈 배지가 이미
  /// 도착을 알린다"는 근거로 포그라운드 배너를 띄우지 않기로 했으나, 실기기 확인에서
  /// **알림을 놓치기 쉽다**는 판단이 나와 전부 띄우는 쪽으로 바꿨다(설계 §5 개정).
  ///
  /// 플랫폼별로 하는 일이 다르지만 **결과는 같아야 한다.**
  /// - iOS: 앱이 떠 있으면 시스템이 배너를 자동으로 띄우지 않는 것이 기본이라,
  ///   표시 옵션을 켜 주어야 한다
  /// - Android: 포그라운드 메시지가 시스템 트레이로 가지 않으므로, 앱이 직접
  ///   받아서 로컬 알림으로 띄워야 한다
  Future<void> enableForegroundNotifications();
}

/// Firebase가 아직 배선되지 않은 동안 쓰는 구현.
///
/// **토큰을 돌려주지 않으므로 등록이 일어나지 않는다** — 그래서 앱은 알림 없이 정상
/// 동작하고, 그 상태가 권한을 거부당했을 때와 정확히 같다(R14). 설정 파일과
/// `firebase_messaging` 의존이 들어오면 이 자리에 실제 구현을 끼운다.
///
/// 지도 SDK가 "키가 없으면 조용히 건너뛰고 앱 기동은 막지 않는다"고 판단한 것과 같은
/// 방식이다(설계 §3.1).
class UnavailablePushMessagingService implements PushMessagingService {
  const UnavailablePushMessagingService();

  @override
  Future<String?> token() async {
    if (kDebugMode) {
      debugPrint(
        '[Alarm] Firebase 설정이 없어 FCM 토큰을 건너뛴다 — '
        '앱은 알림 없이 정상 동작한다(설계 §11)',
      );
    }
    return null;
  }

  @override
  Stream<String> tokenRefreshes() => const Stream<String>.empty();

  @override
  Stream<PushDestination> notificationTaps() =>
      const Stream<PushDestination>.empty();

  @override
  Future<PushDestination?> initialDestination() async => null;

  @override
  Future<void> ensureChannels() async {}

  @override
  Future<void> enableForegroundNotifications() async {}
}

/// 이 기기의 플랫폼. 서버가 발송 페이로드 형식을 가르는 데 쓴다(계약).
///
/// 테스트에서 `Platform`을 흉내 낼 수 없으므로 값을 주입할 수 있게 열어 둔다.
DevicePlatform currentDevicePlatform() =>
    Platform.isIOS ? DevicePlatform.ios : DevicePlatform.android;
