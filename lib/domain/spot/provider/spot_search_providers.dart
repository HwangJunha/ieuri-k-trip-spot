import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
// 페이지 모델은 공용 OffsetPage다 — 기능이 자기 페이지네이션을 만들지 않는다(§4).
import '../../../common/pagination/offset_page.dart';
import '../../../common/storage/search_radius_controller.dart';
import '../../../common/category/spot_category.dart';
import '../../../common/category/spot_category_selection.dart';
import '../model/spot_search_result.dart';
import '../model/spot_search_state.dart';
import '../model/spot_suggestion.dart';
import 'recent_searches_providers.dart';
import '../../../common/category/spot_category_toggle.dart';
import 'spot_providers.dart';
import '../../auth/provider/session_scope.dart';

part 'spot_search_providers.g.dart';

/// 검색 페이지가 한 번에 받는 결과 수. 계약 기본값(20)을 따른다.
const int spotSearchPageSize = 20;

/// 검색에 걸린 카테고리 필터(SPEC-0013 R5 · SPEC-0020 R2). **비어 있을 수 없는
/// 집합이다** — "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현이 없다.
///
/// **Discover의 [SelectedSpotCategory]와 별개다**(R12) — 같은 provider를 쓰면
/// Discover에서 고른 필터가 검색 결과까지 갈아치운다.
///
/// `keepAlive`인 이유는 검색 상태와 같다 — 상세를 다녀와도 고른 필터가 남아야
/// 결과와 어긋나지 않는다(AC-13.2·AC12.3).
///
/// **결과를 다시 받는 것은 호출부(화면)가 한다** — 이 provider는 조회 조건만 들고
/// 있고, 무엇을 언제 다시 조회할지는 검색 notifier가 정한다.
@Riverpod(keepAlive: true)
class SpotSearchCategory extends _$SpotSearchCategory with SpotCategoryToggle {
  @override
  Set<SpotCategory> build() {
    // 로그아웃하면 필터를 초기화한다.
    ref.watchSignedIn();
    return <SpotCategory>{};
  }
}

/// 검색 결과 상태 기계(R11).
///
/// **자동완성과 분리되어 있다**(설계 §2) — 자동완성은 입력할 때마다 갱신되므로 이
/// 상태에 섞으면 타이핑 중에 로딩 표시가 요동친다.
///
/// `keepAlive`인 이유는 AC-13.2다 — 결과에서 상세로 갔다 돌아왔을 때 질의와 결과가
/// 그대로 있어야 한다. autoDispose면 상세로 이동하는 동안 화면이 트리에서 빠지면서
/// 상태가 버려지고, 돌아오면 빈 검색 페이지가 된다.
@Riverpod(keepAlive: true)
class SpotSearch extends _$SpotSearch {
  @override
  SpotSearchState build() {
    // 로그아웃하면 검색 결과를 버린다.
    ref.watchSignedIn();
    return const SpotSearchIdle();
  }

  /// 질의를 실행한다(AC-11.1~11.4, AC-12.1).
  ///
  /// 공백뿐인 질의는 서버를 부르지 않고 초기 상태로 되돌린다 — 서버가
  /// `EMPTY_QUERY`로 거절할 입력이고(R8), 사용자가 입력을 지운 상황이므로 최근
  /// 검색어를 다시 보여주는 것이 맞다.
  Future<void> search(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const SpotSearchIdle();
      return;
    }

    state = SpotSearchLoading(trimmed);

    // 검색을 실행한 시점에 기록한다(AC-12.1) — 성공 여부와 무관하다. 사용자가
    // 무엇을 찾으려 했는지가 기록의 뜻이고, 서버 실패로 그것이 사라지면 재시도할
    // 발판이 없어진다.
    await ref.read(recentSearchesProvider.notifier).record(trimmed);

    await _run(trimmed);
  }

  /// 카테고리 필터가 바뀌었을 때 **같은 질의로 처음부터 다시 조회한다**(R5).
  ///
  /// 페이지를 이어 붙이지 않고 0페이지부터 받는 이유는 필터가 바뀌면 결과 집합
  /// 자체가 달라져 이전 페이지와 이어지지 않기 때문이다.
  ///
  /// 아직 검색하지 않았다면(초기 상태) 아무것도 하지 않는다 — 고를 질의가 없다.
  Future<void> reapplyCategory() async {
    final String? query = switch (state) {
      SpotSearchIdle() => null,
      SpotSearchLoading(:final String query) => query,
      SpotSearchLoaded(:final String query) => query,
      SpotSearchEmpty(:final String query) => query,
      SpotSearchFailed(:final String query) => query,
    };
    if (query == null) return;

    state = SpotSearchLoading(query);
    await _run(query);
  }

  /// 실패한 질의를 그대로 다시 보낸다(AC-11.3).
  Future<void> retry() async {
    final SpotSearchState current = state;
    if (current is! SpotSearchFailed) return;

    state = SpotSearchLoading(current.query);
    await _run(current.query);
  }

  /// 현재 선택을 조회 변수로 접는다. 빈 집합은 null이 되어 인자가 생략된다
  /// (빈 배열은 서버가 거절한다, AC5.1).
  List<String>? _categoryCodes() =>
      SpotCategorySelection(ref.read(spotSearchCategoryProvider)).codesOrNull;

  Future<void> _run(String query) async {
    try {
      final Coordinates coords = await ref.read(
        currentCoordinatesProvider.future,
      );
      final double radiusKm = ref.read(searchRadiusControllerProvider);

      final SpotSearchResult result = await ref
          .read(spotRepositoryProvider)
          .searchSpots(
            query: query,
            latitude: coords.latitude,
            longitude: coords.longitude,
            radiusMeters: radiusMetersOf(radiusKm),
            // 빈 집합이면 인자를 생략해 전체를 받는다 — 빈 배열은 서버가
            // `EMPTY_CATEGORY_SET`으로 거절한다(SPEC-0020 AC5.1).
            categoryCodes: _categoryCodes(),
            page: 0,
            size: spotSearchPageSize,
          );

      // 결과 0건과 실패는 서로 다른 상태다(AC-11.2 vs AC-11.3).
      state = result.isEmpty
          ? SpotSearchEmpty(query)
          : SpotSearchLoaded(query: query, result: result);
    } catch (error) {
      // 질의 원문은 사용자 입력이라 로깅하지 않는다(POL-013).
      state = SpotSearchFailed(query);
    }
  }

  /// 다음 페이지를 이어 붙인다.
  ///
  /// 페이지 모델은 `common/pagination`의 [OffsetPage]이고 목록은
  /// `PaginationListView`가 그린다 — 기능이 자기 페이지네이션을 만들지 않는다
  /// (CLAUDE.md §4).
  ///
  /// **오프셋 페이징이다** — 다음 장은 `page + 1`로 요청한다. 초안(스펙 §8.1)은
  /// 커서를 요구했으나 서버가 커서 방식에서 정확히 동작하지 않아 전환됐다.
  ///
  /// **중복 호출을 여기서 막는다** — `PaginationListView`는 바닥 근처에서 여러 번
  /// 발화할 수 있고, 그것을 거르는 것은 컨트롤러 몫이라고 그 위젯이 명시한다.
  Future<void> loadMore() async {
    final SpotSearchState current = state;
    if (current is! SpotSearchLoaded) return;
    if (!current.result.hasNextPage || current.isLoadingMore) return;

    state = current.copyWith(isLoadingMore: true);
    try {
      final Coordinates coords = await ref.read(
        currentCoordinatesProvider.future,
      );
      final double radiusKm = ref.read(searchRadiusControllerProvider);

      final SpotSearchResult next = await ref
          .read(spotRepositoryProvider)
          .searchSpots(
            query: current.query,
            latitude: coords.latitude,
            longitude: coords.longitude,
            radiusMeters: radiusMetersOf(radiusKm),
            // 첫 페이지와 **같은 필터로** 이어 받는다 — 도중에 바뀌면 화면이
            // 처음부터 다시 조회하므로 이 경로는 실행되지 않는다.
            categoryCodes: _categoryCodes(),
            page: current.result.pageNumber + 1,
            size: spotSearchPageSize,
          );

      state = SpotSearchLoaded(
        query: current.query,
        result: current.result.append(next),
      );
    } catch (error) {
      // 추가 로딩 실패는 화면 전체를 실패로 만들지 않는다 — 이미 본 결과가 남는다.
      state = current.copyWith(isLoadingMore: false);
    }
  }
}

/// 자동완성 디바운스 간격.
///
/// 스펙이 클라이언트 재량으로 남긴 값이다(§9.3 — "매 키 입력마다 호출하지 않는다"가
/// 요건이고 간격은 체감 반응성과 호출량의 균형). 250ms는 한 글자 더 치는 사이에는
/// 나가지 않고 손을 멈추면 곧 뜨는 값이다.
const Duration suggestionDebounce = Duration(milliseconds: 250);

/// 검색어 자동완성(R9).
///
/// **결과 상태 기계와 별개의 provider다**(설계 §2) — 입력 중 계속 갱신되므로 결과
/// 상태에 섞으면 타이핑할 때마다 로딩 표시가 요동친다.
///
/// `autoDispose`(codegen 기본)라 질의가 바뀌면 이전 provider가 폐기된다. 디바운스가
/// 그 폐기를 이용한다 — 대기 중에 버려지면 조회를 내보내지 않는다.
@riverpod
Future<List<SpotSuggestion>> spotSearchSuggestions(
  Ref ref,
  String query,
) async {
  final String trimmed = query.trim();
  // 빈 질의는 서버를 부르지 않는다. 서버도 빈 목록으로 답하지만(AC-9.4) 왕복이
  // 낭비다 — 화면이 최근 검색어를 보여주는 구간이다.
  if (trimmed.isEmpty) return const <SpotSuggestion>[];

  // 반경을 **`await`보다 먼저 읽는다.** 비동기 gap 뒤의 `ref.watch`는 의존성으로
  // 등록되지 않아, 디바운스 뒤에 두면 설정에서 반경을 바꿔도 제안이 갱신되지 않는다.
  final double radiusKm = ref.watch(searchRadiusControllerProvider);

  // 디바운스: 이 사이에 질의가 바뀌면 provider가 폐기되고 호출은 나가지 않는다.
  bool disposed = false;
  ref.onDispose(() => disposed = true);
  await Future<void>.delayed(suggestionDebounce);
  if (disposed) return const <SpotSuggestion>[];

  final Coordinates coords = await ref.watch(currentCoordinatesProvider.future);

  return ref
      .watch(spotRepositoryProvider)
      .spotSearchSuggestions(
        query: trimmed,
        latitude: coords.latitude,
        longitude: coords.longitude,
        radiusMeters: radiusMetersOf(radiusKm),
      );
}
