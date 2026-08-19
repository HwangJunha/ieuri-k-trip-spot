import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/model/device_registration.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/model/notification_preference.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/provider/alarm_store_providers.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/provider/notification_preference_controller.dart';
import 'package:ieuri_k_trip_spot/domain/alarm/provider/push_registration_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';

import '../../common/permission/permission_test_doubles.dart';
import '../auth/auth_test_doubles.dart';
import 'alarm_test_doubles.dart';

/// 알림 provider/notifier(SPEC-0028 §10) — 등록 시점·언어 갱신·토글·권한 게이팅.

/// 인증을 마친 컨테이너. 알림 설정 provider가 인증을 watch하므로 먼저 해소해 둔다.
Future<ProviderContainer> _container({
  required FakeAlarmRepository repo,
  FakePushMessagingService? messaging,
  FakeDeviceIdStore? deviceId,
  FakeSentRegistrationStore? sent,
  FakePermissionService? permission,
  String deviceLanguage = 'ko',
  bool authenticated = true,
}) async {
  final SecureStorage secure = await seededSecureStorage(
    authenticated: authenticated,
    onboarded: authenticated,
  );
  final ProviderContainer container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(secure),
      authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
      alarmRepositoryProvider.overrideWithValue(repo),
      pushMessagingServiceProvider.overrideWithValue(
        messaging ?? FakePushMessagingService(),
      ),
      deviceIdStoreProvider.overrideWithValue(
        deviceId ?? FakeDeviceIdStore(),
      ),
      sentRegistrationStoreProvider.overrideWithValue(
        sent ?? FakeSentRegistrationStore(),
      ),
      permissionServiceProvider.overrideWithValue(
        permission ??
            FakePermissionService(
              initial: <PermissionKind, PermissionState>{
                PermissionKind.notification: PermissionState.granted,
              },
            ),
      ),
      deviceLanguageCodeProvider.overrideWithValue(deviceLanguage),
      devicePlatformProvider.overrideWithValue(DevicePlatform.android),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  return container;
}

void main() {
  group('기기 등록 (R1 · AC14.3)', () {
    test('권한이 있으면 등록한다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final ProviderContainer container = await _container(repo: repo);

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      expect(repo.registrations, hasLength(1));
      expect(
        container.read(pushRegistrationControllerProvider),
        PushRegistrationOutcome.registered,
      );
    });

    test('권한이 거부되면 등록을 시도하지 않는다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final ProviderContainer container = await _container(
        repo: repo,
        permission: FakePermissionService(
          initial: <PermissionKind, PermissionState>{
            PermissionKind.notification: PermissionState.denied,
          },
        ),
      );

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      expect(
        repo.registrations,
        isEmpty,
        reason: '권한이 없는데 등록하면 서버에 못 쓰는 토큰이 쌓인다',
      );
      expect(
        container.read(pushRegistrationControllerProvider),
        PushRegistrationOutcome.permissionDenied,
      );
    });

    test('발급값이 없으면 등록을 시도하지 않는다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final ProviderContainer container = await _container(
        repo: repo,
        messaging: FakePushMessagingService(issuedToken: null),
      );

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      expect(repo.registrations, isEmpty);
      expect(
        container.read(pushRegistrationControllerProvider),
        PushRegistrationOutcome.noToken,
        reason: 'Firebase 미설정이 이 경로로 온다 — 앱은 그대로 동작해야 한다',
      );
    });

    test('등록이 실패해도 예외가 밖으로 새지 않는다 (AC12.3)', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository(failRegister: true);
      final ProviderContainer container = await _container(repo: repo);

      // 던지면 이 await에서 테스트가 실패한다 — 조용한 실패가 요구사항이다.
      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      expect(
        container.read(pushRegistrationControllerProvider),
        PushRegistrationOutcome.failed,
      );
    });

    test('기기 언어를 서버 값으로 옮겨 보낸다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final ProviderContainer container = await _container(
        repo: repo,
        deviceLanguage: 'ja',
      );

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      expect(repo.registrations.single.languageCode, 'JA');
    });
  });

  group('재등록 판정 (R20)', () {
    test('직전과 같으면 보내지 않는다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final FakeSentRegistrationStore sent = FakeSentRegistrationStore();
      final ProviderContainer container = await _container(
        repo: repo,
        sent: sent,
      );

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();
      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      expect(
        repo.registrations,
        hasLength(1),
        reason: '포그라운드 복귀마다 왕복이 생기면 안 된다',
      );
      expect(
        container.read(pushRegistrationControllerProvider),
        PushRegistrationOutcome.unchanged,
      );
    });

    test('기기 언어가 바뀌면 다시 보낸다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final FakeSentRegistrationStore sent = FakeSentRegistrationStore();

      final ProviderContainer first = await _container(
        repo: repo,
        sent: sent,
        deviceLanguage: 'ko',
      );
      await first
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      // 같은 저장소를 물려주고 언어만 바꾼다 — 기기 언어가 바뀐 상황이다.
      final ProviderContainer second = await _container(
        repo: repo,
        sent: sent,
        deviceLanguage: 'ja',
      );
      await second
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      expect(repo.registrations, hasLength(2));
      expect(repo.registrations.last.languageCode, 'JA');
    });

    test('force면 같은 값이어도 보낸다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final FakeSentRegistrationStore sent = FakeSentRegistrationStore();
      final ProviderContainer container = await _container(
        repo: repo,
        sent: sent,
      );

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();
      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register(force: true);

      expect(repo.registrations, hasLength(2));
    });

    test('등록이 실패하면 지문을 남기지 않는다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository(failRegister: true);
      final FakeSentRegistrationStore sent = FakeSentRegistrationStore();
      final ProviderContainer container = await _container(
        repo: repo,
        sent: sent,
      );

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .register();

      expect(
        sent.saved,
        isNull,
        reason: '실패했는데 지문이 남으면 다음 기동에서 재시도를 건너뛴다',
      );
    });
  });

  group('해제 (R2)', () {
    test('그 기기의 deviceId로 해제한다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final ProviderContainer container = await _container(
        repo: repo,
        deviceId: FakeDeviceIdStore('device-9'),
      );

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .unregister();

      expect(repo.deletedDeviceIds, <String>['device-9']);
    });

    test('해제가 실패해도 지문은 지운다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository(failDelete: true);
      final FakeSentRegistrationStore sent = FakeSentRegistrationStore()
        ..saved = 'stale';
      final ProviderContainer container = await _container(
        repo: repo,
        sent: sent,
      );

      await container
          .read(pushRegistrationControllerProvider.notifier)
          .unregister();

      expect(
        sent.saved,
        isNull,
        reason: '남겨 두면 다음 로그인에서 등록을 건너뛰어 알림을 영영 못 받는다',
      );
    });

    test('해제 뒤 다시 등록하면 실제로 보낸다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final FakeSentRegistrationStore sent = FakeSentRegistrationStore();
      final ProviderContainer container = await _container(
        repo: repo,
        sent: sent,
      );
      final notifier = container.read(
        pushRegistrationControllerProvider.notifier,
      );

      await notifier.register();
      await notifier.unregister();
      await notifier.register();

      expect(repo.registrations, hasLength(2));
    });
  });

  group('알림 설정 (R19)', () {
    test('인증된 회원의 설정을 싣는다', () async {
      final ProviderContainer container = await _container(
        repo: FakeAlarmRepository(),
      );

      final List<NotificationPreference> result = await container.read(
        notificationPreferenceControllerProvider.future,
      );

      expect(result, hasLength(2));
      expect(result.isEnabled(NotificationCategory.message), isTrue);
    });

    test('미인증이면 조회하지 않는다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final ProviderContainer container = await _container(
        repo: repo,
        authenticated: false,
      );

      final List<NotificationPreference> result = await container.read(
        notificationPreferenceControllerProvider.future,
      );

      expect(result, isEmpty, reason: '설정은 회원에 묶인다 — 보낼 대상이 없다');
    });

    test('토글이 서버 응답을 기다리지 않고 즉시 반영된다', () async {
      final ProviderContainer container = await _container(
        repo: FakeAlarmRepository(),
      );
      await container.read(notificationPreferenceControllerProvider.future);

      final Future<void> pending = container
          .read(notificationPreferenceControllerProvider.notifier)
          .toggle(NotificationCategory.message, false);

      expect(
        container
            .read(notificationPreferenceControllerProvider)
            .value!
            .isEnabled(NotificationCategory.message),
        isFalse,
        reason: '낙관적 갱신이면 await 전에 이미 꺼져 있어야 한다',
      );
      await pending;
    });

    test('응답의 전체 설정으로 갈아 끼운다 (AC19.3)', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository();
      final ProviderContainer container = await _container(repo: repo);
      await container.read(notificationPreferenceControllerProvider.future);

      await container
          .read(notificationPreferenceControllerProvider.notifier)
          .toggle(NotificationCategory.spotQa, false);

      final List<NotificationPreference> result = container
          .read(notificationPreferenceControllerProvider)
          .value!;
      expect(result.isEnabled(NotificationCategory.spotQa), isFalse);
      expect(
        result.isEnabled(NotificationCategory.message),
        isTrue,
        reason: '카테고리는 독립이다 — 한쪽을 껐다고 다른 쪽이 변하면 안 된다',
      );
    });

    test('토글이 실패하면 원래 값으로 되돌아간다', () async {
      final FakeAlarmRepository repo = FakeAlarmRepository(failUpdate: true);
      final ProviderContainer container = await _container(repo: repo);
      await container.read(notificationPreferenceControllerProvider.future);

      await expectLater(
        container
            .read(notificationPreferenceControllerProvider.notifier)
            .toggle(NotificationCategory.message, false),
        throwsA(anything),
      );

      expect(
        container
            .read(notificationPreferenceControllerProvider)
            .value!
            .isEnabled(NotificationCategory.message),
        isTrue,
        reason: '실패했는데 꺼진 채로 남으면 사용자가 저장됐다고 오해한다',
      );
    });
  });
}
