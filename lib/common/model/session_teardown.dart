import 'dart:async';

import 'package:flutter/foundation.dart';

/// 세션이 사라지기 **전에** 해야 할 정리 작업을 모으는 자리.
///
/// **왜 필요한가.** 로그아웃 시 기기 푸시 등록을 해제해야 하는데(SPEC-0028 R2),
/// `deleteDeviceToken`이 인증을 요구하므로 세션이 지워진 뒤에 부르면 실패한다
/// (설계 §3.2). 그래서 해제는 `signOut`이 저장소를 비우기 전에 일어나야 한다.
///
/// **그렇다고 auth가 alarm을 알면 안 된다**(CLAUDE.md §3 — 기능 간 의존 금지).
/// 그래서 의존을 뒤집는다: alarm이 자기 정리 작업을 여기 등록하고, auth는 "등록된
/// 것들을 부른다"는 사실만 안다. 두 기능 다 상대를 import하지 않고 이 공용 타입만
/// 본다.
///
/// 정리 작업의 **실패는 로그아웃을 막지 않는다.** 사용자가 나가겠다고 했으면 나가야
/// 한다 — 서버 정리는 실패해도 서버가 나중에 스스로 치운다(SPEC-0028 R4).
class SessionTeardown {
  SessionTeardown();

  final List<Future<void> Function()> _callbacks = <Future<void> Function()>[];

  /// 세션이 지워지기 전에 부를 작업을 더한다. 등록 순서대로 불린다.
  void register(Future<void> Function() callback) => _callbacks.add(callback);

  /// 등록된 작업을 전부 부른다. 하나가 실패해도 나머지는 계속한다.
  Future<void> run() async {
    for (final Future<void> Function() callback in _callbacks) {
      try {
        await callback();
      } on Object catch (error) {
        if (kDebugMode) debugPrint('[Session] 정리 작업 실패: $error');
      }
    }
  }
}
