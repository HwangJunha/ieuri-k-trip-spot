import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/auth_state.dart';
import 'auth_controller.dart';

/// 세션에 매인 provider가 쓰는 헬퍼.
///
/// **`keepAlive` provider가 사용자 데이터를 들면 로그아웃해도 남는다.** 실제로
/// 로그아웃 뒤 전국 지도에 이전 사용자의 방문 칸이 그대로 보였다 — `signOut()`은
/// 토큰만 지우고 provider 캐시는 건드리지 않기 때문이다.
///
/// 고치는 방법은 두 가지였다.
///
/// 1. `signOut()`에서 목록을 놓고 일괄 무효화 — 새 provider를 추가할 때 그 목록에
///    등록하는 것을 잊으면 **다시 샌다**
/// 2. 각 provider가 `build()`에서 인증 상태를 watch — 자기 수명을 자기가 책임진다
///
/// **2를 골랐다**(사용자 결정, 2026-08-22). 등록을 잊을 자리가 없고, 이 레포에
/// `AgreementsController`·`NotificationPreferenceController`가 이미 그렇게 하고
/// 있어 검증된 방식이다.
///
/// 쓰는 법:
///
/// ```dart
/// @Riverpod(keepAlive: true)
/// class Something extends _$Something {
///   @override
///   Future<List<Thing>> build() async {
///     if (!ref.watchSignedIn()) return const <Thing>[];
///     return ref.watch(repositoryProvider).fetch();
///   }
/// }
/// ```
extension SessionScope on Ref {
  /// 지금 로그인되어 있는지. **watch이므로** 로그인·로그아웃이 이 provider를
  /// 다시 만든다 — 그것이 캐시를 비우는 계기다.
  ///
  /// 인증 판정이 아직 진행 중(`loading`)이면 false다. 그 사이 조회를 내보내
  /// 실패시키는 것보다 한 프레임 기다리는 편이 낫다 — 판정이 끝나면 watch가
  /// 다시 부른다.
  bool watchSignedIn() {
    final AsyncValue<AuthState> auth = watch(authControllerProvider);
    return auth.value?.isAuthenticated ?? false;
  }

  /// 로그아웃이 **확정될 때만** [onSignedOut]을 부른다.
  ///
  /// [watchSignedIn]과 달리 build를 다시 돌리지 않는다. 관측해서 쌓아 둔 값을 들고
  /// 있는 provider는 watch를 쓸 수 없다 — 인증 판정이 `loading`에서 `data`로
  /// 자리잡는 것만으로도 build가 다시 돌아 **쌓아 둔 값이 지워진다**. 로그인 직후
  /// 첫 조회가 그 타이밍에 걸리면 관측이 통째로 날아간다.
  ///
  /// 그런 provider는 이것을 쓴다. 로그아웃이라는 **사건**에만 반응하므로 세션
  /// 경계는 그대로 지키면서 값이 살아남는다.
  void listenSignedOut(void Function() onSignedOut) {
    listen(authControllerProvider, (
      AsyncValue<AuthState>? _,
      AsyncValue<AuthState> next,
    ) {
      if (next.value?.isAuthenticated == false) onSignedOut();
    });
  }
}
