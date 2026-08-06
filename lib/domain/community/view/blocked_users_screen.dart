import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/blocked_user.dart';
import '../provider/blocked_users_providers.dart';
import '../provider/moderation_providers.dart';

/// 차단한 사용자 목록(가이드 §6).
///
/// **내가 건 차단만 나온다.** 나를 차단한 사람은 여기 없다 — 남이 건 차단은 내가
/// 풀 수 없기 때문이다. "글이 안 보이는데 목록에 없다"는 문의로 이어지므로 화면
/// 상단에 그 사실을 적어 둔다.
class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  static String get routeName => 'blocked-users';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<BlockedUsersState> state = ref.watch(
      blockedUsersControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.communityBlockedUsersTitle)),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _Notice(
            text: l10n.communityFeedUnavailable,
            onRetry: () => ref.invalidate(blockedUsersControllerProvider),
            retryLabel: l10n.communityRetry,
          ),
          data: (BlockedUsersState data) => Column(
            children: <Widget>[
              _Note(text: l10n.communityBlockedUsersNote),
              Expanded(
                child: data.isEmpty
                    ? Center(child: Text(l10n.communityBlockedUsersEmpty))
                    : _List(data: data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.data});

  final BlockedUsersState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return PaginationListView(
      itemCount: data.items.length,
      hasMore: data.hasMore,
      isLoadingMore: data.isLoadingMore,
      onLoadMore: () =>
          ref.read(blockedUsersControllerProvider.notifier).loadMore(),
      // 피드와 같은 규약 — 공용 `common/pagination`의 선택 인자다(CLAUDE.md §4).
      // 다른 기기에서 차단을 풀었을 때 목록을 맞출 수단이 필요하고, 새 값을
      // await해야 데이터가 올 때까지 스피너가 돈다.
      onRefresh: () async {
        ref.invalidate(blockedUsersControllerProvider);
        await ref
            .read(blockedUsersControllerProvider.future)
            .catchError((Object _) => data);
      },
      itemBuilder: (BuildContext context, int index) {
        final BlockedUser blocked = data.items[index];
        final String? avatar = blocked.member.profileImageUrl;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            foregroundImage: avatar == null ? null : NetworkImage(avatar),
            child: Text(
              blocked.member.nickname.isEmpty
                  ? '?'
                  : blocked.member.nickname.characters.first,
            ),
          ),
          title: Text(blocked.member.nickname),
          trailing: TextButton(
            onPressed: () => _unblock(context, ref, blocked),
            child: Text(l10n.communityUnblockAction),
          ),
        );
      },
    );
  }

  /// 차단을 푼다. 멱등이라 이미 풀린 상태에서 눌러도 성공이다(가이드 §7).
  /// 성공하면 목록을 다시 받는다 — 로컬에서 지우면 서버 상태와 어긋날 수 있다.
  Future<void> _unblock(
    BuildContext context,
    WidgetRef ref,
    BlockedUser blocked,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ModerationOutcome outcome = await ref
        .read(moderationControllerProvider.notifier)
        .unblock(blocked.member.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          outcome == ModerationOutcome.success
              ? l10n.communityUnblockDone
              : l10n.communityActionFailed,
        ),
      ),
    );
    if (outcome == ModerationOutcome.success) {
      ref.invalidate(blockedUsersControllerProvider);
    }
  }
}

/// "내가 건 차단만 보인다"는 안내. 목록이 비어 있을 때도 보여야 하므로 목록 밖에
/// 둔다.
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
