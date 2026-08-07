import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/localization/locale_controller.dart';
import '../../../common/navigation/settings_routes.dart';
import '../../../common/network/media_cdn.dart';
import '../../../common/storage/app_preferences.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/model/auth_state.dart';
import '../../auth/model/me.dart';
import '../../auth/provider/auth_controller.dart';
import '../component/settings_tile.dart';
import '../../../common/storage/search_radius_controller.dart';
import 'account_deletion_screen.dart';
import 'my_posts_screen.dart';
import 'preferences_screen.dart';
import 'profile_edit_screen.dart';
import 'terms_screen.dart';

/// 설정 홈(SPEC-0011 R1). 홈 화면 우상단에서 진입하며 하위 화면들이 여기 아래로
/// 중첩된다 — 뒤로 가기가 설정 홈을 거쳐 진입 직전 화면으로 돌아간다.
///
/// 셸 밖의 최상위 라우트라 하단 탭을 덮는다(관광지 상세·글 상세와 같은 성격).
///
/// 약관 관리(R9·R10)와 프로필 수정(R4~R6)·내가 쓴 글(R3)은 라이브 스키마에 계약이
/// 붙어(2026-08-08 introspection 기준) 실제 화면으로 이어진다.
///
/// **이메일 변경(R7·R8)만 진입점이 없다** — `requestEmailChange`/`confirmEmailChange`가
/// 스키마에 없고 가입 전용 `verifyEmail`을 돌려 쓸 수 없어 갈 곳이 없다. 눌리지 않는
/// 행을 두면 고장으로 보이므로 아예 두지 않았다
/// (`docs/design/SPEC-0011-settings-mypage.md` §0).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static String get routeName => settingsRouteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 프로필 요약은 이미 세션에 실려 있는 값을 쓴다 — 설정을 열 때마다 `me`를
    // 다시 조회하면 화면 진입이 네트워크에 묶인다.
    final Me? me = ref.watch(
      authControllerProvider.select(
        (AsyncValue<AuthState> s) => s.value?.session?.user,
      ),
    );
    final double radiusKm = ref.watch(searchRadiusControllerProvider);
    final AppLanguage language = ref.watch(
      localeControllerProvider.select(
        (Locale l) =>
            AppLanguage.fromCode(l.languageCode) ?? AppLanguage.english,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _ProfileSummaryTile(
              me: me,
              onTap: () => context.pushNamed(ProfileEditScreen.routeName),
            ),
            const Divider(height: 1),

            SettingsSectionHeader(l10n.settingsSectionActivity),
            SettingsTile(
              icon: Icons.article_outlined,
              title: l10n.settingsMyPosts,
              onTap: () => context.pushNamed(MyPostsScreen.routeName),
            ),
            // 찜한 장소는 **하단 탭(셸 브랜치)이라 push하면 안 된다.** 셸이 이미
            // 그 라우트의 페이지 키를 잡고 있어서, 루트 내비게이터에 같은 것을
            // 얹으면 `!keyReservation.contains(key)` assertion으로 앱이 빨간
            // 화면이 된다(실제로 그렇게 터졌다).
            //
            // 탭으로 **전환**한다 — `go`는 스택을 쌓지 않고 셸의 해당 브랜치를
            // 보여준다. 설정은 셸 밖이라 뒤로 가기가 아니라 탭 이동이 맞다.
            SettingsTile(
              icon: Icons.favorite_border,
              title: l10n.settingsLikedSpots,
              onTap: () => context.goNamed(likedSpotsRouteName),
            ),

            SettingsSectionHeader(l10n.settingsSectionAccount),
            // 프로필 수정(R4~R6). 맨 위 프로필 요약과 **같은 목적지**다 — 목업이
            // 둘 다 두었고, 요약을 못 알아본 사용자에게 이름 붙은 행이 남는다.
            //
            // **"Change Email" 행은 없다**(R7·R8). 라이브 스키마(2026-08-08)에
            // `requestEmailChange`/`confirmEmailChange`가 없어 갈 곳이 없다 —
            // 눌리지 않는 행을 두면 고장으로 보인다.
            SettingsTile(
              icon: Icons.person_outline,
              title: l10n.settingsEditProfile,
              onTap: () => context.pushNamed(ProfileEditScreen.routeName),
            ),
            // 차단 목록의 진입점만 커뮤니티에서 여기로 옮긴다(R2). 화면 자체는
            // `community`에 그대로 둔다 — 옮기면 커뮤니티 리포지토리 의존이
            // `settings`로 끌려 들어온다(설계 §1).
            SettingsTile(
              icon: Icons.block,
              title: l10n.settingsBlockedUsers,
              onTap: () => context.pushNamed(blockedUsersRouteName),
            ),

            SettingsSectionHeader(l10n.settingsSectionPreferences),
            SettingsTile(
              icon: Icons.my_location,
              title: l10n.settingsSearchRadius,
              value: l10n.preferencesRadiusValue(
                AppPreferences.formatKm(radiusKm),
              ),
              onTap: () => context.pushNamed(PreferencesScreen.routeName),
            ),
            SettingsTile(
              icon: Icons.language,
              title: l10n.settingsLanguage,
              value: language.nativeName,
              onTap: () => context.pushNamed(PreferencesScreen.routeName),
            ),

            SettingsSectionHeader(l10n.settingsSectionLegal),
            SettingsTile(
              icon: Icons.assignment_outlined,
              title: l10n.settingsTerms,
              onTap: () => context.pushNamed(TermsScreen.routeName),
            ),

            const SizedBox(height: 24),
            const Divider(height: 1),
            // 로그아웃은 기존 `LogoutButton`의 로직을 그대로 쓴다(R15) — 서버 호출이
            // 실패해도 로컬 토큰을 지우고 로그인 화면으로 보낸다. 이동은 라우터
            // 리다이렉트가 하므로 여기서 직접 내비게이션하지 않는다.
            SettingsTile(
              icon: Icons.logout,
              title: l10n.settingsLogOut,
              showChevron: false,
              onTap: () => ref.read(authControllerProvider.notifier).signOut(),
            ),
            SettingsTile(
              icon: null,
              title: l10n.settingsDeleteAccount,
              destructive: true,
              showChevron: false,
              onTap: () => context.pushNamed(AccountDeletionScreen.routeName),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// 설정 홈 맨 위의 프로필 요약. 탭하면 프로필 수정으로 간다(R4).
class _ProfileSummaryTile extends StatelessWidget {
  const _ProfileSummaryTile({required this.me, required this.onTap});

  final Me? me;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // 서버 값은 키일 수 있어 그대로 NetworkImage에 넘기면 페인트 중에 터진다.
    final String? imageUrl = MediaCdn.profileImage(me?.profileImageUrl);

    return ListTile(
      onTap: onTap,
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // `foregroundImage`를 쓴다 — 이미지가 실패해도 아래의 [child]가 남아 아바타
      // 자리가 비지 않는다. `backgroundImage`는 실패하면 그릴 것이 없다.
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        foregroundImage: imageUrl == null ? null : NetworkImage(imageUrl),
        child: Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant),
      ),
      title: Text(
        me?.nickname ?? '',
        style: theme.textTheme.titleMedium,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        me?.email ?? '',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
