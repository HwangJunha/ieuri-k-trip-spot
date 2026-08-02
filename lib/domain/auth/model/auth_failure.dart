/// A domain-level auth failure, mapped from a server `userErrors[].code` or a
/// top-level GraphQL/transport error (spec §6.4). Carries no raw server text so
/// nothing sensitive is logged; the UI resolves a localized message from [kind].
///
/// [field] echoes the offending input field name when the server supplies one,
/// so the UI can show an inline error under that field.
enum AuthFailureKind {
  invalidCredentials,
  emailAlreadyInUse,

  /// SNS login for an account that doesn't exist yet (spec §4). The server
  /// rejects `loginSns` for an unregistered identity rather than auto-creating
  /// one; the caller routes the user to SNS sign-up.
  memberNotFound,

  /// accessToken이 만료/무효라 갱신이 필요하다(SPEC-0005 E1·E2, R4·R5).
  unauthenticated,

  /// 서버가 refreshToken을 거부했다 — 토큰을 제거하고 세션을 종료한다
  /// (SPEC-0005 E3·E4, R9·R11). 재사용 감지(E4)도 여기에 포함된다.
  refreshRejected,

  /// 네트워크가 끊겼거나 서버에 닿지 못했다 — 토큰은 유지한 채 오류만 전파한다
  /// (SPEC-0005 E5, R10). "서버가 거부함"과 뭉개면 R9·R10 중 하나는 반드시
  /// 위반되므로 [refreshRejected]와 반드시 구분한다.
  transportFailure,

  unknown,
}

class AuthFailure implements Exception {
  const AuthFailure(this.kind, {this.field});

  final AuthFailureKind kind;
  final String? field;

  /// Maps a server `userErrors[].code` string to a domain failure kind.
  ///
  /// `UserError.code` is a `String` in the schema (not an enum), so the exact
  /// constants aren't discoverable statically. The candidates below are the
  /// common ones; unknown codes fall back to [AuthFailureKind.unknown].
  ///
  /// TODO(runtime): confirm the real code constants by exercising the live
  /// server (bad login, duplicate email, wrong verification code). The repo's
  /// `GraphqlDebugLog.userErrors` logs code/field in debug so they can be
  /// collected and this mapping finalized (spec §6.4).
  factory AuthFailure.fromCode(String? code, {String? field}) {
    switch (code) {
      case 'INVALID_CREDENTIALS':
        return AuthFailure(AuthFailureKind.invalidCredentials, field: field);
      case 'EMAIL_TAKEN':
      case 'EMAIL_ALREADY_IN_USE':
        return AuthFailure(AuthFailureKind.emailAlreadyInUse, field: field);
      case 'MEMBER_NOT_FOUND':
        return AuthFailure(AuthFailureKind.memberNotFound, field: field);
      default:
        return AuthFailure(AuthFailureKind.unknown, field: field);
    }
  }

  /// accessToken 만료/무효 — 갱신 트리거 대상(E1·E2).
  static const AuthFailure unauthenticated = AuthFailure(
    AuthFailureKind.unauthenticated,
  );

  /// 서버가 refreshToken을 거부함 — 세션 종료 대상(E3·E4).
  static const AuthFailure refreshRejected = AuthFailure(
    AuthFailureKind.refreshRejected,
  );

  /// 네트워크/서버 도달 실패 — 토큰 유지, 오류만 전파(E5).
  static const AuthFailure transportFailure = AuthFailure(
    AuthFailureKind.transportFailure,
  );

  @override
  bool operator ==(Object other) =>
      other is AuthFailure && other.kind == kind && other.field == field;

  @override
  int get hashCode => Object.hash(kind, field);

  @override
  String toString() => 'AuthFailure(${kind.name})';
}
