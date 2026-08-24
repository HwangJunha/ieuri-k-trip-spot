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

  /// 이메일 인증을 마쳤는지(SPEC-0024 R10). 라우터 게이트의 판정 근거다.
  ///
  /// **`user`가 아직 없으면 참으로 본다.** 토큰은 있는데 `me`를 못 읽은 상태인데,
  /// 이때 거짓을 주면 인증을 마친 사용자가 조회 실패 한 번에 인증 화면으로 튕긴다.
  /// 게이트는 `me`를 읽은 뒤에만 판정하고, 못 읽은 구간은 상위의 `loading`이
  /// 이미 막고 있다.
  bool get emailVerified => session?.user?.emailVerified ?? true;

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
