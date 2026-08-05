import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/location/location_service.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../spot/model/spot_category.dart';
import '../../spot/view/spot_detail_view.dart';
import '../component/discovery_tile_grid.dart';
import '../component/post_card.dart';
import '../component/topic_chip_row.dart';
import '../model/discovery_tile.dart';
import '../model/post.dart';
import '../model/post_topic.dart';
import '../provider/community_providers.dart';
import '../provider/nearby_feed_providers.dart';
import 'post_composer_screen.dart';
import 'post_detail_screen.dart';
import 'post_moderation_flow.dart';

/// 커뮤니티 탭 — Spot Talk(SPEC-0010 R7·R8·R10·R11), **당근 동네생활 배치**.
///
/// 위에서부터 탐색 타일 그리드, 카테고리 행, 지역 피드다. 라우트 `/community`와 탭
/// 라벨 `navCommunity`는 SPEC-0008이 이미 만들어 둔 것을 그대로 쓴다 — **탭을 새로
/// 만들지 않고 스텁 내용만 바꾼 것**이다(설계 §1).
///
/// **타일과 피드를 서로 다른 provider로 갈라 둔 이유**가 화면에 드러난다: 지금 서버는
/// 커넥션 조회(`nearbyPosts`)만 깨져 있고 타일은 정상이라, 피드가 실패해도 타일과
/// 카테고리 행은 그대로 보이고 피드 자리에만 오류와 재시도가 뜬다. 하나로 묶었으면
/// 화면 전체가 빈 오류 화면이 됐을 것이다.
///
/// 미인증으로도 피드를 볼 수 있다(R17) — 조회 4종은 로그인이 필요 없고, 상호작용
/// 시점에 로그인으로 유도한다. **버튼을 감추지 않는다.**
class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  static String get routeName => 'community';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PostTopic? topic = ref.watch(selectedPostTopicProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.communityTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.communityComposeAction,
        onPressed: () => _openComposer(context, ref, topic),
        child: const Icon(Icons.edit_outlined),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _Tiles(),
            TopicChipRow(
              selected: topic,
              onSelected: (PostTopic? next) =>
                  ref.read(selectedPostTopicProvider.notifier).select(next),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.communityNearbyTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            // 본문만 상태에 따라 갈린다 — 피드가 로딩·오류여도 타일과 카테고리 행은
            // 그대로 있어야 다른 태그로 옮겨갈 수 있다.
            Expanded(child: _NearbyFeed(topic: topic)),
          ],
        ),
      ),
    );
  }

  /// 컴포저를 연다. 등록에 성공하면 **피드를 다시 불러온다** — `createPost`는
  /// `postId`만 주고 `post`는 항상 null이라(가이드 §11) 새 글을 응답으로 조립할 수
  /// 없기 때문이다.
  Future<void> _openComposer(
    BuildContext context,
    WidgetRef ref,
    PostTopic? topic,
  ) async {
    final bool? created = await context.pushNamed<bool>(
      PostComposerScreen.routeName,
    );
    if (created ?? false) {
      ref.invalidate(nearbyFeedControllerProvider(topic));
    }
  }
}

/// 탐색 타일 영역. **빈 목록이 정상**이고(가이드 §15) 조회가 실패해도 피드를 막지
/// 않으므로, 두 경우 모두 영역을 그리지 않는다 — 사용자가 고칠 수 없는 운영 상태에
/// 오류 문구를 띄울 이유가 없다.
class _Tiles extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(discoveryTilesProvider)
      .maybeWhen(
        data: (List<DiscoveryTile> tiles) => DiscoveryTileGrid(
          tiles: tiles,
          // 타일 진입은 카테고리 선택과 **같은 상태**를 쓴다(R11-3) — 상단 행이 그
          // 태그로 선택된 것처럼 보인다.
          onTap: (DiscoveryTile tile) => ref
              .read(selectedPostTopicProvider.notifier)
              .applyFromTile(tile.filterTopic),
        ),
        orElse: () => const SizedBox.shrink(),
      );
}

/// 지역 피드. 로딩·빈 피드·위치 실패·조회 실패가 **서로 다른 상태**다(디자인 §1).
///
/// 특히 위치 실패는 빈 피드와 구분해 그 사유를 보여준다(설계 §3) — "글이 없다"와
/// "위치를 못 얻었다"는 사용자가 할 일이 다르다.
class _NearbyFeed extends ConsumerWidget {
  const _NearbyFeed({required this.topic});

  final PostTopic? topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<NearbyFeedState> state = ref.watch(
      nearbyFeedControllerProvider(topic),
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
        onRetry: () => ref.invalidate(nearbyFeedControllerProvider(topic)),
      ),
      data: (NearbyFeedState data) => data.isEmpty
          ? Center(child: Text(l10n.communityFeedEmpty))
          : _FeedList(topic: topic, data: data),
    );
  }
}

/// 피드 본문. 스크롤·추가 로딩은 공용 [PaginationListView]가 담당한다(CLAUDE.md §4).
///
/// 카드 사이는 **얇은 구분선**이다 — 당근 동네생활은 그림자 있는 카드가 아니라
/// 구분선으로만 항목을 나눈다.
class _FeedList extends ConsumerWidget {
  const _FeedList({required this.topic, required this.data});

  /// 어느 태그의 피드인지 — 추가 로딩을 같은 family 인스턴스에 요청해야 한다.
  final PostTopic? topic;
  final NearbyFeedState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 카드마다 DateTime.now()를 부르면 같은 화면 안에서 기준이 어긋난다. 빌드 1회당
    // 한 번만 읽어 모든 카드가 같은 기준을 쓴다.
    final DateTime now = DateTime.now().toUtc();
    return PaginationListView(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: data.items.length,
      hasMore: data.hasMore,
      isLoadingMore: data.isLoadingMore,
      onLoadMore: () =>
          ref.read(nearbyFeedControllerProvider(topic).notifier).loadMore(),
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
                  .read(nearbyFeedControllerProvider(topic).notifier)
                  .toggleLike(post.id)
                  // 실패는 컨트롤러가 롤백하고 로그를 남긴다. 여기서 다시 던지면
                  // 프레임 밖 예외가 되어 앱이 죽는다.
                  .catchError((Object _) {}),
              onTargetTap: () => _openTarget(context, post),
              // 차단·신고·삭제. 성공하면 흐름이 피드를 다시 불러온다 — 서버가
              // 필터링하므로 로컬에서 지우는 것이 아니다(가이드 §6).
              onOptions: () => runPostModerationFlow(
                context,
                ref,
                post: post,
                onChanged: () =>
                    ref.invalidate(nearbyFeedControllerProvider(topic)),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 대상 상세로 이동한다. `PostTarget.id`는 관광지의 경우 기존 `spot.id`와 **같은
  /// 식별자 공간**이라 그대로 `/spot/:id`에 넘길 수 있다(가이드 §1).
  ///
  /// 카테고리는 알 수 없다 — `PostTarget`에 없는 값이라 라우트의 기본값(관광지)으로
  /// 떨어진다. 실제와 다르면 서버가 운영정보를 빈 값으로 주고 해당 섹션이 렌더되지
  /// 않으므로 화면이 깨지지 않는다.
  void _openTarget(BuildContext context, Post post) {
    if (post.target.type != PostTargetType.spot) return;
    context.pushNamed(
      SpotDetailView.routeName,
      pathParameters: <String, String>{'id': post.target.id},
      queryParameters: <String, String>{
        'category': SpotCategory.touristSpot.name,
        'thumb': post.target.thumbnailImageUrl,
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
