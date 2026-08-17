import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/network/graphql_client.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_state.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/email_verification_handle.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_credential.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_registration_result.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_sign_in_outcome.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_controller.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/sns_authenticator.dart';

import '../auth_test_doubles.dart';

ProviderContainer _container(
  MemoryStore store, {
  required AuthRepository repo,
  SnsAuthenticator? snsAuth,
}) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(SecureStorage(store)),
      authRepositoryProvider.overrideWithValue(repo),
      if (snsAuth != null) snsAuthenticatorProvider.overrideWithValue(snsAuth),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

const AuthSession _tokens = AuthSession(
  accessToken: 'access',
  refreshToken: 'refresh',
  tokenType: 'Bearer',
  accessTokenExpiresIn: 300,
);

void main() {
  test('restores unauthenticated when no tokens are stored', () async {
    final MemoryStore store = MemoryStore();
    final ProviderContainer c = _container(
      store,
      repo: FakeAuthRepository(session: _tokens),
    );

    final AuthState state = await c.read(authControllerProvider.future);

    expect(state.isAuthenticated, isFalse);
  });

  test(
    'restores an authenticated session by confirming with fetchMe',
    () async {
      final MemoryStore store = MemoryStore();
      final SecureStorage secure = SecureStorage(store);
      await secure.writeTokens(accessToken: 'access', refreshToken: 'refresh');
      final ProviderContainer c = _container(
        store,
        repo: FakeAuthRepository(session: _tokens),
      );

      final AuthState state = await c.read(authControllerProvider.future);

      expect(state.isAuthenticated, isTrue);
      expect(state.userId, '7');
    },
  );

  test(
    'signIn logs in, fetches me, and emits an authenticated state',
    () async {
      final MemoryStore store = MemoryStore();
      final ProviderContainer c = _container(
        store,
        repo: FakeAuthRepository(session: _tokens),
      );
      await c.read(authControllerProvider.future);

      await c
          .read(authControllerProvider.notifier)
          .signIn(email: 'a@b.com', password: 'pw');

      final AuthState state = c.read(authControllerProvider).value!;
      expect(state.isAuthenticated, isTrue);
      expect(state.session!.user!.id, '7');
      expect(await SecureStorage(store).readAccessToken(), 'access');
    },
  );

  test('signIn persists the access token BEFORE fetching me', () async {
    // Regression: AuthLink reads the access token from secure storage on every
    // request, so `me` is unauthenticated unless the token was stored first.
    final MemoryStore store = MemoryStore();
    final FakeAuthRepository repo = FakeAuthRepository(
      session: _tokens,
      tokenProbe: SecureStorage(store),
    );
    final ProviderContainer c = _container(store, repo: repo);
    await c.read(authControllerProvider.future);

    await c
        .read(authControllerProvider.notifier)
        .signIn(email: 'a@b.com', password: 'pw');

    expect(repo.accessTokenAtFetchMe, 'access');
  });

  test('signIn failure surfaces as an error AsyncValue', () async {
    final MemoryStore store = MemoryStore();
    final ProviderContainer c = _container(
      store,
      repo: FakeAuthRepository(
        failure: const AuthFailure(AuthFailureKind.invalidCredentials),
      ),
    );
    await c.read(authControllerProvider.future);

    await c
        .read(authControllerProvider.notifier)
        .signIn(email: 'a@b.com', password: 'bad');

    expect(c.read(authControllerProvider).hasError, isTrue);
  });

  test('signUp returns a verification handle without authenticating', () async {
    final MemoryStore store = MemoryStore();
    final ProviderContainer c = _container(
      store,
      repo: FakeAuthRepository(verificationId: 'verify-9'),
    );
    await c.read(authControllerProvider.future);

    final EmailVerificationHandle handle = await c
        .read(authControllerProvider.notifier)
        .signUp(
          email: 'a@b.com',
          password: 'pw',
          ageVerified: true,
          agreements: const [],
        );

    expect(handle.verificationId, 'verify-9');
    expect(c.read(authControllerProvider).value!.isAuthenticated, isFalse);
  });

  test('verifyEmail completes without flipping auth state', () async {
    final MemoryStore store = MemoryStore();
    final ProviderContainer c = _container(store, repo: FakeAuthRepository());
    await c.read(authControllerProvider.future);

    await expectLater(
      c
          .read(authControllerProvider.notifier)
          .verifyEmail(verificationId: 'v', code: '123456'),
      completes,
    );
  });

  test('signOut calls the server logout then clears tokens', () async {
    final MemoryStore store = MemoryStore();
    final FakeAuthRepository repo = FakeAuthRepository(session: _tokens);
    final ProviderContainer c = _container(store, repo: repo);
    await c.read(authControllerProvider.future);
    await c
        .read(authControllerProvider.notifier)
        .signIn(email: 'a@b.com', password: 'pw');

    await c.read(authControllerProvider.notifier).signOut();

    expect(repo.logoutCalls, <String>['refresh']);
    expect(c.read(authControllerProvider).value!.isAuthenticated, isFalse);
    expect(await SecureStorage(store).readAccessToken(), isNull);
  });

  test('refresh bridge renews the access token on success', () async {
    final MemoryStore store = MemoryStore();
    await SecureStorage(
      store,
    ).writeTokens(accessToken: 'old', refreshToken: 'refresh');
    final ProviderContainer c = _container(
      store,
      repo: FakeAuthRepository(
        refreshResult: const AuthSession(
          accessToken: 'new-access',
          refreshToken: 'refresh',
        ),
      ),
    );
    await c.read(authControllerProvider.future);

    final String? renewed = await c
        .read(tokenRefreshBridgeProvider)
        .refresher!();

    expect(renewed, 'new-access');
    expect(await SecureStorage(store).readAccessToken(), 'new-access');
  });

  test('refresh failure signs the user out', () async {
    final MemoryStore store = MemoryStore();
    await SecureStorage(
      store,
    ).writeTokens(accessToken: 'old', refreshToken: 'refresh');
    final ProviderContainer c = _container(
      store,
      repo: FakeAuthRepository(refreshResult: null),
    );
    await c.read(authControllerProvider.future);

    final String? renewed = await c
        .read(tokenRefreshBridgeProvider)
        .refresher!();

    expect(renewed, isNull);
    expect(c.read(authControllerProvider).value!.isAuthenticated, isFalse);
    expect(await SecureStorage(store).readAccessToken(), isNull);
  });

  test('completeOnboarding marks the account onboarded', () async {
    final MemoryStore store = MemoryStore();
    final ProviderContainer c = _container(
      store,
      repo: FakeAuthRepository(session: _tokens),
    );
    await c.read(authControllerProvider.future);
    await c
        .read(authControllerProvider.notifier)
        .signIn(email: 'a@b.com', password: 'pw');

    await c.read(authControllerProvider.notifier).completeOnboarding();

    expect(c.read(authControllerProvider).value!.onboardingCompleted, isTrue);
    expect(await SecureStorage(store).isOnboardingCompleted('7'), isTrue);
  });

  test(
    'signInSns authenticates and emits an authenticated state on a known member',
    () async {
      final MemoryStore store = MemoryStore();
      final ProviderContainer c = _container(
        store,
        repo: FakeAuthRepository(session: _tokens),
        snsAuth: FakeSnsAuthenticator(),
      );
      await c.read(authControllerProvider.future);

      final SnsSignInOutcome outcome = await c
          .read(authControllerProvider.notifier)
          .signInSns(SnsProvider.google);

      expect(outcome, isA<SnsAuthenticated>());
      expect(c.read(authControllerProvider).value!.isAuthenticated, isTrue);
    },
  );

  test(
    'signInSns returns needsSignUp (with credential) for an unregistered member',
    () async {
      final MemoryStore store = MemoryStore();
      const SnsCredential credential = SnsCredential(
        provider: SnsProvider.google,
        idToken: 'id-token',
        email: 'new@b.com',
      );
      final ProviderContainer c = _container(
        store,
        repo: FakeAuthRepository(
          session: _tokens,
          snsFailure: const AuthFailure(AuthFailureKind.memberNotFound),
        ),
        snsAuth: FakeSnsAuthenticator(credential: credential),
      );
      await c.read(authControllerProvider.future);

      final SnsSignInOutcome outcome = await c
          .read(authControllerProvider.notifier)
          .signInSns(SnsProvider.google);

      expect(outcome, isA<SnsNeedsSignUp>());
      expect((outcome as SnsNeedsSignUp).credential.email, 'new@b.com');
      // Not an auth error: state stays unauthenticated, not error.
      expect(c.read(authControllerProvider).hasError, isFalse);
      expect(c.read(authControllerProvider).value!.isAuthenticated, isFalse);
    },
  );

  test('signInSns returns cancelled when the user backs out', () async {
    final MemoryStore store = MemoryStore();
    final ProviderContainer c = _container(
      store,
      repo: FakeAuthRepository(session: _tokens),
      snsAuth: FakeSnsAuthenticator(error: const SnsCancelledException()),
    );
    await c.read(authControllerProvider.future);

    final SnsSignInOutcome outcome = await c
        .read(authControllerProvider.notifier)
        .signInSns(SnsProvider.kakao);

    expect(outcome, isA<SnsCancelled>());
    expect(c.read(authControllerProvider).hasError, isFalse);
  });

  test(
    'signInSns sends the authorization code with the login request',
    () async {
      final MemoryStore store = MemoryStore();
      final FakeAuthRepository repo = FakeAuthRepository(session: _tokens);
      final ProviderContainer c = _container(
        store,
        repo: repo,
        snsAuth: FakeSnsAuthenticator(
          credential: const SnsCredential(
            provider: SnsProvider.google,
            idToken: 'id-token',
            authorizationCode: 'server-auth-code',
          ),
        ),
      );
      await c.read(authControllerProvider.future);

      await c
          .read(authControllerProvider.notifier)
          .signInSns(SnsProvider.google);

      expect(repo.loginSnsAuthorizationCode, 'server-auth-code');
    },
  );

  test(
    'signInSns still authenticates when the provider gave no authorization code',
    () async {
      final MemoryStore store = MemoryStore();
      final FakeAuthRepository repo = FakeAuthRepository(session: _tokens);
      final ProviderContainer c = _container(
        store,
        repo: repo,
        // 카카오처럼 code를 노출하지 않는 provider — null이 정상 경로다(R7).
        snsAuth: FakeSnsAuthenticator(
          credential: const SnsCredential(
            provider: SnsProvider.kakao,
            idToken: 'id-token',
          ),
        ),
      );
      await c.read(authControllerProvider.future);

      final SnsSignInOutcome outcome = await c
          .read(authControllerProvider.notifier)
          .signInSns(SnsProvider.kakao);

      expect(outcome, isA<SnsAuthenticated>());
      expect(c.read(authControllerProvider).value!.isAuthenticated, isTrue);
      expect(repo.loginSnsCalled, isTrue);
      expect(repo.loginSnsAuthorizationCode, isNull);
    },
  );

  test('signUpSns sends the credential authorization code', () async {
    final MemoryStore store = MemoryStore();
    final FakeAuthRepository repo = FakeAuthRepository(session: _tokens);
    final ProviderContainer c = _container(store, repo: repo);
    await c.read(authControllerProvider.future);

    await c
        .read(authControllerProvider.notifier)
        .signUpSns(
          credential: const SnsCredential(
            provider: SnsProvider.apple,
            idToken: 'id-token',
            authorizationCode: 'apple-code',
          ),
          email: 'a@b.com',
          ageVerified: true,
          agreements: const [],
        );

    expect(repo.registerSnsAuthorizationCode, 'apple-code');
  });

  test(
    'signUpSns delegates to the repository and returns its result',
    () async {
      final MemoryStore store = MemoryStore();
      final ProviderContainer c = _container(
        store,
        repo: FakeAuthRepository(
          session: _tokens,
          snsRegistrationResult: const SnsRegistrationResult(
            emailVerified: false,
            verificationId: 'v-1',
          ),
        ),
      );
      await c.read(authControllerProvider.future);

      final SnsRegistrationResult result = await c
          .read(authControllerProvider.notifier)
          .signUpSns(
            credential: const SnsCredential(
              provider: SnsProvider.apple,
              idToken: 'id-token',
            ),
            email: 'a@b.com',
            ageVerified: true,
            agreements: const [],
          );

      expect(result.needsVerification, isTrue);
      expect(result.verificationId, 'v-1');
    },
  );

  group('EMAIL_NOT_VERIFIED 안전망 (실기기 무한 호출 회귀)', () {
    /// 미인증 세션이 선 컨테이너를 만든다.
    Future<(ProviderContainer, FakeAuthRepository)> unverifiedSession() async {
      final MemoryStore store = MemoryStore();
      final FakeAuthRepository repo = FakeAuthRepository(
        session: _tokens,
        me: const Me(
          id: '7',
          email: 'a@b.com',
          nickname: 'Traveler',
          emailVerified: false,
        ),
      );
      await SecureStorage(
        store,
      ).writeTokens(accessToken: 'access', refreshToken: 'refresh');
      final ProviderContainer c = _container(store, repo: repo);
      await c.read(authControllerProvider.future);
      return (c, repo);
    }

    test('이미 미인증으로 알고 있으면 me를 다시 읽지 않는다', () async {
      // **이것이 무한 호출의 핵심이었다.** 인증 화면에 머무는 동안 화면들이 보내는
      // 요청은 전부 EMAIL_NOT_VERIFIED로 거절되는데, 그때마다 me를 다시 읽으면
      // 그 응답이 상태를 갈아 끼우고 → 라우터가 재평가하고 → 화면이 다시 조회를
      // 내면서 서버를 끝없이 두드린다.
      final (ProviderContainer c, FakeAuthRepository repo) =
          await unverifiedSession();
      final int before = repo.fetchMeCalls;

      await c.read(authControllerProvider.notifier).handleEmailNotVerified();
      await c.read(authControllerProvider.notifier).handleEmailNotVerified();
      await c.read(authControllerProvider.notifier).handleEmailNotVerified();

      expect(repo.fetchMeCalls, before, reason: '추가 조회가 나가면 안 된다');
    });

    test('미인증 상태에서는 아무것도 하지 않는다', () async {
      final MemoryStore store = MemoryStore();
      final FakeAuthRepository repo = FakeAuthRepository();
      final ProviderContainer c = _container(store, repo: repo);
      await c.read(authControllerProvider.future);
      final int before = repo.fetchMeCalls;

      await c.read(authControllerProvider.notifier).handleEmailNotVerified();

      expect(repo.fetchMeCalls, before);
    });

    test('refreshMe는 값이 그대로면 상태를 갈아끼우지 않는다', () async {
      // 같은 값이라도 새 AsyncValue를 넣으면 리스너가 깨어나 재평가가 돈다.
      final (ProviderContainer c, FakeAuthRepository _) =
          await unverifiedSession();
      final AsyncValue<AuthState> before = c.read(authControllerProvider);

      await c.read(authControllerProvider.notifier).refreshMe();

      expect(
        identical(c.read(authControllerProvider), before),
        isTrue,
        reason: '같은 값이면 인스턴스도 그대로여야 한다',
      );
    });
  });
}
