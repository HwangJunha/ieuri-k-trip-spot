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
    case AuthFailureKind.network:
      return l10n.errorNetwork;
    case AuthFailureKind.unknown:
      return l10n.errorUnknown;
  }
}
