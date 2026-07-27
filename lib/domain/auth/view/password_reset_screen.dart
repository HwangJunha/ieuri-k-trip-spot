import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../../router/app_router.dart';
import '../component/auth_failure_message.dart';
import '../component/auth_text_field.dart';
import '../model/password_policy.dart';
import '../provider/auth_controller.dart';

/// Code-based two-stage password reset (spec §5.4):
/// 1. Enter the account email → `requestPasswordReset` sends a code.
/// 2. Enter email + code + new password → `resetPassword` completes it.
class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

enum _Stage { request, confirm }

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _code = TextEditingController();
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
    _code.dispose();
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
    final String code = _code.text.trim();
    final String newPassword = _newPassword.text;
    setState(() {
      _codeError = code.isEmpty ? l10n.validationCodeRequired : null;
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
      context.go(Routes.login, extra: _email.text.trim());
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _serverError = authFailureMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
                l10n.passwordResetSubtitle,
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
                textInputAction: TextInputAction.done,
                errorText: _emailError,
                // Lock the email once a code has been sent for it.
                enabled: !_submitting && _stage == _Stage.request,
                onSubmitted: (_) => _requestCode(l10n),
              ),
              if (_stage == _Stage.confirm) ...<Widget>[
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _code,
                  label: l10n.verificationCodeLabel,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  errorText: _codeError,
                  enabled: !_submitting,
                ),
                const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
    );
  }
}
