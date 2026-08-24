import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

import '../../../common/log/app_log.dart';
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

  static final Logger _log = appLogger('FcmMessagingService');

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
        _log.d('APNs 토큰이 아직 없어 등록을 미룬다');
        return null;
      }
      return await _messaging.getToken();
    } on Object catch (error, stackTrace) {
      // 조용히 실패한다. 호출부는 null을 "지금은 없음"으로 다룬다(R14).
      _log.w('FCM 토큰 발급 실패', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Stream<String> tokenRefreshes() => _messaging.onTokenRefresh;

  /// 포그라운드에서 띄운 로컬 알림의 탭을 [notificationTaps]로 합류시키는 통로.
  ///
  /// FCM의 `onMessageOpenedApp`은 **백그라운드에서 깨어난 경우만** 흘린다. 포그라운드
  /// 알림은 우리가 직접 띄운 것이라 탭도 우리가 받아야 하는데, 사용자에게는 둘이 같은
  /// 동작이므로 목적지 스트림은 하나로 둔다.
  final StreamController<PushDestination> _localTaps =
      StreamController<PushDestination>.broadcast();

  @override
  Stream<PushDestination> notificationTaps() {
    // 백그라운드 탭과 포그라운드 알림 탭을 한 줄기로 합친다. `async` 패키지의
    // `StreamGroup`을 쓰지 않고 손으로 합치는 이유는 의존을 하나 더 들이지 않기
    // 위해서다 — 합칠 스트림이 둘뿐이라 이 정도면 충분하다.
    final StreamController<PushDestination> merged =
        StreamController<PushDestination>.broadcast();
    final List<StreamSubscription<PushDestination>> subscriptions =
        <StreamSubscription<PushDestination>>[];

    merged.onListen = () {
      subscriptions.addAll(<StreamSubscription<PushDestination>>[
        FirebaseMessaging.onMessageOpenedApp
            .map(_destinationOf)
            .where((PushDestination? d) => d != null)
            .cast<PushDestination>()
            .listen(merged.add),
        _localTaps.stream.listen(merged.add),
      ]);
    };
    merged.onCancel = () async {
      for (final StreamSubscription<PushDestination> s in subscriptions) {
        await s.cancel();
      }
      subscriptions.clear();
    };
    return merged.stream;
  }

  @override
  Future<PushDestination?> initialDestination() async {
    try {
      final RemoteMessage? initial = await _messaging.getInitialMessage();
      return initial == null ? null : _destinationOf(initial);
    } on Object catch (error, stackTrace) {
      _log.w('초기 메시지 조회 실패', error: error, stackTrace: stackTrace);
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
    } on Object catch (error, stackTrace) {
      _log.w('알림 채널 생성 실패', error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> enableForegroundNotifications() async {
    try {
      // iOS: 앱이 떠 있을 때 시스템이 배너를 띄우도록 켠다. 이것만으로 끝이며
      // 아래 `onMessage` 구독은 iOS에서 알림을 **두 번** 띄우지 않도록 Android로
      // 한정한다.
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 탭 응답기를 먼저 붙인다 — 알림을 띄우기 전에 준비돼 있어야 한다.
      await _local.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            // 권한은 이미 `permission_handler`가 받았다(SPEC-0001의 부팅 시퀀스).
            // 여기서 다시 요청하면 다이얼로그가 두 번 뜬다.
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );

      if (!Platform.isAndroid) return;

      // Android: 포그라운드 메시지는 시스템 트레이로 가지 않으므로 직접 띄운다.
      _foregroundMessages ??= FirebaseMessaging.onMessage.listen(_showLocal);
    } on Object catch (error, stackTrace) {
      _log.w('포그라운드 알림 설정 실패', error: error, stackTrace: stackTrace);
    }
  }

  StreamSubscription<RemoteMessage>? _foregroundMessages;

  /// 포그라운드에서 받은 메시지를 로컬 알림으로 띄운다.
  ///
  /// **목적지를 payload에 실어 둔다.** 탭했을 때 어디로 갈지는 그 값으로 복원하며,
  /// 백그라운드 탭과 같은 스트림으로 흘려보낸다.
  Future<void> _showLocal(RemoteMessage message) async {
    try {
      final RemoteNotification? notification = message.notification;
      // 서버는 `notification.title`만 싣고 본문은 비운다(서버 안내 §0).
      final String title = notification?.title ?? '';
      if (title.isEmpty) return;

      final Map<String, String> data = _stringData(message);
      final AndroidNotificationChannel channel = _channelFor(data['type']);

      await _local.show(
        // 같은 대화의 알림이 쌓이지 않도록 목적지를 id로 접는다 — 새 메시지가
        // 오면 같은 자리를 덮어쓴다.
        (data['conversationId'] ?? data['questionId'] ?? '0').hashCode,
        title,
        notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: channel.importance,
            priority: Priority.high,
          ),
        ),
        payload: jsonEncode(data),
      );
    } on Object catch (error, stackTrace) {
      _log.w('포그라운드 알림 표시 실패', error: error, stackTrace: stackTrace);
    }
  }

  /// 로컬 알림 탭 → 목적지 스트림.
  void _onLocalNotificationTap(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final Object? decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) return;
      final PushDestination? destination = PushDestination.tryParse(
        <String, String>{
          for (final MapEntry<String, dynamic> e in decoded.entries)
            if (e.value != null) e.key: e.value.toString(),
        },
      );
      if (destination != null) _localTaps.add(destination);
    } on FormatException {
      // 깨진 payload는 버린다 — 앱이 죽는 것보다 알림 하나를 놓치는 편이 낫다.
    }
  }

  /// 알림 종류에 맞는 채널. 모르는 종류는 질문·답변 쪽으로 보낸다 — DM 채널은
  /// 중요도가 높아 엉뚱한 알림을 그리로 보내면 더 시끄럽다.
  AndroidNotificationChannel _channelFor(String? type) =>
      type == PushNotificationType.dm.wireName
      ? _messageChannel
      : _spotQaChannel;

  /// FCM 데이터 페이로드에서 목적지를 복원한다.
  ///
  /// 값이 전부 문자열이라(FCM 데이터 메시지 제약) `Map<String, String>`으로 좁혀
  /// 순수 함수인 [PushDestination.tryParse]에 넘긴다. 복원할 수 없으면 null이고,
  /// 호출부가 기본 착지점으로 보낸다(AC16.4).
  PushDestination? _destinationOf(RemoteMessage message) =>
      PushDestination.tryParse(_stringData(message));

  /// FCM 데이터를 `Map<String, String>`으로 좁힌다. 값이 전부 문자열이라(데이터 메시지
  /// 제약) 손실이 없다.
  Map<String, String> _stringData(RemoteMessage message) => <String, String>{
    for (final MapEntry<String, dynamic> e in message.data.entries)
      if (e.value != null) e.key: e.value.toString(),
  };
}
