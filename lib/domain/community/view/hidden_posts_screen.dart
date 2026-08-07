import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/community_labels.dart';
import '../../../common/model/post.dart';
import '../provider/hidden_posts_providers.dart';
import '../provider/moderation_providers.dart';

/// 내가 숨긴 글 목록(2차 가이드 §2) — 해제하는 유일한 경로다.
///
/// **차단 목록과 나란한 화면이지만 축이 다르다**: 차단은 사람 단위 양방향이고,
/// 이건 글 하나를 **내 화면에서만** 감춘 것이다. 남에게는 그대로 보이므로 그 사실을
/// 상단에 적어 둔다 — 신고나 삭제로 오해하면 쓰지 않게 된다.
///
/// **숨긴 글은 그 밖의 모든 조회에서 빠진다**(피드도, 단건 조회도 null). 그래서 이
/// 목록 자체가 `posts(hiddenByViewer: true)`로 따로 받는다.
class HiddenPostsScreen extends ConsumerWidget {
  const HiddenPostsScreen({super.key});

  static String get routeName => 'hidden-posts';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<HiddenPostsState> state = ref.watch(
      hiddenPostsControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.communityHiddenPostsTitle)),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _Notice(
            text: l10n.communityFeedUnavailable,
            onRetry: () => ref.invalidate(hiddenPostsControllerProvider),
            retryLabel: l10n.communityRetry,
          ),
          data: (HiddenPostsState data) => Column(
            children: <Widget>[
              _Note(text: l10n.communityHiddenPostsNote),
              Expanded(
                child: data.isEmpty
                    ? Center(child: Text(l10n.communityHiddenPostsEmpty))
                    : _List(data: data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 숨긴 글 줄. **카드 전체를 그리지 않는다** — 여기서 할 일은 읽는 것이 아니라
/// 무엇을 숨겼는지 알아보고 되돌리는 것이라, 제목과 시각이면 충분하다.
class _List extends ConsumerWidget {
  const _List({required this.data});

  final HiddenPostsState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 모든 줄이 같은 기준으로 상대 시각을 계산하도록 빌드 1회당 한 번만 읽는다.
    final DateTime now = DateTime.now().toUtc();
    return PaginationListView(
      itemCount: data.items.length,
      hasMore: data.hasMore,
      isLoadingMore: data.isLoadingMore,
      onLoadMore: () =>
          ref.read(hiddenPostsControllerProvider.notifier).loadMore(),
      // 차단 목록과 같은 규약 — 공용 `common/pagination`의 선택 인자다(CLAUDE.md §4).
      onRefresh: () async {
        ref.invalidate(hiddenPostsControllerProvider);
        await ref
            .read(hiddenPostsControllerProvider.future)
            .catchError((Object _) => data);
      },
      itemBuilder: (BuildContext context, int index) {
        final Post post = data.items[index];
        return ListTile(
          title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(relativePostTime(l10n, post.createdAt, now)),
          trailing: TextButton(
            onPressed: () => _unhide(context, ref, post),
            child: Text(l10n.communityUnhideAction),
          ),
        );
      },
    );
  }

  /// 숨김을 푼다. 멱등이고 **삭제된 글에도 동작한다**(2차 가이드 §2) — 그래야 이미
  /// 지워진 글이 목록에 남지 않는다. 성공하면 목록을 다시 받는다: 로컬에서 지우면
  /// 서버 상태와 어긋날 수 있다(차단 해제와 같은 규약).
  Future<void> _unhide(BuildContext context, WidgetRef ref, Post post) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ModerationOutcome outcome = await ref
        .read(moderationControllerProvider.notifier)
        .unhidePost(post.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          outcome == ModerationOutcome.success
              ? l10n.communityUnhideDone
              : l10n.communityActionFailed,
        ),
      ),
    );
    if (outcome == ModerationOutcome.success) {
      ref.invalidate(hiddenPostsControllerProvider);
    }
  }
}

/// "내 화면에서만 숨겨진다"는 안내. 목록이 비어 있을 때도 보여야 하므로 목록 밖에
/// 둔다(차단 목록과 같은 배치).
class _Note extends StatelessWidget {
  const _Note({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({
    required this.text,
    required this.onRetry,
    required this.retryLabel,
  });

  final String text;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(text, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    ),
  );
}
