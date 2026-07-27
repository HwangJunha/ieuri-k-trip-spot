import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/email_verification_handle.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository.dart';

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
    this.tokenProbe,
  });

  final AuthSession? session;
  final Me me;
  final AuthFailure? failure;
  final String verificationId;
  final AuthSession? refreshResult;

  /// If set, `fetchMe` reads the current access token from it and records it in
  /// [accessTokenAtFetchMe]. Lets a test assert the token was persisted BEFORE
  /// `me` is fetched (AuthLink reads it from storage per request).
  final SecureStorage? tokenProbe;

  /// The access token present in [tokenProbe] at the moment `fetchMe` ran
  /// (null if `fetchMe` was never called or the token was absent).
  String? accessTokenAtFetchMe;

  final List<String> logoutCalls = <String>[];

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
  Future<Me> fetchMe() async {
    if (tokenProbe != null) {
      accessTokenAtFetchMe = await tokenProbe!.readAccessToken();
    }
    return me;
  }

  @override
  Future<AuthSession?> refresh({required String refreshToken}) async =>
      refreshResult;

  @override
  Future<void> logout({required String refreshToken}) async =>
      logoutCalls.add(refreshToken);

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {}
}
