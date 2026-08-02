import '../../../l10n/gen/app_localizations.dart';
import '../model/auth_failure.dart';

/// Resolves a domain [AuthFailure] to a localized, user-facing message. Kept in
/// the UI layer because it depends on [AppLocalizations]; the model stays pure.
String authFailureMessage(AppLocalizations l10n, Object error) {
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
    // 갱신 거부(E3·E4)와 인증 실패(E1·E2)는 사용자에게 구분해 보여주지 않는다 —
    // 어느 쪽이든 다시 로그인하면 되고, 재사용 감지에 별도 안내를 하지 않는 것은
    // 의도된 선택이다(SPEC-0005 §2.2).
    case AuthFailureKind.unauthenticated:
    case AuthFailureKind.refreshRejected:
      return l10n.errorUnknown;
    case AuthFailureKind.transportFailure:
      return l10n.errorNetwork;
    case AuthFailureKind.unknown:
      return l10n.errorUnknown;
  }
}
