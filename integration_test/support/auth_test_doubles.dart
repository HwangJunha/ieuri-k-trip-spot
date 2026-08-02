import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/email_verification_handle.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_registration_result.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/terms_code.dart';
import 'package:ieuri_k_trip_spot/domain/auth/repository/auth_repository.dart';

/// e2e 전용 in-memory [SecureKeyValueStore]. 실 플랫폼 시크릿 저장소를 절대 건드리지
/// 않는다 — 여정 #2는 인증 자체를 검증 대상으로 삼지 않으므로, 이미 로그인·온보딩된
/// 상태를 코드로 직접 세팅한다(e2e-flow-testing skill §7 — 시작 상태 명시적 확립).
class MemoryStore implements SecureKeyValueStore {
  final Map<String, String> _data = <String, String>{};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);
}

/// 로그인 + 온보딩 완료 상태로 미리 채운 [SecureStorage]를 만든다. 실제
/// [AuthController._restoreSession]이 이 저장소를 읽고 `fetchMe`(아래 페이크)로
/// 세션을 확립하므로, 로그인 UI를 거치지 않고도 실제 컨트롤러 로직을 그대로 태운다.
Future<SecureStorage> seededAuthenticatedStorage() async {
  final SecureStorage secure = SecureStorage(MemoryStore());
  await secure.writeTokens(
    accessToken: 'e2e-access',
    refreshToken: 'e2e-refresh',
  );
  await secure.writeUser(userId: 'e2e-user', userEmail: 'e2e@ktripspot.test');
  await secure.setOnboardingCompleted('e2e-user');
  return secure;
}

/// `me` 조회만 성공시키는 최소 [AuthRepository] 페이크. 나머지 메서드는 이 여정에서
/// 호출되지 않는다.
class FixedMeAuthRepository implements AuthRepository {
  const FixedMeAuthRepository();

  static const Me _me = Me(
    id: 'e2e-user',
    email: 'e2e@ktripspot.test',
    nickname: 'E2E Traveler',
  );

  @override
  Future<Me> fetchMe() async => _me;

  @override
  Future<EmailVerificationHandle> registerEmailMember({
    required String email,
    required String password,
    required bool ageVerified,
    required List<Agreement> agreements,
  }) => throw UnimplementedError('not exercised by this journey');

  @override
  Future<void> verifyEmail({
    required String verificationId,
    required String code,
  }) => throw UnimplementedError('not exercised by this journey');

  @override
  Future<EmailVerificationHandle> resendVerification({
    required String verificationId,
  }) => throw UnimplementedError('not exercised by this journey');

  @override
  Future<AuthSession> loginEmail({
    required String email,
    required String password,
  }) => throw UnimplementedError('not exercised by this journey');

  @override
  Future<AuthSession> loginSns({
    required SnsProvider provider,
    required String idToken,
  }) => throw UnimplementedError('not exercised by this journey');

  @override
  Future<SnsRegistrationResult> registerSnsMember({
    required SnsProvider provider,
    required String idToken,
    required String email,
    required bool ageVerified,
    required List<Agreement> agreements,
  }) => throw UnimplementedError('not exercised by this journey');

  @override
  Future<AuthSession?> refresh({required String refreshToken}) async => null;

  @override
  Future<void> logout({required String refreshToken}) async {}

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {}
}

/// 저장소에 보관된 세션 값 한 쌍. 여정 파일이 저장소 API를 직접 호출하지 않고도
/// 보관 상태를 단언할 수 있게 한다.
typedef StoredSession = ({String? access, String? refresh});

/// 현재 보관된 세션 값을 읽는다.
Future<StoredSession> readStoredSession(SecureStorage storage) async => (
  access: await storage.readAccessToken(),
  refresh: await storage.readRefreshToken(),
);

/// accessToken이 만료된 채 부팅하는 상황을 재현한다(SPEC-0005 §2.6, AC-34).
///
/// 갱신 전에는 `me`가 인증 실패로 끝나고, 갱신이 성공한 뒤에야 계정이 확립된다.
/// 사용자가 로그인 화면을 거치지 않고 곧장 홈에 도달해야 한다 — 상태를 잠깐이라도
/// `unauthenticated`로 넘기면 라우터가 `/login`으로 보내므로, 이 여정은 그 회귀를
/// 잡는다.
class ExpiredAccessTokenAuthRepository extends FixedMeAuthRepository {
  ExpiredAccessTokenAuthRepository({this.renewSucceeds = true});

  /// 갱신이 성공하는지 여부. false면 전송 실패(E5)를 흉내내 보관된 값이 유지된 채
  /// 미인증으로 남는지 확인한다(R10).
  final bool renewSucceeds;

  /// 갱신이 몇 번 나갔는지 — 부팅 경로에서 갱신이 선행됐는지 확인한다.
  final List<String> renewCalls = <String>[];

  bool _renewed = false;

  @override
  Future<Me> fetchMe() async {
    if (!_renewed) throw AuthFailure.unauthenticated;
    return super.fetchMe();
  }

  @override
  Future<AuthSession?> refresh({required String refreshToken}) async {
    renewCalls.add(refreshToken);
    if (!renewSucceeds) throw AuthFailure.transportFailure;
    _renewed = true;
    return const AuthSession(
      accessToken: 'e2e-access-2',
      refreshToken: 'e2e-refresh-2',
      tokenType: 'Bearer',
    );
  }
}
