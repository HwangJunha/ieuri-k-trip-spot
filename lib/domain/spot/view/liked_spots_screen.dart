import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/category_bar.dart';
import '../component/liked_spot_card.dart';
import '../model/liked_spot.dart';
import '../model/spot_category.dart';
import '../provider/liked_spots_providers.dart';
import 'spot_detail_view.dart';

/// 좋아요 목록 탭(SPEC-0008 R-12 · R-18).
///
/// 항목을 선택하면 **기존 `/spot/:id`로 진입한다**(§5.1) — 상세 화면을 새로 만들지
/// 않는다. 선택한 spot의 상세가 부재하면 축약 화면이 뜨고(§3), 그것은 좋아요 목록에서
/// 들어오든 스와이프에서 들어오든 같은 화면·같은 규칙이다(AC-55).
///
/// 정렬 옵션·검색·좋아요 해제 UI는 비스코프다(§5.3) — 목록 표시와 상세 진입만 한다.
/// 좋아요 해제는 상세 화면의 기존 반응 경로로 가능하다.
///
/// 좋아요는 spot에 대한 반응이라 spot 도메인의 화면이다 — 별도 도메인이 아니다.
class LikedSpotsScreen extends ConsumerWidget {
  const LikedSpotsScreen({super.key});

  static String get routeName => 'liked';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SpotCategory? category = ref.watch(selectedLikedCategoryProvider);
    final AsyncValue<LikedSpotsState> state = ref.watch(
      likedSpotsControllerProvider(category),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navLiked)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            // Discover와 같은 바를 쓰되 선택 상태는 이 화면 것이다 — 여기서 고른
            // 필터가 스와이프 스택을 갈아치우면 안 된다.
            CategoryBar(
              selected: category,
              onSelected: (SpotCategory? next) =>
                  ref.read(selectedLikedCategoryProvider.notifier).select(next),
            ),
            const SizedBox(height: 8),
            // 본문만 상태에 따라 갈린다 — 카테고리를 바꿔 로딩이 떠도 바는 그대로
            // 있어야 다른 카테고리로 이어서 옮길 수 있다.
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                // 미인증(UNAUTHENTICATED)은 SPEC-0005의 세션 갱신 경로가 처리한다 —
                // 여기선 일반 오류와 같게 다루고 재시도만 제공한다(§5.2).
                error: (_, _) => _ErrorBody(
                  onRetry: () =>
                      ref.invalidate(likedSpotsControllerProvider(category)),
                ),
                data: (LikedSpotsState data) => data.isEmpty
                    ? Center(child: Text(l10n.likedSpotsEmpty))
                    : _LikedList(category: category, data: data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 목록 본문. 스크롤·추가 로딩은 공용 [PaginationListView]가 담당한다(§4).
class _LikedList extends ConsumerWidget {
  const _LikedList({required this.category, required this.data});

  /// 어느 카테고리의 목록인지 — 추가 로딩을 같은 family 인스턴스에 요청해야 한다.
  final SpotCategory? category;
  final LikedSpotsState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) => PaginationListView(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: data.items.length,
    hasMore: data.hasMore,
    isLoadingMore: data.isLoadingMore,
    onLoadMore: () =>
        ref.read(likedSpotsControllerProvider(category).notifier).loadMore(),
    itemBuilder: (BuildContext context, int index) {
      final LikedSpot spot = data.items[index];
      return LikedSpotCard(spot: spot, onTap: () => _openDetail(context, spot));
    },
  );

  /// 기존 상세 라우트로 진입한다(§5.1). [LikedSpot.id]가 그대로 `spotDetail(id:)`에
  /// 들어가는 같은 식별자다.
  ///
  /// category·thumb를 함께 넘기는 이유는 스와이프에서 열 때와 같다 — 서버의
  /// `intro`/`infoItems`가 카테고리를 필수 인자로 요구하고, 썸네일은 본문 조회를
  /// 기다리는 동안 깜빡임을 없앤다.
  ///
  /// `feed` 파라미터는 넘기지 않는다. 좋아요 목록은 스와이프 피드가 아니므로 반응
  /// 후 소비할 카드 스택이 없다 — 라우트가 null(전체 피드)로 되돌린다.
  void _openDetail(BuildContext context, LikedSpot spot) {
    context.pushNamed(
      SpotDetailView.routeName,
      pathParameters: <String, String>{'id': spot.id},
      queryParameters: <String, String>{
        'category': spot.category.name,
        'thumb': spot.thumbnailImageUrl,
      },
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(l10n.likedSpotsUnavailable),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: Text(l10n.spotDetailRetryButton),
          ),
        ],
      ),
    );
  }
}
