import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 내가 쓴 글 목록(SPEC-0011 R3).
///
/// **서버 계약이 아직 없다.** `myPosts` 쿼리가 라이브 스키마에 없어
/// (2026-08-07 introspection 기준) 지금은 빈 상태만 그린다. 계약이 붙으면
/// `common/pagination/`의 `PaginationListView`로 목록을 채우고, 커뮤니티의 기존
/// `Post` 도메인 모델을 재사용한다 — 마이페이지용 모델을 따로 만들지 않는다
/// (설계 §10, `docs/design/SPEC-0011-settings-mypage.md` §7).
class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  static String get routeName => 'settings-my-posts';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPostsTitle)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.myPostsEmpty,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
