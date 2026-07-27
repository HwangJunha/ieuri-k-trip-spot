import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../../router/app_router.dart';
import '../component/auth_failure_message.dart';
import '../component/auth_text_field.dart';
import '../provider/auth_controller.dart';

/// Email verification (spec §5.3): the mandatory step after sign-up. Enters the
/// emailed code and calls `verifyEmail`; on success routes to login with the
/// email prefilled. A resend button requests a fresh code.
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({
    super.key,
    required this.verificationId,
    required this.email,
  });

  final String verificationId;
  final String email;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final TextEditingController _code = TextEditingController();
  late String _verificationId = widget.verificationId;
  String? _codeError;
  String? _serverError;
  bool _submitting = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify(AppLocalizations l10n) async {
    final String code = _code.text.trim();
    setState(() {
      _codeError = code.isEmpty ? l10n.validationCodeRequired : null;
      _serverError = null;
    });
    if (_codeError != null) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .verifyEmail(verificationId: _verificationId, code: code);
      if (!mounted) return;
      // Verified — go to login with the email prefilled (spec §5.3).
      context.go(Routes.login, extra: widget.email);
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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

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
                controller: _code,
                label: l10n.verificationCodeLabel,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                errorText: _codeError,
                enabled: !_submitting,
                onSubmitted: (_) => _verify(l10n),
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
              const SizedBox(height: 8),
              TextButton(
                onPressed: _submitting ? null : () => _resend(l10n),
                child: Text(l10n.emailVerificationResend),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
