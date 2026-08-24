import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/log/app_log.dart';
import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
import '../model/nearby_spot.dart';
import '../model/nearby_spot_category.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'nearby_spots_providers.g.dart';

/// 한 번에 받아오는 장소 수. 시트 한 화면을 넘게 채우면서도 첫 표시가 늦지 않을
/// 크기다.
///
/// **50은 서버가 그대로 지켜 준다**(라이브 확인 — `spots(size: 50)`이 50건을 돌려주며
/// 잘리지 않는다). 검색이 서버로 넘어간 뒤로는(SPEC-0013 R14) "많이 받아 둘수록 필터가
/// 넓게 짚는다"는 이유가 사라졌지만, 주변 목록 자체를 훑는 데는 이 크기가 여전히
/// 알맞아 그대로 둔다.
const int nearbySpotsPageSize = 50;

/// 조회 반경(미터). 컴포저에서 고르는 장소는 "지금 있는 곳 주변"이라 피드보다 좁게
/// 잡는다 — 5km 안에 이미 수천 건이 있어(라이브 확인) 더 넓힐 이유가 없다.
const int nearbySpotsRadiusMeters = 5000;

/// 장소 선택 시트에 입력한 검색어.
///
/// **주변 탭에서는 서버 검색어다**(SPEC-0013 R14) — 값이 있으면 시트가
/// `searchSpots`를 부르고, 지우면 좌표 기반 목록으로 돌아온다(AC-14.3).
/// 좋아요 탭에서는 여전히 이미 받아 둔 목록을 좁히는 이름 필터다 — `searchSpots`는
/// 좌표 기반 반경 검색이라 "내가 좋아요한 것 중에서"를 표현할 수 없다.
///
/// 필터는 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다 — 시트를
/// 닫으면 사라지는 것이 맞다.
@riverpod
class NearbySpotQuery extends _$NearbySpotQuery {
  @override
  String build() => '';

  void set(String value) => state = value;
}

/// 장소 선택 시트의 카테고리 줄 구성.
///
/// **언어마다 목록이 다르다**(라이브 확인 — ko에는 `TRAVEL_COURSE`가, en에는 그 자리에
/// `TRANSPORT`가 있다). 그래서 클라이언트가 값을 하드코딩하지 않고 상단 칩과 같이
/// 서버가 준 것만 그린다. **빈 목록도 정상**이라 그때는 줄 자체를 그리지 않는다.
///
/// 목록 조회와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다 —
/// 카테고리 줄이 못 떠도 주변 장소 목록은 그대로 뜬다.
@Riverpod(retry: communityRetryPolicy)
Future<List<NearbySpotCategory>> nearbySpotCategories(Ref ref) =>
    ref.watch(communityRepositoryProvider).fetchNearbySpotCategories();

/// 장소 선택 시트가 지금 보고 있는 출처.
///
/// **주변이 기본이다** — 컴포저에서 고르는 장소는 대개 "지금 있는 곳"이고, 좋아요한
/// 장소는 그 목록에 없는 곳을 다시 찾아 붙일 때 쓰는 보조 경로다.
enum SpotPickerSource {
  /// 서버 `spots` — 좌표 기반, 오프셋 페이징, 거리 있음.
  nearby,

  /// 서버 `likedSpots` — 커서 페이징, 거리 없음(좌표 인자가 없다).
  liked,
}

/// 시트에서 지금 고른 출처(탭). 시트가 열려 있는 동안의 상태라 autoDispose다.
@riverpod
class SpotPickerSourceTab extends _$SpotPickerSourceTab {
  @override
  SpotPickerSource build() => SpotPickerSource.nearby;

  void set(SpotPickerSource value) => state = value;
}

/// 시트에서 지금 고른 카테고리. null이면 "전체"다.
///
/// **이름 필터와 달리 이 값은 서버로 간다** — 바뀌면 [NearbySpotsController]가
/// 페이지 0부터 다시 받는다(오프셋이 카테고리마다 다르므로 이어 붙일 수 없다).
///
/// 시트가 열려 있는 동안의 상태라 autoDispose(codegen 기본)로 둔다.
@riverpod
class NearbySpotCategoryFilter extends _$NearbySpotCategoryFilter {
  @override
  NearbySpotCategory? build() => null;

  void set(NearbySpotCategory? value) => state = value;
}

/// 시트가 누적한 주변 장소. 커서가 아니라 **오프셋 페이징**이라 [OffsetPage]의
/// `page`/`hasNext`를 그대로 이어 붙인다(CLAUDE.md §4 — 페이지네이션은 공용).
class NearbySpotsState {
  const NearbySpotsState({
    required this.items,
    required this.hasMore,
    required this.page,
    this.isLoadingMore = false,
  });

  /// 지금까지 받은 장소 전부(페이지 경계 없이 이어 붙인 것). 서버가 거리 오름차순
  /// 으로 주므로 **클라이언트가 다시 정렬하지 않는다.**
  final List<NearbySpot> items;
  final bool hasMore;

  /// 마지막으로 받은 페이지 번호(0-based).
  final int page;

  /// 추가 페이지를 받는 중인지. 첫 로딩(`AsyncValue.loading`)과 구분해 목록 끝에
  /// 인디케이터만 띄우기 위한 값이다.
  final bool isLoadingMore;

  /// 반경 안에 장소가 하나도 없는 상태. 위치 실패와는 **다른 상태**이며 시트가 둘을
  /// 구분해 보여준다.
  bool get isEmpty => items.isEmpty && !hasMore;

  // `filtered`는 SPEC-0013에서 **제거했다**(R14, AC-14.1). 주변 탭은 이제 이미 받아
  // 둔 목록을 거르는 대신 서버 `searchSpots`를 부른다 — 그 결과는
  // `SpotSearchList`가 들고 있다. 좋아요 탭은 좌표 기반 검색을 쓸 수 없어
  // `LikedSpotsState.filtered`가 그대로 남는다.

  NearbySpotsState copyWith({
    List<NearbySpot>? items,
    bool? hasMore,
    int? page,
    bool? isLoadingMore,
  }) => NearbySpotsState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    page: page ?? this.page,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 컴포저 장소 선택 시트의 목록.
///
/// 좌표는 앱이 이미 쓰고 있는 [currentCoordinatesProvider]를 그대로 쓴다. 위치를
/// 얻지 못하면 그 실패가 `AsyncValue.error`로 올라오고 **시트가 사유와 재시도를
/// 보여준다** — 빈 시트나 무한 스피너로 두지 않는다. 그 상태에서도 장소 없이 글을
/// 등록하는 길은 그대로 열려 있다(가이드 §5).
///
/// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리를 바꾸면 build가 다시
/// 돌아 페이지 0부터 받는다** — 오프셋이 카테고리마다 다르니 이어 붙일 수 없다.
@Riverpod(retry: communityRetryPolicy)
class NearbySpotsController extends _$NearbySpotsController {
  static const AppLog _log = AppLog('NearbySpotsController');

  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  @override
  Future<NearbySpotsState> build() async {
    final NearbySpotCategory? category = ref.watch(
      nearbySpotCategoryFilterProvider,
    );
    final Coordinates coords = await ref.watch(
      currentCoordinatesProvider.future,
    );
    final OffsetPage<NearbySpot> page = await _repository.fetchNearbySpots(
      latitude: coords.latitude,
      longitude: coords.longitude,
      radiusMeters: nearbySpotsRadiusMeters,
      category: category,
      page: 0,
      size: nearbySpotsPageSize,
    );
    return NearbySpotsState(
      items: page.items,
      hasMore: page.hasNext,
      page: page.page,
    );
  }

  /// 다음 페이지를 이어 붙인다. 더 받을 것이 없거나 이미 받는 중이면 아무것도 하지
  /// 않는다 — 스크롤 끝에서 중복 호출이 들어와도 안전하다.
  Future<void> loadMore() async {
    final NearbySpotsState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final Coordinates? coords = ref.read(currentCoordinatesProvider).value;
    // 첫 페이지를 받은 뒤이므로 좌표는 이미 있다. 없다면 조용히 멈춘다 — 여기서
    // 좌표를 새로 얻으면 걸어 다니는 사용자의 거리 정렬이 페이지마다 어긋난다.
    if (coords == null) return;

    state = AsyncData<NearbySpotsState>(current.copyWith(isLoadingMore: true));
    try {
      final OffsetPage<NearbySpot> next = await _repository.fetchNearbySpots(
        latitude: coords.latitude,
        longitude: coords.longitude,
        radiusMeters: nearbySpotsRadiusMeters,
        // 첫 페이지와 같은 카테고리로 이어 받는다 — 도중에 바뀌면 build가 다시 돌아
        // 이 경로는 애초에 실행되지 않는다.
        category: ref.read(nearbySpotCategoryFilterProvider),
        page: current.page + 1,
        size: nearbySpotsPageSize,
      );
      state = AsyncData<NearbySpotsState>(
        NearbySpotsState(
          items: <NearbySpot>[...current.items, ...next.items],
          hasMore: next.hasNext,
          page: next.page,
        ),
      );
    } on Object catch (error) {
      // 추가 로딩 실패는 이미 보고 있는 목록을 지우지 않는다 — 인디케이터만 걷는다.
      // 서버 message는 PII를 담을 수 있어 싣지 않고 실패 유형만 남긴다(POL-013).
      _log.warn('nearby spots loadMore failed: ${error.runtimeType}');
      state = AsyncData<NearbySpotsState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }
}

/// 시트 검색이 누적한 결과(SPEC-0013 R14).
///
/// **주변 목록과 같은 오프셋 페이징이다** — 초안은 커서였으나 서버가 커서 방식에서
/// 정확히 동작하지 않아 전환됐다. 다음 장은 `page + 1`로 요청한다.
class SpotSearchListState {
  const SpotSearchListState({
    required this.items,
    required this.hasMore,
    this.page = 0,
    this.isLoadingMore = false,
  });

  /// 지금까지 받은 결과 전부. 서버가 관련도·거리 순으로 주므로 **클라이언트가 다시
  /// 정렬하지 않는다**(POL-019).
  final List<NearbySpot> items;
  final bool hasMore;

  /// 마지막으로 받은 페이지 번호(0-based).
  final int page;

  /// 추가 페이지를 받는 중인지. 첫 로딩과 구분해 목록 끝에 인디케이터만 띄운다.
  final bool isLoadingMore;

  /// 질의에 맞는 결과가 하나도 없는 상태. **실패가 아니다**.
  bool get isEmpty => items.isEmpty && !hasMore;

  SpotSearchListState copyWith({
    List<NearbySpot>? items,
    bool? hasMore,
    int? page,
    bool? isLoadingMore,
  }) => SpotSearchListState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    page: page ?? this.page,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 시트 검색 결과(SPEC-0013 R14, AC-14.1·14.2).
///
/// **질의를 인자로 받는다**(family) — 질의가 바뀌면 Riverpod이 새 provider를 만들고
/// 이전 것을 폐기하므로, 이어 붙이던 커서가 자동으로 초기화된다. 질의를 상태로 들고
/// 있으면 그 초기화를 손으로 해야 하고, 한 번 빠뜨리면 이전 질의의 다음 페이지를
/// 새 질의 결과에 붙이게 된다.
///
/// **디바운스가 없다.** 시트는 검색어를 *제출*할 때만 질의를 갱신하므로(엔터 또는
/// 키보드의 검색), 한 글자마다 호출이 나가지 않는다 — 억제할 대상이 없다.
@Riverpod(retry: communityRetryPolicy)
class SpotSearchList extends _$SpotSearchList {
  static const AppLog _log = AppLog('SpotSearchList');

  @override
  Future<SpotSearchListState> build(String query) async {
    final String trimmed = query.trim();
    // 빈 질의면 조회하지 않는다 — 시트가 주변/좋아요 목록으로 되돌아간다(AC-14.3).
    if (trimmed.isEmpty) {
      return const SpotSearchListState(items: <NearbySpot>[], hasMore: false);
    }

    // 카테고리 칩을 **watch 한다** — 칩을 바꾸면 이 provider가 다시 빌드되어
    // 새 필터로 처음부터 조회한다. 주변 목록이 같은 값을 watch하는 것과 같다.
    //
    // **`await`보다 먼저 읽는다.** 비동기 gap 뒤의 `ref.watch`는 의존성으로
    // 등록되지 않아, 디바운스 뒤에 두면 칩을 바꿔도 재조회가 걸리지 않는다
    // (실제로 그렇게 두었다가 카테고리가 null로 나갔다).
    final NearbySpotCategory? category = ref.watch(
      nearbySpotCategoryFilterProvider,
    );

    final Coordinates coords = await ref.watch(
      currentCoordinatesProvider.future,
    );
    final OffsetPage<NearbySpot> result = await ref
        .read(communityRepositoryProvider)
        .searchSpots(
          query: trimmed,
          latitude: coords.latitude,
          longitude: coords.longitude,
          radiusMeters: nearbySpotsRadiusMeters,
          category: category,
          page: 0,
          size: nearbySpotsPageSize,
        );
    return SpotSearchListState(
      items: result.items,
      hasMore: result.hasNext,
      page: result.page,
    );
  }

  /// 다음 페이지를 이어 붙인다(AC-14.2).
  ///
  /// **질의가 입력된 상태에서도 동작한다** — 이것이 이전 구현과의 차이다. 예전에는
  /// 클라이언트 필터라 "보이는 것이 몇 건이든 다음 페이지가 그 이름과 맞는다는
  /// 보장이 없어" 질의 중에는 페이징을 꺼야 했다.
  Future<void> loadMore() async {
    final SpotSearchListState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final Coordinates? coords = ref.read(currentCoordinatesProvider).value;
    // 첫 페이지를 받은 뒤이므로 좌표는 이미 있다(주변 목록과 같은 판단).
    if (coords == null) return;

    state = AsyncData<SpotSearchListState>(
      current.copyWith(isLoadingMore: true),
    );
    try {
      final OffsetPage<NearbySpot> next = await ref
          .read(communityRepositoryProvider)
          .searchSpots(
            query: query.trim(),
            latitude: coords.latitude,
            longitude: coords.longitude,
            radiusMeters: nearbySpotsRadiusMeters,
            // 첫 페이지와 같은 필터로 이어 받는다 — 도중에 바뀌면 build가 다시
            // 돌아 이 경로는 실행되지 않는다(주변 목록과 같은 판단).
            category: ref.read(nearbySpotCategoryFilterProvider),
            page: current.page + 1,
            size: nearbySpotsPageSize,
          );
      state = AsyncData<SpotSearchListState>(
        SpotSearchListState(
          items: <NearbySpot>[...current.items, ...next.items],
          hasMore: next.hasNext,
          page: next.page,
        ),
      );
    } on Object catch (error) {
      // 추가 로딩 실패는 이미 보고 있는 목록을 지우지 않는다(주변 목록과 동일).
      _log.warn('spot search loadMore failed: ${error.runtimeType}');
      state = AsyncData<SpotSearchListState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }
}

/// 시트가 누적한 좋아요한 장소. 주변 목록과 달리 **커서 페이징**이라 `endCursor`를
/// 다음 조회의 `after`로 넘긴다.
///
/// 페이지 한 장은 공용 `common/pagination`의 `CursorPage`를 그대로 쓴다(CLAUDE.md §4 —
/// 기능이 자기 페이지네이션 모델을 새로 만들지 않는다). 이 클래스는 그 페이지들을
/// 화면용으로 **누적한 상태**이지 페이지 모델이 아니다.
///
/// [NearbySpotsState]와 필드가 겹치지만 **이어 붙이는 열쇠가 다르다**(페이지 번호 vs
/// 커서). 하나로 합치면 둘 중 하나는 늘 의미 없는 필드를 들고 다니게 된다.
class LikedSpotsState {
  const LikedSpotsState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  final List<NearbySpot> items;
  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  /// 좋아요한 장소가 하나도 없는 상태. **오류가 아니다** — 시트가 빈 안내를 그린다.
  bool get isEmpty => items.isEmpty && !hasMore;

  /// [query]로 좁힌 목록. 주변 목록과 같이 **이미 받아 둔 것만** 거른다.
  List<NearbySpot> filtered(String query) =>
      items.where((NearbySpot s) => s.matches(query)).toList(growable: false);

  LikedSpotsState copyWith({
    List<NearbySpot>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => LikedSpotsState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 장소 선택 시트의 "좋아요한 장소" 탭.
///
/// **좌표가 필요 없다** — `likedSpots`는 좌표 인자를 받지 않으므로 위치를 못 얻는
/// 상황에서도 이 탭은 그대로 돈다. 주변 탭이 위치 실패로 막혔을 때 장소를 붙일 수
/// 있는 유일한 길이기도 하다.
///
/// [nearbySpotCategoryFilterProvider]를 watch하므로 **카테고리 줄 하나가 두 탭에
/// 함께 걸린다** — 바꾸면 build가 다시 돌아 첫 페이지부터 받는다.
@Riverpod(retry: communityRetryPolicy)
class LikedSpotsController extends _$LikedSpotsController {
  static const AppLog _log = AppLog('LikedSpotsController');

  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  @override
  Future<LikedSpotsState> build() async {
    final NearbySpotCategory? category = ref.watch(
      nearbySpotCategoryFilterProvider,
    );
    final CursorPage<NearbySpot> page = await _repository.fetchLikedSpots(
      category: category,
      first: nearbySpotsPageSize,
    );
    return LikedSpotsState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  /// 다음 페이지를 이어 붙인다. 더 받을 것이 없거나 이미 받는 중이면 아무것도 하지
  /// 않는다 — 스크롤 끝에서 중복 호출이 들어와도 안전하다.
  Future<void> loadMore() async {
    final LikedSpotsState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<LikedSpotsState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<NearbySpot> next = await _repository.fetchLikedSpots(
        // 첫 페이지와 같은 카테고리로 이어 받는다 — 도중에 바뀌면 build가 다시 돌아
        // 이 경로는 애초에 실행되지 않는다.
        category: ref.read(nearbySpotCategoryFilterProvider),
        first: nearbySpotsPageSize,
        after: current.endCursor,
      );
      state = AsyncData<LikedSpotsState>(
        LikedSpotsState(
          items: <NearbySpot>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      // 추가 로딩 실패는 이미 보고 있는 목록을 지우지 않는다 — 인디케이터만 걷는다.
      // 서버 message는 PII를 담을 수 있어 싣지 않고 실패 유형만 남긴다(POL-013).
      _log.warn('liked spots loadMore failed: ${error.runtimeType}');
      state = AsyncData<LikedSpotsState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }
}
