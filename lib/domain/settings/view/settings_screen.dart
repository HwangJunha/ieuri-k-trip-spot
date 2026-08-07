import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/localization/locale_controller.dart';
import '../../../common/navigation/settings_routes.dart';
import '../../../common/storage/app_preferences.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/model/auth_state.dart';
import '../../auth/model/me.dart';
import '../../auth/provider/auth_controller.dart';
import '../component/settings_tile.dart';
import '../provider/search_radius_controller.dart';
import 'account_deletion_screen.dart';
import 'my_posts_screen.dart';
import 'preferences_screen.dart';

/// 설정 홈(SPEC-0011 R1). 홈 화면 우상단에서 진입하며 하위 화면들이 여기 아래로
/// 중첩된다 — 뒤로 가기가 설정 홈을 거쳐 진입 직전 화면으로 돌아간다.
///
/// 셸 밖의 최상위 라우트라 하단 탭을 덮는다(관광지 상세·글 상세와 같은 성격).
///
/// **서버 계약이 아직 없는 항목이 많다.** 프로필 수정·이메일 변경·약관 관리는
/// `agreements`/닉네임·이미지·이메일 변경 오퍼레이션이 라이브 스키마에 없어
/// (2026-08-07 introspection 기준) 진입점만 두고 목적지는 서버가 붙을 때 잇는다.
/// 자세한 것은 `docs/design/SPEC-0011-settings-mypage.md` §0.
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
            _ProfileSummaryTile(me: me),
            const Divider(height: 1),

            SettingsSectionHeader(l10n.settingsSectionActivity),
            SettingsTile(
              icon: Icons.article_outlined,
              title: l10n.settingsMyPosts,
              onTap: () => context.pushNamed(MyPostsScreen.routeName),
            ),
            SettingsTile(
              icon: Icons.favorite_border,
              title: l10n.settingsLikedSpots,
              onTap: () => context.pushNamed(likedSpotsRouteName),
            ),

            SettingsSectionHeader(l10n.settingsSectionAccount),
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

/// 설정 홈 맨 위의 프로필 요약. 탭하면 프로필 수정으로 간다.
///
/// **프로필 수정 화면은 서버 계약이 없어 아직 없다** — 목적지가 생길 때까지
/// 탭 동작을 두지 않는다(비활성 진입점보다 없는 편이 낫다).
class _ProfileSummaryTile extends StatelessWidget {
  const _ProfileSummaryTile({required this.me});

  final Me? me;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? imageUrl = me?.profileImageUrl;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl),
        child: imageUrl == null
            ? Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant)
            : null,
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
