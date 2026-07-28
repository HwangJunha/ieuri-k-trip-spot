import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../model/auth_failure.dart';
import '../model/auth_session.dart';
import '../model/email_verification_handle.dart';
import '../model/me.dart';
import '../model/sns_provider.dart';
import '../model/sns_registration_result.dart';
import '../model/terms_code.dart';
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
  }) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationLoginSns,
      Variables$Mutation$LoginSns(
        input: Input$LoginSnsInput(
          provider: _provider(provider),
          idToken: idToken,
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
        ),
      ).toJson(),
      'registerSnsMember',
    );
    final payload = Mutation$RegisterSnsMember.fromJson(
      data,
    ).registerSnsMember;
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

  @override
  Future<AuthSession?> refresh({required String refreshToken}) async {
    try {
      final Map<String, dynamic> data = await _mutate(
        documentNodeMutationRefreshToken,
        Variables$Mutation$RefreshToken(
          input: Input$RefreshTokenInput(refreshToken: refreshToken),
        ).toJson(),
        'refreshToken',
      );
      final payload = Mutation$RefreshToken.fromJson(data).refreshToken;
      _check('refreshToken', payload.success, payload.userErrors);
      return _sessionFrom(
        accessToken: payload.accessToken,
        refreshToken: payload.refreshToken,
        tokenType: payload.tokenType,
        accessTokenExpiresIn: payload.accessTokenExpiresIn,
        refreshTokenExpiresIn: payload.refreshTokenExpiresIn,
      );
    } on AuthFailure {
      // Refresh failed (expired/invalid) — caller signs out. No throw.
      return null;
    }
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
      throw AuthFailure.networkFailure;
    }

    GraphqlDebugLog.response(operation, result);

    if (hasTransportFailure(result)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw AuthFailure.networkFailure;
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
