import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'session_teardown.dart';

part 'session_teardown_provider.g.dart';

/// 세션 정리 훅의 단일 출처(SPEC-0028 §3.2).
///
/// `TokenRefreshBridge`가 네트워크 계층과 auth의 순환을 콜백으로 끊은 것과 같은
/// 방식이다 — 등록하는 쪽(alarm)과 부르는 쪽(auth)이 서로를 import하지 않는다.
@Riverpod(keepAlive: true)
SessionTeardown sessionTeardown(Ref ref) => SessionTeardown();
