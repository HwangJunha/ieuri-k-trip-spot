import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widget/failure_notice.dart';
import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../community/component/post_moderation_sheet.dart';
import '../../spot/view/spot_detail_view.dart';
import '../component/feed_action_rail.dart';
import '../component/feed_item_page.dart';
import '../model/feed_item.dart';
import '../provider/conversation_start_providers.dart';
import '../provider/feed_list_providers.dart';
import '../provider/viewer_providers.dart';
import 'conversation_screen.dart';
import 'feed_composer_screen.dart';

/// 피드 전면 스크롤(R4).
///
/// **목록도 그리드도 아니다** — 한 번에 한 건이 화면을 채우는 세로 `PageView`다.
/// 공용 `PaginationListView`를 쓰지 않는 유일한 목록성 화면인데, 저것은 `ListView`
/// 위에서 "바닥에 가까워지면 더 받는다"를 구현하므로 페이지 단위 스냅과 맞지 않는다
/// (디자인 §2 갭). 대신 페이지 전환 콜백에서 다음 커서를 미리 당긴다.
///
/// **이 화면의 실패는 추천 화면을 막지 않는다**(AC5-3) — 둘이 서로 다른 provider를
/// 보고 있고 토글은 어느 쪽을 그릴지만 정하기 때문이다. 오류는 이 body 안에만
/// 그려지고 토글은 계속 조작할 수 있다.
class FeedScrollView extends ConsumerStatefulWidget {
  const FeedScrollView({super.key});

  @override
  ConsumerState<FeedScrollView> createState() => _FeedScrollViewState();
}

class _FeedScrollViewState extends ConsumerState<FeedScrollView> {
  final PageController _controller = PageController();

  /// 끝에서 이만큼 남았을 때 다음 페이지를 당긴다.
  ///
  /// 사진이 항목당 최대 5장이라 과도한 선반입은 메모리·대역폭을 함께 소모한다
  /// (설계 §2). 3이면 한 페이지(20건)를 다 보기 훨씬 전에 다음이 도착하면서도
  /// 앞질러 받는 양이 화면 세 장을 넘지 않는다.
  static const int _prefetchThreshold = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<FeedListState> state = ref.watch(
      feedListControllerProvider,
    );

    final Widget body = state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, _) => FailureNotice.retryable(
        title: l10n.feedUnavailableTitle,
        body: l10n.feedUnavailableBody,
        actionLabel: l10n.feedRetry,
        onAction: () => ref.invalidate(feedListControllerProvider),
      ),
      data: (FeedListState data) => data.isEmpty
          ? _FeedEmpty(onCompose: _openComposer)
          : _buildPages(data),
    );

    // **작성 버튼은 상태와 무관하게 떠 있다.** 빈 상태에서 특히 필요하다 — 글이
    // 하나도 없을 때가 바로 첫 글을 쓸 때인데, 목록 안에만 버튼을 두면 그 순간
    // 진입점이 사라진다. 로그인하지 않았으면 그리지 않는다(갈 곳이 없다).
    final bool signedIn = ref.watch(viewerAuthorProvider) != null;

    return Stack(
      children: <Widget>[
        Positioned.fill(child: body),
        if (signedIn)
          Positioned(
            right: 16,
            // 떠 있는 내비 바 위로 올린다 — 셸이 `extendBody: true`라 보정하지
            // 않으면 버튼이 바 뒤로 숨어 눌리지 않는다.
            //
            // **`barExtent`에 안전영역이 포함돼 있지 않다.** 노치 기기에서는 바가
            // 홈 인디케이터만큼 더 올라와 있어, 그만큼 더하지 않으면 버튼이 바에
            // 걸친다(실제로 걸쳤다).
            bottom:
                FloatingBottomNavScaffold.barExtent +
                MediaQuery.paddingOf(context).bottom +
                feedActionRailLift,
            child: FloatingActionButton(
              heroTag: 'feed-composer-fab',
              tooltip: l10n.feedComposeAction,
              onPressed: _openComposer,
              child: const Icon(Icons.edit_outlined),
            ),
          ),
      ],
    );
  }

  /// 작성 화면을 연다. 돌아오면서 true를 주면 새 글이 올라간 것이라 피드를 새로
  /// 받는다 — 방금 쓴 글이 목록에 없으면 올라갔는지 알 수 없다.
  Future<void> _openComposer() async {
    final Object? posted = await context.pushNamed<Object?>(
      FeedComposerScreen.routeName,
    );
    if (!mounted || posted != true) return;
    ref.invalidate(feedListControllerProvider);
  }

  Widget _buildPages(FeedListState data) {
    // 페이지마다 now를 새로 읽으면 같은 화면 안에서 상대 시각 기준이 어긋난다.
    final DateTime now = DateTime.now().toUtc();
    return PageView.builder(
      controller: _controller,
      scrollDirection: Axis.vertical,
      itemCount: data.items.length,
      onPageChanged: (int index) {
        if (index >= data.items.length - _prefetchThreshold) {
          // 중복 호출은 컨트롤러가 막는다(이미 받는 중이면 무시).
          ref.read(feedListControllerProvider.notifier).loadMore();
        }
      },
      itemBuilder: (BuildContext context, int index) {
        final FeedItem item = data.items[index];
        return FeedItemPage(
          item: item,
          now: now,
          onLike: () =>
              ref.read(feedListControllerProvider.notifier).toggleLike(item.id),
          onSpotTap: () => context.pushNamed(
            SpotDetailView.routeName,
            pathParameters: <String, String>{'id': item.spot.id},
          ),
          // **내 글에는 DM 진입점을 그리지 않는다**(AC7-4) — 자기 자신과의 대화는
          // 만들 수 없다. 미로그인일 때도 마찬가지로 갈 곳이 없다.
          onMessage:
              (item.ownedByViewer || ref.watch(viewerAuthorProvider) == null)
              ? null
              : () => _startConversation(item),
          onOptions: item.ownedByViewer ? null : () => _report(item),
        );
      },
    );
  }

  /// 작성자와의 대화를 열고 대화 화면으로 간다. 이미 대화가 있으면 서버가 그것을
  /// 돌려준다(AC7-2).
  Future<void> _startConversation(FeedItem item) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? conversationId = await ref
        .read(conversationStarterProvider)
        .start(item.id);
    if (!mounted) return;

    if (conversationId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.feedConversationStartFailed)));
      return;
    }
    // 라우트에는 id만 넘긴다(CLAUDE.md §6).
    context.pushNamed(
      ConversationScreen.routeName,
      pathParameters: <String, String>{'id': conversationId},
    );
  }

  /// 피드 신고. 사유 시트는 커뮤니티의 것을 **그대로 재사용한다**(설계 §8) — 새
  /// 신고 시트를 만들지 않는다.
  ///
  /// **접수 뮤테이션이 아직 없다.** 서버에는 `reportContent(targetType: FEED_ITEM)`이
  /// 있지만 `FeedRepository`에 그 오퍼레이션이 뚫려 있지 않다. 접수되지 않았는데
  /// "접수했다"고 말하면 사용자가 신고했다고 믿고 넘어가므로, 실패를 그대로
  /// 알린다 — repository에 메서드가 생기면 이 자리에서 부르고 성공 문구로 바꾼다.
  Future<void> _report(FeedItem item) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ReportSubmission? submission = await showReportSheet(context);
    if (submission == null || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.feedReportFailed)));
  }
}

/// 글이 하나도 없을 때. **오류가 아니다** — 재시도 버튼을 두지 않는다.
///
/// 대신 **첫 글을 쓰는 길을 준다.** 빈 피드에서 사용자가 할 수 있는 유일한 일이
/// 글을 쓰는 것이고, 문구가 "첫 번째 글을 남겨보세요"라고 권하면서 그 수단이
/// 화면 구석의 버튼뿐이면 권유가 막다른 길이 된다.
class _FeedEmpty extends StatelessWidget {
  const _FeedEmpty({required this.onCompose});

  final VoidCallback onCompose;

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
              Icons.dynamic_feed_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.feedEmptyTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.feedEmptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCompose,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(l10n.feedComposeAction),
            ),
          ],
        ),
      ),
    );
  }
}
