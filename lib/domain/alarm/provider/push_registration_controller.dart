import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../../../common/permission/model/permission_kind.dart';
import '../../../common/permission/model/permission_state.dart';
import '../../../common/permission/provider/permission_providers.dart';
import '../model/device_registration.dart';
import '../repository/alarm_repository.dart';
import '../repository/alarm_repository_impl.dart';
import '../repository/push_messaging_service.dart';
import '../repository/sent_registration_store.dart';
import 'alarm_store_providers.dart';

part 'push_registration_controller.g.dart';

/// 알림 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지 않는다).
/// 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
@Riverpod(keepAlive: true)
AlarmRepository alarmRepository(Ref ref) =>
    AlarmRepositoryImpl(ref.watch(graphqlClientProvider));

/// FCM 플러그인 경계. Firebase 설정이 들어오면 이 provider 하나만 갈아 끼운다
/// (`push_messaging_service.dart` 참조).
@Riverpod(keepAlive: true)
PushMessagingService pushMessagingService(Ref ref) =>
    const UnavailablePushMessagingService();

/// 기기 OS 언어 코드. 앱 언어 설정이 아니다 — 알림은 앱 밖에서 표시되므로 사용자가
/// 그 순간 읽는 언어는 OS 언어다(설계 §8).
@Riverpod(keepAlive: true)
String deviceLanguageCode(Ref ref) =>
    PlatformDispatcher.instance.locale.languageCode;

/// 이 기기의 플랫폼. 테스트가 갈아 끼울 수 있게 provider로 둔다 — `Platform`은
/// 위젯 테스트에서 흉내 낼 수 없다.
@Riverpod(keepAlive: true)
DevicePlatform devicePlatform(Ref ref) => currentDevicePlatform();

/// 기기 푸시 등록의 수명주기(SPEC-0028 R1·R2·R20).
///
/// **인증 전이는 이 notifier가 듣지 않는다.** `auth_controller`가 alarm을 알 이유가
/// 없으므로 방향을 뒤집어, 이것을 구독하는 쪽(`PushRegistrationGate`)이 인증 상태를
/// 보고 [register]·[unregister]를 부른다(설계 §3.2).
///
/// **실패는 전부 조용하다.** 등록이 실패해도 사용자에게 아무것도 보여주지 않고 로그만
/// 남기며, 즉시 재시도 루프를 만들지 않는다 — 재시도는 다음 기동 시점이다
/// (R12·AC12.3 · POL-040).
@Riverpod(keepAlive: true)
class PushRegistrationController extends _$PushRegistrationController {
  /// 마지막 시도의 결과. 화면에 쓰지 않으며 테스트와 디버깅용이다.
  @override
  PushRegistrationOutcome build() => PushRegistrationOutcome.idle;

  /// 등록한다(R1). 권한이 없거나 발급값을 받지 못하면 **시도하지 않는다**(AC14.3).
  ///
  /// [force]가 거짓이면 직전에 보낸 값과 같을 때 건너뛴다(R20) — 포그라운드 복귀마다
  /// 무조건 재등록하면 불필요한 왕복이 생긴다.
  Future<void> register({bool force = false}) async {
    final PermissionState permission = await ref
        .read(permissionControllerProvider.notifier)
        .check(PermissionKind.notification);
    if (permission != PermissionState.granted) {
      // 권한이 없으면 등록하지 않는다. **재요청 다이얼로그를 띄우지 않는다**(AC14.2).
      state = PushRegistrationOutcome.permissionDenied;
      return;
    }

    final String? issued = await ref.read(pushMessagingServiceProvider).token();
    if (issued == null || issued.isEmpty) {
      state = PushRegistrationOutcome.noToken;
      return;
    }

    final DeviceRegistration registration = DeviceRegistration(
      deviceId: await ref.read(deviceIdStoreProvider).readOrCreate(),
      fcmToken: issued,
      languageCode: languageFromDeviceCode(ref.read(deviceLanguageCodeProvider)),
      platform: ref.read(devicePlatformProvider),
    );

    final SentRegistrationStore sent = ref.read(sentRegistrationStoreProvider);
    if (!force && !sent.hasChanged(registration.digest)) {
      state = PushRegistrationOutcome.unchanged;
      return;
    }

    try {
      await ref.read(alarmRepositoryProvider).registerDeviceToken(registration);
      await sent.write(registration.digest);
      state = PushRegistrationOutcome.registered;
    } on Object catch (error) {
      // 조용히 실패한다 — 알림을 못 받는 것은 앱을 막을 이유가 되지 않는다(설계 §9).
      if (kDebugMode) debugPrint('[Alarm] 기기 등록 실패: $error');
      state = PushRegistrationOutcome.failed;
    }
  }

  /// 로그아웃 시 해제한다(R2).
  ///
  /// **세션이 사라지기 전에 불러야 한다** — `deleteDeviceToken`이 인증을 요구하므로
  /// 순서가 뒤집히면 실패한다(설계 §3.2).
  Future<void> unregister() async {
    final String deviceId = await ref
        .read(deviceIdStoreProvider)
        .readOrCreate();
    try {
      await ref.read(alarmRepositoryProvider).deleteDeviceToken(deviceId);
    } on Object catch (error) {
      // 해제 실패도 조용하다. 서버는 다음 발송에서 무효 등록을 스스로 지운다(R4).
      if (kDebugMode) debugPrint('[Alarm] 기기 해제 실패: $error');
    } finally {
      // **지문은 반드시 지운다.** 남겨 두면 다음 로그인에서 "안 바뀌었다"고 판단해
      // 등록을 건너뛰고, 그 계정은 알림을 영영 못 받는다.
      await ref.read(sentRegistrationStoreProvider).clear();
      state = PushRegistrationOutcome.unregistered;
    }
  }
}

/// 마지막 시도의 결과. 사용자에게 보여주는 값이 아니다(R12).
enum PushRegistrationOutcome {
  idle,

  /// 등록했다.
  registered,

  /// 직전과 같아 보내지 않았다(R20).
  unchanged,

  /// 권한이 없어 시도하지 않았다(AC14.3).
  permissionDenied,

  /// 발급값을 받지 못해 시도하지 않았다 — Firebase 미설정이 여기로 온다.
  noToken,

  /// 서버 호출이 실패했다. 다음 기동에서 다시 시도한다(AC12.3).
  failed,

  /// 해제했다.
  unregistered,
}
