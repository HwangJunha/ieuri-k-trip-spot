import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/pending_destination.dart';
import '../../../common/navigation/root_navigator_key.dart';
import '../model/push_destination.dart';
import '../provider/push_deep_link_providers.dart';

/// 알림 탭을 목적지 이동으로 잇는다(SPEC-0028 R16·R17).
///
/// **두 경로가 다르다.**
///
/// - **종료 상태**(R17): 앱이 알림 탭으로 기동됐다. 인증 게이트가 아직 판정 중이라
///   지금 이동하면 게이트가 되돌린다. 그래서 [PendingDestination]에 넣어 두고 게이트가
///   풀리는 순간 라우터가 꺼내 간다(AC17.1·AC17.2).
/// - **백그라운드**(R16): 앱이 이미 살아 있고 게이트도 이미 풀려 있다. 보관하면 다음
///   리다이렉트가 돌 때까지 아무 일도 일어나지 않으므로 **바로 이동한다.**
///
/// **포그라운드 수신은 여기 오지 않는다.** 배너도 띄우지 않고 화면도 바꾸지 않는다
/// (R15·AC15.2) — 그 판단은 `PushMessagingService`가 스트림에 흘리지 않는 것으로
/// 이미 끝나 있다.
///
/// 목적지를 복원할 수 없으면(알 수 없는 `type`·식별자 누락) **아무것도 하지 않는다** —
/// 사용자는 앱을 연 그대로의 화면에 있고 앱은 죽지 않는다(AC16.4).
class PushDeepLinkGate extends ConsumerStatefulWidget {
  const PushDeepLinkGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<PushDeepLinkGate> createState() => _PushDeepLinkGateState();
}

class _PushDeepLinkGateState extends ConsumerState<PushDeepLinkGate> {
  StreamSubscription<PushDestination>? _taps;

  @override
  void initState() {
    super.initState();
    // 첫 프레임 전에 보관해야 게이트보다 먼저 들어간다(설계 §3.3 — "가장 먼저").
    unawaited(_captureColdStart());
    _listenForTaps();
  }

  @override
  void dispose() {
    unawaited(_taps?.cancel());
    super.dispose();
  }

  /// 종료 상태에서 알림 탭으로 기동된 경우의 목적지를 보관한다(R17).
  ///
  /// 라우터가 게이트를 통과시키는 순간 꺼내 가며, 한 번 꺼내면 비므로 재소비가
  /// 자동으로 막힌다(AC17.4).
  Future<void> _captureColdStart() async {
    final PushDestination? destination = await ref.read(
      pushInitialDestinationProvider.future,
    );
    if (destination == null) return;
    ref.read(pendingDestinationProvider).rememberIfAbsent(destination.location);
  }

  /// 백그라운드에서 탭해 돌아온 경우 바로 이동한다(R16).
  void _listenForTaps() {
    _taps = ref.read(pushNotificationTapsProvider).stream.listen(_go);
  }

  void _go(PushDestination destination) {
    final BuildContext? context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      // 트리가 아직 없다 = 사실상 종료 상태다. 보관 경로로 떨어뜨린다.
      ref
          .read(pendingDestinationProvider)
          .rememberIfAbsent(destination.location);
      return;
    }
    context.go(destination.location);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
