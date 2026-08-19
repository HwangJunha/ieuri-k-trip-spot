import 'dart:async';

import 'package:ieuri_k_trip_spot/domain/alarm/model/alarm_failure.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/model/device_registration.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/model/notification_preference.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/model/push_destination.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/repository/alarm_repository.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/repository/device_id_store.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/repository/push_messaging_service.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/repository/sent_registration_store.dart';

/// SPEC-0028 알림 테스트가 함께 쓰는 페이크. 한자리에 모아 파일 수를 줄인다
/// (CLAUDE.md §8 — 파일 수가 실행 시간을 정한다).

/// 설정 가능한 [AlarmRepository] 페이크.
///
/// - [preferences]는 조회가 돌려주는 값
/// - [failRegister]·[failUpdate]는 해당 호출을 실패시킨다
/// - [registrations]·[deletedDeviceIds]는 실제로 무엇이 나갔는지 기록한다
class FakeAlarmRepository implements AlarmRepository {
  FakeAlarmRepository({
    List<NotificationPreference>? preferences,
    this.failRegister = false,
    this.failDelete = false,
    this.failUpdate = false,
    this.failFetch = false,
  }) : preferences =
           preferences ??
           <NotificationPreference>[
             const NotificationPreference(
               category: NotificationCategory.message,
               enabled: true,
             ),
             const NotificationPreference(
               category: NotificationCategory.spotQa,
               enabled: true,
             ),
           ];

  List<NotificationPreference> preferences;
  bool failRegister;
  bool failDelete;
  bool failUpdate;
  bool failFetch;

  final List<DeviceRegistration> registrations = <DeviceRegistration>[];
  final List<String> deletedDeviceIds = <String>[];

  /// 등록 호출을 붙잡아 두고 싶을 때 쓴다(동시성 테스트).
  Completer<void>? registerGate;

  @override
  Future<void> registerDeviceToken(DeviceRegistration registration) async {
    if (registerGate != null) await registerGate!.future;
    if (failRegister) throw AlarmFailure.network;
    registrations.add(registration);
  }

  @override
  Future<void> deleteDeviceToken(String deviceId) async {
    if (failDelete) throw AlarmFailure.network;
    deletedDeviceIds.add(deviceId);
  }

  @override
  Future<List<NotificationPreference>> fetchPreferences() async {
    if (failFetch) throw AlarmFailure.network;
    return preferences;
  }

  @override
  Future<List<NotificationPreference>> updatePreference({
    required NotificationCategory category,
    required bool enabled,
  }) async {
    if (failUpdate) throw AlarmFailure.network;
    preferences = preferences
        .map(
          (NotificationPreference p) =>
              p.category == category ? p.copyWith(enabled: enabled) : p,
        )
        .toList();
    return preferences;
  }
}

/// 메모리 기반 [DeviceIdStore]. 한 번 만든 값을 계속 돌려준다.
class FakeDeviceIdStore implements DeviceIdStore {
  FakeDeviceIdStore([this.value = 'device-1']);

  String value;
  int createCalls = 0;

  @override
  Future<String> readOrCreate() async {
    createCalls++;
    return value;
  }
}

/// 메모리 기반 [SentRegistrationStore].
class FakeSentRegistrationStore implements SentRegistrationStore {
  String? saved;
  int clearCalls = 0;

  @override
  bool hasChanged(String digest) => saved != digest;

  @override
  Future<void> write(String digest) async => saved = digest;

  @override
  Future<void> clear() async {
    saved = null;
    clearCalls++;
  }
}

/// 스크립트 가능한 [PushMessagingService].
///
/// [token]이 null이면 발급받지 못한 상태다 — Firebase 미설정·권한 거부가 여기로 온다.
class FakePushMessagingService implements PushMessagingService {
  FakePushMessagingService({this.issuedToken = 'fcm-token-1', this.initial});

  String? issuedToken;
  PushDestination? initial;

  final StreamController<PushDestination> taps =
      StreamController<PushDestination>.broadcast();
  final StreamController<String> refreshes = StreamController<String>.broadcast();

  int channelCalls = 0;
  int suppressCalls = 0;

  @override
  Future<String?> token() async => issuedToken;

  @override
  Stream<String> tokenRefreshes() => refreshes.stream;

  @override
  Stream<PushDestination> notificationTaps() => taps.stream;

  @override
  Future<PushDestination?> initialDestination() async => initial;

  @override
  Future<void> ensureChannels() async => channelCalls++;

  @override
  Future<void> suppressForegroundBanners() async => suppressCalls++;

  Future<void> dispose() async {
    await taps.close();
    await refreshes.close();
  }
}
