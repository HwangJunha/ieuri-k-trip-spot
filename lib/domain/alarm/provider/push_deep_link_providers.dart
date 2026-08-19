import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/push_destination.dart';
import '../repository/push_messaging_service.dart';
import 'push_registration_controller.dart';

part 'push_deep_link_providers.g.dart';

/// 알림 탭이 만드는 목적지를 화면 계층에 흘린다(SPEC-0028 R16·R17).
///
/// **왜 얇은 provider를 한 겹 두는가.** `PushMessagingService`는 repository 계층의
/// 인터페이스라 component가 그것을 직접 읽으면 계층을 건너뛴다(CLAUDE.md §3 —
/// component는 provider·model·common만 본다). 다른 기능의 repository가 전부 provider
/// 안에서만 소비되는 것과 같은 모양을 지킨다.

/// 알림 탭 스트림을 감싸 값으로 넘긴다.
///
/// **왜 감싸는가.** `@riverpod`가 `Stream<T>` 반환을 보면 `AsyncValue<T>`를 노출하는
/// StreamProvider를 만드는데, 구독자는 이벤트가 올 때마다 `context.go`를 불러야 해서
/// 접힌 마지막 값이 아니라 **이벤트 하나하나**가 필요하다. Riverpod 3에는 생성된
/// StreamProvider에서 원본 스트림을 꺼내는 `.stream`이 없으므로, 한 겹 감싸 평범한
/// 값으로 돌려준다.
class PushTapStream {
  const PushTapStream(this.stream);

  final Stream<PushDestination> stream;
}

/// 백그라운드에서 알림을 탭해 돌아온 경우의 목적지(R16).
///
/// 포그라운드 수신은 여기 흐르지 않는다 — 배너도 띄우지 않고 화면도 바꾸지 않는다
/// (R15·AC15.2).
@Riverpod(keepAlive: true)
PushTapStream pushNotificationTaps(Ref ref) => PushTapStream(
  ref.watch(pushMessagingServiceProvider).notificationTaps(),
);

/// 토큰 로테이션 스트림을 감싸 값으로 넘긴다([PushTapStream]과 같은 이유).
class PushTokenRefreshStream {
  const PushTokenRefreshStream(this.stream);

  final Stream<String> stream;
}

/// FCM이 토큰을 새로 발급했을 때 흐른다(서버 안내 §2 — 재등록 시점 중 하나).
@Riverpod(keepAlive: true)
PushTokenRefreshStream pushTokenRefreshes(Ref ref) => PushTokenRefreshStream(
  ref.watch(pushMessagingServiceProvider).tokenRefreshes(),
);

/// 앱 전체에 한 번 하는 알림 준비 — Android 채널 2개 생성과 포그라운드 알림 표시
/// (설계 §5·§6).
///
/// **인증과 무관하다.** 로그인하지 않아도 채널은 있어야 하고, 표시 설정은 앱 전체
/// 설정이다. 그래서 등록 흐름(R1)이 아니라 별도 provider로 둔다.
///
/// 실패는 서비스 구현이 이미 삼킨다 — 채널이 없으면 Android에서 알림이 표시되지 않을
/// 뿐 앱은 정상 동작한다.
@Riverpod(keepAlive: true)
Future<void> pushNotificationSetup(Ref ref) async {
  final PushMessagingService service = ref.watch(pushMessagingServiceProvider);
  await service.ensureChannels();
  await service.enableForegroundNotifications();
}

/// 앱이 **종료 상태**에서 알림 탭으로 기동된 경우의 목적지(R17). 그런 경우가 아니면
/// null이다.
@Riverpod(keepAlive: true)
Future<PushDestination?> pushInitialDestination(Ref ref) =>
    ref.watch(pushMessagingServiceProvider).initialDestination();
