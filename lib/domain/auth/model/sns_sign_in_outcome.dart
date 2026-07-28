import 'sns_credential.dart';

/// The result of an SNS login attempt (spec §4), returned to the view so it can
/// navigate. Three shapes:
///
///   - [authenticated]  → login succeeded; the app-global auth state is updated
///     and the router handles navigation. The view does nothing.
///   - [needsSignUp]    → the identity isn't registered yet ([credential] is the
///     verified SNS credential to carry into the SNS sign-up screen).
///   - [cancelled]      → the user backed out of the provider dialog; the view
///     silently returns to the login screen.
sealed class SnsSignInOutcome {
  const SnsSignInOutcome();
}

class SnsAuthenticated extends SnsSignInOutcome {
  const SnsAuthenticated();
}

class SnsNeedsSignUp extends SnsSignInOutcome {
  const SnsNeedsSignUp(this.credential);

  final SnsCredential credential;
}

class SnsCancelled extends SnsSignInOutcome {
  const SnsCancelled();
}
