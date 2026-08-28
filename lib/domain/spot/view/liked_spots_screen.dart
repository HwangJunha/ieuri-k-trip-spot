import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/settings_routes.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../common/widget/skeleton_list.dart';
import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../common/category/spot_category_bar.dart';
import '../component/liked_spot_card.dart';
import '../component/liked_spots_search_field.dart';
import '../provider/swipe_providers.dart';
import '../model/liked_spot.dart';
import '../model/liked_spots_empty_reason.dart';
import '../model/liked_spots_query.dart';
import '../model/spot_skeleton_samples.dart';
import '../../../common/category/spot_category.dart';
import '../../../common/category/spot_category_selection.dart';
import '../provider/spot_detail_providers.dart';
import '../provider/liked_spots_providers.dart';
import 'spot_detail_view.dart';

/// 좋아요 목록 탭(SPEC-0008 R-12 · R-18).
///
/// 항목을 선택하면 **기존 `/spot/:id`로 진입한다**(§5.1) — 상세 화면을 새로 만들지
/// 않는다. 선택한 spot의 상세가 부재하면 축약 화면이 뜨고(§3), 그것은 좋아요 목록에서
/// 들어오든 스와이프에서 들어오든 같은 화면·같은 규칙이다(AC-55).
///
/// 정렬 옵션·좋아요 해제 UI는 비스코프다(§5.3) — 목록 표시와 상세 진입만 한다.
/// 좋아요 해제는 상세 화면의 기존 반응 경로로 가능하다.
///
/// 목록 내 검색은 SPEC-0033에서 붙었다 — **새 화면도 새 라우트도 만들지 않고**
/// 카테고리 바 위에 입력을 둔다. 이 화면은 보관함(`LibraryScreen`)이 `showAppBar:
/// false`로 품고 있어 앱바가 그쪽 것이므로, 입력은 앱바가 아니라 본문 상단에 있어야
/// 보관함 셸의 토글과 부딪히지 않는다.
///
/// 좋아요는 spot에 대한 반응이라 spot 도메인의 화면이다 — 별도 도메인이 아니다.
class LikedSpotsScreen extends ConsumerStatefulWidget {
  const LikedSpotsScreen({super.key, this.showAppBar = true});

  static String get routeName => likedSpotsRouteName;

  /// 자체 상단바를 그릴지(SPEC-0030 R18).
  ///
  /// 보관함 화면이 이 화면을 품을 때는 상단바를 보관함이 갖고 토글을 거기 둔다 —
  /// 그대로 두면 상단바가 두 줄이 된다. **화면의 동작은 그대로다**, 상단바만 빠진다.
  final bool showAppBar;

  @override
  ConsumerState<LikedSpotsScreen> createState() => _LikedSpotsScreenState();
}

class _LikedSpotsScreenState extends ConsumerState<LikedSpotsScreen> {
  /// 직전에 이 화면이 속한 탭이 활성이었는지. 탭 이탈을 가리는 근거다.
  bool _wasActive = true;

  /// 탭을 떠나면 검색어를 버린다 — 다음 진입은 빈 입력으로 시작한다(§입력 처리).
  ///
  /// **`autoDispose`로는 안 된다.** 좋아요 탭은 `StatefulShellRoute.indexedStack`의
  /// 브랜치라 다른 탭에 가도 계속 mount되어 provider가 버려지지 않는다. 대신
  /// go_router가 비활성 브랜치를 `TickerMode(enabled: false)`로 감싸므로
  /// (go_router 14.8.1 `lib/src/route.dart:1538`) 그것을 탭 이탈 신호로 쓴다.
  ///
  /// 보관함 안의 좋아요↔커뮤니티 토글은 `IndexedStack`만 쓰고 `TickerMode`를 새로
  /// 씌우지 않으므로 여기 걸리지 않는다. 상세로 push하는 것도 브랜치를 비활성으로
  /// 만들지 않는다 — 둘 다 이탈이 아니라는 스펙의 규정과 맞는다.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool active = TickerMode.valuesOf(context).enabled;
    final bool left = _wasActive && !active;
    _wasActive = active;
    if (!left) return;
    // **빌드 중에 provider를 고칠 수 없다.** `didChangeDependencies`는 빌드 단계에서
    // 불리므로 여기서 바로 `clear()`를 부르면 Riverpod이 막는다 — 한 프레임 뒤로
    // 미룬다. 이미 떠난 탭이라 한 프레임 늦는 것이 화면에 보이지 않는다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(likedSpotsSearchQueryProvider.notifier).clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 최초 상태는 "전체"다(사용자 결정, 2026-08-15) — 네 화면이 같은 규칙을 쓴다.
    final Set<SpotCategory> selected = ref.watch(selectedLikedCategoryProvider);
    // 카테고리와 검색어를 한 키로 묶는다 — 검색어가 키에 없으면 검색어를 바꿔도
    // 같은 인스턴스를 가리켜 재조회가 일어나지 않는다(SPEC-0033 §핵심 배선).
    final LikedSpotsQuery query = LikedSpotsQuery(
      selection: SpotCategorySelection(selected),
      query: ref.watch(likedSpotsSearchQueryProvider),
    );
    final AsyncValue<LikedSpotsState> state = ref.watch(
      likedSpotsControllerProvider(query),
    );

    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: Text(l10n.navLiked)) : null,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            // 검색은 카테고리 바 **위**에 둔다(§어디에 붙는가).
            const LikedSpotsSearchField(),
            // Discover와 같은 바를 쓰되 선택 상태는 이 화면 것이다 — 여기서 고른
            // 필터가 스와이프 스택을 갈아치우면 안 된다.
            SpotCategoryBar(
              available:
                  ref.watch(availableSpotCategoriesProvider).value ??
                  const <SpotCategory>[],
              selected: selected,
              onToggle: (SpotCategory next) =>
                  ref.read(selectedLikedCategoryProvider.notifier).toggle(next),
              onSelectAll: () =>
                  ref.read(selectedLikedCategoryProvider.notifier).selectAll(),
            ),
            const SizedBox(height: 8),
            // 본문만 상태에 따라 갈린다 — 카테고리를 바꿔 로딩이 떠도 바는 그대로
            // 있어야 다른 카테고리로 이어서 옮길 수 있다.
            Expanded(
              child: state.when(
                // 실제 카드에 더미를 넣어 그린 뒤 시머로 덮는다 — 카드 디자인이
                // 바뀌어도 뼈대가 저절로 따라간다.
                loading: () => SkeletonList(
                  itemBuilder: (_, _) => LikedSpotCard(
                    spot: likedSpotSkeletonSample,
                    onTap: () {},
                  ),
                ),
                // 미인증(UNAUTHENTICATED)은 SPEC-0005의 세션 갱신 경로가 처리한다 —
                // 여기선 일반 오류와 같게 다루고 재시도만 제공한다(§5.2).
                //
                // 입력 검증 오류(EMPTY_QUERY·QUERY_TOO_LONG)도 이 경로로 흘린다 —
                // 입력에서 막으므로 실제로 올 일이 없고, 코드별 전용 문구를 만들
                // 이유가 없다(SPEC-0033 §오류 처리). 재시도는 **검색어를 유지한 채**
                // 같은 키를 다시 조회한다.
                error: (_, _) => _ErrorBody(
                  onRetry: () =>
                      ref.invalidate(likedSpotsControllerProvider(query)),
                ),
                data: (LikedSpotsState data) => _LikedBody(
                  query: query,
                  data: data,
                  // 빈 상태 판정은 위젯 밖 순수 함수가 한다 — build 안에 인라인으로
                  // 두면 단위 테스트로 검증할 수 없다(SPEC-0033 §테스트가 붙는 단위).
                  emptyReason: likedSpotsEmptyReason(
                    isEmpty: data.isEmpty,
                    hasQuery: query.hasQuery,
                    hasAnyLikes: ref.watch(likedSpotsPresenceProvider),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 데이터가 온 뒤의 본문 — 빈 상태 둘과 목록을 가른다(SPEC-0033 §두 개의 빈 상태).
class _LikedBody extends StatelessWidget {
  const _LikedBody({
    required this.query,
    required this.data,
    required this.emptyReason,
  });

  final LikedSpotsQuery query;
  final LikedSpotsState data;

  /// null이면 보여줄 항목이 있다는 뜻이다.
  final LikedSpotsEmptyReason? emptyReason;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (emptyReason) {
      // 저장한 것이 없는 사람에게는 검색어가 쳐 있어도 "좋아요해 보세요"가 맞다
      // (AC8.4) — "검색 결과가 없습니다"는 다음 할 일을 알려주지 못한다.
      LikedSpotsEmptyReason.noLikes => Center(
        child: Text(l10n.likedSpotsEmpty),
      ),
      LikedSpotsEmptyReason.noSearchResults => Center(
        child: Text(l10n.likedSpotsSearchNoResults),
      ),
      null => _LikedList(query: query, data: data),
    };
  }
}

/// 목록 본문. 스크롤·추가 로딩은 공용 [PaginationListView]가 담당한다(§4).
class _LikedList extends ConsumerWidget {
  const _LikedList({required this.query, required this.data});

  /// 어느 조회의 목록인지 — 추가 로딩을 같은 family 인스턴스에 요청해야 한다.
  final LikedSpotsQuery query;
  final LikedSpotsState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) => PaginationListView(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: data.items.length,
    hasMore: data.hasMore,
    isLoadingMore: data.isLoadingMore,
    onLoadMore: () =>
        ref.read(likedSpotsControllerProvider(query).notifier).loadMore(),
    // 당겨서 새로고침 — 다른 화면에서 좋아요를 풀고 돌아와도 목록을 손으로
    // 맞출 수 있어야 한다.
    //
    // **`.future`를 await 해야 한다**(공용 위젯의 계약) — invalidate만 하고
    // 끝나면 데이터가 오기 전에 스피너가 걷혀 새로고침이 안 된 것처럼 보인다.
    onRefresh: () async {
      ref.invalidate(likedSpotsControllerProvider(query));
      await ref
          .read(likedSpotsControllerProvider(query).future)
          .catchError((Object _) => data);
    },
    itemBuilder: (BuildContext context, int index) {
      final LikedSpot spot = data.items[index];
      return LikedSpotCard(spot: spot, onTap: () => _openDetail(context, ref, spot));
    },
  );

  /// 기존 상세 라우트로 진입한다(§5.1). [LikedSpot.id]가 그대로 `spotDetail(id:)`에
  /// 들어가는 같은 식별자다.
  ///
  /// **카테고리는 넘기지 않는다**(SPEC-0020) — 서버가 상세를 spot 자신의 카테고리로
  /// 해석하므로 호출부가 알려줄 것이 없다. `thumb`는 본문 조회를 기다리는 동안
  /// 깜빡임을 없앤다.
  ///
  /// `feed` 파라미터도 넘기지 않는다. 좋아요 목록은 스와이프 피드가 아니므로 반응
  /// 후 소비할 카드 스택이 없다 — 라우트가 null로 되돌린다.
  void _openDetail(BuildContext context, WidgetRef ref, LikedSpot spot) {
    // 상세가 운영정보를 받으려면 카테고리 코드가 필요하다 — 목록은 알고 있고
    // 상세 응답의 `category.code`는 null로 온다.
    ref
        .read(spotCategoryCodesProvider.notifier)
        .remember(spot.id, spot.category.code);
    AppAnalytics.logEvent(AnalyticsEvents.spotDetailView, <String, Object>{
      AnalyticsParams.from: 'liked',
    });
    context.pushNamed(
      SpotDetailView.routeName,
      pathParameters: <String, String>{'id': spot.id},
      queryParameters: <String, String>{'thumb': spot.thumbnailImageUrl},
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
