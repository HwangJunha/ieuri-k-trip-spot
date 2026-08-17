import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../../../common/storage/secure_storage.dart';
import '../model/auth_failure.dart';
import '../model/auth_session.dart';
import '../model/auth_state.dart';
import '../model/email_verification_handle.dart';
import '../model/me.dart';
import '../model/refresh_outcome.dart';
import '../model/sns_credential.dart';
import '../model/sns_provider.dart';
import '../model/sns_registration_result.dart';
import '../model/sns_sign_in_outcome.dart';
import '../../../common/model/terms_code.dart';
import '../repository/auth_repository.dart';
import '../repository/sns_authenticator.dart';
import 'auth_repository_provider.dart';

part 'auth_controller.g.dart';

/// Owns the app-global authentication state (spec §7). Restores the session
/// from secure storage on build, then exposes `AsyncValue<AuthState>` to the UI
/// and the router.
///
/// keepAlive: the auth state must survive navigation and outlive any single
/// screen — the router reads it on every redirect and the GraphQL refresh
/// bridge points at this notifier (CLAUDE.md §5 justification).
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    // Register the refresh hook so the network layer can renew an expired
    // access token without importing this provider (breaks the cycle, §8).
    final TokenRefreshBridge bridge = ref.read(tokenRefreshBridgeProvider);
    bridge.refresher = _refreshAccessToken;
    // 같은 이유로 미인증 안전망도 콜백으로 등록한다(SPEC-0024 §2).
    bridge.emailNotVerifiedHandler = handleEmailNotVerified;
    return _restoreSession();
  }

  SecureStorage get _storage => ref.read(secureStorageProvider);
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Session restore (spec §4.2): load the stored tokens. If an access token is
  /// present, confirm it by fetching `me`; if that fails, try a refresh.
  ///
  /// 이 경로의 실패도 §2.2 분류를 따른다(SPEC-0005 §2.6). accessToken만 만료된 경우
  /// 갱신이 선행되어 로그인 화면을 거치지 않아야 하므로(AC-34), 갱신 시도가 끝나기
  /// 전에는 상태를 `unauthenticated`로 넘기지 않는다 — 이 메서드는 `build()` 안에서
  /// 돌기 때문에 반환 전까지 라우터가 보는 상태는 `loading`으로 유지된다.
  Future<AuthState> _restoreSession() async {
    final String? accessToken = await _storage.readAccessToken();
    final String? refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) return AuthState.unauthenticated;

    if (accessToken != null) {
      final AuthState? confirmed = await _tryEstablish(
        AuthSession(accessToken: accessToken, refreshToken: refreshToken),
      );
      if (confirmed != null) return confirmed;
    }

    // Access token missing or rejected — try one refresh before giving up.
    //
    // 이 경로도 억제 플래그를 [_refreshAccessToken]과 동일하게 갱신해야 한다.
    // 그러지 않으면 [retryRefresh]가 억제를 풀고 이 경로로 재시도했다가 또 실패해도
    // 억제가 서지 않아, 화면 전환마다 갱신이 다시 나간다(AC-36 위반).
    final TokenRefreshBridge bridge = ref.read(tokenRefreshBridgeProvider);
    final RefreshOutcome outcome = await _refreshSession(refreshToken);
    switch (outcome) {
      case RefreshSucceeded(:final AuthSession session):
        await _persist(session);
        bridge.allowRefresh();
        final AuthState? established = await _tryEstablish(session);
        return established ?? AuthState.unauthenticated;
      case RefreshRejected():
        // 서버가 거부했으니 보관해도 쓸모없다 — 지운다(R9·R11).
        bridge.suppressRefresh();
        await _storage.clearSession();
        return AuthState.unauthenticated;
      case RefreshUnavailable():
        // 부팅 중 네트워크가 끊겨 있으면 토큰을 지우지 않고 유지한 채 미인증으로
        // 둔다(R10). 복구 후 재시도 시 보관된 refreshToken으로 갱신이 성공해야
        // 한다(AC-29).
        bridge.suppressRefresh();
        return AuthState.unauthenticated;
    }
  }

  /// Fetches `me` for [session] and builds an authenticated [AuthState], or
  /// `null` if `me` fails (e.g. the access token is stale). Never throws.
  Future<AuthState?> _tryEstablish(AuthSession session) async {
    try {
      final Me me = await _repo.fetchMe();
      final AuthSession full = session.copyWith(user: me);
      await _persistUser(me);
      final bool onboarded = await _storage.isOnboardingCompleted(me.id);
      return AuthState(session: full, onboardingCompleted: onboarded);
    } on Object {
      return null;
    }
  }

  /// Logs in (spec §5.1): `loginEmail` for tokens, then establishes the account.
  /// Emits loading → data/error.
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue<AuthState>.loading();
    state = await AsyncValue.guard(() async {
      final AuthSession tokens = await _repo.loginEmail(
        email: email,
        password: password,
      );
      return _establishSession(tokens);
    });
  }

  /// Persists a freshly issued token pair, fetches `me`, and builds the
  /// authenticated [AuthState]. Shared by email [signIn] and SNS [signInSns] —
  /// the token pair is identical regardless of how it was issued.
  ///
  /// Tokens are persisted BEFORE fetching `me`: AuthLink reads the access token
  /// from secure storage on every request, so `me` is unauthenticated unless the
  /// token is already stored.
  Future<AuthState> _establishSession(AuthSession tokens) async {
    await _persist(tokens);
    final Me me = await _repo.fetchMe();
    final AuthSession session = tokens.copyWith(user: me);
    await _persistUser(me);
    final bool onboarded = await _storage.isOnboardingCompleted(me.id);
    return AuthState(session: session, onboardingCompleted: onboarded);
  }

  SnsAuthenticator get _snsAuth => ref.read(snsAuthenticatorProvider);

  /// SNS login (spec §4). Drives the provider SDK to get a credential, then
  /// `loginSns` for tokens and establishes the account like [signIn]. Returns an
  /// [SnsSignInOutcome] telling the view how to navigate:
  ///   - [SnsAuthenticated] on success (state updated → router navigates),
  ///   - [SnsNeedsSignUp] when the identity isn't registered (carry the
  ///     credential to the SNS sign-up screen),
  ///   - [SnsCancelled] when the user backs out (silent).
  /// A real login/network failure rethrows for the login screen to show.
  Future<SnsSignInOutcome> signInSns(SnsProvider provider) async {
    final SnsCredential credential;
    try {
      credential = await _snsAuth.authenticate(provider);
    } on SnsCancelledException {
      return const SnsCancelled();
    }

    final AsyncValue<AuthState> previous = state;
    state = const AsyncValue<AuthState>.loading();
    try {
      final AuthSession tokens = await _repo.loginSns(
        provider: provider,
        idToken: credential.idToken,
        // 로그인에도 code를 실어야 한다(SPEC-0012 §3). 클라이언트 업데이트
        // 전에 가입한 회원은 토큰이 없고 다음 로그인 때 보충되므로, 이 경로를
        // 빠뜨리면 기존 회원이 영영 연동 해제 대상이 되지 못한다.
        authorizationCode: credential.authorizationCode,
      );
      // **`guard`로 삼키지 않는다.** 삼키면 `_establishSession`(=`me` 조회) 실패가
      // error 상태로 남는데, 게이트는 error를 "판정 불가"로 접어 로그인 화면에
      // 그대로 둔다 — 토큰은 이미 저장됐는데 사용자는 로그인이 안 된 것처럼 보여
      // 계속 다시 시도하게 된다(실기기에서 구글 로그인이 반복된 원인).
      //
      // 던지면 로그인 화면이 오류를 보여 주고, 사용자는 무슨 일이 일어났는지 안다.
      // 토큰은 저장돼 있으므로 다음 시도나 앱 재시작 때 세션 복원이 이어받는다.
      try {
        state = AsyncValue<AuthState>.data(await _establishSession(tokens));
      } on Object {
        state = previous;
        rethrow;
      }
      return const SnsAuthenticated();
    } on AuthFailure catch (failure) {
      // Not registered yet → route to SNS sign-up. Restore the prior state so
      // the router doesn't see a spurious error/loading.
      if (failure.kind == AuthFailureKind.memberNotFound) {
        state = previous;
        return SnsNeedsSignUp(credential);
      }
      state = previous;
      rethrow;
    }
  }

  /// SNS sign-up (spec §5.2). Like [signUp] this issues no tokens and is NOT
  /// wrapped in `state`: it must not flip the app-global auth state. Returns the
  /// [SnsRegistrationResult] so the caller routes to verification-or-login;
  /// failures rethrow for the SNS sign-up view to show locally.
  Future<SnsRegistrationResult> signUpSns({
    required SnsCredential credential,
    required String email,
    required bool ageVerified,
    required List<Agreement> agreements,
  }) => _repo.registerSnsMember(
    provider: credential.provider,
    idToken: credential.idToken,
    email: email,
    ageVerified: ageVerified,
    agreements: agreements,
    authorizationCode: credential.authorizationCode,
  );

  /// Registers a member (spec §4.2/§5.2). Returns the [EmailVerificationHandle]
  /// so the caller routes to the verification screen. Deliberately NOT wrapped
  /// in `state`/`AsyncValue.guard`: registration doesn't authenticate, so it
  /// must not flip the app-global auth state (the router observes it). Failures
  /// rethrow for the sign-up view to show locally.
  Future<EmailVerificationHandle> signUp({
    required String email,
    required String password,
    required bool ageVerified,
    required List<Agreement> agreements,
  }) => _repo.registerEmailMember(
    email: email,
    password: password,
    ageVerified: ageVerified,
    agreements: agreements,
  );

  Future<void> verifyEmail({
    required String verificationId,
    required String code,
  }) => _repo.verifyEmail(verificationId: verificationId, code: code);

  Future<EmailVerificationHandle> resendVerification({
    required String verificationId,
  }) => _repo.resendVerification(verificationId: verificationId);

  /// 인증 대상 주소를 바꾸고 새 코드를 받는다(SPEC-0024 R7).
  ///
  /// `state`를 건드리지 않는다 — 인증 전 상태가 그대로 유지돼야 하고, 주소는
  /// **인증을 통과할 때** 확정되므로 여기서 `me`를 다시 읽어도 옛 주소가 온다.
  Future<EmailVerificationHandle> retargetEmailVerification({
    required String newEmail,
  }) => _repo.retargetEmailVerification(newEmail: newEmail);

  Future<void> requestPasswordReset({required String email}) =>
      _repo.requestPasswordReset(email: email);

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _repo.resetPassword(email: email, code: code, newPassword: newPassword);

  /// Signs out (spec §6.3): invalidate the refresh token server-side, then
  /// clear local tokens and reset state — regardless of the server call's
  /// outcome.
  Future<void> signOut() async {
    final String? refreshToken = await _storage.readRefreshToken();
    if (refreshToken != null) {
      await _repo.logout(refreshToken: refreshToken);
    }
    await _storage.clearSession();
    state = const AsyncValue<AuthState>.data(AuthState.unauthenticated);
  }

  /// 세션에 실린 `Me`를 서버 값으로 다시 맞춘다(SPEC-0011 R4~R6).
  ///
  /// 프로필(닉네임·이미지)이 바뀌면 설정 화면과 홈이 그리는 값은 세션의 `Me`인데,
  /// 그 값은 로그인 시점의 것이라 저절로 갱신되지 않는다. 변경한 쪽이 여기를 부른다.
  ///
  /// **로딩 상태로 떨어뜨리지 않는다.** `AuthController`의 로딩은 라우터 게이트가
  /// "판정 불가"로 읽어 화면이 스플래시로 튄다 — 프로필 한 줄 때문에 앱이 껌뻑이면
  /// 안 된다. 그래서 성공했을 때만 데이터를 갈아 끼운다.
  ///
  /// **실패해도 던지지 않는다.** 서버 변경 자체는 이미 성공한 뒤라, 표시값 동기화가
  /// 실패했다고 사용자에게 "실패했다"고 말하면 거짓이 된다.
  Future<void> refreshMe() async {
    final AuthState? current = state.value;
    final AuthSession? session = current?.session;
    if (current == null || session == null) return;
    try {
      final Me me = await _repo.fetchMe();
      // **값이 그대로면 대입하지 않는다.** 같은 값이라도 새 AsyncValue를 넣으면
      // 리스너가 깨어나고, 라우터가 리다이렉트를 다시 평가하면서 화면이 재구독한
      // provider가 또 조회를 낸다 — 그 응답이 다시 여기로 돌아오면 앱이 서버를
      // 무한히 두드린다(실기기에서 agreements·me가 끝없이 반복했다).
      if (session.user == me) return;
      state = AsyncValue<AuthState>.data(
        current.copyWith(session: session.copyWith(user: me)),
      );
    } on Object {
      // 표시값만 옛것으로 남는다 — 다음 조회에서 맞춰진다.
    }
  }

  /// 서버가 `EMAIL_NOT_VERIFIED`를 최상위 오류로 보냈을 때의 안전망
  /// (SPEC-0024 §2, 설계 §3).
  ///
  /// 라우팅 게이트가 정상 동작하면 이 오류는 원칙적으로 발생하지 않는다. 그래도
  /// 두는 이유는 두 가지다 — 게이트가 놓친 진입점이 있거나, 인증 상태가 서버에서
  /// 바뀐 경우다.
  ///
  /// **토큰을 지우지 않는다.** 토큰 자체는 유효하고 문제는 인증 상태뿐이라,
  /// 로그아웃시키면 사용자가 이유 없이 로그인 화면으로 튕긴다. `me`를 다시 읽어
  /// 세션의 `emailVerified`를 서버 값에 맞추면 게이트가 인증 화면으로 보낸다.
  ///
  /// 화면별로 잡지 않고 여기 한 곳에 둔다(설계 §3).
  ///
  /// **이미 미인증으로 알고 있으면 아무것도 하지 않는다.** 인증 화면에 머무는 동안
  /// 화면들이 보내는 요청은 전부 이 오류로 거절되는데, 그때마다 `me`를 다시 읽으면
  /// 조회가 끝없이 이어진다. 이 안전망이 필요한 경우는 앱이 인증을 마쳤다고
  /// **잘못 알고 있을 때**뿐이고, 그때만 서버 값을 다시 읽으면 된다.
  Future<void> handleEmailNotVerified() async {
    final AuthState? current = state.value;
    if (current == null || !current.isAuthenticated) return;
    if (!current.emailVerified) return; // 이미 안다 — 게이트가 처리 중이다.
    await refreshMe();
  }

  /// Marks onboarding done for the current account and updates state so the
  /// router lets the user through to home (spec §4.3-B local fallback).
  Future<void> completeOnboarding() async {
    final AuthState? current = state.value;
    final String? userId = current?.userId;
    if (current == null || userId == null) return;
    await _storage.setOnboardingCompleted(userId);
    state = AsyncValue<AuthState>.data(
      current.copyWith(onboardingCompleted: true),
    );
  }

  Future<void> _persist(AuthSession session) => _storage.writeTokens(
    accessToken: session.accessToken,
    refreshToken: session.refreshToken,
  );

  Future<void> _persistUser(Me me) =>
      _storage.writeUser(userId: me.id, userEmail: me.email);

  /// Called by the network refresh bridge on an auth error. Renews the token
  /// pair and returns the new access token.
  ///
  /// 실패 처리는 두 갈래로 갈린다(SPEC-0005 §2.2) — 이걸 뭉개면 R9와 R10 중 하나는
  /// 반드시 위반된다:
  ///   - 갱신 거부(E3·E4): 토큰을 제거하고 세션을 종료한다(R9·R11).
  ///   - 전송 실패(E5): 토큰을 **유지**한 채 오류만 전파한다(R10). 네트워크가
  ///     복구되면 보관된 refreshToken으로 갱신이 성공해야 하기 때문이다(AC-29).
  ///
  /// 어느 쪽이든 실패하면 억제 플래그를 세워 순차 재발화를 막는다(R14, AC-36).
  Future<String?> _refreshAccessToken() async {
    final TokenRefreshBridge bridge = ref.read(tokenRefreshBridgeProvider);
    final String? refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) {
      bridge.suppressRefresh();
      await signOut();
      return null;
    }

    final RefreshOutcome outcome = await _refreshSession(refreshToken);
    switch (outcome) {
      case RefreshSucceeded(:final AuthSession session):
        // 저장이 끝난 뒤에 대기 중인 요청이 풀려야 이후 요청이 새 토큰을 담는다
        // (AC-32). 갱신 성공 시 억제는 당연히 해제된다.
        await _persist(session);
        bridge.allowRefresh();
        return session.accessToken;
      case RefreshRejected():
        bridge.suppressRefresh();
        await signOut();
        return null;
      case RefreshUnavailable():
        // R10 — 토큰을 지우지 않는다. 세션도 강제 종료하지 않는다.
        bridge.suppressRefresh();
        return null;
    }
  }

  /// refreshToken으로 갱신을 시도하고 결과를 세 갈래로 돌려준다. repository가 던지는
  /// [AuthFailure] 분류를 그대로 따르며, 여기서 다시 판별하지 않는다(SPEC-0005 §2.1 —
  /// 판별은 한 곳에서만).
  Future<RefreshOutcome> _refreshSession(String refreshToken) async {
    try {
      final AuthSession? refreshed = await _repo.refresh(
        refreshToken: refreshToken,
      );
      // `success: true`인데 accessToken이 null인 응답은 실패로 간주하고 R9를 따른다
      // (AC-31). 스키마상 accessToken이 nullable이라 가능한 상태다.
      if (refreshed == null) return const RefreshRejected();
      return RefreshSucceeded(refreshed);
    } on AuthFailure catch (failure) {
      return failure.kind == AuthFailureKind.transportFailure
          ? const RefreshUnavailable()
          : const RefreshRejected();
    }
  }

  /// 사용자의 명시적 재시도 — 억제를 해제하고 세션 복원을 다시 시도한다(AC-38).
  /// 시간 기반 자동 해제는 두지 않으므로 이 경로와 앱 재시작만이 해제 계기다.
  Future<void> retryRefresh() async {
    ref.read(tokenRefreshBridgeProvider).allowRefresh();
    state = const AsyncValue<AuthState>.loading();
    state = await AsyncValue.guard(_restoreSession);
  }
}
