import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/provider/auth_controller.dart';
import '../../auth/provider/auth_repository_provider.dart';

part 'account_deletion_controller.g.dart';

/// 회원 탈퇴(SPEC-0011 R16).
///
/// 상태는 "아직 실행 안 함(data) / 진행 중(loading) / 실패(error)" 세 갈래다.
/// **성공 상태가 따로 없다** — 성공하면 세션이 지워져 라우터가 로그인 화면으로
/// 보내므로 이 화면이 남아 성공을 그릴 일이 없다.
@riverpod
class AccountDeletionController extends _$AccountDeletionController {
  @override
  Future<void> build() async {
    // 확인 전에는 아무것도 하지 않는다(R16) — 화면을 여는 것만으로 탈퇴가
    // 진행되면 안 된다.
  }

  /// 탈퇴를 실행한다. 서버가 계정을 지운 뒤에만 로컬을 정리한다.
  ///
  /// **서버 실패 시 로컬을 건드리지 않는다** — 로그아웃(R15)과 반대다. 계정이
  /// 남아 있는데 토큰만 지우면 사용자는 탈퇴됐다고 오해하고, 다시 로그인하면
  /// 계정이 되살아난 것처럼 보인다.
  Future<void> deleteAccount() async {
    state = const AsyncValue<void>.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).withdrawMember();
      // 계정이 사라졌으므로 로그아웃과 같은 정리를 한다 — 토큰 갱신 시도가
      // 남아 있으면 안 된다. `signOut`은 서버 revoke까지 시도하지만 이미 지워진
      // 계정이라 실패해도 무해하고, 리포지토리가 그 실패를 삼킨다.
      await ref.read(authControllerProvider.notifier).signOut();
    });
  }
}
