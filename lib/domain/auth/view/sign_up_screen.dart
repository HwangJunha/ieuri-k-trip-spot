import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/agreement_checklist.dart';
import '../component/auth_failure_message.dart';
import '../component/auth_text_field.dart';
import '../model/auth_failure.dart';
import '../model/email_verification_handle.dart';
import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../common/model/email_format.dart';
import '../model/password_policy.dart';
import '../../../common/model/terms_code.dart';
import '../provider/auth_controller.dart';
import 'email_verification_screen.dart';

/// Account creation (spec §5.2): email + password + confirm, plus the inline
/// agreements/age checklist. The submit button stays disabled until the
/// password policy passes and all REQUIRED consent items are checked. On
/// success the server returns a `verificationId` (no tokens, §4.2), so we route
/// to the email-verification screen.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  static String get routeName => 'signUp';

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  AgreementSelection _agreements = const AgreementSelection();

  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _serverError;
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  /// The gate for enabling submit (spec §5.2): password policy holds and every
  /// required consent item is checked.
  bool get _canSubmit =>
      PasswordPolicy.isValid(_password.text) && _agreements.requiredSatisfied;

  bool _validate(AppLocalizations l10n) {
    final String email = _email.text.trim();
    final String password = _password.text;
    final String confirm = _confirm.text;
    setState(() {
      _emailError = email.isEmpty
          ? l10n.validationEmailRequired
          : (!EmailFormat.isValid(email) ? l10n.validationEmailInvalid : null);
      _passwordError = password.isEmpty
          ? l10n.validationPasswordRequired
          : (!PasswordPolicy.isValid(password)
                ? l10n.validationPasswordPolicy
                : null);
      _confirmError = password != confirm
          ? l10n.validationPasswordMismatch
          : null;
    });
    return _emailError == null &&
        _passwordError == null &&
        _confirmError == null;
  }

  List<Agreement> _buildAgreements() {
    return AgreementItem.all
        .where((AgreementItem i) => i.termsCode != null)
        .map(
          (AgreementItem i) => Agreement(
            termsCode: i.termsCode!,
            agreed: _agreements.isChecked(i),
          ),
        )
        .toList();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_validate(l10n)) return;
    setState(() {
      _submitting = true;
      _serverError = null;
    });
    final String email = _email.text.trim();
    try {
      final EmailVerificationHandle handle = await ref
          .read(authControllerProvider.notifier)
          .signUp(
            email: email,
            password: _password.text,
            ageVerified: _agreements.ageVerified,
            agreements: _buildAgreements(),
          );
      // **핸들을 받았으면 서버 등록이 끝난 것이다.** 이메일 인증이 남았지만 그건
      // 별개 단계다 — 여기서 세지 않으면 인증 화면에서 이탈한 사용자가 가입 시도에
      // 잡히지 않아 퍼널이 끊긴다.
      AppAnalytics.logEvent(AnalyticsEvents.signUp, <String, Object>{
        AnalyticsParams.method: 'email',
      });
      if (!mounted) return;
      // No tokens on sign-up (§4.2) — go to email verification with the handle.
      //
      // 비밀번호를 함께 넘긴다. 인증에 성공하면 그것으로 자동 로그인해서 사용자를
      // **바로 앱으로** 들여보낸다 — 방금 계정을 만든 사람에게 로그인 화면을 다시
      // 보여 주고 같은 값을 또 치게 할 이유가 없다. 값은 메모리에만 머문다.
      context.pushNamed(
        EmailVerificationScreen.routeName,
        extra: EmailVerificationArgs(
          verificationId: handle.verificationId,
          email: email,
          password: _password.text,
        ),
      );
    } on Object catch (error) {
      if (!mounted) return;
      // 서버가 어느 입력이 문제인지 `field`로 알려 준다. 그 칸 아래에 붙여야
      // 사용자가 무엇을 고쳐야 할지 바로 안다 — 상단 배너에만 띄우면 긴 폼에서는
      // 어느 칸 얘기인지 알 수 없다.
      final String message = authFailureMessage(l10n, error);
      setState(() {
        if (error is AuthFailure && error.pointsAt('password')) {
          _passwordError = message;
          _serverError = null;
        } else if (error is AuthFailure && error.pointsAt('email')) {
          _emailError = message;
          _serverError = null;
        } else {
          _serverError = message;
        }
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final bool enabled = !_submitting && _canSubmit;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.signUpTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 8),
              Text(
                l10n.signUpSubtitle,
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
              AuthTextField(
                controller: _email,
                label: l10n.emailLabel,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                errorText: _emailError,
                enabled: !_submitting,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _password,
                label: l10n.passwordLabel,
                obscure: true,
                showToggle: true,
                showLabel: l10n.showPassword,
                hideLabel: l10n.hidePassword,
                textInputAction: TextInputAction.next,
                errorText: _passwordError,
                enabled: !_submitting,
                // Re-evaluate the submit gate as the password changes, and show
                // the policy error inline while a non-empty password is invalid
                // (the submit button is gated on the same policy, so the error
                // wouldn't otherwise surface on submit — spec §5.2).
                onChanged: (String value) => setState(() {
                  _passwordError =
                      value.isNotEmpty && !PasswordPolicy.isValid(value)
                      ? l10n.validationPasswordPolicy
                      : null;
                }),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _confirm,
                label: l10n.confirmPasswordLabel,
                obscure: true,
                showToggle: true,
                showLabel: l10n.showPassword,
                hideLabel: l10n.hidePassword,
                textInputAction: TextInputAction.done,
                errorText: _confirmError,
                enabled: !_submitting,
                onSubmitted: (_) => _submit(l10n),
              ),
              const SizedBox(height: 24),
              AgreementChecklist(
                selection: _agreements,
                onChanged: (AgreementSelection next) =>
                    setState(() => _agreements = next),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: enabled ? () => _submit(l10n) : null,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.signUpButton),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(l10n.haveAccountPrompt),
                  TextButton(
                    onPressed: _submitting ? null : () => context.pop(),
                    child: Text(l10n.goToLogin),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
