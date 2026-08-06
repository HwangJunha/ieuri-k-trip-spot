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
      throw const AuthFailure(AuthFailureKind.unknown);
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
      _withAuthorizationCode(
        Variables$Mutation$LoginSns(
          input: Input$LoginSnsInput(
            provider: _provider(provider),
            idToken: idToken,
          ),
        ).toJson(),
        authorizationCode,
      ),
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
      _withAuthorizationCode(
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
          ),
        ).toJson(),
        authorizationCode,
      ),
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

  /// 서버가 `authorizationCode`를 받을 준비가 됐는지(SPEC-0012 R4).
  ///
  /// **지금은 false다.** 서버 SPEC-0012가 배포되지 않아 `LoginSnsInput`과
  /// `RegisterSnsMemberInput`에 이 필드가 없고, 정의되지 않은 input 필드를
  /// 보내면 서버가 요청을 통째로 거부한다(실측):
  ///
  /// ```
  /// {"errors":[{"message":"The variables input contains a field name
  ///  'authorizationCode' that is not defined for input object type
  ///  'LoginSnsInput'","extensions":{"classification":"ValidationError"}}]}
  /// ```
  ///
  /// 즉 켠 채로 두면 code를 주는 provider(Apple은 항상, Google은 발급될 때)의
  /// 로그인·가입이 전부 실패한다 — code가 있다는 이유로 인증이 막히는 것이라
  /// R7 위반이기도 하다. 그래서 배선은 모두 연결해 두고 전송만 잠가 둔다.
  ///
  /// **서버 배포 후 할 일:** `auth_schema.graphql`의 두 input에 필드를 넣고
  /// codegen을 돌린 뒤, 이 상수와 [_withAuthorizationCode]를 지우고 값을
  /// `Input$…` 생성자에 직접 넘긴다.
  static const bool _sendAuthorizationCode = false;

  /// SNS 요청 변수의 `input`에 `authorizationCode`를 얹는다.
  ///
  /// 생성 타입에 넣지 않고 직렬화 뒤에 얹는 것은 커밋된 SDL에 필드가 없어
  /// 생성자에 파라미터 자체가 없기 때문이다. [_sendAuthorizationCode]가
  /// 꺼져 있으면 아무것도 하지 않는다.
  ///
  /// code가 없으면 아무것도 얹지 않는다 — 필드가 빠진 요청이 R7의 정상 경로다.
  Map<String, dynamic> _withAuthorizationCode(
    Map<String, dynamic> variables,
    String? authorizationCode,
  ) {
    if (!_sendAuthorizationCode ||
        authorizationCode == null ||
        authorizationCode.isEmpty) {
      return variables;
    }
    final Object? input = variables['input'];
    if (input is! Map<String, dynamic>) {
      // 두 호출자 모두 생성 타입의 toJson()을 넘기므로 도달할 수 없다.
      // 변수 모양이 바뀌면 조용히 code를 흘리는 대신 여기서 드러나야 한다.
      throw StateError('SNS 요청 변수에 input 맵이 없다: $variables');
    }
    return <String, dynamic>{
      ...variables,
      'input': <String, dynamic>{
        ...input,
        'authorizationCode': authorizationCode,
      },
    };
  }

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
  ({String code, String? field}) _userError(Object? error) {
    if (error == null) return (code: '', field: null);
    final Map<String, dynamic> json =
        (error as dynamic).toJson() as Map<String, dynamic>;
    return (
      code: json['code'] as String? ?? '',
      field: json['field'] as String?,
    );
  }
}
