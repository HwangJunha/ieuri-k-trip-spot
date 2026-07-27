import 'auth_session.dart';

/// The app-global authentication state exposed to the UI (spec §7).
///
/// A `null` [session] means unauthenticated. When [session] is non-null the
/// user is signed in. [onboardingCompleted] is tracked here (not on [session])
/// because the server has no onboarding field — it is a per-userId local flag
/// (spec §4.3-B, §8-onboarding). [userId] is the account key the router uses.
class AuthState {
  const AuthState({this.session, this.onboardingCompleted = false});

  final AuthSession? session;
  final bool onboardingCompleted;

  static const AuthState unauthenticated = AuthState();

  bool get isAuthenticated => session != null;

  String? get userId => session?.user?.id;

  AuthState copyWith({AuthSession? session, bool? onboardingCompleted}) =>
      AuthState(
        session: session ?? this.session,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      );

  @override
  bool operator ==(Object other) =>
      other is AuthState &&
      other.session == session &&
      other.onboardingCompleted == onboardingCompleted;

  @override
  int get hashCode => Object.hash(session, onboardingCompleted);
}
