import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/model/post.dart';
import '../../../common/navigation/settings_routes.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/my_post_row.dart';
import '../provider/my_posts_controller.dart';

/// 내가 쓴 글 목록(SPEC-0011 R3, 디자인 §7).
///
/// **페이지네이션은 `common/pagination/`의 [PaginationListView]를 쓴다** — 기능이
/// 자기 페이지네이션을 만들지 않는다(CLAUDE.md §4).
///
/// 커뮤니티의 기존 [Post] 도메인 모델을 재사용한다 — `myPosts`가 같은
/// `PostConnection`을 주므로 마이페이지용 모델을 따로 만들지 않는다(설계 §10).
/// 그 모델은 두 기능이 함께 쓰게 되면서 `common/model/`로 올라와 있다(§4).
class MyPostsScreen extends ConsumerWidget {
  const MyPostsScreen({super.key});

  static String get routeName => myPostsRouteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<MyPostsState> posts = ref.watch(myPostsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPostsTitle)),
      body: SafeArea(
        child: posts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, _) => _Failure(
            message: l10n.myPostsFailed,
            retryLabel: l10n.myPostsRetry,
            onRetry: () => ref.invalidate(myPostsControllerProvider),
          ),
          data: (MyPostsState state) => state.isEmpty
              ? const _Empty()
              : _List(state: state, now: DateTime.now().toUtc()),
        ),
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.state, required this.now});

  final MyPostsState state;

  /// 상대 시각 계산 기준. 한 번 계산해 모든 행이 같은 기준을 쓴다 — 행마다 `now()`를
  /// 부르면 같은 프레임 안에서도 기준이 미세하게 어긋난다.
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyPostsController controller = ref.read(
      myPostsControllerProvider.notifier,
    );
    return PaginationListView(
      itemCount: state.items.length,
      hasMore: state.hasMore,
      isLoadingMore: state.isLoadingMore,
      onLoadMore: controller.loadMore,
      onRefresh: controller.refresh,
      itemBuilder: (BuildContext context, int index) {
        final Post post = state.items[index];
        return Column(
          children: <Widget>[
            MyPostRow(
              post: post,
              now: now,
              // 글 상세는 셸 밖의 최상위 라우트라 하단 탭을 덮는다. **id만 넘긴다**
              // (CLAUDE.md §6) — 상세가 그 id로 다시 조회한다.
              onTap: () => context.pushNamed(
                postDetailRouteName,
                pathParameters: <String, String>{'id': post.id},
              ),
            ),
            // 납작한 행 + 얇은 구분선(디자인 §7). 카드 그림자를 쓰지 않는다.
            const Divider(height: 1, indent: 16, endIndent: 16),
          ],
        );
      },
    );
  }
}

/// 빈 상태(디자인 §7). 가운데 muted 아이콘 + 안내 + "첫 글 쓰기".
class _Empty extends ConsumerWidget {
  const _Empty();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Center(
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
            const SizedBox(height: 16),
            FilledButton(
              // **등록하고 돌아오면 목록을 다시 받는다.** 컴포저는 성공 시
              // `pop(true)`만 하므로(그쪽 설계), 여기서 결과를 받아 invalidate
              // 하지 않으면 "글을 등록했어요" 토스트가 뜬 채로 빈 목록이 남는다.
              onPressed: () async {
                final bool? created = await context.pushNamed<bool>(
                  postComposerRouteName,
                );
                if (created ?? false) {
                  ref.invalidate(myPostsControllerProvider);
                }
              },
              child: Text(l10n.myPostsWriteFirst),
            ),
          ],
        ),
      ),
    );
  }
}

/// 조회 실패. **다시 시도를 준다** — 재시도 정책이 이미 1회 돌고 난 뒤라, 여기서
/// 버튼 없이 오류만 보여주면 사용자가 화면을 나갔다 들어와야 한다.
class _Failure extends StatelessWidget {
  const _Failure({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}
