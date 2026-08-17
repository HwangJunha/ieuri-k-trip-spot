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
    this.password,
  });

  final String verificationId;
  final String email;

  /// 가입 폼에서 넘어온 비밀번호. 인증에 성공하면 이것으로 **자동 로그인**해서
  /// 사용자를 바로 앱으로 들여보낸다 — 방금 계정을 만든 사람에게 로그인 화면을
  /// 다시 보여 주고 같은 값을 또 치게 할 이유가 없다.
  ///
  /// **메모리에만 머문다.** 저장소에 쓰지 않고 화면이 사라지면 함께 사라진다
  /// (CLAUDE.md §7 — 비밀번호는 어디에도 남기지 않는다). SNS 가입은 비밀번호가
  /// 없으므로 null이고, 그 경로는 인증 후 로그인 화면으로 간다.
  final String? password;
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
    this.password,
  });

  static String get routeName => 'emailVerification';

  final String verificationId;
  final String email;

  /// 가입 직후 자동 로그인에 쓸 비밀번호. 없으면 인증 후 로그인 화면으로 간다.
  final String? password;

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

  /// 서버 핸들을 들고 있는지. 없으면 `verifyEmail`도 `resendVerification`도 부를 수
  /// 없다 — 둘 다 `verificationId`를 필수로 요구한다.
  bool get _hasHandle => _verificationId.isNotEmpty;

  int get _cooldownSeconds => _cooldown.remainingSecondsAt(DateTime.now());
  bool get _coolingDown => _cooldownSeconds > 0;

  /// 화면에 보여 줄 발송 주소.
  ///
  /// 인자로 받은 값이 우선이고(가입 직후 경로), 없으면 세션의 `me.email`을 쓴다
  /// (게이트 진입 경로). 어느 주소로 코드가 갔는지 모르면 사용자는 어느 메일함을
  /// 봐야 할지 알 수 없다.
  String _resolvedEmail(WidgetRef ref) {
    if (_targetEmail.isNotEmpty) return _targetEmail;
    return ref.read(authControllerProvider).value?.session?.user?.email ?? '';
  }

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

    // **핸들이 없으면 서버를 부르지 않는다.** 빈 verificationId로 보내면 서버가
    // `Invalid UUID string`으로 거절하는데(실기기 확인), 그 오류로는 사용자가 무엇을
    // 해야 하는지 알 수 없고 누를 때마다 요청만 나간다. 이 상태에서 필요한 것은
    // 코드 입력이 아니라 **재발송**이다 — 코드에는 유효기간이 있어 옛 코드는
    // 어차피 쓸 수 없다.
    if (!_hasHandle) {
      setState(() {
        _codeError = null;
        _serverError = l10n.emailVerificationNeedsResend;
      });
      return;
    }

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

      final bool authenticated =
          ref.read(authControllerProvider).value?.isAuthenticated ?? false;

      if (authenticated) {
        // 게이트 경로 — 세션이 이미 서 있다. 서버 상태를 다시 읽으면
        // `me.emailVerified`가 참으로 바뀌어 라우터가 메인으로 보낸다(설계 §3).
        await ref.read(authControllerProvider.notifier).refreshMe();
        return;
      }

      // 가입 직후 경로 — 토큰이 없다. 비밀번호를 들고 있으면 **자동 로그인해서 바로
      // 앱으로 들여보낸다.** 방금 계정을 만든 사람에게 로그인 화면을 다시 보여 주고
      // 같은 값을 또 치게 할 이유가 없다.
      final String? password = widget.password;
      if (password != null && password.isNotEmpty) {
        try {
          await ref
              .read(authControllerProvider.notifier)
              .signIn(email: _targetEmail, password: password);
          if (!mounted) return;
          // 성공하면 라우터가 상태 변화를 보고 메인으로 보낸다. 실패했다면 아래
          // 로그인 화면으로 떨어뜨려 사용자가 직접 시도하게 한다 — 인증 자체는
          // 이미 끝났으므로 되돌릴 것은 없다.
          if (ref.read(authControllerProvider).value?.isAuthenticated ?? false) {
            return;
          }
        } on Object {
          // 자동 로그인 실패는 치명적이지 않다 — 로그인 화면으로 보낸다.
          if (!mounted) return;
        }
      }

      if (!mounted) return;
      context.goNamed(LoginScreen.routeName, extra: _targetEmail);
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

  /// 코드 재발송.
  ///
  /// 핸들이 있으면 `resendVerification`을, 없으면(게이트 진입 경로) 같은 주소로
  /// `retargetEmailVerification`을 부른다. 후자는 토큰만으로 새 코드를 발급하므로
  /// **핸들 없이 코드를 다시 받을 수 있는 유일한 길**이다. 사용자에게는 둘 다
  /// "재발송"이며 구분할 이유가 없다.
  Future<void> _resend(AppLocalizations l10n) async {
    final String fallbackEmail = _resolvedEmail(ref);
    if (!_hasHandle && fallbackEmail.isEmpty) {
      // 보낼 주소조차 모르는 상태 — 주소 정정으로 직접 받아야 한다.
      setState(() => _serverError = l10n.errorUnknown);
      return;
    }

    setState(() {
      _submitting = true;
      _serverError = null;
    });
    try {
      final handle = _hasHandle
          ? await ref
                .read(authControllerProvider.notifier)
                .resendVerification(verificationId: _verificationId)
          : await ref
                .read(authControllerProvider.notifier)
                .retargetEmailVerification(newEmail: fallbackEmail);
      if (!mounted) return;
      setState(() {
        _verificationId = handle.verificationId;
        if (_targetEmail.isEmpty) _targetEmail = fallbackEmail;
      });
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
    if (!mounted) return;
    // **명시적으로 이동한다.** 게이트가 이 화면을 미인증 허용 경로로 두고 있어서
    // 상태 변화만으로는 리다이렉트가 `null`을 돌려주고 화면이 그대로 남았다 —
    // 실기기에서 로그아웃이 먹지 않는 교착이 났다. 게이트도 함께 고쳤지만, 화면이
    // 자기 출구를 스스로 아는 편이 안전하다(`_verify`도 같은 이유로 그렇게 한다).
    context.goNamed(LoginScreen.routeName);
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
    // 세션의 이메일까지 감안한 발송 주소. 게이트로 진입하면 인자가 비어 있어
    // `me.email`이 유일한 근거다.
    final String shownEmail = _resolvedEmail(ref);
    // 핸들이 없으면 코드를 넣어도 서버가 거절한다. 입력 자체를 막아 사용자가
    // 헛되이 여섯 자리를 치지 않게 한다.
    final bool codeUsable = _hasHandle;

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
              if (shownEmail.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  shownEmail,
                  key: const Key('email-verification-target'),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              // 핸들 없이 도착했으면(앱 재시작 등) 왜 코드를 넣을 수 없는지 먼저
              // 말해 준다 — 안내 없이 잠긴 입력만 보이면 고장으로 읽힌다.
              if (!codeUsable) ...<Widget>[
                const SizedBox(height: 16),
                Text(
                  l10n.emailVerificationNeedsResend,
                  key: const Key('email-verification-needs-resend'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
                enabled: !_submitting && codeUsable,
                autofocus: codeUsable,
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
                // 핸들이 없으면 잠근다. 열어 두면 누를 때마다 빈 verificationId가
                // 서버로 나가 `Invalid UUID string`만 돌아온다.
                onPressed: _submitting || !codeUsable
                    ? null
                    : () => _verify(l10n),
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.emailVerificationButton),
              ),
              // 재발송은 **핸들이 없을 때 오히려 더 필요하다** — 그 상태에서 코드를
              // 다시 받는 유일한 길이다. 핸들이 있으면 resendVerification을,
              // 없으면 같은 주소로 retarget을 부른다(둘 다 사용자에겐 "재발송"이다).
              //
              // 세션이 없고 핸들도 없으면 어느 오퍼레이션도 부를 수 없어 숨긴다 —
              // 이 조합은 라우터 게이트가 로그인 화면으로 돌려보내는 상태다.
              if (_hasHandle || authenticated) ...<Widget>[
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
              // 오퍼레이션이라 세션이 선 경우에만 보인다. 재발송과 60초 타이머를
              // 공유한다.
              if (authenticated) ...<Widget>[
                const SizedBox(height: 8),
                TextButton(
                  key: const Key('email-verification-retarget'),
                  onPressed: _submitting || _coolingDown
                      ? null
                      : () => _retarget(l10n),
                  child: Text(l10n.emailVerificationChangeAddress),
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
