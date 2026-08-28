import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/network/graphql_client.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_state.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository.dart';

import '../auth_test_doubles.dart';

/// 갱신 실패의 두 갈래 처리를 검증한다(SPEC-0005 §2.2·§2.6).
///
/// R9(갱신 거부 → 세션 종료)와 R10(전송 실패 → 세션 유지)은 정반대의 처리를
/// 요구하므로, 이 둘을 구분하지 않으면 두 요구사항 중 하나는 반드시 위반된다.

ProviderContainer _container(
  SecureStorage storage, {
  required AuthRepository repo,
}) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(storage),
      authRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// accessToken이 만료돼 `fetchMe`가 실패하는 상태를 만든다 — 부팅 시 갱신 경로로
/// 들어가게 하는 설정이다.
Future<SecureStorage> _storedTokens() async {
  final SecureStorage storage = SecureStorage(MemoryStore());
  await storage.writeTokens(accessToken: 'stale', refreshToken: 'stored-r');
  return storage;
}

const AuthSession _fresh = AuthSession(
  accessToken: 'new-access',
  refreshToken: 'new-refresh',
  tokenType: 'Bearer',
);

/// 저장된 accessToken이 만료돼 `me`가 항상 실패하는 저장소. 부팅 흐름이 `me` 확인을
/// 건너뛰고 갱신 경로로 들어가게 한다.
class _StaleAccessTokenRepository extends FakeAuthRepository {
  _StaleAccessTokenRepository({super.refreshFailure, super.refreshResult});

  @override
  Future<Me> fetchMe() async => throw AuthFailure.unauthenticated;
}

void main() {
  // 사용자가 아무 조작도 안 했는데 로그인 화면으로 튕기던 문제의 회귀 방지.
  //
  // 예전 판정은 "`transportFailure`가 아니면 전부 세션 종료"였다. 서버가 앱이 모르는
  // 코드를 하나만 내려도(`fromCode`가 `unknown`으로 접는다) 즉시 로그아웃됐고, 갱신은
  // 화면을 보는 중에 조용히 도는 것이라 "보고 있는데 갑자기 로그아웃"으로 나타났다.
  group('갱신 실패가 세션을 끝내는 기준 (회귀)', () {
    test('모르는 서버 코드로는 로그아웃되지 않는다', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: _StaleAccessTokenRepository(
          // 서버가 새 코드를 내면 `fromCode`가 여기로 접는다.
          refreshFailure: const AuthFailure(AuthFailureKind.unknown),
        ),
      );

      await c.read(authControllerProvider.future);

      // **토큰이 남아 있어야 한다** — 이번 갱신을 못 했을 뿐이다. 정말 만료됐다면
      // 다음 요청에서 서버가 refreshRejected로 다시 거부하고 그때 로그아웃된다.
      expect(await storage.readRefreshToken(), isNotNull);
    });

    test('회전 토큰 재사용이 감지되면 세션을 끝낸다', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: _StaleAccessTokenRepository(
          refreshFailure: AuthFailure.tokenReuseDetected,
        ),
      );

      final AuthState state = await c.read(authControllerProvider.future);

      // 재발급으로 회복되지 않는다 — 재로그인이 유일한 복구다.
      expect(state.isAuthenticated, isFalse);
      expect(await storage.readRefreshToken(), isNull);
    });

    test('비활성 계정이면 세션을 끝낸다', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: _StaleAccessTokenRepository(
          refreshFailure: const AuthFailure(AuthFailureKind.accountInactive),
        ),
      );

      final AuthState state = await c.read(authControllerProvider.future);

      expect(state.isAuthenticated, isFalse);
      expect(await storage.readRefreshToken(), isNull);
    });
  });

  group('부팅 시 갱신 (R13, §2.6)', () {
    test('갱신 거부면 토큰을 지우고 미인증이 된다 (R9·R11)', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: _StaleAccessTokenRepository(
          refreshFailure: AuthFailure.refreshRejected,
        ),
      );

      final AuthState state = await c.read(authControllerProvider.future);

      expect(state.isAuthenticated, isFalse);
      // 서버가 거부했으니 보관해도 쓸모없다 — 지운다.
      expect(await storage.readRefreshToken(), isNull);
    });

    test('전송 실패면 토큰을 유지한 채 미인증이 된다 (R10, AC-29)', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: _StaleAccessTokenRepository(
          refreshFailure: AuthFailure.transportFailure,
        ),
      );

      final AuthState state = await c.read(authControllerProvider.future);

      expect(state.isAuthenticated, isFalse);
      // 복구 후 재시도 시 이 refreshToken으로 갱신이 성공해야 한다.
      expect(await storage.readRefreshToken(), 'stored-r');
    });

    test('accessToken만 만료된 경우 갱신이 선행되어 인증 상태로 복원된다 (AC-34)', () async {
      final SecureStorage storage = await _storedTokens();
      final FakeAuthRepository repo = _RefreshThenSucceedRepository();
      final ProviderContainer c = _container(storage, repo: repo);

      final AuthState state = await c.read(authControllerProvider.future);

      expect(state.isAuthenticated, isTrue, reason: '로그인 화면을 거치지 않는다');
      expect(repo.refreshCalls, hasLength(1));
      // 새 토큰 쌍이 함께 기록되고 이전 값이 남지 않는다 (R12, AC-30).
      expect(await storage.readAccessToken(), 'new-access');
      expect(await storage.readRefreshToken(), 'new-refresh');
    });

    test('refreshToken이 없으면 갱신을 시도하지 않는다', () async {
      final FakeAuthRepository repo = FakeAuthRepository();
      final ProviderContainer c = _container(
        SecureStorage(MemoryStore()),
        repo: repo,
      );

      final AuthState state = await c.read(authControllerProvider.future);

      expect(state.isAuthenticated, isFalse);
      expect(repo.refreshCalls, isEmpty);
    });

    test(
      'success:true인데 accessToken이 null이면 실패로 보고 세션을 종료한다 (AC-31)',
      () async {
        final SecureStorage storage = await _storedTokens();
        final ProviderContainer c = _container(
          storage,
          // refreshResult를 주지 않는다 = repository가 accessToken이 null인 응답을
          // null로 돌려준 상태.
          repo: _StaleAccessTokenRepository(),
        );

        final AuthState state = await c.read(authControllerProvider.future);

        expect(state.isAuthenticated, isFalse);
        expect(await storage.readRefreshToken(), isNull, reason: 'R9를 따른다');
      },
    );
  });

  group('갱신 실패 후 억제 (R14, §2.3.1)', () {
    test('전송 실패로 갱신이 실패하면 억제 플래그가 선다 (AC-36)', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: FakeAuthRepository(refreshFailure: AuthFailure.transportFailure),
      );
      await c.read(authControllerProvider.future);
      final TokenRefreshBridge bridge = c.read(tokenRefreshBridgeProvider);

      final String? token = await bridge.refresher!();

      expect(token, isNull);
      expect(bridge.suppressed, isTrue);
      // R10 — 전송 실패에서는 토큰을 지우지 않는다.
      expect(await storage.readRefreshToken(), 'stored-r');
    });

    test('갱신 거부로 실패하면 억제와 함께 토큰이 제거된다 (R9·R11)', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: FakeAuthRepository(refreshFailure: AuthFailure.refreshRejected),
      );
      await c.read(authControllerProvider.future);
      final TokenRefreshBridge bridge = c.read(tokenRefreshBridgeProvider);

      final String? token = await bridge.refresher!();

      expect(token, isNull);
      expect(bridge.suppressed, isTrue);
      expect(await storage.readRefreshToken(), isNull);
    });

    test('갱신이 성공하면 억제가 해제된다', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: FakeAuthRepository(refreshResult: _fresh),
      );
      await c.read(authControllerProvider.future);
      final TokenRefreshBridge bridge = c.read(tokenRefreshBridgeProvider);
      bridge.suppressRefresh();

      final String? token = await bridge.refresher!();

      expect(token, 'new-access');
      expect(bridge.suppressed, isFalse, reason: '억제는 실패 상태에만 존재한다');
    });

    test('사용자의 명시적 재시도가 성공하면 억제가 해제된다 (AC-38)', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: _StaleAccessTokenRepository(refreshResult: _fresh),
      );
      await c.read(authControllerProvider.future);
      final TokenRefreshBridge bridge = c.read(tokenRefreshBridgeProvider);
      bridge.suppressRefresh();

      await c.read(authControllerProvider.notifier).retryRefresh();

      expect(bridge.suppressed, isFalse);
    });

    test('재시도가 또 실패하면 억제가 다시 선다 (AC-36)', () async {
      final SecureStorage storage = await _storedTokens();
      final ProviderContainer c = _container(
        storage,
        repo: _StaleAccessTokenRepository(
          refreshFailure: AuthFailure.transportFailure,
        ),
      );
      await c.read(authControllerProvider.future);
      final TokenRefreshBridge bridge = c.read(tokenRefreshBridgeProvider);

      // 재시도는 억제를 풀고 시작한다 — 실패로 끝나면 다시 서야 한다. 그러지 않으면
      // 화면 전환마다 갱신이 재발화한다.
      await c.read(authControllerProvider.notifier).retryRefresh();

      expect(bridge.suppressed, isTrue);
      // R10 — 전송 실패이므로 토큰은 유지된다.
      expect(await storage.readRefreshToken(), 'stored-r');
    });

    /// **로그인은 억제를 푸는 계기다**(2026-08-29).
    ///
    /// 부팅 때 갱신이 실패해 억제가 서 있으면, 그 뒤 로그인해서 멀쩡한
    /// refreshToken을 새로 받아도 갱신 링크가 발화하지 않았다 — 액세스 토큰이
    /// 만료되는 순간부터 모든 요청이 `UNAUTHENTICATED_TOKEN_REJECTED`로 떨어지고
    /// 갱신은 영영 시도되지 않는다. 실기기에서 그 상태를 겪었다.
    test('로그인에 성공하면 억제가 해제된다', () async {
      final SecureStorage storage = SecureStorage(MemoryStore());
      final ProviderContainer c = _container(
        storage,
        repo: FakeAuthRepository(session: _fresh),
      );
      await c.read(authControllerProvider.future);
      final TokenRefreshBridge bridge = c.read(tokenRefreshBridgeProvider);
      // 부팅 갱신 실패로 억제가 선 상태를 만든다.
      bridge.suppressRefresh();

      await c
          .read(authControllerProvider.notifier)
          .signIn(email: 'a@b.com', password: 'pw');

      expect(
        bridge.suppressed,
        isFalse,
        reason: '새 토큰 쌍을 받았으므로 억제를 유지할 근거가 없다',
      );
    });
  });
}

/// `fetchMe`가 처음엔 실패(만료된 accessToken)하고, 갱신 후에는 성공하는 저장소.
/// 부팅 시 "갱신 선행" 경로(AC-34)를 재현한다.
class _RefreshThenSucceedRepository extends FakeAuthRepository {
  _RefreshThenSucceedRepository() : super(refreshResult: _fresh);

  bool _refreshed = false;

  @override
  Future<AuthSession?> refresh({required String refreshToken}) {
    _refreshed = true;
    return super.refresh(refreshToken: refreshToken);
  }

  @override
  Future<Me> fetchMe() async {
    if (!_refreshed) throw AuthFailure.unauthenticated;
    return me;
  }
}
