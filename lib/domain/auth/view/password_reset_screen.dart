import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/auth_failure_message.dart';
import '../component/auth_text_field.dart';
import '../component/verification_code_field.dart';
import '../../../common/model/email_format.dart';
import '../model/password_policy.dart';
import '../model/verification_code_input.dart';
import '../provider/auth_controller.dart';
import 'login_screen.dart';

/// Code-based two-stage password reset (spec §5.4):
/// 1. Enter the account email → `requestPasswordReset` sends a code.
/// 2. Enter email + code + new password → `resetPassword` completes it.
class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  static String get routeName => 'passwordReset';

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

enum _Stage { request, confirm }

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final TextEditingController _email = TextEditingController();
  /// 6칸에서 올라온 코드. **문자열로만** 다룬다 — 앞자리 0이 살아야 한다(R11-5).
  String _code = '';
  final TextEditingController _newPassword = TextEditingController();

  _Stage _stage = _Stage.request;
  String? _emailError;
  String? _codeError;
  String? _passwordError;
  String? _serverError;
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  Future<void> _requestCode(AppLocalizations l10n) async {
    final String email = _email.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? l10n.validationEmailRequired
          : (!EmailFormat.isValid(email) ? l10n.validationEmailInvalid : null);
      _serverError = null;
    });
    if (_emailError != null) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .requestPasswordReset(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordResetCodeSent)));
      setState(() => _stage = _Stage.confirm);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _serverError = authFailureMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _confirmReset(AppLocalizations l10n) async {
    final String code = _code;
    final String newPassword = _newPassword.text;
    setState(() {
      _codeError = code.length < verificationCodeLength
          ? l10n.validationCodeRequired
          : null;
      _passwordError = !PasswordPolicy.isValid(newPassword)
          ? l10n.validationPasswordPolicy
          : null;
      _serverError = null;
    });
    if (_codeError != null || _passwordError != null) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .resetPassword(
            email: _email.text.trim(),
            code: code,
            newPassword: newPassword,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordResetDone)));
      context.goNamed(LoginScreen.routeName, extra: _email.text.trim());
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _serverError = authFailureMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// 주소를 잘못 넣었을 때 1단계로 돌아간다.
  ///
  /// 코드·비밀번호를 함께 비운다 — 다른 주소로 받을 코드에 이전 입력이 남아 있으면
  /// 사용자가 옛 코드를 그대로 제출하게 된다.
  void _backToRequest() {
    setState(() {
      _stage = _Stage.request;
      _code = '';
      _newPassword.clear();
      _codeError = null;
      _passwordError = null;
      _serverError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.passwordResetTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 8),
              Text(
                // 단계마다 할 일이 다르다 — 안내도 그에 맞춰 바뀌어야 사용자가
                // 지금 무엇을 하는 중인지 안다.
                _stage == _Stage.request
                    ? l10n.passwordResetSubtitle
                    : l10n.passwordResetConfirmSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
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
              // **1단계에서만 입력칸을 보인다.** 코드를 받은 뒤에는 비활성 회색 칸이
              // 남아 "입력하다 만 폼"처럼 보였다 — 대신 어디로 보냈는지를 읽기 좋게
              // 요약하고, 주소를 고치려면 1단계로 돌아가게 한다.
              if (_stage == _Stage.request)
                AuthTextField(
                  controller: _email,
                  label: l10n.emailLabel,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  errorText: _emailError,
                  enabled: !_submitting,
                  onSubmitted: (_) => _requestCode(l10n),
                )
              else ...<Widget>[
                _SentToBanner(
                  email: _email.text.trim(),
                  label: l10n.passwordResetSentTo,
                  actionLabel: l10n.passwordResetChangeEmail,
                  onChangeEmail: _submitting ? null : _backToRequest,
                ),
                const SizedBox(height: 24),
                // 인증 화면과 같은 6칸 입력을 쓴다 — 같은 성격의 코드를 두 화면이
                // 다른 모양으로 받으면 사용자가 매번 형식을 다시 파악해야 한다.
                Text(
                  l10n.verificationCodeLabel,
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                VerificationCodeField(
                  enabled: !_submitting,
                  errorText: _codeError,
                  // 여기서는 자동 제출하지 않는다 — 코드 아래 새 비밀번호 칸이
                  // 남아 있어서, 여섯 칸을 채웠다고 제출하면 빈 비밀번호로 나간다.
                  autofocus: false,
                  onChanged: (String code) => setState(() {
                    _code = code;
                    _codeError = null;
                  }),
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _newPassword,
                  label: l10n.newPasswordLabel,
                  obscure: true,
                  showToggle: true,
                  showLabel: l10n.showPassword,
                  hideLabel: l10n.hidePassword,
                  textInputAction: TextInputAction.done,
                  errorText: _passwordError,
                  enabled: !_submitting,
                  onSubmitted: (_) => _confirmReset(l10n),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting
                    ? null
                    : () => _stage == _Stage.request
                          ? _requestCode(l10n)
                          : _confirmReset(l10n),
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _stage == _Stage.request
                            ? l10n.passwordResetRequestButton
                            : l10n.passwordResetConfirmButton,
                      ),
              ),
              // 코드가 오지 않는 가장 흔한 두 이유를 미리 알려 준다. 서버는 계정
              // 존재 여부를 숨기므로(설계 결정 §4-2 B안) 앱이 "당신 계정은 SNS다"라고
              // 말할 수는 없지만, 조건 자체는 알려 줄 수 있다 — 그래야 사용자가
              // 오지 않을 메일을 기다리지 않는다.
              if (_stage == _Stage.confirm) ...<Widget>[
                const SizedBox(height: 24),
                Text(
                  l10n.passwordResetNoCodeHint,
                  key: const Key('password-reset-no-code-hint'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 코드를 보낸 주소를 요약해 보여 주고, 주소를 고칠 길을 함께 둔다.
///
/// 2단계에서 이메일을 비활성 입력칸으로 남기면 "입력하다 만 폼"처럼 보인다 —
/// 이미 확정된 값은 입력칸이 아니라 **읽는 정보**로 그리는 편이 맞다.
class _SentToBanner extends StatelessWidget {
  const _SentToBanner({
    required this.email,
    required this.label,
    required this.actionLabel,
    required this.onChangeEmail,
  });

  final String email;
  final String label;
  final String actionLabel;

  /// null이면 잠긴다(전송 중).
  final VoidCallback? onChangeEmail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.mark_email_read_outlined,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  key: const Key('password-reset-sent-to'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            key: const Key('password-reset-change-email'),
            onPressed: onChangeEmail,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionLabel, style: theme.textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}
