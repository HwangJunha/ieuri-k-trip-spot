import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_state.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/account_deletion_controller.dart';

import '../../auth/auth_test_doubles.dart';

/// SPEC-0011 R16 — 탈퇴는 확인 전에 실행되지 않고, 성공하면 토큰까지 정리한다.

ProviderContainer _container(MemoryStore store, FakeAuthRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(SecureStorage(store)),
      authRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('화면을 여는 것만으로는 탈퇴가 실행되지 않는다', () async {
    final FakeAuthRepository repo = FakeAuthRepository();
    final ProviderContainer container = _container(MemoryStore(), repo);

    await container.read(accountDeletionControllerProvider.future);

    expect(repo.withdrawCalls, 0);
  });

  test('탈퇴하면 withdrawMember가 한 번 나간다', () async {
    final FakeAuthRepository repo = FakeAuthRepository();
    final ProviderContainer container = _container(MemoryStore(), repo);
    await container.read(accountDeletionControllerProvider.future);

    await container
        .read(accountDeletionControllerProvider.notifier)
        .deleteAccount();

    expect(repo.withdrawCalls, 1);
  });

  test('탈퇴에 성공하면 저장된 토큰이 지워진다', () async {
    // 계정이 사라졌으므로 토큰 갱신 시도가 남아 있으면 안 된다(R16).
    final MemoryStore store = MemoryStore();
    final SecureStorage storage = SecureStorage(store);
    await storage.writeTokens(accessToken: 'a', refreshToken: 'r');
    final ProviderContainer container = _container(store, FakeAuthRepository());
    await container.read(accountDeletionControllerProvider.future);

    await container
        .read(accountDeletionControllerProvider.notifier)
        .deleteAccount();

    expect(await storage.readRefreshToken(), isNull);
  });

  test('탈퇴에 성공하면 인증 상태가 풀린다', () async {
    final ProviderContainer container = _container(
      MemoryStore(),
      FakeAuthRepository(),
    );
    await container.read(accountDeletionControllerProvider.future);

    await container
        .read(accountDeletionControllerProvider.notifier)
        .deleteAccount();

    final AuthState? state = container.read(authControllerProvider).value;
    expect(state?.isAuthenticated, isFalse);
  });

  test('서버가 실패하면 오류 상태가 되고 토큰은 남는다', () async {
    // 로그아웃(R15)과 반대다 — 계정이 남아 있는데 토큰만 지우면 사용자는
    // 탈퇴됐다고 오해하고, 다시 로그인하면 계정이 되살아난 것처럼 보인다.
    final MemoryStore store = MemoryStore();
    final SecureStorage storage = SecureStorage(store);
    await storage.writeTokens(accessToken: 'a', refreshToken: 'r');
    final FakeAuthRepository repo = FakeAuthRepository()
      ..withdrawFailure = const AuthFailure(AuthFailureKind.unknown);
    final ProviderContainer container = _container(store, repo);
    await container.read(accountDeletionControllerProvider.future);

    await container
        .read(accountDeletionControllerProvider.notifier)
        .deleteAccount();

    expect(container.read(accountDeletionControllerProvider).hasError, isTrue);
    expect(await storage.readRefreshToken(), 'r');
  });
}
