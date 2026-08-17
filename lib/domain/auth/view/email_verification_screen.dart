import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/model/email_format.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/auth_failure_message.dart';
import '../component/auth_text_field.dart';
import '../component/verification_code_field.dart';
import '../model/auth_failure.dart';
import '../model/auth_state.dart';
import '../model/resend_cooldown.dart';
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

  /// 지금 인증 코드가 발송된 주소. 주소를 정정하면 여기가 바뀐다.
  ///
  /// `me.email`을 쓰지 않는다 — 주소는 **인증을 통과할 때** 확정되므로 정정 직후
  /// 서버의 `me.email`은 아직 이전 주소다(SPEC-0024 R7). 사용자에게는 코드가 실제로
  /// 간 곳을 보여 줘야 한다.
  late String _targetEmail = widget.email;

  /// 6칸에서 올라온 현재 코드. 자릿수가 덜 찼으면 그만큼 짧다. **문자열로만**
  /// 다룬다 — 앞자리 0이 살아야 한다(R11-5).
  String _code = '';

  String? _codeError;
  String? _serverError;
  bool _submitting = false;

  /// 재발송과 주소 정정이 **공유하는** 쿨다운(SPEC-0024 R7). 서버가 두 오퍼레이션에
  /// 하나의 타이머를 쓰므로 앱도 하나로 센다 — 따로 세면 한쪽이 열려 보이는데 누르면
  /// 실패한다.
  ResendCooldown _cooldown = ResendCooldown.idle;

  /// 카운트다운 표시를 1초마다 다시 그리는 타이머. 쿨다운 중에만 돈다.
  Timer? _ticker;

  /// 재발송 가능 여부. 게이트로 진입해 핸들이 없으면 서버를 부를 수 없다.
  bool get _canResend => _verificationId.isNotEmpty;

  int get _cooldownSeconds => _cooldown.remainingSecondsAt(DateTime.now());
  bool get _coolingDown => _cooldownSeconds > 0;

  /// 코드를 보낸 직후 호출한다. 쿨다운을 시작하고 카운트다운을 돌린다.
  void _startCooldown() {
    setState(() => _cooldown = _cooldown.markSent(DateTime.now()));
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted || !_coolingDown) {
        timer.cancel();
        return;
      }
      // 남은 초만 다시 그린다.
      setState(() {});
    });
  }

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

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
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
      _startCooldown();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.emailVerificationResent)));
    } on Object catch (error) {
      if (!mounted) return;
      // 서버가 쿨다운으로 막았다면 앱의 타이머가 서버와 어긋나 있었다는 뜻이다.
      // 여기서 타이머를 세워 두 번째 시도가 헛돌지 않게 한다.
      if (error is AuthFailure &&
          error.kind == AuthFailureKind.resendCooldownActive) {
        _startCooldown();
      }
      setState(() => _serverError = authFailureMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// 주소 정정(SPEC-0024 R7). 인증 화면 안에서만 쓰는 경로이며 설정의
  /// `changeEmail`과 UI를 공유하지 않는다 — 그쪽은 인증을 마친 회원 전용이다.
  Future<void> _retarget(AppLocalizations l10n) async {
    final String? newEmail = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) =>
          _RetargetDialog(currentEmail: _targetEmail),
    );
    if (newEmail == null || !mounted) return;

    setState(() {
      _submitting = true;
      _serverError = null;
    });
    try {
      final handle = await ref
          .read(authControllerProvider.notifier)
          .retargetEmailVerification(newEmail: newEmail);
      if (!mounted) return;
      setState(() {
        // 새 핸들로 갈아 끼운다 — 이전 코드는 서버에서 무효화됐다.
        _verificationId = handle.verificationId;
        _targetEmail = newEmail;
      });
      _startCooldown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.emailVerificationAddressChanged)),
      );
    } on Object catch (error) {
      if (!mounted) return;
      if (error is AuthFailure &&
          error.kind == AuthFailureKind.resendCooldownActive) {
        _startCooldown();
      }
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
              if (_targetEmail.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  _targetEmail,
                  key: const Key('email-verification-target'),
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
                  key: const Key('email-verification-resend'),
                  // 쿨다운 중에는 잠근다. 서버가 어차피 거부하므로 눌리게 두면
                  // 사용자가 오류만 본다.
                  onPressed: _submitting || _coolingDown
                      ? null
                      : () => _resend(l10n),
                  child: Text(
                    _coolingDown
                        ? l10n.emailVerificationResendCountdown(
                            _cooldownSeconds,
                          )
                        : l10n.emailVerificationResend,
                  ),
                ),
              ],
              // 주소 정정(SPEC-0024 R7). 로그인 상태에서만 부를 수 있는
              // 오퍼레이션이라 세션이 선 경우에만 보인다.
              //
              // **게이트로 진입해 핸들이 없는 사용자에게는 이것이 유일한 길이다** —
              // 재발송은 verificationId를 요구해 못 쓰지만, 이쪽은 토큰만으로
              // 새 코드를 받아 낼 수 있다.
              if (authenticated) ...<Widget>[
                const SizedBox(height: 8),
                TextButton(
                  key: const Key('email-verification-retarget'),
                  onPressed: _submitting || _coolingDown
                      ? null
                      : () => _retarget(l10n),
                  child: Text(
                    _coolingDown && !_canResend
                        ? l10n.emailVerificationResendCountdown(
                            _cooldownSeconds,
                          )
                        : l10n.emailVerificationChangeAddress,
                  ),
                ),
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

/// 주소 정정 입력 다이얼로그(SPEC-0024 R7).
///
/// 새 주소만 받고 서버 호출은 하지 않는다 — 호출과 오류 분기는 인증 화면이 맡아야
/// 쿨다운 타이머가 한 곳에서 관리된다.
class _RetargetDialog extends StatefulWidget {
  const _RetargetDialog({required this.currentEmail});

  final String currentEmail;

  @override
  State<_RetargetDialog> createState() => _RetargetDialogState();
}

class _RetargetDialogState extends State<_RetargetDialog> {
  final TextEditingController _email = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit(AppLocalizations l10n) {
    final String value = _email.text.trim();
    // 형식 검사는 여기서 한다 — 서버 왕복 없이 걸러야 쿨다운을 헛되이 쓰지 않는다.
    // 정정은 60초에 한 번뿐이라 오타로 그 기회를 날리면 1분을 더 기다려야 한다.
    setState(() {
      _error = value.isEmpty
          ? l10n.validationEmailRequired
          : (!EmailFormat.isValid(value) ? l10n.validationEmailInvalid : null);
    });
    if (_error != null) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.emailVerificationChangeAddressTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(l10n.emailVerificationChangeAddressBody),
          const SizedBox(height: 16),
          AuthTextField(
            key: const Key('email-verification-retarget-field'),
            controller: _email,
            label: l10n.emailLabel,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            errorText: _error,
            onSubmitted: (_) => _submit(l10n),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          key: const Key('email-verification-retarget-submit'),
          onPressed: () => _submit(l10n),
          child: Text(l10n.emailVerificationResend),
        ),
      ],
    );
  }
}
