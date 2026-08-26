import '../model/auth_session.dart';
import '../model/email_verification_handle.dart';
import '../model/me.dart';
import '../model/sns_provider.dart';
import '../model/sns_registration_result.dart';
import '../../../common/model/terms_code.dart';

/// Data-access contract for authentication (spec §6). Returns domain models;
/// GraphQL types never cross this boundary. On failure throws an `AuthFailure`.
abstract interface class AuthRepository {
  /// Registers an email member (spec §5.2/§6.2). Returns NO tokens — on success
  /// yields an [EmailVerificationHandle] (the `verificationId` the verify step
  /// needs). Throws `AuthFailure` on e.g. a taken email.
  Future<EmailVerificationHandle> registerEmailMember({
    required String email,
    required String password,
    required bool ageVerified,
    required List<Agreement> agreements,
  });

  /// Confirms an email with the code the user received (spec §5.3). Throws
  /// `AuthFailure` if the server reports failure or `verified != true`.
  Future<void> verifyEmail({
    required String verificationId,
    required String code,
  });

  /// Requests a fresh verification code, returning the (possibly new) handle
  /// with its `expiresAt` (spec §5.3). Throws `AuthFailure` on failure.
  Future<EmailVerificationHandle> resendVerification({
    required String verificationId,
  });

  /// 인증 대상 주소를 바꾸고 새 코드를 받는다(SPEC-0024 R7).
  ///
  /// 인증을 마치기 전에만 쓸 수 있고 가입 유형을 가리지 않는다. 성공하면 이전
  /// 코드가 무효화되고 **새 `verificationId`가 나오므로** 호출자는 들고 있던 핸들을
  /// 갈아 끼워야 한다.
  ///
  /// `changeEmail`과 다른 경로다 — 그쪽은 인증을 마친 `Provider.EMAIL` 회원 전용이다.
  ///
  /// 실패 시 `AuthFailure`를 던진다. 화면이 분기해야 하는 코드는
  /// `resendCooldownActive`(재발송과 60초 타이머 공유)와 `emailAlreadyInUse`,
  /// `alreadyVerified`다.
  Future<EmailVerificationHandle> retargetEmailVerification({
    required String newEmail,
  });

  /// Logs in with email/password (spec §5.1/§6.2). On success returns an
  /// [AuthSession] with the token pair and server-provided expiries — but NO
  /// user (login has none); the caller fetches [fetchMe]. Throws `AuthFailure`.
  Future<AuthSession> loginEmail({
    required String email,
    required String password,
  });

  /// SNS login (spec §4/§6.2) for an existing member. On success returns an
  /// [AuthSession] with the token pair (no user — the caller fetches [fetchMe]),
  /// exactly like [loginEmail]. Throws `AuthFailure`; a `memberNotFound` kind
  /// means the identity isn't registered and the caller routes to SNS sign-up.
  /// [authorizationCode]는 SPEC-0012 R4의 code다. null이 정상 경로이며
  /// (provider가 주지 않거나 획득에 실패), 없다고 요청을 막지 않는다(R7).
  Future<AuthSession> loginSns({
    required SnsProvider provider,
    required String idToken,
    String? authorizationCode,
  });

  /// SNS sign-up (spec §5.2). Issues NO tokens — returns an
  /// [SnsRegistrationResult] telling the caller whether email verification is
  /// still needed. [email] is required (provider-prefilled but user-editable).
  /// Throws `AuthFailure` on e.g. a taken email or an invalid/expired idToken.
  /// [authorizationCode]는 [loginSns]와 같은 규약이다 — null이 정상이다.
  /// [nickname]은 provider가 준 표시 이름이다(2026-08-25). 카카오는 `id_token`
  /// 클레임이 아니라 별도 프로필 API에 있어, 클라이언트가 넘기지 않으면 서버가 알
  /// 수 없다.
  ///
  /// **형식을 검증하지 않고 그대로 넘긴다** — 어긋나면 서버가 조용히 자동 생성
  /// 닉네임으로 대체하고 오류를 내지 않는다(서버 안내). null이면 서버가 정한다.
  Future<SnsRegistrationResult> registerSnsMember({
    required SnsProvider provider,
    required String idToken,
    required String email,
    required bool ageVerified,
    required List<Agreement> agreements,
    String? authorizationCode,
    String? nickname,
  });

  /// Fetches the authenticated account via the `me` query (spec §6.2). Throws
  /// `AuthFailure` on transport failure or an unauthenticated response.
  Future<Me> fetchMe();

  /// Exchanges a refresh token for a fresh session (spec §6.3). Returns the new
  /// [AuthSession] (tokens only).
  ///
  /// 실패는 **던진다** — 분류된 `AuthFailure`로 나오며, 호출자는 갱신 거부(E3·E4 →
  /// 세션 종료)와 전송 실패(E5 → 세션 유지)를 구분해 처리해야 한다(SPEC-0005 §2.2).
  /// 이 둘을 하나로 뭉개면 R9와 R10 중 하나는 반드시 위반된다.
  ///
  /// `null`은 실패 전반이 아니라 **한 가지 경우만** 뜻한다: `success: true`인데
  /// accessToken이 없는 응답(AC-31). 호출자는 이때 R9를 따른다.
  Future<AuthSession?> refresh({required String refreshToken});

  /// Invalidates the refresh token server-side (spec §6.3). Best-effort: never
  /// throws so local sign-out always completes.
  Future<void> logout({required String refreshToken});

  /// Step 1 of password reset (spec §5.4): request a code be emailed. Throws
  /// `AuthFailure` on failure.
  Future<void> requestPasswordReset({required String email});

  /// Step 2 of password reset (spec §5.4): confirm with the emailed code and a
  /// new password. Throws `AuthFailure` on failure.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// 회원 탈퇴(SPEC-0011 R16). 인자가 없다 — 서버가 토큰의 주체를 지운다.
  ///
  /// **[logout]과 달리 실패를 삼키지 않는다.** 로그아웃은 실패해도 로컬을 정리하는
  /// 것이 옳지만(R15), 탈퇴는 서버에서 지워지지 않았는데 로컬만 지우면 사용자가
  /// 계정이 사라졌다고 오해한다. 실패는 `AuthFailure`로 올린다.
  Future<void> withdrawMember();
}
