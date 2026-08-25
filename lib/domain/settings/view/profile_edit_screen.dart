import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/settings_routes.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/model/auth_state.dart';
import '../../auth/model/me.dart';
import '../../auth/provider/auth_controller.dart';
import '../component/profile_avatar_editor.dart';
import '../model/nickname_validation.dart';
import '../provider/profile_edit_controller.dart';
import 'email_change_screen.dart';

/// 프로필 수정(SPEC-0011 R4~R6, 디자인 §3).
///
/// ```
/// ┌──────────────────────────────────────────┐
/// │ ←  Edit Profile                  Save    │  ← 변경 없으면 Save 비활성
/// │              ( ◕ )📷                     │
/// │        Change Photo    Remove            │
/// │ Nickname                                 │
/// │ ┌──────────────────────────────┐  7/20   │
/// │ ⚠ This nickname is already taken.        │  ← 서버 판정
/// │ Email  (읽기 전용)          Change       │  ← 별도 화면으로
/// └──────────────────────────────────────────┘
/// ```
///
/// **이메일은 이 폼의 Save로 저장되지 않는다**(R7·R8). 인증 2단계를 거쳐야 바뀌므로
/// 별도 화면(`EmailChangeScreen`)으로 보낸다 — 닉네임과 같은 Save에 묶으면 "저장했다"는
/// 응답과 "아직 안 바뀌었다"는 사실이 한 화면에서 충돌한다.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  static String get routeName => profileEditRouteName;

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController _nickname;

  /// 진입 시점의 닉네임. Save 활성 판정의 기준이다 — 바뀐 것이 없으면 저장할 것도
  /// 없다(디자인 §3).
  late final String _initialNickname;

  @override
  void initState() {
    super.initState();
    // **세션에 이미 실린 값을 쓴다** — 화면을 열 때마다 `me`를 다시 조회하면 진입이
    // 네트워크에 묶인다.
    _initialNickname =
        ref.read(authControllerProvider).value?.session?.user?.nickname ?? '';
    _nickname = TextEditingController(text: _initialNickname);
  }

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final Me? me = ref.watch(
      authControllerProvider.select(
        (AsyncValue<AuthState> s) => s.value?.session?.user,
      ),
    );
    final ProfileEditState edit = ref.watch(profileEditControllerProvider);

    // 저장 성공·실패는 화면에 남기지 않고 스낵바로 알린 뒤 상태를 비운다 — 남겨 두면
    // 다시 들어왔을 때 지난 결과가 붙어 있다.
    ref.listen<ProfileEditState>(profileEditControllerProvider, (
      ProfileEditState? previous,
      ProfileEditState next,
    ) {
      if (next.saved) {
        _showSnack(l10n.profileEditSaved);
      } else if (next.failure != null) {
        _showSnack(l10n.profileEditFailed);
      }
    });

    final String current = normalizeNickname(_nickname.text);
    final bool dirty = current != _initialNickname && current.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileEditTitle),
        actions: <Widget>[
          TextButton(
            // 변경이 없으면 비활성이다(디자인 §3).
            onPressed: dirty ? _submit : null,
            child: Text(l10n.profileEditSave),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          children: <Widget>[
            ProfileAvatarEditor(profileImageUrl: me?.profileImageUrl),
            const SizedBox(height: 32),
            Text(
              l10n.profileEditNicknameLabel,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nickname,
              maxLength: null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                errorText: _fieldError(l10n, edit),
                counterText: l10n.profileEditNicknameCounter(
                  nicknameLength(_nickname.text),
                  nicknameMaxLength,
                ),
              ),
              onChanged: (_) {
                // 입력이 바뀌면 직전 오류를 지우고 Save 활성 여부를 다시 계산한다.
                ref.read(profileEditControllerProvider.notifier).clearErrors();
                setState(() {});
              },
              onSubmitted: (_) {
                if (dirty) _submit();
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.profileEditEmailLabel, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    // **여기서는 읽기 전용이다** — 이메일은 인증을 거쳐야 바뀌므로
                    // 이 폼의 Save와 같이 저장되지 않는다(R7). 값은 세션의 것이다.
                    key: const Key('profile-email-field'),
                    enabled: false,
                    controller: TextEditingController(text: me?.email ?? ''),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // 이메일 변경 진입점은 서버가 준 capability로 가른다
                // (SPEC-0024 R6). **비활성이 아니라 숨긴다** — 비활성으로 두면
                // 왜 못 쓰는지 설명해야 하고, SNS 계정의 이메일이 provider 소유라는
                // 사실은 설정 화면에서 설명할 만한 내용이 아니다.
                //
                // provider를 받아 앱이 `== EMAIL`을 판정하지 않는다. 규칙에 조건이
                // 붙어도 서버만 고치면 된다.
                if (me?.canChangeEmail ?? false) ...<Widget>[
                  const SizedBox(width: 8),
                  TextButton(
                    key: const Key('profile-email-change-button'),
                    onPressed: () =>
                        context.pushNamed(EmailChangeScreen.routeName),
                    child: Text(l10n.profileEditEmailChange),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() =>
      ref.read(profileEditControllerProvider.notifier).submit(_nickname.text);

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// 입력란 아래 오류. 형식 오류만 여기 붙는다 — 중복은 허용되고(2026-08-25 서버
  /// 변경), 그 밖의 실패는 입력값 문제가 아니라 화면 상단의 일반 오류로 간다(R5).
  String? _fieldError(AppLocalizations l10n, ProfileEditState edit) {
    return switch (edit.formatError) {
      NicknameValidation.empty => l10n.profileEditNicknameEmpty,
      NicknameValidation.tooLong => l10n.profileEditNicknameTooLong(
        nicknameMaxLength,
      ),
      NicknameValidation.ok || null => null,
    };
  }
}
