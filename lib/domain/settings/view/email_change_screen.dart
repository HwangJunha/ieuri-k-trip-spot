import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/settings_routes.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/model/auth_state.dart';
import '../../../common/model/email_format.dart';
import '../../auth/provider/auth_controller.dart';
import '../component/email_change_pending_banner.dart';
import '../component/resend_countdown_button.dart';
import '../model/email_change_failure_reason.dart';
import '../model/settings_failure.dart';
import '../provider/email_change_controller.dart';

/// 이메일 변경(SPEC-0011 R7·R8, 디자인 §4).
///
/// ```
/// 1) Change Email                    2) Verify Email
/// ┌────────────────────────┐        ┌────────────────────────┐
/// │ Current: alex@...      │        │ ⓘ 인증해야 바뀝니다     │  ← 대기 배너
/// │ New Email Address      │        │ alex.new@... 로 보낸    │
/// │ ┌────────────────────┐ │        │ 코드를 입력하세요        │
/// │ We'll send a 6-digit…  │        │ ⚠ 사유별 안내           │
/// │ [   Send Code   ]      │        │ Resend code in 0:47    │
/// └────────────────────────┘        └────────────────────────┘
/// ```
///
/// **한 화면이 두 단계를 모두 그린다.** 단계를 라우트로 나누면 `verificationId`를
/// route extra로 넘겨야 하고, 뒤로 가기로 돌아온 주소 화면이 죽은 검증 건을 들고
/// 있게 된다. 전이는 controller 상태가 쥔다.
///
/// **가입 검증 화면(`EmailVerificationScreen`)과 형태는 같지만 호출부가 다르다** —
/// 가입 전용인 `verifyEmail`을 돌려 쓰면 가입 흐름의 상태 기계가 여기 끌려온다
/// (디자인 §4).
class EmailChangeScreen extends ConsumerStatefulWidget {
  const EmailChangeScreen({super.key});

  static String get routeName => emailChangeRouteName;

  @override
  ConsumerState<EmailChangeScreen> createState() => _EmailChangeScreenState();
}

class _EmailChangeScreenState extends ConsumerState<EmailChangeScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _code = TextEditingController();

  /// 클라이언트가 판정하는 형식 오류. 서버 판정과 섞지 않는다 — 사용자가 무엇을
  /// 고쳐야 할지 알아야 한다.
  String? _emailFormatError;
  String? _codeFormatError;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final EmailChangeState change = ref.watch(emailChangeControllerProvider);

    // 성공·재발송은 화면에 남기지 않고 스낵바로 알린다.
    ref.listen<EmailChangeState>(emailChangeControllerProvider, (
      EmailChangeState? previous,
      EmailChangeState next,
    ) {
      if (next.step == EmailChangeStep.done &&
          previous?.step != EmailChangeStep.done) {
        // 스낵바를 **pop 전에** 상위 messenger로 띄운다. `context`를 pop 뒤에
        // 쓰면 이미 사라진 라우트의 것을 붙잡게 된다 — 먼저 잡아 두면 화면이
        // 닫혀도 안내가 남는다.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.emailChangeSucceeded)));
        // 변경이 끝났으니 **프로필 수정 화면으로 보낸다** — 거기 이메일이 새 값으로
        // 갱신돼 있다(controller가 `refreshMe`를 이미 마쳤다).
        //
        // `pop()`이 아니라 목적지를 지정하는 이유: pop은 "바로 아래 화면"으로만
        // 돌아가므로, 프로필을 거치지 않고 이 화면에 들어온 경로가 생기면 엉뚱한
        // 곳에 떨어진다. 갈 곳이 정해져 있으면 그곳을 이름으로 말하는 편이 낫다.
        if (context.mounted) context.goNamed(profileEditRouteName);
      } else if (next.resent && !(previous?.resent ?? false)) {
        _showSnack(l10n.emailChangeResent);
      }
      // 시도 초과로 주소 단계로 되돌아왔으면 옛 코드를 비운다.
      //
      // **형식 오류도 함께 지운다.** 코드를 비우면서 오류만 남기면, 새 코드를 받아
      // 다시 들어왔을 때 아무것도 입력하지 않은 빈 칸에 지난 오류가 붙어 있다.
      if (previous?.step == EmailChangeStep.code &&
          next.step == EmailChangeStep.address) {
        _code.clear();
        if (_codeFormatError != null) {
          setState(() => _codeFormatError = null);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          change.step == EmailChangeStep.code
              ? l10n.emailChangeVerifyTitle
              : l10n.emailChangeTitle,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: change.step == EmailChangeStep.code
              ? _codeStep(l10n, change)
              : _addressStep(l10n, change),
        ),
      ),
    );
  }

  // --- 1단계: 새 주소 -------------------------------------------------------

  List<Widget> _addressStep(AppLocalizations l10n, EmailChangeState change) {
    final ThemeData theme = Theme.of(context);
    final String? currentEmail = ref.watch(
      authControllerProvider.select(
        (AsyncValue<AuthState> s) => s.value?.session?.user?.email,
      ),
    );

    return <Widget>[
      // 시도 초과로 여기까지 되돌아왔을 수 있다 — 왜 처음부터인지 남겨 둔다.
      if (change.reason != null) ...<Widget>[
        _errorText(theme, _reasonMessage(l10n, change.reason!)),
        const SizedBox(height: 16),
      ],
      if (change.failure != null) ...<Widget>[
        _errorText(theme, _requestFailureMessage(l10n, change.failure!)),
        const SizedBox(height: 16),
      ],
      Text(l10n.emailChangeCurrentLabel, style: theme.textTheme.labelLarge),
      const SizedBox(height: 4),
      Text(currentEmail ?? '', style: theme.textTheme.bodyLarge),
      const SizedBox(height: 24),
      TextField(
        key: const Key('email-change-new-field'),
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        enabled: !change.busy,
        decoration: InputDecoration(
          labelText: l10n.emailChangeNewLabel,
          border: const OutlineInputBorder(),
          errorText: _emailFormatError,
        ),
        onChanged: (_) {
          if (_emailFormatError == null && change.failure == null) return;
          setState(() => _emailFormatError = null);
          ref.read(emailChangeControllerProvider.notifier).clearErrors();
        },
        onSubmitted: (_) => _submitAddress(l10n, currentEmail),
      ),
      const SizedBox(height: 8),
      Text(
        l10n.emailChangeHint,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 24),
      FilledButton(
        key: const Key('email-change-send-button'),
        onPressed: change.busy
            ? null
            : () => _submitAddress(l10n, currentEmail),
        child: change.busy
            ? const _ButtonSpinner()
            : Text(l10n.emailChangeSendCode),
      ),
    ];
  }

  void _submitAddress(AppLocalizations l10n, String? currentEmail) {
    final String email = _email.text.trim();
    // 형식과 "현재 주소와 같음"은 서버를 부르기 전에 거른다 — 왕복해도 답이 같다.
    final String? error = email.isEmpty
        ? l10n.validationEmailRequired
        : (!EmailFormat.isValid(email)
              ? l10n.validationEmailInvalid
              : (email.toLowerCase() == currentEmail?.toLowerCase()
                    ? l10n.emailChangeSameAsCurrent
                    : null));
    setState(() => _emailFormatError = error);
    if (error != null) return;

    ref.read(emailChangeControllerProvider.notifier).requestChange(email);
  }

  // --- 2단계: 코드 ----------------------------------------------------------

  List<Widget> _codeStep(AppLocalizations l10n, EmailChangeState change) {
    final ThemeData theme = Theme.of(context);

    return <Widget>[
      // **검증 전까지 프로필 이메일은 옛 값이다**(R7 첫 기준). 이 배너가 없으면
      // 사용자가 실패로 오해한다.
      EmailChangePendingBanner(message: l10n.emailChangePendingBanner),
      const SizedBox(height: 24),
      Text(
        l10n.emailChangeCodeSentTo(change.pendingEmail ?? ''),
        style: theme.textTheme.bodyMedium,
      ),
      const SizedBox(height: 24),
      // 사유별로 다른 문구를 보여준다 — 셋을 묶으면 다음 행동을 모른다(디자인 §4).
      if (change.reason != null) ...<Widget>[
        _errorText(theme, _reasonMessage(l10n, change.reason!)),
        const SizedBox(height: 16),
      ],
      if (change.failure != null) ...<Widget>[
        _errorText(theme, _confirmFailureMessage(l10n, change.failure!)),
        const SizedBox(height: 16),
      ],
      TextField(
        key: const Key('email-change-code-field'),
        controller: _code,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        enabled: !change.busy,
        decoration: InputDecoration(
          labelText: l10n.emailChangeCodeLabel,
          border: const OutlineInputBorder(),
          errorText: _codeFormatError,
        ),
        onChanged: (_) {
          if (_codeFormatError == null &&
              change.reason == null &&
              change.failure == null) {
            return;
          }
          setState(() => _codeFormatError = null);
          ref.read(emailChangeControllerProvider.notifier).clearErrors();
        },
        onSubmitted: (_) => _submitCode(l10n),
      ),
      const SizedBox(height: 24),
      FilledButton(
        key: const Key('email-change-verify-button'),
        onPressed: change.busy ? null : () => _submitCode(l10n),
        child: change.busy
            ? const _ButtonSpinner()
            : Text(l10n.emailChangeVerifyButton),
      ),
      const SizedBox(height: 8),
      // 60초 쿨다운을 **미리 막고** 남은 시간을 카운트다운으로 보여준다(디자인 §4).
      ResendCountdownButton(
        key: const Key('email-change-resend-button'),
        cooldownUntil: change.resendCooldownUntil,
        label: l10n.emailChangeResend,
        countdownLabel: l10n.emailChangeResendIn,
        enabled: !change.busy,
        onResend: () =>
            ref.read(emailChangeControllerProvider.notifier).resend(),
      ),
    ];
  }

  void _submitCode(AppLocalizations l10n) {
    final String code = _code.text.trim();
    setState(
      () =>
          _codeFormatError = code.isEmpty ? l10n.emailChangeCodeRequired : null,
    );
    if (_codeFormatError != null) return;

    ref.read(emailChangeControllerProvider.notifier).confirm(code);
  }

  // --- 문구 -----------------------------------------------------------------

  /// `failureReason`별 안내(R8, 디자인 §4의 표). **묶지 않는다** — 재입력·재발송·
  /// 처음부터로 다음 행동이 서로 다르다.
  String _reasonMessage(AppLocalizations l10n, EmailChangeFailureReason r) =>
      switch (r) {
        EmailChangeFailureReason.codeMismatch => l10n.emailChangeCodeMismatch,
        EmailChangeFailureReason.expired => l10n.emailChangeCodeExpired,
        EmailChangeFailureReason.maxAttemptsExceeded =>
          l10n.emailChangeMaxAttempts,
        // 서버가 새 사유를 추가해도 화면은 깨지지 않는다.
        EmailChangeFailureReason.unknown => l10n.emailChangeVerifyFailed,
      };

  /// 1단계(발송 요청)의 실패 문구.
  String _requestFailureMessage(AppLocalizations l10n, SettingsFailure f) =>
      f.code == emailAlreadyInUseCode
      ? l10n.emailChangeEmailTaken
      : l10n.emailChangeFailed;

  /// 2단계·재발송의 실패 문구. 쿨다운만 따로 안내한다 — 클라이언트 차단을 뚫고 온
  /// 경우라 "다시 시도"보다 "잠시 후"가 맞다.
  String _confirmFailureMessage(AppLocalizations l10n, SettingsFailure f) =>
      f.code == resendCooldownActiveCode
      ? l10n.emailChangeResendCooldown
      : l10n.emailChangeVerifyFailed;

  Widget _errorText(ThemeData theme, String message) => Text(
    message,
    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
  );

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 버튼 안의 진행 표시. 두 단계가 같은 모양을 쓴다.
class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(strokeWidth: 2),
  );
}
