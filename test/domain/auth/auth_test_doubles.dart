import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/email_verification_handle.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_credential.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_registration_result.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/sns_authenticator.dart';

/// In-memory [SecureKeyValueStore] for tests so they never touch the platform
/// secure-storage plugin.
class MemoryStore implements SecureKeyValueStore {
  final Map<String, String> _data = <String, String>{};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);
}

/// Builds a [SecureStorage] over a fresh [MemoryStore], optionally pre-seeded
/// with a signed-in session and onboarding flag. Lives in this plugin-free
/// helper so router/widget tests can seed a session without their imports
/// tripping the insecure-storage guard.
Future<SecureStorage> seededSecureStorage({
  bool authenticated = false,
  bool onboarded = false,
}) async {
  final SecureStorage secure = SecureStorage(MemoryStore());
  if (authenticated) {
    await secure.writeTokens(accessToken: 'a', refreshToken: 'r');
    await secure.writeUser(userId: '7', userEmail: 'a@b.com');
    if (onboarded) await secure.setOnboardingCompleted('7');
  }
  return secure;
}

/// One configurable [AuthRepository] fake for every auth test.
///
/// - [session] is what `loginEmail` / `refresh` return (or a failure is thrown).
/// - [me] is what `fetchMe` returns.
/// - [failure] makes `loginEmail` / `registerEmailMember` throw it.
/// - [verificationId] is what `registerEmailMember` / `resendVerification`
///   return.
/// - [refreshResult] is what `refresh` returns (null = refresh failed).
/// - [logoutCalls] records `logout` invocations so a test can assert the server
///   call happened on sign-out.
/// A no-arg instance is an inert stub for tests that only read auth state.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.session,
    this.me = const Me(id: '7', email: 'a@b.com', nickname: 'Traveler'),
    this.failure,
    this.verificationId = 'verify-1',
    this.refreshResult,
    this.refreshFailure,
    this.tokenProbe,
    this.snsFailure,
    this.snsRegistrationResult = const SnsRegistrationResult(
      emailVerified: true,
    ),
  });

  final AuthSession? session;
  final Me me;
  final AuthFailure? failure;
  final String verificationId;
  final AuthSession? refreshResult;

  /// Makes `refresh` throw it. 갱신 거부(E3·E4)와 전송 실패(E5)를 구분해 처리하는지
  /// 검증하려면 repository가 던지는 분류를 그대로 재현해야 한다(SPEC-0005 §2.2).
  final AuthFailure? refreshFailure;

  /// `refresh` 호출 기록 — 갱신이 몇 번 나갔는지 세는 데 쓴다(R8·R14).
  final List<String> refreshCalls = <String>[];

  /// Makes `loginSns` / `registerSnsMember` throw it (e.g. a `memberNotFound`
  /// for the login-not-registered path). Falls back to [failure] if unset.
  final AuthFailure? snsFailure;

  /// What `registerSnsMember` returns on success.
  final SnsRegistrationResult snsRegistrationResult;

  /// If set, `fetchMe` reads the current access token from it and records it in
  /// [accessTokenAtFetchMe]. Lets a test assert the token was persisted BEFORE
  /// `me` is fetched (AuthLink reads it from storage per request).
  final SecureStorage? tokenProbe;

  /// The access token present in [tokenProbe] at the moment `fetchMe` ran
  /// (null if `fetchMe` was never called or the token was absent).
  String? accessTokenAtFetchMe;

  final List<String> logoutCalls = <String>[];

  /// `withdrawMember` 호출 횟수 — 확인 전에는 실행되지 않아야 한다(SPEC-0011 R16).
  int withdrawCalls = 0;

  /// 설정하면 `withdrawMember`가 이걸 던진다. 서버 실패 시 로컬 세션을 건드리지
  /// 않는지 검증하는 데 쓴다(로그아웃과 반대다).
  AuthFailure? withdrawFailure;

  @override
  Future<EmailVerificationHandle> registerEmailMember({
    required String email,
    required String password,
    required bool ageVerified,
    required List<Agreement> agreements,
  }) async {
    if (failure != null) throw failure!;
    return EmailVerificationHandle(verificationId: verificationId);
  }

  @override
  Future<void> verifyEmail({
    required String verificationId,
    required String code,
  }) async {
    if (failure != null) throw failure!;
  }

  @override
  Future<EmailVerificationHandle> resendVerification({
    required String verificationId,
  }) async {
    if (failure != null) throw failure!;
    return EmailVerificationHandle(verificationId: this.verificationId);
  }

  @override
  Future<AuthSession> loginEmail({
    required String email,
    required String password,
  }) async {
    if (failure != null) throw failure!;
    if (session == null) throw UnimplementedError();
    return session!;
  }

  @override
  Future<AuthSession> loginSns({
    required SnsProvider provider,
    required String idToken,
  }) async {
    final AuthFailure? f = snsFailure ?? failure;
    if (f != null) throw f;
    if (session == null) throw UnimplementedError();
    return session!;
  }

  @override
  Future<SnsRegistrationResult> registerSnsMember({
    required SnsProvider provider,
    required String idToken,
    required String email,
    required bool ageVerified,
    required List<Agreement> agreements,
  }) async {
    final AuthFailure? f = snsFailure ?? failure;
    if (f != null) throw f;
    return snsRegistrationResult;
  }

  @override
  Future<Me> fetchMe() async {
    if (tokenProbe != null) {
      accessTokenAtFetchMe = await tokenProbe!.readAccessToken();
    }
    return me;
  }

  @override
  Future<AuthSession?> refresh({required String refreshToken}) async {
    refreshCalls.add(refreshToken);
    if (refreshFailure != null) throw refreshFailure!;
    return refreshResult;
  }

  @override
  Future<void> logout({required String refreshToken}) async =>
      logoutCalls.add(refreshToken);

  @override
  Future<void> withdrawMember() async {
    withdrawCalls++;
    // 탈퇴는 로그아웃과 달리 실패를 삼키지 않는다(SPEC-0011 R16) — 실패를 그대로
    // 올려서 컨트롤러가 로컬을 건드리지 않는지 검증할 수 있게 한다.
    if (withdrawFailure != null) throw withdrawFailure!;
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {}
}

/// Configurable [SnsAuthenticator] fake so controller/view tests never drive the
/// real provider SDKs. [credential] is returned by `authenticate`; if [error] is
/// set (e.g. an [SnsCancelledException]) it's thrown instead.
class FakeSnsAuthenticator implements SnsAuthenticator {
  FakeSnsAuthenticator({
    this.credential = const SnsCredential(
      provider: SnsProvider.google,
      idToken: 'id-token',
      email: 'a@b.com',
    ),
    this.error,
  });

  final SnsCredential credential;
  final Object? error;

  SnsProvider? authenticatedProvider;

  @override
  Future<SnsCredential> authenticate(SnsProvider provider) async {
    authenticatedProvider = provider;
    if (error != null) throw error!;
    return SnsCredential(
      provider: provider,
      idToken: credential.idToken,
      email: credential.email,
      emailVerified: credential.emailVerified,
      nickname: credential.nickname,
      profileImageUrl: credential.profileImageUrl,
    );
  }
}
