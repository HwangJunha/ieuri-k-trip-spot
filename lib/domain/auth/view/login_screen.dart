import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../../router/app_router.dart';
import '../component/auth_failure_message.dart';
import '../component/auth_text_field.dart';
import '../model/auth_state.dart';
import '../model/password_policy.dart';
import '../provider/auth_controller.dart';

/// Email/password login (spec §5.1). Shows inline validation before submit,
/// a server-error banner from `userErrors`, and a loading state on the button.
/// An email passed via `extra` (from the sign-up flow) is prefilled.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.prefilledEmail});

  final String? prefilledEmail;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _email = TextEditingController(
    text: widget.prefilledEmail,
  );
  final TextEditingController _password = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations l10n) {
    final String email = _email.text.trim();
    final String password = _password.text;
    setState(() {
      _emailError = email.isEmpty
          ? l10n.validationEmailRequired
          : (!EmailFormat.isValid(email) ? l10n.validationEmailInvalid : null);
      _passwordError = password.isEmpty
          ? l10n.validationPasswordRequired
          : null;
    });
    return _emailError == null && _passwordError == null;
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_validate(l10n)) return;
    await ref
        .read(authControllerProvider.notifier)
        .signIn(email: _email.text.trim(), password: _password.text);
    // On success the router redirect handles navigation via refreshListenable.
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<AuthState> auth = ref.watch(authControllerProvider);
    final bool loading = auth.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 32),
              Text(l10n.loginTitle, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                l10n.loginSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              if (auth.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    authFailureMessage(l10n, auth.error!),
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
                enabled: !loading,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _password,
                label: l10n.passwordLabel,
                obscure: true,
                showToggle: true,
                showLabel: l10n.showPassword,
                hideLabel: l10n.hidePassword,
                textInputAction: TextInputAction.done,
                errorText: _passwordError,
                enabled: !loading,
                onSubmitted: (_) => _submit(l10n),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: loading
                      ? null
                      : () => context.push(Routes.passwordReset),
                  child: Text(l10n.forgotPassword),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: loading ? null : () => _submit(l10n),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.loginButton),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(l10n.noAccountPrompt),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () => context.push(Routes.signUp),
                    child: Text(l10n.goToSignUp),
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
