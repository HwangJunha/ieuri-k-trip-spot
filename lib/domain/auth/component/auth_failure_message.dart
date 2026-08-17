import '../../../l10n/gen/app_localizations.dart';
import '../model/auth_failure.dart';
import '../model/verification_failure_reason.dart';

/// Resolves a domain [AuthFailure] to a localized, user-facing message. Kept in
/// the UI layer because it depends on [AppLocalizations]; the model stays pure.
String authFailureMessage(AppLocalizations l10n, Object error) {
  // 코드 검증 실패는 오류가 아니라 결과라 별도 타입으로 온다(SPEC-0024 §6).
  // 만료와 오타는 사용자가 해야 할 행동이 다르므로 문구를 나눈다.
  if (error is VerificationFailure) {
    return verificationFailureMessage(l10n, error.reason);
  }
  if (error is! AuthFailure) return l10n.errorUnknown;
  switch (error.kind) {
    case AuthFailureKind.invalidCredentials:
      return l10n.errorInvalidCredentials;
    case AuthFailureKind.emailAlreadyInUse:
      return l10n.errorEmailAlreadyInUse;
    // Normally intercepted by the SNS login flow to route to sign-up (spec §4);
    // this message is only a fallback if it ever reaches the UI.
    case AuthFailureKind.memberNotFound:
      return l10n.errorSnsMemberNotFound;
    case AuthFailureKind.snsVerificationFailed:
      return l10n.errorSnsVerificationExpired;
    // 갱신 거부(E3)와 인증 실패(E1·E2)는 사용자에게 구분해 보여주지 않는다 —
    // 어느 쪽이든 다시 로그인하면 된다(SPEC-0005 §2.2).
    case AuthFailureKind.unauthenticated:
    case AuthFailureKind.refreshRejected:
      return l10n.errorUnknown;
    // 재사용 감지는 **안내가 다르다**(SPEC-0024 §6). 자동 복구가 불가능해 사용자가
    // 직접 다시 로그인해야 하므로, 그 사실을 말해 주지 않으면 왜 튕겼는지 모른다.
    case AuthFailureKind.tokenReuseDetected:
      return l10n.errorSessionExpiredSignInAgain;
    case AuthFailureKind.emailNotVerified:
      return l10n.errorEmailNotVerified;
    case AuthFailureKind.resendCooldownActive:
      return l10n.errorResendCooldownActive;
    case AuthFailureKind.alreadyVerified:
      return l10n.errorAlreadyVerified;
    case AuthFailureKind.notEmailMember:
      return l10n.errorNotEmailMember;
    case AuthFailureKind.invalidEmailFormat:
      return l10n.errorInvalidEmailFormat;
    case AuthFailureKind.transportFailure:
      return l10n.errorNetwork;
    case AuthFailureKind.unknown:
      return l10n.errorUnknown;
  }
}

/// 코드 검증 실패 이유를 사용자 문구로 옮긴다(SPEC-0024 §6).
///
/// 만료·사용됨·시도초과는 **새 코드가 필요하다**고 알리고, 불일치는 다시 입력하면
/// 된다고 알린다 — 하나로 뭉치면 사용자가 재발송을 눌러야 할 때 계속 같은 코드를
/// 다시 넣는다.
String verificationFailureMessage(
  AppLocalizations l10n,
  VerificationFailureReason reason,
) => switch (reason) {
  VerificationFailureReason.expired => l10n.verificationCodeExpired,
  VerificationFailureReason.consumed => l10n.verificationCodeConsumed,
  VerificationFailureReason.maxAttemptsExceeded => l10n.verificationMaxAttempts,
  VerificationFailureReason.codeMismatch => l10n.verificationCodeMismatch,
  // 서버가 두 경우를 구분해 주지 않는다 — 어느 쪽이든 새 코드가 필요하다.
  VerificationFailureReason.invalidOrExpired => l10n.verificationCodeExpired,
  VerificationFailureReason.unknown => l10n.errorUnknown,
};
