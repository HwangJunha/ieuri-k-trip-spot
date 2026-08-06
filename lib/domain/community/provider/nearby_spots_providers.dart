import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/pagination/offset_page.dart';
import '../model/nearby_spot.dart';
import '../model/nearby_spot_category.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'nearby_spots_providers.g.dart';

/// 한 번에 받아오는 장소 수. 시트 한 화면을 넘게 채우면서도 첫 표시가 늦지 않을
/// 크기다.
///
/// **50은 서버가 그대로 지켜 준다**(라이브 확인 — `spots(size: 50)`이 50건을 돌려주며
/// 잘리지 않는다). 이름 필터가 이미 받아 둔 목록만 좁히므로, 한 번에 더 받아 둘수록
/// 그 필터가 짚을 수 있는 범위가 넓어진다.
const int nearbySpotsPageSize = 50;

/// 조회 반경(미터). 컴포저에서 고르는 장소는 "지금 있는 곳 주변"이라 피드보다 좁게
/// 잡는다 — 5km 안에 이미 수천 건이 있어(라이브 확인) 더 넓힐 이유가 없다.
const int nearbySpotsRadiusMeters = 5000;

/// 장소 선택 시트가 입력한 이름 필터.
///
/// **서버에 이름 검색 인자가 없다** — `spots`는 좌표 기반이다. 그래서 이 값은 이미
/// 받아 둔 목록만 좁히며, 시트가 그 사실을 문구로 알린다.
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

  /// [query]로 좁힌 목록. **이미 받아 둔 것만 거른다**(서버 검색이 아니다).
  List<NearbySpot> filtered(String query) =>
      items.where((NearbySpot s) => s.matches(query)).toList(growable: false);

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
      developer.log(
        'nearby spots loadMore failed: ${error.runtimeType}',
        name: 'NearbySpotsController',
      );
      state = AsyncData<NearbySpotsState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }
}
