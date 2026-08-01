import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/agreement_checklist.dart';
import '../component/auth_failure_message.dart';
import '../component/auth_text_field.dart';
import '../model/password_policy.dart';
import '../model/sns_credential.dart';
import '../model/sns_registration_result.dart';
import '../model/terms_code.dart';
import '../provider/auth_controller.dart';
import 'email_verification_screen.dart';
import 'login_screen.dart';

/// SNS sign-up (spec §5.2). Entered after a successful SNS authentication with
/// the [SnsCredential] in hand — this screen does NOT re-run provider login.
/// Collects a required email (prefilled from the provider, editable) plus the
/// inline agreements/age checklist; there is no password (SNS accounts have
/// none). On success the server issues no tokens (§4), so:
///   - emailVerified → login screen (email prefilled),
///   - not verified  → email-verification screen with the handle.
class SnsSignUpScreen extends ConsumerStatefulWidget {
  const SnsSignUpScreen({super.key, required this.credential});

  static String get routeName => 'snsSignUp';

  final SnsCredential credential;

  @override
  ConsumerState<SnsSignUpScreen> createState() => _SnsSignUpScreenState();
}

class _SnsSignUpScreenState extends ConsumerState<SnsSignUpScreen> {
  late final TextEditingController _email = TextEditingController(
    text: widget.credential.email ?? '',
  );

  AgreementSelection _agreements = const AgreementSelection();

  String? _emailError;
  String? _serverError;
  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  /// Submit is gated on required consent only — the email is validated on
  /// submit (it's prefilled and editable, spec §5.2).
  bool get _canSubmit => _agreements.requiredSatisfied;

  bool _validate(AppLocalizations l10n) {
    final String email = _email.text.trim();
    setState(() {
      _emailError = email.isEmpty
          ? l10n.validationEmailRequired
          : (!EmailFormat.isValid(email) ? l10n.validationEmailInvalid : null);
    });
    return _emailError == null;
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
      final SnsRegistrationResult result = await ref
          .read(authControllerProvider.notifier)
          .signUpSns(
            credential: widget.credential,
            email: email,
            ageVerified: _agreements.ageVerified,
            agreements: _buildAgreements(),
          );
      if (!mounted) return;
      if (result.needsVerification) {
        // Email edited or provider-unverified → verify with a code (§4).
        context.pushNamed(
          EmailVerificationScreen.routeName,
          extra: EmailVerificationArgs(
            verificationId: result.verificationId!,
            email: email,
          ),
        );
      } else {
        // Already verified → straight to login with the email prefilled.
        context.goNamed(LoginScreen.routeName, extra: email);
      }
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
    final bool enabled = !_submitting && _canSubmit;
    final bool providerGaveNoEmail = (widget.credential.email ?? '').isEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.snsSignUpTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 8),
              Text(
                l10n.snsSignUpSubtitle,
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
                enabled: !_submitting,
              ),
              if (providerGaveNoEmail)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    l10n.snsEmailPrefillHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
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
                    : Text(l10n.snsSignUpButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
