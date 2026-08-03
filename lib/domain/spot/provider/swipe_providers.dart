import 'dart:developer' as developer;
import 'dart:ui' show Locale;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/localization/locale_controller.dart';
import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/pagination/offset_page.dart';
import '../model/retry_budget.dart';
import '../model/retry_exhausted.dart';
import '../model/spot_category.dart';
import '../model/spot_failure.dart';
import '../model/spot_reaction.dart';
import '../model/swipe_queue.dart';
import '../model/tourist_spot.dart';
import '../repository/spot_repository.dart';
import 'retry_budget_providers.dart';
import 'retry_counting.dart';
import 'spot_providers.dart';

part 'swipe_providers.g.dart';

/// 한 번에 저장하는 페이지 크기(spec §4 방향 변경). 서버가 커서를 지원하지 않아
/// page/size 오프셋으로 조회하며, provider가 100장씩 보관한다.
const int _pageSize = 100;

/// 잔여 카드가 이 값 미만으로 떨어지면 다음 페이지를 선제 조회한다. 100장을 받아
/// 두고 10장 미만이 남으면 다음 100장을 이어 붙여 스택이 끊기지 않게 한다.
const int _prefetchThreshold = 10;

/// 받아온 페이지를 클라이언트에서 한 번 더 섞는다.
///
/// 서버는 같은 좌표·카테고리에 같은 순서를 돌려주므로, 한 카페에 있는 사용자들이
/// 전부 같은 카드를 같은 순서로 보게 된다. 페이지 안에서만 섞어도 100장 규모에서는
/// 충분히 갈라진다 — 보통 한 세션에 100장을 넘기지 않기 때문이다.
///
/// 페이지 **경계는 넘지 않는다**: 이어 붙인 다음 페이지는 그 페이지 안에서만 섞어
/// 서버의 거리순 대분류(가까운 100장 → 다음 100장)를 보존한다. 전체를 다시 섞으면
/// 멀리 있는 장소가 앞으로 튀어나온다.
List<TouristSpot> _shuffled(List<TouristSpot> items) {
  final List<TouristSpot> copy = List<TouristSpot>.of(items);
  copy.shuffle();
  return copy;
}

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

/// 현재 선택된 카테고리(null=전체). CategoryBar가 갱신하고 SwipeController 패밀리
/// 인자로 쓰인다 — 값이 바뀌면 다른 SwipeController 인스턴스를 보게 되어 재로딩된다.
@riverpod
class SelectedSpotCategory extends _$SelectedSpotCategory {
  @override
  SpotCategory? build() => null;

  void select(SpotCategory? category) => state = category;
}

/// Discover 스와이프 카드 스택 컨트롤러(spec §4). [category]별 패밀리 —
/// 카테고리 변경은 다른 인스턴스 로딩으로 이어진다.
///
/// - 첫 빌드: 현재 좌표를 얻어 첫 페이지(page 0, size 100)를 조회해 [SwipeQueue]를 만든다.
/// - [swipe]: 낙관적으로 맨 위 카드를 즉시 제거하고 `reactToSpot`을 비동기 발사한다.
///   실패해도 카드를 복원하지 않고 조용히 로깅한다(좋아요 실패는 비치명적).
/// - 잔여 [_prefetchThreshold] 미만이고 다음 페이지가 있으면 백그라운드로 이어 붙인다.
/// - 소진: 큐가 비고 `hasNext=false`면 [SwipeQueue.isExhausted]로 빈 상태.
/// [retry]로 자동 재시도를 1회로 묶는다(R1). Riverpod 기본값은 최대 10회 지수 백오프라
/// 실패 상태에서 조회가 폭주하는데, 그 폭주의 실제 경로가 여기다(설계문서 §2.1).
///
/// SPEC-0007: 서버가 종료된 축제를 삭제하므로 쌓아둔 카드의 id가 세션 도중 해소
/// 불가가 될 수 있다. 그 경우 [dropMissingCard]로 해당 카드만 걷어내고 세션은
/// 계속한다(AC-43·AC-44) — 세션 전체를 실패로 만들지 않는다.
@Riverpod(retry: spotRetryPolicy)
class SwipeController extends _$SwipeController {
  SpotRepository get _repository => ref.read(spotRepositoryProvider);

  bool _isPrefetching = false;

  /// 이 카테고리의 재시도 예산(SPEC-0006 R4). 컨트롤러 바깥의 keepAlive provider라
  /// 재빌드를 넘어 살아남는다 — 인스턴스 필드에 두면 폭주 경로인 재빌드가 카운터를
  /// 초기화해 상한이 무의미해진다(설계문서 §2.2).
  SpotRetryBudget get _budget => ref.read(
    spotRetryBudgetProvider(swipeRetryScope(category?.name)).notifier,
  );

  RetryBudget get _budgetState =>
      ref.read(spotRetryBudgetProvider(swipeRetryScope(category?.name)));

  @override
  Future<SwipeQueue> build(SpotCategory? category) async {
    // 언어가 바뀌면 세션을 통째로 다시 만든다(SPEC-0007 §4.5·R-14). 쌓아둔 카드의
    // id는 전부 이전 언어의 spot.id라, 그대로 두면 상세·반응이 SPOT_NOT_FOUND로
    // 거부된다. **값은 쓰지 않고 재빌드 트리거로만 구독한다** — 지우면 R-14가 깨진다.
    ref.watch(localeControllerProvider);

    // 좌표는 watch 한다 — 위치가 바뀌면 피드를 다시 받아야 하기 때문이다. 그 재빌드가
    // 실패 상태에서 폭주하지 않도록 막는 것이 아래 상한 확인이다(R1).
    final Coordinates coords = await ref.watch(
      currentCoordinatesProvider.future,
    );

    // 상한을 이미 소진했으면 repository를 호출하지 않고 종료 상태를 그대로 돌려준다
    // (AC-11·AC-12). 재빌드가 몇 번 일어나도 조회 횟수는 늘지 않는다. 원인은 예산이
    // 들고 있던 실제 실패를 쓴다 — 지어내면 로깅·분기가 실제와 어긋난다.
    final RetryBudget budget = _budgetState;
    if (budget.isExhausted) {
      throw RetryExhausted(budget.lastFailure ?? SpotFailure.network);
    }

    return _fetchFirstPage(coords);
  }

  /// 첫 페이지를 조회하고 실패를 상한에 계상한다. 계상 대상은 설계문서 §2.3의 표를
  /// 따른다 — 인증 실패는 SPEC-0005 갱신 경로 소관이라 계상하지 않는다(AC-14·AC-15).
  Future<SwipeQueue> _fetchFirstPage(Coordinates coords) async {
    try {
      final OffsetPage<TouristSpot> page = await _repository.fetchSpotPage(
        latitude: coords.latitude,
        longitude: coords.longitude,
        category: category,
        page: 0,
        size: _pageSize,
      );
      return SwipeQueue(
        cards: _shuffled(page.items),
        loadedPage: page.page,
        hasNextPage: page.hasNext,
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

  /// 맨 위 카드를 [reaction]으로 처리한다. 즉시 큐에서 제거(낙관적)하고 반응 기록을
  /// 비동기 발사한다. 데이터가 아직 없으면 무시한다.
  void swipe(SpotReaction reaction) {
    final SwipeQueue? queue = state.value;
    final TouristSpot? top = queue?.top;
    if (queue == null || top == null) return;

    // 낙관적 제거: 카드를 먼저 없앤다.
    state = AsyncData<SwipeQueue>(
      queue.copyWith(cards: queue.cards.sublist(1)),
    );

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
      developer.log(
        'reactToSpot failed',
        name: 'SwipeController',
        error: error,
        stackTrace: stack,
      );
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
    final SwipeQueue next = queue.removeCard(spotId);
    if (identical(next, queue)) return;
    state = AsyncData<SwipeQueue>(next);
    _maybePrefetch();
  }

  /// 잔여 카드가 임계값 미만이고 다음 페이지가 있으면 한 번만 이어 조회한다.
  Future<void> _maybePrefetch() async {
    final SwipeQueue? queue = state.value;
    if (queue == null || _isPrefetching) return;
    final int? nextPage = queue.nextPage;
    if (nextPage == null || queue.cards.length >= _prefetchThreshold) return;

    _isPrefetching = true;
    try {
      // 좌표는 첫 조회 시점 값을 재사용한다(스와이프 중 위치가 바뀌어도 같은 피드를 이어감).
      final Coordinates coords = await ref.read(
        currentCoordinatesProvider.future,
      );
      final OffsetPage<TouristSpot> next = await _repository.fetchSpotPage(
        latitude: coords.latitude,
        longitude: coords.longitude,
        category: category,
        page: nextPage,
        size: _pageSize,
      );
      final SwipeQueue? current = state.value;
      if (current == null) return;
      state = AsyncData<SwipeQueue>(
        current.copyWith(
          cards: <TouristSpot>[...current.cards, ..._shuffled(next.items)],
          loadedPage: next.page,
          hasNextPage: next.hasNext,
        ),
      );
    } catch (error, stack) {
      // 선제 조회 실패는 기존 스택을 유지하고 다음 스와이프에서 다시 시도한다.
      developer.log(
        'prefetch failed',
        name: 'SwipeController',
        error: error,
        stackTrace: stack,
      );
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
  /// 이 실패도 계상되어야 하므로 `_fetchFirstPage`와 같은 규칙을 쓴다.
  Future<void> reload() async {
    state = const AsyncLoading<SwipeQueue>();
    state = await AsyncValue.guard(() async {
      final Coordinates coords = await ref.read(
        currentCoordinatesProvider.future,
      );
      try {
        final SwipeQueue queue = await _fetchFirstPage(coords);
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
