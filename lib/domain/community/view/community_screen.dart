import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/location/location_service.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/category_chip_row.dart';
import '../component/feed_sort_toggle.dart';
import '../component/post_card.dart';
import '../component/post_photo.dart';
import '../model/community_chip.dart';
import '../model/post.dart';
import '../model/post_sort_order.dart';
import '../model/target_category.dart';
import '../provider/community_providers.dart';
import '../provider/feed_providers.dart';
import 'blocked_users_screen.dart';
import 'hidden_posts_screen.dart';
import 'post_composer_screen.dart';
import 'post_detail_screen.dart';
import 'post_moderation_flow.dart';

/// 커뮤니티 탭 — Spot Talk, **당근 동네생활 배치**.
///
/// 위에서부터 카테고리 줄, 지역 피드다. 라우트 `/community`와 탭 라벨 `navCommunity`는
/// SPEC-0008이 이미 만들어 둔 것을 그대로 쓴다.
///
/// **칩 줄과 피드를 서로 다른 provider로 갈라 두었다** — 하나가 실패해도 다른 하나는
/// 그대로 보인다. 칩 조회가 실패하면 줄만 사라지고 전체 피드는 계속 읽을 수 있다.
///
/// **칩이 비어도 정상이다**(가이드 §2). 구성이 없는 앱이면 서버가 빈 목록을 주며,
/// 그때는 줄 자체를 그리지 않고 피드가 위로 붙는다.
class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  static String get routeName => 'community';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TargetCategory? category = ref.watch(selectedCategoryProvider);
    final PostSortOrder sort = ref.watch(selectedSortProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.communityTitle),
        actions: <Widget>[
          // 숨긴 글 목록은 차단 목록 **옆**에 둔다 — 둘 다 "내가 안 보이게 한 것"을
          // 되돌리는 화면이라 같은 자리에 있어야 찾는다. 다만 축은 다르다:
          // 차단은 사람, 숨김은 글 하나다(2차 가이드 §2).
          IconButton(
            icon: const Icon(Icons.visibility_off_outlined),
            tooltip: l10n.communityHiddenPostsAction,
            onPressed: () => context.pushNamed(HiddenPostsScreen.routeName),
          ),
          IconButton(
            icon: const Icon(Icons.block),
            tooltip: l10n.communityBlockedUsersAction,
            onPressed: () => context.pushNamed(BlockedUsersScreen.routeName),
          ),
        ],
      ),
      // 셸이 `extendBody: true`라 이 화면의 body가 떠 있는 내비 바 **아래까지**
      // 그려진다. 기본 위치의 FAB은 그 바에 가려지므로 바 높이만큼 띄우고, 바에
      // 딱 붙지 않도록 한 칸 더 준다. 바 높이를 여기 적지 않고 셸 상수를 읽는
      // 이유는 바의 높이·여백이 바뀔 때 보정이 저절로 따라오게 하기 위해서다.
      //
      // 여백 27은 12에서 15 올린 값이다 — 실기기에서 바에 너무 붙어 보였다.
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: FloatingBottomNavScaffold.barExtent + 27,
        ),
        child: FloatingActionButton(
          tooltip: l10n.communityComposeAction,
          onPressed: () => _openComposer(context, ref, category, sort),
          child: const Icon(Icons.edit_outlined),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _Chips(selected: category),
            // 정렬 토글. **여기서는 상태만 바꾼다** — 피드가 정렬별 family라 값이
            // 바뀌면 새 인스턴스가 커서 없이 첫 페이지부터 받는다(2차 가이드 §3).
            FeedSortToggle(
              selected: sort,
              onSelected: (PostSortOrder next) =>
                  ref.read(selectedSortProvider.notifier).select(next),
            ),
            // 본문만 상태에 따라 갈린다 — 피드가 로딩·오류여도 칩 줄과 정렬 토글은
            // 그대로 있어야 다른 카테고리·정렬로 옮겨갈 수 있다.
            Expanded(
              child: _Feed(category: category, sort: sort),
            ),
          ],
        ),
      ),
    );
  }

  /// 컴포저를 연다. 등록에 성공하면 **피드를 다시 불러온다** — `createPost`는
  /// `postId`만 주고 `post`는 항상 null이라(가이드 §5) 새 글을 응답으로 조립할 수
  /// 없기 때문이다.
  Future<void> _openComposer(
    BuildContext context,
    WidgetRef ref,
    TargetCategory? category,
    PostSortOrder sort,
  ) async {
    final bool? created = await context.pushNamed<bool>(
      PostComposerScreen.routeName,
    );
    if (created ?? false) {
      ref.invalidate(feedControllerProvider(category, sort));
    }
  }
}

/// 상단 카테고리 줄. **구성은 서버가 정하고 표시 문구만 앱이 매핑한다**(가이드 §2).
///
/// 빈 목록도 조회 실패도 줄을 그리지 않는 것으로 접는다 — 사용자가 고칠 수 없는
/// 운영 상태에 오류 문구를 띄울 이유가 없고, 그동안에도 전체 피드는 읽을 수 있다.
class _Chips extends ConsumerWidget {
  const _Chips({required this.selected});

  final TargetCategory? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(communityChipsProvider)
      .maybeWhen(
        data: (List<CommunityChip> chips) => CategoryChipRow(
          chips: chips,
          selected: selected,
          onSelected: (TargetCategory? next) =>
              ref.read(selectedCategoryProvider.notifier).select(next),
        ),
        orElse: () => const SizedBox.shrink(),
      );
}

/// 지역 피드. 로딩·빈 피드·위치 실패·조회 실패가 **서로 다른 상태**다.
///
/// 특히 위치 실패는 빈 피드와 구분해 그 사유를 보여준다 — "글이 없다"와 "위치를 못
/// 얻었다"는 사용자가 할 일이 다르다.
class _Feed extends ConsumerWidget {
  const _Feed({required this.category, required this.sort});

  final TargetCategory? category;

  /// 어느 정렬의 피드인지. **family 인자라서 정렬이 바뀌면 다른 인스턴스가**
  /// 커서 없이 처음부터 로딩된다(2차 가이드 §3).
  final PostSortOrder sort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<FeedState> state = ref.watch(
      feedControllerProvider(category, sort),
    );

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, _) => _FeedError(
        // 위치 실패는 조회 실패와 다른 사유를 보여준다.
        title: error is LocationUnavailable
            ? l10n.communityLocationUnavailable
            : l10n.communityFeedUnavailable,
        body: error is LocationUnavailable
            ? null
            : l10n.communityFeedUnavailableBody,
        onRetry: () => ref.invalidate(feedControllerProvider(category, sort)),
      ),
      data: (FeedState data) => data.isEmpty
          ? Center(child: Text(l10n.communityFeedEmpty))
          : _FeedList(category: category, sort: sort, data: data),
    );
  }
}

/// 피드 본문. 스크롤·추가 로딩·**당겨서 새로고침**은 공용 [PaginationListView]가
/// 담당한다(CLAUDE.md §4).
///
/// 카드 사이는 **얇은 구분선**이다 — 당근 동네생활은 그림자 있는 카드가 아니라
/// 구분선으로만 항목을 나눈다.
class _FeedList extends ConsumerWidget {
  const _FeedList({
    required this.category,
    required this.sort,
    required this.data,
  });

  /// 어느 카테고리·정렬의 피드인지 — 추가 로딩을 **같은 family 인스턴스**에
  /// 요청해야 한다. 다른 인스턴스에 요청하면 커서 형식이 어긋나 서버가
  /// `INVALID_INPUT`을 준다(2차 가이드 §3).
  final TargetCategory? category;
  final PostSortOrder sort;
  final FeedState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 카드마다 DateTime.now()를 부르면 같은 화면 안에서 기준이 어긋난다. 빌드 1회당
    // 한 번만 읽어 모든 카드가 같은 기준을 쓴다.
    final DateTime now = DateTime.now().toUtc();
    return PaginationListView(
      // 마지막 카드가 내비 바와 그 위의 FAB에 가리지 않도록 둘 다 넘는 만큼 비운다.
      // 바 높이는 셸 상수를 읽고(값이 바뀌면 따라온다), FAB(56)과 숨돌릴 여백을 더한다.
      padding: const EdgeInsets.only(
        bottom: FloatingBottomNavScaffold.barExtent + 56 + 16,
      ),
      itemCount: data.items.length,
      hasMore: data.hasMore,
      isLoadingMore: data.isLoadingMore,
      onLoadMore: () =>
          ref.read(feedControllerProvider(category, sort).notifier).loadMore(),
      // 당겨서 새로고침. 공용 `common/pagination`의 선택 인자를 쓴다 — 화면이 자기
      // RefreshIndicator를 따로 만들지 않는다(CLAUDE.md §4).
      //
      // 글을 쓰고 돌아온 뒤 목록을 다시 받는 수단이기도 하다 — `createPost`는 postId만
      // 주므로(가이드 §5) 새 글을 응답으로 조립할 수 없고 다시 조회해야 한다.
      //
      // **새 값을 await한다** — 그래야 데이터가 올 때까지 스피너가 돈다. invalidate만
      // 하고 끝내면 조회가 시작되자마자 인디케이터가 걷혀 새로고침이 안 된 것처럼
      // 보인다. 실패는 provider가 오류 상태로 들고 화면이 그 자리에서 사유를
      // 보여주므로 여기서 다시 던지지 않는다.
      onRefresh: () async {
        ref.invalidate(feedControllerProvider(category, sort));
        await ref
            .read(feedControllerProvider(category, sort).future)
            .catchError((Object _) => data);
      },
      itemBuilder: (BuildContext context, int index) {
        final Post post = data.items[index];
        return Column(
          children: <Widget>[
            if (index > 0) const Divider(height: 1, thickness: 0.5),
            PostCard(
              post: post,
              now: now,
              onTap: () => context.pushNamed(
                PostDetailScreen.routeName,
                pathParameters: <String, String>{'id': post.id},
              ),
              onLike: () => ref
                  .read(feedControllerProvider(category, sort).notifier)
                  .toggleLike(post.id)
                  // 실패는 컨트롤러가 롤백하고 로그를 남긴다. 여기서 다시 던지면
                  // 프레임 밖 예외가 되어 앱이 죽는다.
                  .catchError((Object _) {}),
              onPhotoTap: (int at) => showPostPhotoViewer(
                context,
                photoKeys: post.photoKeys,
                initialIndex: at,
              ),
              // 신고·차단·수정·삭제. 성공하면 흐름이 피드를 다시 불러온다 — 서버가
              // 필터링하므로 로컬에서 지우는 것이 아니다(가이드 §6).
              onOptions: () => runPostModerationFlow(
                context,
                ref,
                post: post,
                onChanged: () =>
                    ref.invalidate(feedControllerProvider(category, sort)),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 피드 오류 자리. **빈 화면이나 무한 스피너로 두지 않는다** — 무엇이 실패했는지와
/// 재시도 수단을 함께 보여준다.
class _FeedError extends StatelessWidget {
  const _FeedError({required this.title, required this.onRetry, this.body});

  final String title;
  final String? body;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
            if (body != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(l10n.communityRetry)),
          ],
        ),
      ),
    );
  }
}
