import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../model/push_destination.dart';
import 'push_messaging_service.dart';

/// `firebase_messaging` 기반 [PushMessagingService](SPEC-0028).
///
/// **이 파일이 플러그인을 아는 유일한 자리다.** 나머지 코드는 [PushMessagingService]
/// 인터페이스만 보므로, 플러그인 API가 바뀌어도 수정 범위가 여기서 끝난다.
///
/// 실패를 밖으로 던지지 않는다 — 알림을 못 받는 것은 앱을 막을 이유가 되지 않는다
/// (설계 §9 · R12·AC12.3).
class FcmMessagingService implements PushMessagingService {
  FcmMessagingService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _local = localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;

  /// DM 채널. 상대가 보내는 만큼 오므로 Q&A와 성가심의 정도가 다르다(설계 §6).
  static const AndroidNotificationChannel _messageChannel =
      AndroidNotificationChannel(
        'ktripspot_messages',
        '메시지',
        description: '새 다이렉트 메시지',
        importance: Importance.high,
      );

  /// 질문·답변 채널. 가끔 온다.
  static const AndroidNotificationChannel _spotQaChannel =
      AndroidNotificationChannel(
        'ktripspot_spot_qa',
        '질문·답변',
        description: '내 질문에 달린 답변과 내 답변에 달린 답글',
        importance: Importance.defaultImportance,
      );

  @override
  Future<String?> token() async {
    try {
      // iOS는 APNs 토큰이 먼저 붙어야 FCM 토큰이 나온다. 아직이면 null이고, 그때는
      // 등록을 건너뛴다 — 다음 기동이나 `onTokenRefresh`에서 다시 시도한다.
      if (Platform.isIOS && await _messaging.getAPNSToken() == null) {
        if (kDebugMode) {
          debugPrint('[Alarm] APNs 토큰이 아직 없어 등록을 미룬다');
        }
        return null;
      }
      return await _messaging.getToken();
    } on Object catch (error) {
      // 조용히 실패한다. 호출부는 null을 "지금은 없음"으로 다룬다(R14).
      if (kDebugMode) debugPrint('[Alarm] FCM 토큰 발급 실패: $error');
      return null;
    }
  }

  @override
  Stream<String> tokenRefreshes() => _messaging.onTokenRefresh;

  @override
  Stream<PushDestination> notificationTaps() =>
      FirebaseMessaging.onMessageOpenedApp
          .map(_destinationOf)
          .where((PushDestination? d) => d != null)
          .cast<PushDestination>();

  @override
  Future<PushDestination?> initialDestination() async {
    try {
      final RemoteMessage? initial = await _messaging.getInitialMessage();
      return initial == null ? null : _destinationOf(initial);
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Alarm] 초기 메시지 조회 실패: $error');
      return null;
    }
  }

  @override
  Future<void> ensureChannels() async {
    // iOS에는 채널 개념이 없다(설계 §6).
    if (!Platform.isAndroid) return;
    try {
      final AndroidFlutterLocalNotificationsPlugin? android = _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android == null) return;
      // Android 8+는 채널 없이 보낸 알림을 표시하지 않으므로 필수다.
      // **서버가 채널을 지정하지 않는다**(서버 안내 §1) — 클라이언트가 만들어 둔다.
      await android.createNotificationChannel(_messageChannel);
      await android.createNotificationChannel(_spotQaChannel);
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Alarm] 알림 채널 생성 실패: $error');
    }
  }

  @override
  Future<void> suppressForegroundBanners() async {
    try {
      // **결과가 양쪽에서 같아야 한다**(설계 §5).
      //
      // iOS는 앱이 떠 있으면 시스템이 배너를 자동으로 띄우지 않는 것이 기본이라,
      // 아래 값을 전부 false로 두는 것이 곧 "아무것도 하지 않음"이다.
      //
      // Android는 `onMessage`를 구독하지 않으면 포그라운드 메시지가 표시되지 않는다 —
      // 이 클래스는 `onMessage`를 어디에서도 듣지 않으므로 그것으로 끝난다.
      // 그래서 여기서 하는 일은 iOS 쪽 명시뿐이다.
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );
    } on Object catch (error) {
      if (kDebugMode) debugPrint('[Alarm] 포그라운드 표시 설정 실패: $error');
    }
  }

  /// FCM 데이터 페이로드에서 목적지를 복원한다.
  ///
  /// 값이 전부 문자열이라(FCM 데이터 메시지 제약) `Map<String, String>`으로 좁혀
  /// 순수 함수인 [PushDestination.tryParse]에 넘긴다. 복원할 수 없으면 null이고,
  /// 호출부가 기본 착지점으로 보낸다(AC16.4).
  PushDestination? _destinationOf(RemoteMessage message) {
    final Map<String, String> data = <String, String>{
      for (final MapEntry<String, dynamic> e in message.data.entries)
        if (e.value != null) e.key: e.value.toString(),
    };
    return PushDestination.tryParse(data);
  }
}
