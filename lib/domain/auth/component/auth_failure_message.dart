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
    case AuthFailureKind.network:
      return l10n.errorNetwork;
    case AuthFailureKind.unknown:
      return l10n.errorUnknown;
  }
}
