import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/auth_failure_message.dart';
import '../component/auth_text_field.dart';
import '../component/verification_code_field.dart';
import '../model/auth_failure.dart';
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
      // **자격이 없으면 2단계로 넘기지 않는다.** 코드 입력칸을 보여 주면 사용자는
      // 가입된 계정이라고 믿고 오지 않을 메일을 기다린다 — 미가입자에게 가장
      // 나쁜 결과다. 오류를 이메일 칸에 붙여 1단계에 머무르게 한다.
      //
      // 서버가 (A)로 전환해 이 코드들을 실제로 준다(요청 문서 §8, 라이브 확인) —
      // 미가입은 MEMBER_NOT_FOUND, SNS 회원은 NOT_EMAIL_MEMBER다.
      final bool notEligible =
          error is AuthFailure &&
          (error.kind == AuthFailureKind.memberNotFound ||
              error.kind == AuthFailureKind.notEmailMember);
      setState(() {
        if (notEligible) {
          // 재설정 전용 문구를 쓴다 — `memberNotFound`의 기본 문구는 SNS 로그인
          // 맥락이라 여기서는 엉뚱하게 읽힌다.
          _emailError = l10n.errorPasswordResetNoAccount;
          _serverError = null;
        } else {
          _serverError = authFailureMessage(l10n, error);
        }
      });
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
              // 단계마다 할 일이 다르다 — 안내도 그에 맞춰 바뀌어야 사용자가 지금
              // 무엇을 하는 중인지 안다.
              //
              // **주소는 이 문장 안에 넣는다.** 별도 배너로 빼 봤더니 긴 주소가 두
              // 줄로 깨지고 옆 버튼과 붙어 읽기 어려웠다. 문장에 녹이면 줄바꿈이
              // 자연스럽고, 어디로 갔는지도 읽는 흐름 안에서 확인된다.
              if (_stage == _Stage.request)
                Text(
                  l10n.passwordResetSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                _SentToSentence(
                  email: _email.text.trim(),
                  template: l10n.passwordResetConfirmSubtitleWithEmail(
                    _email.text.trim(),
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
                const SizedBox(height: 8),
                // 주소를 잘못 넣었을 때의 출구. 주요 동작(비밀번호 변경) 아래에
                // 텍스트 링크로 둔다 — 눈에 띄되 주 동선을 흐리지 않는 자리다.
                Center(
                  child: TextButton(
                    key: const Key('password-reset-change-email'),
                    onPressed: _submitting ? null : _backToRequest,
                    child: Text(l10n.passwordResetChangeEmail),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.passwordResetNoCodeHint,
                  key: const Key('password-reset-no-code-hint'),
                  textAlign: TextAlign.center,
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

/// 안내 문장 안에 보낸 주소를 굵게 넣는다.
///
/// 주소를 별도 배너로 빼 봤더니 긴 주소가 두 줄로 깨지고 옆 버튼과 붙어 읽기
/// 어려웠다. 문장에 녹이면 줄바꿈이 자연스럽고 읽는 흐름 안에서 확인된다.
///
/// 문구는 `{email}` 자리표시자를 가진 번역 문자열이라, 그 자리를 기준으로 앞뒤를
/// 잘라 가운데만 강조한다 — 언어마다 주소의 위치가 달라도 동작한다.
class _SentToSentence extends StatelessWidget {
  const _SentToSentence({required this.email, required this.template});

  final String email;

  /// 이미 `{email}`이 치환된 완성 문장.
  final String template;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? base = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final int at = email.isEmpty ? -1 : template.indexOf(email);
    if (at == -1) {
      // 주소를 못 찾으면(빈 값 등) 문장을 그대로 그린다.
      return Text(template, style: base);
    }

    return Text.rich(
      TextSpan(
        style: base,
        children: <InlineSpan>[
          TextSpan(text: template.substring(0, at)),
          TextSpan(
            text: email,
            style: base?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          TextSpan(text: template.substring(at + email.length)),
        ],
      ),
      key: const Key('password-reset-sent-to'),
    );
  }
}
