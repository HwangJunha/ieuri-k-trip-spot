import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/pagination/pagination_list_view.dart';
import '../../../common/widget/failure_notice.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/conversation_tile.dart';
import '../model/conversation.dart';
import '../provider/conversation_list_providers.dart';
import 'conversation_screen.dart';

/// 대화 목록(R8) — DM 재진입의 착지점.
///
/// 스크롤·추가 로딩은 공용 [PaginationListView]가 담당한다(CLAUDE.md §4). 대화
/// **화면**은 위로 스크롤할 때 과거를 받아 방향이 반대라 이 위젯을 쓸 수 없지만,
/// 목록은 방향이 같아 그대로 재사용한다.
class ConversationListScreen extends ConsumerWidget {
  const ConversationListScreen({super.key});

  static String get routeName => 'conversations';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<ConversationListState> state = ref.watch(
      conversationListControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dmConversationsTitle)),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, _) => FailureNotice.retryable(
            title: l10n.dmConversationsUnavailable,
            body: l10n.feedUnavailableBody,
            actionLabel: l10n.feedRetry,
            onAction: () => ref.invalidate(conversationListControllerProvider),
          ),
          data: (ConversationListState data) => data.isEmpty
              ? const _ConversationsEmpty()
              : _ConversationList(data: data),
        ),
      ),
    );
  }
}

class _ConversationList extends ConsumerWidget {
  const _ConversationList({required this.data});

  final ConversationListState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 행마다 now를 읽으면 목록 안에서 상대 시각 기준이 어긋난다.
    final DateTime now = DateTime.now().toUtc();
    return PaginationListView(
      itemCount: data.items.length,
      hasMore: data.hasMore,
      isLoadingMore: data.isLoadingMore,
      onLoadMore: () =>
          ref.read(conversationListControllerProvider.notifier).loadMore(),
      // 대화를 다녀오면 미읽음·마지막 메시지가 달라진다 — 당겨서 새로고침이 그
      // 갱신 수단이다. 새 값을 await해야 도착할 때까지 스피너가 돈다.
      onRefresh: () async {
        ref.invalidate(conversationListControllerProvider);
        await ref
            .read(conversationListControllerProvider.future)
            .catchError((Object _) => data);
      },
      itemBuilder: (BuildContext context, int index) {
        final Conversation conversation = data.items[index];
        return Column(
          children: <Widget>[
            if (index > 0) const Divider(height: 1, thickness: 0.5),
            ConversationTile(
              conversation: conversation,
              now: now,
              // 라우트에는 conversationId만 넘긴다(CLAUDE.md §6).
              onTap: () async {
                await context.pushNamed(
                  ConversationScreen.routeName,
                  pathParameters: <String, String>{'id': conversation.id},
                );
                // 돌아오면 읽음 처리로 배지가 달라졌다 — 목록을 다시 받는다.
                ref.invalidate(conversationListControllerProvider);
              },
            ),
          ],
        );
      },
    );
  }
}

/// 대화가 하나도 없을 때. **오류가 아니다** — 재시도 버튼을 두지 않고, 어디서
/// 대화를 시작하는지 알려주는 것이 이 화면의 유일한 일이다.
class _ConversationsEmpty extends StatelessWidget {
  const _ConversationsEmpty();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.forum_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.dmConversationsEmptyTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.dmConversationsEmptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
