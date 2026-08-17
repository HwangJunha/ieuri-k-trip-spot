import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/network/auth_error_classifier.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../model/auth_failure.dart';
import '../model/auth_session.dart';
import '../model/email_verification_handle.dart';
import '../model/me.dart';
import '../model/sns_provider.dart';
import '../model/sns_registration_result.dart';
import '../model/verification_failure_reason.dart';
import '../../../common/model/terms_code.dart';
import 'auth_operations.graphql.dart';
import 'auth_repository.dart';
import 'auth_schema.graphql.dart';

/// GraphQL-backed [AuthRepository]. Runs the graphql_codegen-generated typed
/// operations through the shared client and maps each payload to a domain
/// model. The generated `*.graphql.dart` types never leave this file
/// (CLAUDE.md §3).
///
/// Every payload carries `success` + `userErrors` (spec §6.2). The two-stage
/// failure check is: (1) `success == false` OR `userErrors` non-empty → domain
/// failure; (2) a transport error (top-level `errors` / link exception) →
/// network failure.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<EmailVerificationHandle> registerEmailMember({
    required String email,
    required String password,
    required bool ageVerified,
    required List<Agreement> agreements,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRegisterEmailMember,
      Variables$Mutation$RegisterEmailMember(
        input: Input$RegisterEmailMemberInput(
          email: email,
          password: password,
          ageVerified: ageVerified,
          agreements: agreements
              .map(
                (Agreement a) => Input$AgreementInput(
                  termsCode: _termsCode(a.termsCode),
                  agreed: a.agreed,
                ),
              )
              .toList(),
        ),
      ).toJson(),
      'registerEmailMember',
    );
    final payload = Mutation$RegisterEmailMember.fromJson(
      data,
    ).registerEmailMember;
    _check('registerEmailMember', payload.success, payload.userErrors);
    return EmailVerificationHandle(
      verificationId: payload.verificationId ?? '',
    );
  }

  @override
  Future<void> verifyEmail({
    required String verificationId,
    required String code,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationVerifyEmail,
      Variables$Mutation$VerifyEmail(
        input: Input$VerifyEmailInput(
          verificationId: verificationId,
          code: code,
        ),
      ).toJson(),
      'verifyEmail',
    );
    final payload = Mutation$VerifyEmail.fromJson(data).verifyEmail;
    _check('verifyEmail', payload.success, payload.userErrors);
    if (payload.verified != true) {
      // **코드가 틀린 것은 오류가 아니라 결과다**(SPEC-0024 §6). success는 "요청이
      // 정상 처리됐는가"라서 여기까지 오고, 이유는 userErrors가 아니라
      // failureReason에 있다. 뭉개면 사용자가 만료와 오타를 구분하지 못한다.
      throw VerificationFailure(
        VerificationFailureReason.fromRaw(payload.failureReason),
      );
    }
  }

  @override
  Future<EmailVerificationHandle> resendVerification({
    required String verificationId,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationResendVerification,
      Variables$Mutation$ResendVerification(
        input: Input$ResendVerificationInput(verificationId: verificationId),
      ).toJson(),
      'resendVerification',
    );
    final payload = Mutation$ResendVerification.fromJson(
      data,
    ).resendVerification;
    _check('resendVerification', payload.success, payload.userErrors);
    return EmailVerificationHandle(
      verificationId: payload.verificationId ?? verificationId,
      expiresAt: payload.expiresAt,
    );
  }

  @override
  Future<EmailVerificationHandle> retargetEmailVerification({
    required String newEmail,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRetargetEmailVerification,
      Variables$Mutation$RetargetEmailVerification(
        input: Input$RetargetEmailVerificationInput(newEmail: newEmail),
      ).toJson(),
      'retargetEmailVerification',
    );
    final payload = Mutation$RetargetEmailVerification.fromJson(
      data,
    ).retargetEmailVerification;
    _check('retargetEmailVerification', payload.success, payload.userErrors);
    final String? issued = payload.verificationId;
    if (issued == null) {
      // 성공했는데 핸들이 없으면 이후 verifyEmail이 부를 대상이 사라진다. 조용히
      // 옛 핸들로 되돌아가면 사용자는 바뀐 주소로 온 코드를 넣는데 서버는 옛 주소의
      // 검증을 기대하게 된다.
      throw const AuthFailure(AuthFailureKind.unknown);
    }
    return EmailVerificationHandle(
      verificationId: issued,
      expiresAt: payload.expiresAt,
    );
  }

  @override
  Future<AuthSession> loginEmail({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationLoginEmail,
      Variables$Mutation$LoginEmail(
        input: Input$LoginEmailInput(email: email, password: password),
      ).toJson(),
      'loginEmail',
    );
    final payload = Mutation$LoginEmail.fromJson(data).loginEmail;
    _check('loginEmail', payload.success, payload.userErrors);
    return _sessionFrom(
      accessToken: payload.accessToken,
      refreshToken: payload.refreshToken,
      tokenType: payload.tokenType,
      accessTokenExpiresIn: payload.accessTokenExpiresIn,
      refreshTokenExpiresIn: payload.refreshTokenExpiresIn,
    );
  }

  @override
  Future<AuthSession> loginSns({
    required SnsProvider provider,
    required String idToken,
    String? authorizationCode,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationLoginSns,
      Variables$Mutation$LoginSns(
        input: Input$LoginSnsInput(
          provider: _provider(provider),
          idToken: idToken,
          authorizationCode: _codeOrNull(authorizationCode),
        ),
      ).toJson(),
      'loginSns',
    );
    final payload = Mutation$LoginSns.fromJson(data).loginSns;
    _check('loginSns', payload.success, payload.userErrors);
    return _sessionFrom(
      accessToken: payload.accessToken,
      refreshToken: payload.refreshToken,
      tokenType: payload.tokenType,
      accessTokenExpiresIn: payload.accessTokenExpiresIn,
      refreshTokenExpiresIn: payload.refreshTokenExpiresIn,
    );
  }

  @override
  Future<SnsRegistrationResult> registerSnsMember({
    required SnsProvider provider,
    required String idToken,
    required String email,
    required bool ageVerified,
    required List<Agreement> agreements,
    String? authorizationCode,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRegisterSnsMember,
      Variables$Mutation$RegisterSnsMember(
        input: Input$RegisterSnsMemberInput(
          provider: _provider(provider),
          idToken: idToken,
          email: email,
          ageVerified: ageVerified,
          agreements: agreements
              .map(
                (Agreement a) => Input$AgreementInput(
                  termsCode: _termsCode(a.termsCode),
                  agreed: a.agreed,
                ),
              )
              .toList(),
          authorizationCode: _codeOrNull(authorizationCode),
        ),
      ).toJson(),
      'registerSnsMember',
    );
    final payload = Mutation$RegisterSnsMember.fromJson(data).registerSnsMember;
    _check('registerSnsMember', payload.success, payload.userErrors);
    return SnsRegistrationResult(
      emailVerified: payload.emailVerified ?? false,
      verificationId: payload.verificationId,
    );
  }

  @override
  Future<Me> fetchMe() async {
    final Map<String, dynamic> data = await _query(documentNodeQueryMe, 'me');
    return Me.fromJson(Query$Me.fromJson(data).me.toJson());
  }

  /// 토큰을 갱신한다. 실패는 **던진다** — 호출자가 갱신 거부(E3·E4)와 전송 실패(E5)를
  /// 구분해 처리해야 하기 때문이다(SPEC-0005 §2.2). 여기서 null로 뭉개면 R9와 R10 중
  /// 하나는 반드시 위반된다.
  ///
  /// `success: true`인데 accessToken이 null인 응답은 실패로 간주해 null을 돌려주고,
  /// 호출자가 R9를 따른다(AC-31). 스키마상 accessToken이 nullable이라 가능한 상태다.
  @override
  Future<AuthSession?> refresh({required String refreshToken}) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRefreshToken,
      Variables$Mutation$RefreshToken(
        input: Input$RefreshTokenInput(refreshToken: refreshToken),
      ).toJson(),
      'refreshToken',
    );
    final payload = Mutation$RefreshToken.fromJson(data).refreshToken;
    _check('refreshToken', payload.success, payload.userErrors);
    if (payload.accessToken == null || payload.refreshToken == null) {
      return null;
    }
    return _sessionFrom(
      accessToken: payload.accessToken,
      refreshToken: payload.refreshToken,
      tokenType: payload.tokenType,
      accessTokenExpiresIn: payload.accessTokenExpiresIn,
      refreshTokenExpiresIn: payload.refreshTokenExpiresIn,
    );
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    // Best-effort: local sign-out must always proceed even if the server call
    // fails, so swallow any failure here (spec §6.3).
    try {
      final Map<String, dynamic> data = await _mutate(
        documentNodeMutationLogout,
        Variables$Mutation$Logout(
          input: Input$LogoutInput(refreshToken: refreshToken),
        ).toJson(),
        'logout',
      );
      final payload = Mutation$Logout.fromJson(data).logout;
      _check('logout', payload.success, payload.userErrors);
    } on AuthFailure {
      // Ignored — the local session is cleared regardless.
    }
  }

  @override
  Future<void> withdrawMember() async {
    // 로그아웃과 달리 실패를 삼키지 않는다(SPEC-0011 R16) — 서버에서 지워지지
    // 않았는데 로컬만 정리하면 사용자가 계정이 사라졌다고 오해한다.
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationWithdrawMember,
      const <String, dynamic>{},
      'withdrawMember',
    );
    final payload = Mutation$WithdrawMember.fromJson(data).withdrawMember;
    _check('withdrawMember', payload.success, payload.userErrors);
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationRequestPasswordReset,
      Variables$Mutation$RequestPasswordReset(
        input: Input$RequestPasswordResetInput(email: email),
      ).toJson(),
      'requestPasswordReset',
    );
    final payload = Mutation$RequestPasswordReset.fromJson(
      data,
    ).requestPasswordReset;
    _check('requestPasswordReset', payload.success, payload.userErrors);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationResetPassword,
      Variables$Mutation$ResetPassword(
        input: Input$ResetPasswordInput(
          email: email,
          code: code,
          newPassword: newPassword,
        ),
      ).toJson(),
      'resetPassword',
    );
    final payload = Mutation$ResetPassword.fromJson(data).resetPassword;
    _check('resetPassword', payload.success, payload.userErrors);
  }

  // --- helpers -------------------------------------------------------------

  Enum$TermsCode _termsCode(TermsCode code) => switch (code) {
    TermsCode.service => Enum$TermsCode.SERVICE,
    TermsCode.privacy => Enum$TermsCode.PRIVACY,
    TermsCode.location => Enum$TermsCode.LOCATION,
    TermsCode.marketing => Enum$TermsCode.MARKETING,
  };

  Enum$Provider _provider(SnsProvider provider) => switch (provider) {
    SnsProvider.google => Enum$Provider.GOOGLE,
    SnsProvider.apple => Enum$Provider.APPLE,
    SnsProvider.kakao => Enum$Provider.KAKAO,
  };

  /// 빈 문자열을 null로 눕힌다(SPEC-0012 R4).
  ///
  /// provider가 빈 code를 줄 이유는 없지만, 준다면 그것은 "없음"이지 "빈 값을
  /// 보내라"가 아니다. 필드를 아예 빼는 쪽이 R7의 정상 경로와 같은 모양이다.
  static String? _codeOrNull(String? authorizationCode) =>
      (authorizationCode == null || authorizationCode.isEmpty)
      ? null
      : authorizationCode;

  AuthSession _sessionFrom({
    required String? accessToken,
    required String? refreshToken,
    required String? tokenType,
    required int? accessTokenExpiresIn,
    required int? refreshTokenExpiresIn,
  }) {
    if (accessToken == null || refreshToken == null) {
      throw const AuthFailure(AuthFailureKind.unknown);
    }
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType ?? 'Bearer',
      accessTokenExpiresIn: accessTokenExpiresIn,
      refreshTokenExpiresIn: refreshTokenExpiresIn,
    );
  }

  /// Runs a mutation and returns `result.data`, after treating a transport
  /// failure as a network failure. The caller then parses the typed payload and
  /// runs [_check] for the domain `success`/`userErrors` stage (spec §6.2).
  Future<Map<String, dynamic>> _mutate(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.mutate(
      MutationOptions(document: document, variables: variables),
    ),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    String operation,
  ) => _run(
    () => _client.query(QueryOptions(document: document)),
    operation,
    const <String, dynamic>{},
  );

  Future<Map<String, dynamic>> _run(
    Future<QueryResult<Object?>> Function() call,
    String operation,
    Map<String, dynamic> variables,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await call();
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      // 클라이언트가 던졌다 = 응답 자체를 못 받았다 → 전송 실패(E5).
      throw AuthFailure.transportFailure;
    }

    GraphqlDebugLog.response(operation, result);

    if (hasTransportFailure(result)) {
      GraphqlDebugLog.transportFailure(operation, result);
      // 실패를 세 갈래로 나눈다(SPEC-0005 §2.2). "서버가 refreshToken을 거부함"과
      // "네트워크가 끊김"을 뭉개면 R9(세션 종료)와 R10(세션 유지) 중 하나는 반드시
      // 위반된다. 밖으로 나가는 값은 분류 결과뿐이며 원본 message는 흘리지
      // 않는다(POL-013).
      throw switch (classifyQueryResult(result)) {
        AuthErrorClass.unauthenticated => AuthFailure.unauthenticated,
        AuthErrorClass.refreshRejected => AuthFailure.refreshRejected,
        // 재사용 감지는 세션 종료라는 결과가 같아도 **재발급을 시도하면 안 되는**
        // 상태라 따로 던진다(SPEC-0024 §6).
        AuthErrorClass.tokenReuseDetected => AuthFailure.tokenReuseDetected,
        // 토큰은 유효하다 — 갱신하거나 지우지 않고 인증 화면으로 보낼 신호만
        // 올린다(SPEC-0024 §2).
        AuthErrorClass.emailNotVerified => AuthFailure.emailNotVerified,
        // 권한 문제는 인증 계열이 아니다. 토큰을 건드리지 않고 전파한다.
        AuthErrorClass.forbidden ||
        AuthErrorClass.transport ||
        AuthErrorClass.none => AuthFailure.transportFailure,
      };
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) {
      throw const AuthFailure(AuthFailureKind.unknown);
    }
    return data;
  }

  /// Stage 1 of the failure check (spec §6.2): `success == false` OR a non-empty
  /// `userErrors` list is a domain failure. Logs the observed codes/fields in
  /// debug (never messages — those can carry PII) then throws the first as an
  /// [AuthFailure].
  void _check(String operation, bool success, List<Object?> userErrors) {
    final List<({String code, String? field})> parsed = userErrors
        .map(_userError)
        .toList();
    if (parsed.isNotEmpty) {
      GraphqlDebugLog.userErrors(operation, parsed);
      final ({String code, String? field}) first = parsed.first;
      throw AuthFailure.fromCode(first.code, field: first.field);
    }
    if (!success) {
      throw const AuthFailure(AuthFailureKind.unknown);
    }
  }

  /// Extracts `code`/`field` from a generated `*$userErrors` payload via its
  /// JSON form, so this stays agnostic of the per-operation generated type.
  ///
  /// **`codeValue`(enum)를 먼저 읽고 `code`(문자열)로 폴백한다**(SPEC-0024 §6).
  /// 서버가 스키마보다 앞선 코드를 내면 `codeValue`만 null이 되고 `code`는 항상
  /// 채워지므로, 이 순서라야 새 코드가 와도 응답을 잃지 않는다.
  ///
  /// 생성 타입의 `toJson()`은 enum을 그 이름 문자열로 직렬화하므로 두 값의 형태가
  /// 같다 — 그래서 [AuthFailure.fromCode]는 한 가지만 다루면 된다.
  ({String code, String? field}) _userError(Object? error) {
    if (error == null) return (code: '', field: null);
    final Map<String, dynamic> json =
        (error as dynamic).toJson() as Map<String, dynamic>;
    final String? codeValue = json['codeValue'] as String?;
    return (
      code: codeValue ?? json['code'] as String? ?? '',
      field: json['field'] as String?,
    );
  }
}
