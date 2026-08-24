
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/locale_controller.dart';
import 'package:logger/logger.dart';

import '../../../common/log/app_log.dart';
import '../../../common/pagination/page.dart';
import '../model/liked_spot.dart';
import '../../../common/category/spot_category.dart';
import '../../../common/category/spot_category_selection.dart';
import '../repository/spot_repository.dart';
import 'retry_counting.dart';
import '../../../common/category/spot_category_toggle.dart';
import 'spot_providers.dart';
import '../../auth/provider/session_scope.dart';

part 'liked_spots_providers.g.dart';

/// 한 번에 받아오는 좋아요 항목 수. 목록 화면이라 스와이프(100장)만큼 쌓아둘 이유가
/// 없다 — 화면에 보이는 만큼과 약간의 여유면 충분하다.
const int _pageSize = 20;

/// 좋아요 목록의 누적 상태(SPEC-0008 R-18).
///
/// 커서 페이징이라 [CursorPage]의 `endCursor`를 다음 조회의 `after`로 넘긴다. 화면은
/// 지금까지 받은 [items]를 이어서 보여주고, [hasMore]가 true인 동안 [loadMore]로
/// 다음 장을 덧붙인다.
///
/// 정렬은 서버가 보장하므로 **클라이언트가 재정렬하지 않는다**(§5.2) — 받은 순서를
/// 그대로 이어 붙이기만 한다.
class LikedSpotsState {
  const LikedSpotsState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  /// 지금까지 받은 항목 전부(페이지 경계 없이 이어 붙인 것).
  final List<LikedSpot> items;

  /// 다음 페이지 존재 여부. false면 소진 상태다.
  final bool hasMore;

  /// 다음 조회에 넘길 커서. 소진했으면 보통 null.
  final String? endCursor;

  /// 추가 페이지를 받는 중인지. 첫 로딩(AsyncValue.loading)과 구분해 하단
  /// 인디케이터만 띄우기 위한 값이다.
  final bool isLoadingMore;

  /// 항목이 하나도 없고 더 받을 것도 없는 상태 — 빈 목록 문구를 띄운다.
  bool get isEmpty => items.isEmpty && !hasMore;

  LikedSpotsState copyWith({
    List<LikedSpot>? items,
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

/// 좋아요 목록의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
/// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
///
/// Discover의 `selectedSpotCategory`와 **일부러 분리한다**(R12). 같은 provider를 쓰면
/// 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치워, 탭을 옮겼을 때 보고 있던
/// 카드가 사라진다. 두 화면의 필터는 서로 독립이다.
///
/// keepAlive인 이유는 Discover의 것과 같다 — 사용자가 고른 필터는 화면이 아니라
/// 세션에 속한다(AC12.3). autoDispose면 상세에 다녀오는 것만으로 초기화된다.
@Riverpod(keepAlive: true)
class SelectedLikedCategory extends _$SelectedLikedCategory
    with SpotCategoryToggle {
  @override
  Set<SpotCategory> build() {
    // 로그아웃하면 필터를 초기화한다.
    ref.watchSignedIn();
    return <SpotCategory>{};
  }
}

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18). [selection]별 패밀리 — 선택을 바꾸면
/// 다른 인스턴스가 로딩되고, 필터링은 서버가 한다(클라이언트가 받은 목록을 거르지
/// 않는다).
///
/// family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유는 스와이프 컨트롤러와
/// 같다 — `Set`은 값 동등성이 없어 family 키로 쓸 수 없다.
///
/// 미인증이면 repository가 `UNAUTHENTICATED`를 [SpotFailure]로 던지고, 그것이
/// `AsyncValue.error`로 UI에 노출되어 SPEC-0005의 세션 갱신 경로를 탄다 — 이 스펙이
/// 별도 처리를 더하지 않는다(§5.2).
///
/// autoDispose(codegen 기본값)를 그대로 쓴다. 스와이프 큐와 달리 이 목록은 화면에
/// 속하고 서버가 정렬을 보장하므로, 탭을 떠났다 오면 다시 받는 것이 오히려 맞다 —
/// 상세에서 좋아요를 해제하고 돌아왔을 때 최신 목록을 보게 된다.
///
/// [spotRetryPolicy]로 자동 재시도를 묶는다(SPEC-0006 R1). Riverpod 기본값은 실패한
/// provider를 최대 10회 지수 백오프로 재조회하는데, 미인증 실패는 여기서 다시 조회해
/// 봐야 같은 실패가 날 뿐이고 그 폭주가 세션 갱신 경로와 겹친다 — 인증 실패에는
/// 재시도하지 않는 이 정책이 그것을 끊는다(R5).
@Riverpod(retry: spotRetryPolicy)
class LikedSpotsController extends _$LikedSpotsController {
  static final Logger _log = appLogger('LikedSpotsController');

  SpotRepository get _repository => ref.read(spotRepositoryProvider);

  @override
  Future<LikedSpotsState> build(SpotCategorySelection selection) async {
    // 언어를 바꾸면 목록을 다시 받는다. 좋아요 **자체는** SPEC-0019 이후 언어를 넘어
    // 유지되지만, 쌓아둔 항목의 제목·주소는 이전 언어로 받아온 문장이다. 좋아요 탭도
    // 셸 브랜치라 계속 mount되어 autoDispose가 돌지 않으므로, 이 구독이 없으면
    // 영어로 바꿔도 한국어 이름이 그대로 남는다.
    ref.watch(localeControllerProvider);

    final CursorPage<LikedSpot> page = await _repository.fetchLikedSpots(
      categoryCodes: selection.codesOrNull,
      first: _pageSize,
    );
    return LikedSpotsState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  /// 다음 페이지를 이어 붙인다. 더 받을 것이 없거나 이미 받는 중이면 아무것도
  /// 하지 않는다 — 스크롤 끝에서 중복 호출이 들어와도 안전하다.
  Future<void> loadMore() async {
    final LikedSpotsState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<LikedSpotsState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<LikedSpot> next = await _repository.fetchLikedSpots(
        // **첫 페이지와 같은 필터로 이어 받는다.** 예전에는 이 인자가 빠져 있어
        // 다음 장부터 필터가 풀렸다 — 커서만 잇고 조건을 바꾸면 서로 이어지지
        // 않는 두 목록을 붙이는 셈이다.
        categoryCodes: selection.codesOrNull,
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<LikedSpotsState>(
        LikedSpotsState(
          items: <LikedSpot>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      // 추가 로딩 실패는 이미 보고 있는 목록을 지우지 않는다 — 인디케이터만 걷고
      // 지금까지 받은 항목(common/pagination의 CursorPage로 받은 것)을 유지한다.
      // hasMore가 그대로라 다시 스크롤하면 재시도된다.
      //
      // 조용히 사라지면 디버깅할 수 없으므로 흔적은 남긴다. 서버 message는 PII를
      // 담을 수 있어 싣지 않고 실패 유형만 적는다(POL-013).
      _log.w('likedSpots loadMore failed: ${error.runtimeType}');
      state = AsyncData<LikedSpotsState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }
}
