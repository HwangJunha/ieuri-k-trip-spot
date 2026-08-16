import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/auth_failure_message.dart';
import '../component/verification_code_field.dart';
import '../model/auth_state.dart';
import '../model/verification_code_input.dart';
import '../provider/auth_controller.dart';
import 'login_screen.dart';

/// Typed arguments for the email-verification route (spec §10 — pass values via
/// `extra`, not a model). Carries the server `verificationId` and the email to
/// prefill on the login screen after verification.
class EmailVerificationArgs {
  const EmailVerificationArgs({
    required this.verificationId,
    required this.email,
  });

  final String verificationId;
  final String email;
}

/// 이메일 인증 화면(SPEC-0024 R11 개편).
///
/// **두 경로로 도착한다.**
///   - 가입 직후 — `verificationId`를 들고 온다. 코드 입력·재발송 모두 가능하다.
///   - 라우터 게이트(R10) — 인증 미완 세션으로 앱을 열면 여기 갇힌다. 이때는
///     `verificationId`가 없다. `me`가 그 값을 주지 않고 서버에도 이메일만으로
///     코드를 다시 받는 오퍼레이션이 없어서(설계 §9 참고), 코드 입력만 가능하고
///     재발송은 열 수 없다 — 없는 기능을 버튼으로 보여 주면 눌렀을 때 실패한다.
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({
    super.key,
    required this.verificationId,
    required this.email,
  });

  static String get routeName => 'emailVerification';

  final String verificationId;
  final String email;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  late String _verificationId = widget.verificationId;

  /// 6칸에서 올라온 현재 코드. 자릿수가 덜 찼으면 그만큼 짧다. **문자열로만**
  /// 다룬다 — 앞자리 0이 살아야 한다(R11-5).
  String _code = '';

  String? _codeError;
  String? _serverError;
  bool _submitting = false;

  /// 재발송 가능 여부. 게이트로 진입해 핸들이 없으면 서버를 부를 수 없다.
  bool get _canResend => _verificationId.isNotEmpty;

  Future<void> _verify(AppLocalizations l10n) async {
    if (_submitting) return;
    setState(() {
      _codeError = _code.length < verificationCodeLength
          ? l10n.validationCodeRequired
          : null;
      _serverError = null;
    });
    if (_codeError != null) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .verifyEmail(verificationId: _verificationId, code: _code);
      if (!mounted) return;
      // 인증 성공 — 메인으로 보내기 전에 서버 상태를 다시 읽는다(설계 §3).
      // 게이트의 판정 근거가 `me.emailVerified`라, 이 갱신 없이는 방금 인증한
      // 사용자가 여전히 미인증으로 판정되어 이 화면에 되돌아온다.
      await ref.read(authControllerProvider.notifier).refreshMe();
      if (!mounted) return;

      // 세션이 이미 서 있었다면(게이트 경로) 갱신만으로 라우터가 메인으로 보낸다.
      // 가입 직후 경로는 토큰이 없으므로 로그인 화면으로 넘긴다.
      final bool authenticated =
          ref.read(authControllerProvider).value?.isAuthenticated ?? false;
      if (!authenticated) {
        context.goNamed(LoginScreen.routeName, extra: widget.email);
      }
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _serverError = authFailureMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _resend(AppLocalizations l10n) async {
    setState(() {
      _submitting = true;
      _serverError = null;
    });
    try {
      final handle = await ref
          .read(authControllerProvider.notifier)
          .resendVerification(verificationId: _verificationId);
      if (!mounted) return;
      setState(() => _verificationId = handle.verificationId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.emailVerificationResent)));
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _serverError = authFailureMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// 인증 화면에서 나가는 출구(설계 §3). 인증할 수 없는 주소로 갇힌 사용자에게
  /// 로그아웃은 유일한 탈출구다 — 뒤로가기로는 나갈 수 없어야 하므로 화면 안에
  /// 둔다.
  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    // 라우터가 미인증을 보고 로그인 화면으로 되돌린다.
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    // 게이트에 걸려 도착한 세션은 로그인 상태다 — 그때만 로그아웃 출구를 보인다.
    final bool authenticated = ref.watch(
      authControllerProvider.select(
        (AsyncValue<AuthState> value) => value.value?.isAuthenticated ?? false,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.emailVerificationTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 8),
              Text(
                l10n.emailVerificationSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (widget.email.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  widget.email,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (_serverError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _serverError!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              VerificationCodeField(
                enabled: !_submitting,
                errorText: _codeError,
                onChanged: (String code) => setState(() {
                  _code = code;
                  _codeError = null;
                }),
                // 여섯 칸이 차면 바로 제출한다 — 버튼을 한 번 더 누르게 할 이유가
                // 없다. 버튼은 실패 후 재시도용으로 남는다.
                onCompleted: (_) => _verify(l10n),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : () => _verify(l10n),
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.emailVerificationButton),
              ),
              if (_canResend) ...<Widget>[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _submitting ? null : () => _resend(l10n),
                  child: Text(l10n.emailVerificationResend),
                ),
              ],
              if (authenticated) ...<Widget>[
                const SizedBox(height: 8),
                TextButton(
                  key: const Key('email-verification-sign-out'),
                  onPressed: _submitting ? null : _signOut,
                  child: Text(l10n.settingsLogOut),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
