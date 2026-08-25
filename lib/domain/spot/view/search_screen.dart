import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/navigation/picked_place.dart';
import '../../../common/navigation/spot_detail_route.dart';
import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../common/category/spot_category_bar.dart';
import '../component/recent_searches_list.dart';
// 결과 목록의 페이징은 이 컴포넌트 안에서 공용 PaginationListView가 맡는다 —
// 기능이 자기 페이지네이션을 만들지 않는다(CLAUDE.md §4).
import '../component/search_result_list.dart';
import '../component/search_suggestion_list.dart';
import '../provider/swipe_providers.dart';
import '../../../common/category/spot_category.dart';
import '../model/spot_search_state.dart';
import '../model/tourist_spot.dart';
import '../provider/recent_searches_providers.dart';
import '../provider/spot_detail_providers.dart';
import '../provider/spot_search_providers.dart';
import 'spot_detail_view.dart';

/// 검색 페이지(R10·R11·R13). 탭 셸 밖의 최상위 라우트라 하단 탭을 덮는다.
///
/// 한 화면이 다섯 상태를 갖는다(설계 §2): 초기(최근 검색어) · 로딩 · 결과 있음 ·
/// 결과 없음 · 실패. **빈 결과와 실패를 같은 화면으로 뭉치지 않는다** — 전자는
/// 정상이라 재시도 버튼을 두지 않고, 후자만 재시도를 준다(AC-11.2·AC-11.3).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.returnsPickedSpot = false});

  /// 결과를 골랐을 때 **상세로 가는 대신 그 spot을 돌려주고 닫을 것인가**.
  ///
  /// 지도(SPEC-0014)가 검색을 열 때 참이다 — 거기서는 "이 장소를 찾아서 지도를
  /// 그리로 옮기는 것"이 목적이라, 상세 화면으로 넘어가면 지도로 돌아와야 한다.
  /// 홈에서 열면 거짓이라 기존대로 상세로 간다.
  final bool returnsPickedSpot;

  /// **탭 셸 밖의 최상위 라우트**라 루트 내비게이터에 push되어 하단 탭을 덮는다
  /// (설계 §1) — 검색은 탭 전환이 아니라 홈에서 밀고 올라오는 흐름이다.
  ///
  /// 이름은 `common/navigation/`에 있다 — **지도(SPEC-0014)가 두 번째 진입점이
  /// 되면서** 올렸다(CLAUDE.md §4, 이 주석이 예고한 그대로다). 화면은 여기 남고
  /// 이름만 공용이며, 이 게터가 그 상수를 돌려준다.
  static String get routeName => searchRouteName;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  /// 입력창에 지금 쳐 있는 글자. 자동완성이 이 값을 따라간다(R9).
  ///
  /// 검색 상태의 `query`와 다르다 — 그쪽은 **제출된** 질의이고 이쪽은 타이핑
  /// 중인 문자열이다. 둘을 하나로 두면 입력할 때마다 결과가 날아간다.
  String _typed = '';

  /// 최근 검색어 패널이 열려 있는지.
  ///
  /// **검색 상태가 아니라 화면 로컬 상태다.** 패널은 결과 위에 잠깐 겹치는 것이라
  /// 결과·질의를 건드리지 않으며, 닫으면 보던 화면이 그대로 남는다 — 상태 기계에
  /// 여섯 번째 상태를 더할 일이 아니다(설계 §2의 다섯 상태는 조회 결과에 관한 것이다).
  bool _recentOpen = false;

  @override
  void initState() {
    super.initState();
    // 상세에서 돌아왔을 때 입력창도 질의를 그대로 들고 있어야 한다(AC-13.2).
    // 상태가 keepAlive라 결과는 남아 있는데 입력창만 비면 어긋나 보인다.
    _typed = _queryOf(ref.read(spotSearchProvider));
    _controller = TextEditingController(text: _typed);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 상태가 들고 있는 질의(초기 상태면 빈 문자열).
  static String _queryOf(SpotSearchState state) => switch (state) {
    SpotSearchIdle() => '',
    SpotSearchLoading(:final String query) => query,
    SpotSearchLoaded(:final String query) => query,
    SpotSearchEmpty(:final String query) => query,
    SpotSearchFailed(:final String query) => query,
  };

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SpotSearchState state = ref.watch(spotSearchProvider);

    // 최초 상태는 "전체"다(사용자 결정, 2026-08-15) — 심는 것이 없다.
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchTitle),
        bottom: PreferredSize(
          // 검색 필드 + 최근 검색어 버튼 줄 + 카테고리 바(88 — 원형 아이콘 디자인으로
          // 바뀌며 48에서 늘었다).
          preferredSize: const Size.fromHeight(200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  // 검색은 제출로 실행한다 — 입력마다 부르면 호출량이 급증하고,
                  // 자동완성(별도 provider)이 입력 중 보조를 맡는다(설계 §2).
                  onChanged: (String value) => setState(() => _typed = value),
                  onSubmitted: (String value) {
                    setState(() => _recentOpen = false);
                    ref.read(spotSearchProvider.notifier).search(value);
                  },
                ),
              ),
              _RecentSearchesButton(
                onPressed: () => setState(() => _recentOpen = !_recentOpen),
              ),
              // 카테고리 필터(R5). Discover·좋아요 목록과 같은 바를 쓰되 **선택은
              // 검색 전용 provider가 들고 있다** — 하나로 묶으면 Discover에서 고른
              // 필터가 검색 결과까지 갈아치운다.
              SpotCategoryBar(
                available:
                    ref.watch(availableSpotCategoriesProvider).value ??
                    const <SpotCategory>[],
                selected: ref.watch(spotSearchCategoryProvider),
                onToggle: _toggleCategory,
                onSelectAll: _selectAllCategories,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        // 최근 검색어를 **본문 위에 겹친다** — 결과를 보다가 열어도 그 결과가
        // 그대로 남아, 닫으면 보던 자리로 돌아온다.
        child: Stack(
          children: <Widget>[
            switch (state) {
              // 초기 상태에서 타이핑 중이면 자동완성을, 비어 있으면 최근 검색어를
              // 보여준다(R9·R12). 둘 다 "아직 검색하지 않았다"에 속하는 화면이다.
              SpotSearchIdle() =>
                _typed.trim().isEmpty
                    ? RecentSearchesList(onSelect: _searchFromRecent)
                    : SearchSuggestionList(
                        query: _typed,
                        onSelect: _searchFromSuggestion,
                      ),
              SpotSearchLoading() => const SearchResultSkeleton(),
              SpotSearchLoaded(:final result, :final isLoadingMore) =>
                SearchResultList(
                  result: result,
                  // 강조에 쓸 질의 — 결과와 같은 것이라 상태에서 꺼낸다.
                  query: _queryOf(state),
                  isLoadingMore: isLoadingMore,
                  onLoadMore: () =>
                      ref.read(spotSearchProvider.notifier).loadMore(),
                  onSelect: _openDetail,
                ),
              SpotSearchEmpty() => _Message(text: l10n.searchEmptyResult),
              SpotSearchFailed() => _Failure(
                onRetry: () => ref.read(spotSearchProvider.notifier).retry(),
              ),
            },
            // 초기 상태에서는 최근 검색어가 이미 본문이라 패널을 얹지 않는다 —
            // 같은 목록이 두 번 그려진다.
            if (_recentOpen && state is! SpotSearchIdle)
              _RecentPanel(
                onSelect: _searchFromRecent,
                onClose: () => setState(() => _recentOpen = false),
              ),
          ],
        ),
      ),
    );
  }

  /// 최근 검색어를 누르면 그 질의로 검색하고 입력창도 같은 값으로 맞춘다.
  void _searchFromRecent(String query) => _searchWith(query);

  /// 자동완성 제안을 누르면 그 제목으로 검색한다(R9).
  void _searchFromSuggestion(String title) => _searchWith(title);

  void _searchWith(String query) {
    _controller.text = query;
    // 검색을 실행하면 패널은 역할을 다했다 — 결과를 가리지 않도록 닫는다.
    setState(() {
      _typed = query;
      _recentOpen = false;
    });
    ref.read(spotSearchProvider.notifier).search(query);
  }

  /// 카테고리를 고르면 **같은 질의로 처음부터 다시 조회한다**(R5).
  ///
  /// 아직 검색 전이면 선택만 기억한다 — 다음 검색에 그 필터가 실린다.
  void _toggleCategory(SpotCategory category) {
    ref.read(spotSearchCategoryProvider.notifier).toggle(category);
    _afterCategoryChange();
  }

  /// "전체"를 누르면 필터를 풀고 같은 질의로 다시 조회한다.
  void _selectAllCategories() {
    ref.read(spotSearchCategoryProvider.notifier).selectAll();
    _afterCategoryChange();
  }

  void _afterCategoryChange() {
    setState(() => _recentOpen = false);
    ref.read(spotSearchProvider.notifier).reapplyCategory();
  }

  /// 결과를 선택하면 그 spot의 상세로 간다(AC-13.1).
  ///
  /// **카테고리는 넘기지 않는다**(SPEC-0020) — 서버가 상세를 spot 자신의 카테고리로
  /// 해석한다. `thumb`는 본문 조회를 기다리는 동안 깜빡임을 없앤다.
  ///
  /// **`push`라서 돌아오면 이 화면이 그대로 살아 있다**(AC-13.2) — 검색 상태가
  /// keepAlive이므로 질의와 결과가 유지된다.
  void _openDetail(TouristSpot spot) {
    // 지도에서 열었으면 고른 장소를 돌려주고 닫는다 — 지도가 그 좌표로 이동한다.
    //
    // **`TouristSpot`이 아니라 `PickedPlace`로 옮겨 준다.** 지도가 그 타입을
    // import하면 교차 feature 의존이 생기고, 피하려고 `dynamic`을 쓰면 런타임에
    // 깨진다(그 타입 주석 참조). 변환은 타입을 아는 이쪽이 맡는다.
    if (widget.returnsPickedSpot) {
      final Coordinates? coordinates = spot.coordinates;
      // 좌표가 없으면 옮길 곳이 없다 — 그런 결과는 기존대로 상세로 보낸다.
      if (coordinates != null) {
        context.pop(
          PickedPlace(
            id: spot.id,
            name: spot.name,
            coordinates: coordinates,
            // 서버 `code`를 싣는다(SPEC-0020) — 지도 마커가 쓰는 표기와 같다.
            categoryName: spot.category?.code,
            // **검색 목록과 같은 폴백을 쓴다**(`search_result_list.dart`).
            // `thumbnailImageUrl`이 비는 경우가 있어 그것만 보면 사진 없는 마커가
            // 된다 — 목록에는 사진이 보이는데 지도에만 안 보이던 이유다.
            thumbnailUrl: spot.thumbnailImageUrl ?? spot.imageRef,
          ),
        );
        return;
      }
    }

    // 상세가 운영정보를 받으려면 카테고리 코드가 필요하다(상세 응답은 null로 온다).
    ref
        .read(spotCategoryCodesProvider.notifier)
        .remember(spot.id, spot.category?.code);
    // `openSpotDetail` 헬퍼를 쓰지 않는 경로라(위 `remember`가 선행돼야 한다)
    // 여기서 직접 남긴다.
    AppAnalytics.logEvent(AnalyticsEvents.spotDetailView, <String, Object>{
      AnalyticsParams.from: 'search',
    });
    context.pushNamed(
      SpotDetailView.routeName,
      pathParameters: <String, String>{'id': spot.id},
      queryParameters: <String, String>{
        if (spot.thumbnailImageUrl != null) 'thumb': spot.thumbnailImageUrl!,
      },
    );
  }
}

/// 빈 결과 문구. **재시도 버튼을 두지 않는다** — 실패가 아니기 때문이다(AC-11.2).
class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// 실패 상태 — 빈 결과와 달리 재시도 수단을 준다(AC-11.3).
class _Failure extends StatelessWidget {
  const _Failure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.searchError,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: Text(l10n.searchRetry)),
          ],
        ),
      ),
    );
  }
}

/// 최근 검색어를 여닫는 텍스트 버튼.
///
/// **기록이 있을 때만 보인다.** 없으면 눌러도 빈 목록이 뜨는 버튼이 되고, 처음
/// 쓰는 사용자에게 의미 없는 자리를 차지한다. 그래서 목록 길이를 직접 구독한다 —
/// `select`로 좁혀, 항목이 바뀌어도 개수가 그대로면 이 버튼은 다시 그리지 않는다.
class _RecentSearchesButton extends ConsumerWidget {
  const _RecentSearchesButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasHistory = ref.watch(
      recentSearchesProvider.select((List<String> q) => q.isNotEmpty),
    );
    if (!hasHistory) return const SizedBox(height: 8);

    final AppLocalizations l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.history, size: 18),
          label: Text(l10n.searchRecentOpen),
        ),
      ),
    );
  }
}

/// 결과 위에 겹치는 최근 검색어 패널.
///
/// 뒤 배경을 눌러도 닫힌다 — 패널 밖을 누르는 것이 "그만 보겠다"는 가장 자연스러운
/// 동작이고, 닫기 버튼만 두면 손가락을 위로 옮겨야 한다.
class _RecentPanel extends StatelessWidget {
  const _RecentPanel({required this.onSelect, required this.onClose});

  final void Function(String query) onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          // 배경 스크림 — 뒤 목록이 눌리지 않게 막으면서 닫기 제스처를 받는다.
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: ColoredBox(
              color: theme.colorScheme.scrim.withValues(alpha: 0.32),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: theme.colorScheme.surface,
              elevation: 3,
              child: RecentSearchesList(onSelect: onSelect, onClose: onClose),
            ),
          ),
        ],
      ),
    );
  }
}
