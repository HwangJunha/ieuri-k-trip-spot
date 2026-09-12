import 'dart:ui' show Locale;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/localization/locale_controller.dart';
import 'package:logger/logger.dart';

import '../../../common/log/app_log.dart';
import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/storage/search_radius_controller.dart';
import '../model/retry_budget.dart';
import '../model/retry_exhausted.dart';
import '../../../common/category/spot_category.dart';
import '../../../common/category/spot_category_selection.dart';
import '../model/spot_failure.dart';
import '../model/spot_reaction.dart';
import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../model/swipe_queue.dart';
import '../model/tourist_spot.dart';
import '../repository/spot_repository.dart';
import 'retry_budget_providers.dart';
import 'retry_counting.dart';
import '../../../common/category/spot_category_toggle.dart';
import 'spot_providers.dart';
import '../../auth/provider/session_scope.dart';

part 'swipe_providers.g.dart';

/// 한 묶음의 크기(spec §4 방향 변경). `recommendedSpots(first: 100)` — 서버 상한도
/// 100이다(SPEC-0035 AC-1.3).
const int _bundleSize = 100;

/// 잔여 카드가 이 값 미만으로 떨어지면 다음 묶음을 선제 조회한다. 100장을 받아
/// 두고 10장 미만이 남으면 다음 묶음을 이어 붙여 스택이 끊기지 않게 한다.
const int _prefetchThreshold = 10;

/// 활성 언어에서 서버가 노출하는 카테고리 목록(spec §5). 서버가 가용성의 단일
/// 출처이므로 CategoryBar는 이 결과만 렌더한다. 언어(locale)에 의존하므로 언어가
/// 바뀌면 자동 재조회된다.
@riverpod
Future<List<SpotCategory>> availableSpotCategories(Ref ref) {
  // 상태(Locale)를 watch 해야 언어 변경 시 재조회된다 — `.notifier`는 안정 인스턴스라
  // watch 해도 상태 변화에 반응하지 않는다.
  final Locale locale = ref.watch(localeControllerProvider);
  final AppLanguage language =
      AppLanguage.fromCode(locale.languageCode) ?? AppLanguage.english;
  return ref.watch(spotRepositoryProvider).fetchAvailableCategories(language);
}

/// Discover 스와이프의 카테고리 선택(SPEC-0020 R2). **비어 있을 수 없는 집합이다** —
/// "전체 보기"가 사라졌으므로 `null`("필터 없음")이라는 표현 자체가 없다.
///
/// [SwipeController]와 같은 이유로 `keepAlive`다 — autoDispose면 다른 탭에 다녀오는
/// 것만으로 선택이 초기화된다. 사용자가 고른 필터는 화면이 아니라 세션에 속한다
/// (AC12.3). R12의 "비영속"은 **재시작 기준**이라(AC12.2) 세션 내 유지와 충돌하지
/// 않는다 — 디스크에 쓰지 않는 것만을 요구한다.
@Riverpod(keepAlive: true)
class SelectedSpotCategory extends _$SelectedSpotCategory
    with SpotCategoryToggle {
  @override
  Set<SpotCategory> build() {
    // 로그아웃하면 필터를 초기화한다.
    ref.watchSignedIn();
    return <SpotCategory>{};
  }
}

/// 지금 살아 있는 스와이프 세션의 선택 집합(SPEC-0007 §4.2 지원).
///
/// **왜 필요한가.** 상세 화면이 "서버에서 사라진 카드"를 스와이프 세션에서 걷어낼 때,
/// 어느 세션에서 열렸는지 모르므로 살아 있는 세션 전부에 알려야 한다. 예전에는
/// `SpotCategory.values`를 훑어 카테고리 10개를 확인하면 됐지만, **다중 선택 이후로는
/// 가능한 조합이 2^n이라 열거할 수 없다.** 그래서 세션이 스스로 등록한다.
///
/// **provider가 아니라 평범한 집합인 이유.** provider로 두면 [SwipeController]의
/// `build`가 다른 provider의 상태를 바꾸게 되는데, Riverpod은 빌드 중 상태 변경을
/// 금지한다 — 실제로 그렇게 만들었더니 컨트롤러가 로딩에서 빠져나오지 못하고
/// 그대로 멈췄다(예외가 아니라 정지로 드러난다). 여기 담기는 것은 UI가 구독할
/// 상태가 아니라 "지금 존재하는 인스턴스의 명부"이므로 provider일 이유도 없다.
///
/// 등록·해제는 컨트롤러의 `build`/`onDispose`가 짝으로 한다. 컨테이너를 넘어 남지만
/// [SwipeController]가 `keepAlive`라 실질 수명이 같고, 없는 세션은 `ref.exists`가
/// 걸러낸다.
final Set<SpotCategorySelection> liveSwipeSessions = <SpotCategorySelection>{};

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [selection]별 패밀리 —
/// 선택 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// **family 인자가 `Set`이 아니라 [SpotCategorySelection]인 이유**(SPEC-0020):
/// Dart의 `Set`은 값 동등성이 없어, 원소가 같아도 매 빌드마다 새 키가 되어
/// keepAlive 세션이 무한히 쌓이고 피드를 계속 다시 받는다. 정렬된 코드 문자열로
/// 동등성을 정의한 값 객체가 그것을 막는다.
///
/// **소스는 `recommendedSpots` 묶음 하나다**(SPEC-0035, 사용자 결정 2026-09-12 —
/// 옛 `spots` 오프셋 "전체"는 뺐다. 거리는 이미 추천 점수의 가장 큰 요인이라 거리순
/// 전체 목록이 카드 화면에서 따로 가치가 없고, 지도 탭이 그 역할을 한다). 칩은
/// 추천 위에 `categories` 필터로 얹히며 빈 선택이 "필터 없는 추천"이다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 묶음(`first: 100`)을 조회해 [SwipeQueue]를 만든다.
///   **받은 순서를 섞지 않는다** — 서버 배열(점수 + 카테고리 반복 감점 + 취향)이
///   계약이고 사용자마다 이미 다르다(POL-019).
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 더 부를 만하면 **같은 인자로 다시 부르고**
///   받은 묶음에서 큐에 이미 있는 id와 이 세션에서 넘긴 id를 걷어낸 뒤 뒤에 붙인다
///   (AC-10.2). `first`보다 적게 오거나 걷어낸 뒤 새 카드가 0장이면 더 부르지 않는다
///   — 무한 재요청 방지.
/// - 소진: 큐가 비고 더 부를 것이 없으면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
///
/// SPEC-0007: 서버가 종료된 축제를 삭제하므로 쌓아둔 카드의 id가 세션 도중 해소
/// 불가가 될 수 있다. 그 경우 [dropMissingCard]로 해당 카드만 걷어내고 세션은
/// 계속한다(AC-43·AC-44) — 세션 전체를 실패로 만들지 않는다.
///
/// **`keepAlive`인 이유(CLAUDE.md §5의 근거 요구).** 이 상태는 화면이 아니라 *세션*에
/// 속한다. autoDispose면 카테고리를 옮기거나 다른 탭에 다녀오는 것만으로 큐가 버려지고,
/// 돌아왔을 때 `build()`가 다시 돌아 새 묶음을 받는다 — 이미 스와이프해 소비한
/// 카드의 반응이 아직 커밋되지 않았으면 되살아난다. 피드를 새로 받는 계기는 앱
/// 재시작·언어 전환·로그아웃·명시적 [reload]다.
@Riverpod(keepAlive: true, retry: spotRetryPolicy)
class SwipeController extends _$SwipeController {
  static final Logger _log = appLogger('SwipeController');

  SpotRepository get _repository => ref.read(spotRepositoryProvider);

  bool _isPrefetching = false;

  /// 이 세션에서 큐를 떠난 카드 id(스와이프·상세 소비·사라진 카드). 묶음을 보충할 때
  /// 겹침 제거에 함께 쓴다(SPEC-0035 §5) — 반응 뮤테이션이 서버에 커밋되기 전에
  /// 재요청하면 방금 넘긴 카드가 한 번 더 올 수 있고, 반응 전송이 실패한 카드도 이
  /// 세션 안에서는 다시 보이지 않는 편이 맞다. 세션(빌드)마다 비운다.
  final Set<String> _seenIds = <String>{};

  /// 이 선택의 재시도 예산(SPEC-0006 R4). 컨트롤러 바깥의 keepAlive provider라
  /// 재빌드를 넘어 살아남는다 — 인스턴스 필드에 두면 폭주 경로인 재빌드가 카운터를
  /// 초기화해 상한이 무의미해진다(설계문서 §2.2).
  ///
  /// 캐시 키는 정렬된 코드 문자열이다 — 예전에는 Dart enum 이름(`.name`)이었으나
  /// 그 표현이 사라졌고, 선택 순서가 예산을 가르면 안 되므로 정렬된 값을 쓴다.
  String get _retryScope => swipeRetryScope(selection.codes.join(','));

  SpotRetryBudget get _budget =>
      ref.read(spotRetryBudgetProvider(_retryScope).notifier);

  RetryBudget get _budgetState =>
      ref.read(spotRetryBudgetProvider(_retryScope));

  @override
  Future<SwipeQueue> build(SpotCategorySelection selection) async {
    // 살아 있는 세션으로 등록한다 — 상세 화면이 사라진 카드를 걷어낼 때 훑을 목록이다.
    // 다중 선택 이후로는 가능한 조합을 열거할 수 없어 세션이 스스로 알린다.
    liveSwipeSessions.add(selection);
    ref.onDispose(() => liveSwipeSessions.remove(selection));
    _seenIds.clear();

    // 언어가 바뀌면 세션을 통째로 다시 만든다(SPEC-0007 §4.5·R-14). **이제 id 때문이
    // 아니다** — SPEC-0019에서 id가 언어 무관해져 옛 카드로도 상세·반응이 통한다.
    // 다시 받는 이유는 카드에 박힌 제목·주소가 이전 언어의 문장이기 때문이다.
    // **값은 쓰지 않고 재빌드 트리거로만 구독한다** — 지우면 R-14가 깨진다.
    ref.watch(localeControllerProvider);

    // 로그아웃도 같은 이유로 세션을 버린다. 큐와 소비한 카드는 그 사람의
    // 것이라 다음 사용자에게 넘기면 안 된다 — 위 주석의 "앱 재시작·언어
    // 전환·명시적 reload"에 로그아웃이 빠져 있었다.
    ref.watchSignedIn();

    // 좌표는 watch 한다 — 위치가 바뀌면 피드를 다시 받아야 하기 때문이다. 그 재빌드가
    // 실패 상태에서 폭주하지 않도록 막는 것이 아래 상한 확인이다(R1).
    final Coordinates coords = await ref.watch(
      currentCoordinatesProvider.future,
    );

    // 검색 반경도 watch 한다(SPEC-0011 R13) — 설정에서 반경을 바꾸면 **피드를 다시
    // 받아야 한다.** 좌표와 같은 성격의 조회 조건이라 같은 자리에서 구독한다.
    //
    // read로 하면 값은 읽히지만 재빌드 계기가 없어, 설정을 바꾸고 돌아와도 옛 반경의
    // 카드가 그대로 남는다(실제로 그렇게 보고됐다).
    final double radiusKm = ref.watch(searchRadiusControllerProvider);

    // 상한을 이미 소진했으면 repository를 호출하지 않고 종료 상태를 그대로 돌려준다
    // (AC-11·AC-12). 재빌드가 몇 번 일어나도 조회 횟수는 늘지 않는다. 원인은 예산이
    // 들고 있던 실제 실패를 쓴다 — 지어내면 로깅·분기가 실제와 어긋난다.
    final RetryBudget budget = _budgetState;
    if (budget.isExhausted) {
      throw RetryExhausted(budget.lastFailure ?? SpotFailure.network);
    }

    return _fetchFirstBundle(coords, radiusKm);
  }

  /// 첫 묶음을 조회하고 실패를 상한에 계상한다. 계상 대상은 설계문서 §2.3의 표를
  /// 따른다 — 인증 실패는 SPEC-0005 갱신 경로 소관이라 계상하지 않는다(AC-14·AC-15).
  Future<SwipeQueue> _fetchFirstBundle(
    Coordinates coords,
    double radiusKm,
  ) async {
    try {
      // **한 번만 받는다**(SPEC-0029). 서버가 활성 언어의 장소만 주므로 원문·번역을
      // 갈라 두 번 조회하던 구간이 사라졌다. 다른 언어에만 있는 장소가 결과에서
      // 빠지는 것은 오류가 아니라 정상이며, 그 지역이 비면 그대로 소진 상태다.
      final List<TouristSpot> bundle = await _fetchBundle(coords, radiusKm);
      return SwipeQueue(
        cards: bundle,
        // first보다 적게 왔으면 반경 안 후보가 소진된 것이다(AC-10.2).
        hasNextPage: bundle.length >= _bundleSize,
      );
    } catch (error) {
      if (!countsTowardRetryBudget(error)) rethrow;

      _budget.countFailure(error);
      // 이번 실패로 상한을 다 썼으면 일반 오류가 아니라 종료 상태로 승격한다
      // (AC-5·AC-6) — 화면이 재시도 버튼만 있는 오류와 구분해 그린다.
      if (_budgetState.isExhausted) throw RetryExhausted(error);
      rethrow;
    }
  }

  /// 묶음 한 번. 첫 조회와 보충이 **같은 인자**를 쓴다 — 서버가 이미 반응한 장소를
  /// 빼 주므로 "다음"을 표현할 인자가 없다(SPEC-0035 §4).
  Future<List<TouristSpot>> _fetchBundle(Coordinates coords, double radiusKm) =>
      _repository.fetchRecommendedSpots(
        latitude: coords.latitude,
        longitude: coords.longitude,
        radiusMeters: radiusMetersOf(radiusKm),
        categoryCodes: selection.codesOrNull,
        first: _bundleSize,
      );

  /// 맨 위 카드를 [reaction]으로 처리한다. 즉시 큐에서 제거(낙관적)하고 반응 기록을
  /// 비동기 발사한다. 데이터가 아직 없으면 무시한다.
  void swipe(SpotReaction reaction) {
    final SwipeQueue? queue = state.value;
    final TouristSpot? top = queue?.top;
    if (queue == null || top == null) return;

    // 낙관적 제거: 카드를 먼저 없앤다.
    _seenIds.add(top.id);
    state = AsyncData<SwipeQueue>(
      queue.copyWith(cards: queue.cards.sublist(1)),
    );

    // **`consume`은 이 경로를 타지 않는다** — 상세 화면에서 누른 좋아요는 스와이프가
    // 아니라 좋아요로 잡혀야 한다(→[likeToggle]).
    AppAnalytics.logEvent(AnalyticsEvents.spotSwipe, <String, Object>{
      AnalyticsParams.liked: reaction == SpotReaction.like,
    });

    // 반응 기록은 비동기 발사, 실패는 조용히 로깅(복원 없음).
    _record(top.id, reaction);

    _maybePrefetch();
  }

  /// [spotId] 카드를 스택에서 제거한다. **반응은 보내지 않는다** — 이미 다른 화면이
  /// 보낸 뒤 호출하는 용도다.
  ///
  /// 상세 화면에서 좋아요/싫어요를 누르면 그 카드는 사용자가 이미 판단한 것이므로,
  /// Discover로 돌아왔을 때 같은 카드가 맨 위에 다시 있으면 안 된다. 상세는 스와이프
  /// 스택의 "자세히 보기" 단계이므로 여기서 소비된다.
  ///
  /// 맨 위가 아닌 카드도 제거한다 — 상세는 스택 중간의 카드에서도 열릴 수 있다.
  /// 해당 id가 없으면 아무 일도 하지 않는다(다른 경로로 들어온 상세).
  void consume(String spotId) {
    final SwipeQueue? queue = state.value;
    if (queue == null) return;
    if (!queue.cards.any((TouristSpot s) => s.id == spotId)) return;

    _seenIds.add(spotId);
    state = AsyncData<SwipeQueue>(
      queue.copyWith(
        cards: queue.cards
            .where((TouristSpot s) => s.id != spotId)
            .toList(growable: false),
      ),
    );
    _maybePrefetch();
  }

  Future<void> _record(String spotId, SpotReaction reaction) async {
    try {
      await _repository.reactToSpot(spotId, reaction);
    } catch (error, stack) {
      // 대상이 이미 삭제됐으면(SPEC-0007 AC-44) 큐에 남아 있는 같은 카드도 걷어낸다.
      // 낙관적 제거로 맨 위에서는 이미 빠졌지만, 아직 뒤에 남아 있을 수 있고 되돌려
      // 놓으면 다음 조회에서 또 실패한다. 재시도 큐에는 넣지 않는다 — 결과가 같다.
      if (error is SpotFailure && error.isSpotMissing) {
        dropMissingCard(spotId);
      }

      // 좋아요 실패는 비치명적(spec §4): 조용히 로깅하고 카드 복원 안 함.
      _log.w('reactToSpot failed', error: error, stackTrace: stack);
    }
  }

  /// 서버에서 사라진 [spotId] 카드를 현재 세션에서 걷어낸다(SPEC-0007 §4.2·§4.3).
  ///
  /// 상세 조회가 `SPOT_NOT_FOUND`로 실패했을 때(AC-43)와 반응 전송이 같은 이유로
  /// 실패했을 때(AC-44) 공통으로 쓴다. 세션을 오류 상태로 만들지 않고 배너도 띄우지
  /// 않는다 — 사용자가 한 행동의 결과가 아니기 때문이다. 이미 없는 id면 무시한다.
  void dropMissingCard(String spotId) {
    final SwipeQueue? queue = state.value;
    if (queue == null) return;
    _seenIds.add(spotId);
    final SwipeQueue next = queue.removeCard(spotId);
    if (identical(next, queue)) return;
    state = AsyncData<SwipeQueue>(next);
    _maybePrefetch();
  }

  /// 잔여 카드가 임계값 미만이고 더 부를 만하면 한 번만 보충한다(SPEC-0035 AC-10.2).
  ///
  /// 같은 인자로 다시 부르고, 큐에 이미 있는 id와 이 세션에서 넘긴 id를 걷어낸 뒤
  /// **받은 순서 그대로** 뒤에 붙인다. 더 부를지는 두 조건으로 정한다 — `first`보다
  /// 적게 왔으면 후보 소진이고, 걷어낸 뒤 새 카드가 0장이면 서버가 줄 수 있는 것을
  /// 큐가 이미 다 들고 있는 것이다. 어느 쪽이든 `hasNextPage`를 내려 같은 요청을
  /// 되풀이하지 않는다.
  Future<void> _maybePrefetch() async {
    final SwipeQueue? queue = state.value;
    if (queue == null || _isPrefetching) return;
    if (!queue.hasNextPage || queue.cards.length >= _prefetchThreshold) return;

    _isPrefetching = true;
    try {
      // 좌표·반경은 첫 조회 시점 값을 재사용한다(스와이프 중 위치가 바뀌어도 같은
      // 피드를 이어감). 바뀌면 이 컨트롤러 자체가 재빌드된다(AC-10.3).
      final Coordinates coords = await ref.read(
        currentCoordinatesProvider.future,
      );
      final double radiusKm = ref.read(searchRadiusControllerProvider);
      final List<TouristSpot> bundle = await _fetchBundle(coords, radiusKm);
      final SwipeQueue? current = state.value;
      if (current == null) return;
      final Set<String> present = <String>{
        ...current.cards.map((TouristSpot s) => s.id),
        ..._seenIds,
      };
      final List<TouristSpot> fresh = bundle
          .where((TouristSpot s) => !present.contains(s.id))
          .toList(growable: false);
      state = AsyncData<SwipeQueue>(
        SwipeQueue(
          cards: <TouristSpot>[...current.cards, ...fresh],
          hasNextPage: bundle.length >= _bundleSize && fresh.isNotEmpty,
        ),
      );
    } catch (error, stack) {
      // 선제 조회 실패는 기존 스택을 유지하고 다음 스와이프에서 다시 시도한다.
      _log.w('prefetch failed', error: error, stackTrace: stack);
    } finally {
      _isPrefetching = false;
    }
  }

  /// 사용자의 명시적 재시도(R3). **상한을 무시하고 1회 조회한다**(AC-8·AC-13) —
  /// 자동 재시도의 상한은 폭주를 막기 위한 것이지 사용자의 의사를 막기 위한 것이 아니다.
  ///
  /// 성공하면 카운터를 0으로 되돌려 이후 실패에 다시 자동 재시도가 가능해진다(AC-9).
  /// 실패하면 종료 상태를 유지하고 자동 재시도를 이어서 발생시키지 않는다(AC-10) —
  /// 여기서 카운터를 올리지 않는 이유는 이미 소진 상태이기 때문이고, 소진 전이었다면
  /// 이 실패도 계상되어야 하므로 `_fetchFirstBundle`과 같은 규칙을 쓴다.
  Future<void> reload() async {
    state = const AsyncLoading<SwipeQueue>();
    state = await AsyncValue.guard(() async {
      final Coordinates coords = await ref.read(
        currentCoordinatesProvider.future,
      );
      // 명시적 재시도라 read다 — 여기서 watch하면 재시도 자체가 구독을 새로 걸어
      // 반경이 바뀔 때마다 이 경로가 또 돈다(build가 이미 그 일을 한다).
      final double radiusKm = ref.read(searchRadiusControllerProvider);
      try {
        final SwipeQueue queue = await _fetchFirstBundle(coords, radiusKm);
        _budget.reset(); // 성공 → 카운터 초기화(AC-9).
        return queue;
      } on RetryExhausted {
        rethrow; // 이미 종료 상태로 승격됨 — 그대로 유지한다(AC-10).
      } catch (error) {
        // 상한을 이미 소진한 뒤의 명시적 재시도가 실패한 경우다. 종료 상태를 유지해
        // 화면이 "재시도 중"으로 되돌아가지 않게 한다(AC-10).
        if (_budgetState.isExhausted) throw RetryExhausted(error);
        rethrow;
      }
    });
  }
}
