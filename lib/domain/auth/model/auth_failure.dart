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

  /// 서버가 provider의 id_token을 검증하지 못했다 — 대개 **만료**다.
  ///
  /// SNS 가입은 provider 인증 → 이메일·약관 입력 → 가입 요청 순이라, 사용자가
  /// 입력에 오래 머물면 그 사이 토큰이 만료된다(애플은 code가 5분이다). 이때
  /// 가입 화면에 남아 재시도해도 같은 토큰을 다시 보낼 뿐이라 영영 실패한다.
  /// 유일한 복구는 provider 재인증이므로 호출자는 로그인 화면으로 되돌린다.
  snsVerificationFailed,

  /// accessToken이 만료/무효라 갱신이 필요하다(SPEC-0005 E1·E2, R4·R5).
  unauthenticated,

  /// 서버가 refreshToken을 거부했다 — 토큰을 제거하고 세션을 종료한다
  /// (SPEC-0005 E3·E4, R9·R11). 재사용 감지(E4)도 여기에 포함된다.
  refreshRejected,

  /// 네트워크가 끊겼거나 서버에 닿지 못했다 — 토큰은 유지한 채 오류만 전파한다
  /// (SPEC-0005 E5, R10). "서버가 거부함"과 뭉개면 R9·R10 중 하나는 반드시
  /// 위반되므로 [refreshRejected]와 반드시 구분한다.
  transportFailure,

  /// 재발송·주소 정정의 60초 쿨다운에 걸렸다(SPEC-0024 R7). 두 버튼이 **하나의**
  /// 타이머를 공유하므로 재발송 직후 주소 정정도 이 코드로 막힌다.
  resendCooldownActive,

  /// 이미 인증을 마친 회원이 주소 정정을 시도했다(SPEC-0024 R7). 그쪽은
  /// `changeEmail`의 몫이다.
  alreadyVerified,

  /// SNS 회원이 이메일 변경을 시도했다(SPEC-0024 R6). SNS 이메일은 provider에
  /// 종속된 값이라 앱에서 바꿀 수 없다.
  notEmailMember,

  /// 이메일 형식이 올바르지 않다고 서버가 판정했다.
  invalidEmailFormat,

  /// 이메일 인증을 마치지 않은 회원이 허용 목록 밖 오퍼레이션을 불렀다
  /// (SPEC-0024 §2). 최상위 오류로 오며, 인증 화면으로 보내는 신호다.
  emailNotVerified,

  /// refresh 재사용이 감지돼 회원의 모든 refresh가 폐기됐다(SPEC-0024 §6).
  /// **재발급으로 회복되지 않는다** — [refreshRejected]와 달리 재로그인이 유일한
  /// 복구다. 둘을 뭉개면 앱이 회복 불가능한 상태에서 갱신을 반복한다.
  tokenReuseDetected,

  unknown,
}

class AuthFailure implements Exception {
  const AuthFailure(this.kind, {this.field});

  final AuthFailureKind kind;
  final String? field;

  /// 서버 `userErrors[].code` 문자열을 도메인 실패로 옮긴다.
  ///
  /// **문자열을 받는다.** 스키마에 `ErrorCode` enum이 생겼지만(SPEC-0024 §6)
  /// 정본은 여전히 `code: String!`이고, `codeValue`는 서버가 스키마보다 앞선 코드를
  /// 낼 때 null이 된다. repository가 `codeValue?.name ?? code`로 접어서 넘기므로
  /// 이 함수는 한 가지 형태만 다루면 된다.
  ///
  /// 모르는 코드는 [AuthFailureKind.unknown]이다 — 서버가 코드를 추가해도 앱이
  /// 깨지지 않아야 한다.
  factory AuthFailure.fromCode(String? code, {String? field}) {
    switch (code) {
      case 'INVALID_CREDENTIALS':
        return AuthFailure(AuthFailureKind.invalidCredentials, field: field);
      case 'EMAIL_TAKEN':
      case 'EMAIL_ALREADY_IN_USE':
        return AuthFailure(AuthFailureKind.emailAlreadyInUse, field: field);
      case 'MEMBER_NOT_FOUND':
        return AuthFailure(AuthFailureKind.memberNotFound, field: field);
      case 'SNS_VERIFICATION_FAILED':
        return AuthFailure(AuthFailureKind.snsVerificationFailed, field: field);
      case 'RESEND_COOLDOWN_ACTIVE':
        return AuthFailure(AuthFailureKind.resendCooldownActive, field: field);
      case 'ALREADY_VERIFIED':
        return AuthFailure(AuthFailureKind.alreadyVerified, field: field);
      case 'NOT_EMAIL_MEMBER':
        return AuthFailure(AuthFailureKind.notEmailMember, field: field);
      case 'INVALID_EMAIL_FORMAT':
        return AuthFailure(AuthFailureKind.invalidEmailFormat, field: field);
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

  /// 미인증 회원의 비허용 오퍼레이션 호출 — 인증 화면으로 보낸다(SPEC-0024 §2).
  static const AuthFailure emailNotVerified = AuthFailure(
    AuthFailureKind.emailNotVerified,
  );

  /// refresh 재사용 감지 — 재발급 불가, 재로그인만이 복구다(SPEC-0024 §6).
  static const AuthFailure tokenReuseDetected = AuthFailure(
    AuthFailureKind.tokenReuseDetected,
  );

  @override
  bool operator ==(Object other) =>
      other is AuthFailure && other.kind == kind && other.field == field;

  @override
  int get hashCode => Object.hash(kind, field);

  @override
  String toString() => 'AuthFailure(${kind.name})';
}
