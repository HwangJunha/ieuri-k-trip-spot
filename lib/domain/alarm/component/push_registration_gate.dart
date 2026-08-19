import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/model/session_teardown_provider.dart';
import '../../auth/model/auth_state.dart';
import '../../auth/provider/auth_controller.dart';
import '../provider/push_deep_link_providers.dart';
import '../provider/push_registration_controller.dart';

/// 인증 전이를 듣고 기기 등록·해제를 몬다(SPEC-0028 §3.2).
///
/// **방향이 핵심이다.** `auth_controller`를 고치지 않고 alarm이 그것을 `ref.listen`으로
/// 구독한다 — auth가 alarm을 알 이유가 없다(설계 §3.2). 그래서 이 위젯은 트리에
/// 얹히기만 하고 화면을 그리지 않는다.
///
/// **로그아웃 해제는 여기서 하지 않는다.** `deleteDeviceToken`이 인증을 요구하므로
/// 세션이 사라진 뒤에 부르면 실패한다. 세션이 이미 사라진 것을 보고 반응하는 이
/// 위젯은 원리적으로 늦다 — 해제는 로그아웃을 **실행하는** 쪽이 세션을 지우기 전에
/// 부른다(`AuthController.signOut`).
///
/// 포그라운드 복귀 때 언어가 바뀌었으면 재등록한다(R20). 바뀌지 않았으면 저장된
/// 지문이 같아 왕복이 생기지 않는다.
class PushRegistrationGate extends ConsumerStatefulWidget {
  const PushRegistrationGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<PushRegistrationGate> createState() =>
      _PushRegistrationGateState();
}

class _PushRegistrationGateState extends ConsumerState<PushRegistrationGate>
    with WidgetsBindingObserver {
  /// 같은 인증 상태로 두 번 등록하지 않기 위한 표시. 리다이렉트가 여러 번 돌아도
  /// 등록은 전이마다 한 번이면 된다.
  bool _registeredForSession = false;

  StreamSubscription<String>? _tokenRefreshes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 알림 채널 2개(Android)와 포그라운드 표시 억제(R15). **인증과 무관하다** —
    // 로그인하지 않아도 채널은 있어야 하고, 배너 억제는 앱 전체 설정이다.
    // 서버가 채널을 지정하지 않으므로 클라이언트가 만든다(서버 안내 §1).
    unawaited(
      ref.read(pushNotificationSetupProvider.future),
    );

    // 로그아웃이 세션을 지우기 **전에** 해제가 일어나도록 콜백을 걸어 둔다
    // (설계 §3.2). auth는 이 기능을 알지 못한 채 등록된 것을 부르기만 한다.
    ref
        .read(sessionTeardownProvider)
        .register(
          () => ref.read(pushRegistrationControllerProvider.notifier)
              .unregister(),
        );

    // 토큰 로테이션(서버 안내 §2 — `onTokenRefresh`). 새 값이 오면 지문이 달라지므로
    // 재등록이 실제로 나간다. 인증 전이면 등록 자체가 게이트에 막혀 조용히 끝난다.
    _tokenRefreshes = ref
        .read(pushTokenRefreshesProvider)
        .stream
        .listen((_) {
          if (!_registeredForSession) return;
          unawaited(
            ref.read(pushRegistrationControllerProvider.notifier).register(),
          );
        });
  }

  @override
  void dispose() {
    unawaited(_tokenRefreshes?.cancel());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!_registeredForSession) return;
    // 기기 언어가 바뀌었을 때만 실제 왕복이 생긴다(R20) — 지문이 같으면 건너뛴다.
    unawaited(
      ref.read(pushRegistrationControllerProvider.notifier).register(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthState>>(authControllerProvider, (
      AsyncValue<AuthState>? previous,
      AsyncValue<AuthState> next,
    ) {
      final bool authenticated = next.value?.isAuthenticated ?? false;

      if (!authenticated) {
        // 세션이 사라졌다. 해제는 `signOut`이 이미 했으므로 여기서는 다음 로그인을
        // 위해 표시만 되돌린다.
        _registeredForSession = false;
        return;
      }

      // **이메일 인증·온보딩까지 끝난 뒤에 등록한다.** 그 전에는 서버가 대부분의
      // 오퍼레이션을 거절하므로 등록도 실패한다(설계 §사용자 흐름 전제).
      final AuthState? value = next.value;
      if (value == null || !value.emailVerified || !value.onboardingCompleted) {
        return;
      }
      if (_registeredForSession) return;

      _registeredForSession = true;
      // **기동 시 등록은 지문과 무관하게 무조건 보낸다**(`force: true`).
      //
      // 서버가 FCM의 `UNREGISTERED` 응답을 보고 이 기기의 행을 **조용히 지울 수
      // 있는데**, 클라이언트는 그 사실을 알 방법이 없다(서버 안내 §5-8). 지문만
      // 믿으면 "안 바뀌었으니 건너뛴다"가 영원히 반복되어 그 계정은 알림을 영영 못
      // 받는다. 기동당 왕복 한 번이 그 위험보다 싸다.
      //
      // 포그라운드 복귀는 지문을 그대로 쓴다 — 복귀는 훨씬 잦고, 기동에서 이미
      // 한 번 복구했다.
      unawaited(
        ref
            .read(pushRegistrationControllerProvider.notifier)
            .register(force: true),
      );
    });

    return widget.child;
  }
}
