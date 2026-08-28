
import '../../../common/network/network_retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/locale_controller.dart';
import 'package:logger/logger.dart';

import '../../../common/log/app_log.dart';
import '../../../common/pagination/page.dart';
import '../model/liked_spot.dart';
import '../model/liked_spots_query.dart';
import '../../../common/category/spot_category.dart';
import '../repository/spot_repository.dart';
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

/// 좋아요 목록의 검색어(SPEC-0033).
///
/// **화면 `State`가 아니라 provider가 들고 있다.** `loadMore`·재시도·`invalidate`가
/// 모두 family 키를 통해 도는데, 검색어가 위젯 안에만 있으면 그 경로들이 검색어를
/// 모른다 — 카테고리 선택([SelectedLikedCategory])을 provider로 둔 것과 같은 이유다.
///
/// **디바운스된 값이다.** 입력창이 들고 있는 타이핑 중 문자열과 다르다 — 이쪽은
/// 조회를 트리거하는 확정 값이라, 타자 한 글자마다 갱신하면 매 글자 재조회가 된다.
///
/// keepAlive가 아닌 이유는 카테고리 선택과 반대다 — 탭을 떠나면 검색어를 버리고
/// 다음 진입은 빈 입력으로 시작한다(§입력 처리). 다만 좋아요 탭은 셸 브랜치라
/// 계속 mount되어 autoDispose가 저절로 돌지 않으므로, 화면이 탭 이탈을 감지해
/// [LikedSpotsSearchQuery.clear]를 부른다.
@riverpod
class LikedSpotsSearchQuery extends _$LikedSpotsSearchQuery {
  @override
  String build() {
    // 로그아웃하면 검색어도 버린다.
    ref.watchSignedIn();
    return '';
  }

  /// 입력에서 온 검색어를 확정한다. **앞뒤 공백을 털고 100자로 자른다** —
  /// `EMPTY_QUERY`·`QUERY_TOO_LONG`은 방어선이지 정상 경로가 아니므로 입력
  /// 단계에서 막는다(§입력 처리).
  void set(String value) {
    final String trimmed = value.trim();
    state = trimmed.length > likedSpotsQueryMaxLength
        ? trimmed.substring(0, likedSpotsQueryMaxLength)
        : trimmed;
  }

  void clear() => state = '';
}

/// 이 세션에서 **필터도 검색어도 없는** 좋아요 목록이 비어 있지 않은 것을 본 적이
/// 있는지(SPEC-0033 §두 개의 빈 상태).
///
/// 검색 결과 0건과 좋아요 0건을 가르려면 "필터를 걷어낸 좋아요가 있는가"를 알아야
/// 하는데, 서버는 그 총량을 따로 주지 않는다(라이브 `LikedSpotConnection`에
/// `totalCount`가 없다). 그래서 **왕복을 늘리지 않고** 관측한다 — 필터도 검색어도
/// 없는 조회는 그 자체가 전체 목록이므로, 그때 받은 결과가 답이다.
///
/// keepAlive다. 검색어를 치는 순간 컨트롤러의 키가 바뀌어 필터 없는 인스턴스가
/// 버려지므로, autoDispose면 판정 근거가 그와 함께 사라진다.
@Riverpod(keepAlive: true)
class LikedSpotsPresence extends _$LikedSpotsPresence {
  @override
  bool build() {
    // **로그아웃에만 반응한다** — `ref.watchSignedIn()`을 쓰면 인증 판정이
    // loading→data로 자리잡는 것만으로도 build가 다시 돌아 이미 관측한 값이
    // false로 지워진다. 로그인 직후 첫 목록이 그 타이밍에 걸리면 좋아요가 있는데도
    // "아직 좋아요한 여행지가 없어요"가 뜬다. 다음 계정의 목록은 다시 봐야 하므로
    // 로그아웃이 확정되면 관측을 버린다.
    ref.listenSignedOut(() => state = false);
    return false;
  }

  /// 필터 없는 조회가 [hasItems]를 돌려줬음을 기록한다. 필터가 걸린 조회는
  /// 근거가 되지 않으므로 호출부가 거른다.
  void observe({required bool hasItems}) => state = hasItems;
}

/// 검색어 상한(SPEC-0033 §입력 처리). 서버 `QUERY_TOO_LONG`과 같은 값이며,
/// 입력에서 막으므로 그 오류가 실제로 올 일은 없어야 한다.
const int likedSpotsQueryMaxLength = 100;

/// 검색어 확정까지 기다리는 시간(SPEC-0033 §입력 처리 — "대기 시간은 이 저장소가
/// 정한다").
///
/// 자동완성(`suggestionDebounce`, 250ms)보다 길게 잡았다 — 이쪽은 제안 목록이
/// 아니라 **목록 전체를 갈아 끼우는 재조회**라, 타자 사이에 목록이 두 번 깜빡이는
/// 것이 250ms에서 눈에 띈다.
const Duration likedSpotsSearchDebounce = Duration(milliseconds: 300);

/// 좋아요 목록 컨트롤러(SPEC-0008 R-18 · SPEC-0033). [query]별 패밀리 — 카테고리
/// 선택이나 검색어를 바꾸면 다른 인스턴스가 로딩되고, 필터링은 서버가 한다
/// (클라이언트가 받은 목록을 거르지 않는다).
///
/// family 인자가 `Set`이나 `String` 조합이 아니라 [LikedSpotsQuery]인 이유는 스와이프
/// 컨트롤러와 같다 — 값 동등성이 없는 타입은 family 키로 쓸 수 없다. **검색어가
/// 이 키에 들어가야** 검색어를 바꿨을 때 재조회가 일어난다(SPEC-0033 §핵심 배선).
///
/// 미인증이면 repository가 `UNAUTHENTICATED`를 [SpotFailure]로 던지고, 그것이
/// `AsyncValue.error`로 UI에 노출되어 SPEC-0005의 세션 갱신 경로를 탄다 — 이 스펙이
/// 별도 처리를 더하지 않는다(§5.2).
///
/// autoDispose(codegen 기본값)를 그대로 쓴다. 스와이프 큐와 달리 이 목록은 화면에
/// 속하고 서버가 정렬을 보장하므로, 탭을 떠났다 오면 다시 받는 것이 오히려 맞다 —
/// 상세에서 좋아요를 해제하고 돌아왔을 때 최신 목록을 보게 된다.
///
/// 공통 정책으로 자동 재시도를 묶는다. Riverpod 기본값은 실패한
/// provider를 최대 10회 지수 백오프로 재조회하는데, 미인증 실패는 여기서 다시 조회해
/// 봐야 같은 실패가 날 뿐이고 그 폭주가 세션 갱신 경로와 겹친다 — 인증 실패에는
/// 재시도하지 않는 이 정책이 그것을 끊는다(R5).
@Riverpod(retry: defaultNetworkRetry)
class LikedSpotsController extends _$LikedSpotsController {
  static final Logger _log = appLogger('LikedSpotsController');

  SpotRepository get _repository => ref.read(spotRepositoryProvider);

  @override
  Future<LikedSpotsState> build(LikedSpotsQuery query) async {
    // 언어를 바꾸면 목록을 다시 받는다. 좋아요 **자체는** SPEC-0019 이후 언어를 넘어
    // 유지되지만, 쌓아둔 항목의 제목·주소는 이전 언어로 받아온 문장이다. 좋아요 탭도
    // 셸 브랜치라 계속 mount되어 autoDispose가 돌지 않으므로, 이 구독이 없으면
    // 영어로 바꿔도 한국어 이름이 그대로 남는다.
    ref.watch(localeControllerProvider);

    final CursorPage<LikedSpot> page = await _repository.fetchLikedSpots(
      categoryCodes: query.selection.codesOrNull,
      query: query.queryOrNull,
      first: _pageSize,
    );
    // 필터도 검색어도 없는 조회만이 "좋아요가 하나라도 있는가"의 근거다 — 빈 상태
    // 문구를 가르는 데 쓴다(SPEC-0033 §두 개의 빈 상태). 필터가 걸린 조회의 0건은
    // 좋아요가 없다는 뜻이 아니다.
    if (query.selection.isEmpty && !query.hasQuery) {
      ref
          .read(likedSpotsPresenceProvider.notifier)
          .observe(hasItems: page.items.isNotEmpty);
    }
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
        // 않는 두 목록을 붙이는 셈이다. 검색어도 같은 이유로 함께 싣는다
        // (SPEC-0033 §핵심 배선 — 첫 페이지만 필터되는 것이 가장 나오기 쉬운 버그다).
        categoryCodes: query.selection.codesOrNull,
        query: query.queryOrNull,
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
