import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/network/graphql_client.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_state.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/email_verification_handle.dart';
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
}
