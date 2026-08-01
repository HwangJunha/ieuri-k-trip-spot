import 'dart:developer' as developer;
import 'dart:ui' show Locale;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/localization/locale_controller.dart';
import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/pagination/offset_page.dart';
import '../model/spot_category.dart';
import '../model/spot_reaction.dart';
import '../model/swipe_queue.dart';
import '../model/tourist_spot.dart';
import '../repository/spot_repository.dart';
import 'spot_providers.dart';

part 'swipe_providers.g.dart';

/// 한 번에 저장하는 페이지 크기(spec §4 방향 변경). 서버가 커서를 지원하지 않아
/// page/size 오프셋으로 조회하며, provider가 100장씩 보관한다.
const int _pageSize = 100;

/// 잔여 카드가 이 값 미만으로 떨어지면 다음 페이지를 선제 조회한다. 100장을 받아
/// 두고 10장 미만이 남으면 다음 100장을 이어 붙여 스택이 끊기지 않게 한다.
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
@riverpod
class SwipeController extends _$SwipeController {
  SpotRepository get _repository => ref.read(spotRepositoryProvider);

  bool _isPrefetching = false;

  @override
  Future<SwipeQueue> build(SpotCategory? category) async {
    final Coordinates coords = await ref.watch(
      currentCoordinatesProvider.future,
    );
    final OffsetPage<TouristSpot> page = await _repository.fetchSpotPage(
      latitude: coords.latitude,
      longitude: coords.longitude,
      category: category,
      page: 0,
      size: _pageSize,
    );
    return SwipeQueue(
      cards: page.items,
      loadedPage: page.page,
      hasNextPage: page.hasNext,
    );
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

  Future<void> _record(String spotId, SpotReaction reaction) async {
    try {
      await _repository.reactToSpot(spotId, reaction);
    } catch (error, stack) {
      // 좋아요 실패는 비치명적(spec §4): 조용히 로깅하고 카드 복원 안 함.
      developer.log(
        'reactToSpot failed',
        name: 'SwipeController',
        error: error,
        stackTrace: stack,
      );
    }
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
          cards: <TouristSpot>[...current.cards, ...next.items],
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

  /// 오류/빈 상태에서 첫 페이지부터 다시 로드한다(재시도 배너·CTA용).
  Future<void> reload() async {
    state = const AsyncLoading<SwipeQueue>();
    state = await AsyncValue.guard(() => build(category));
  }
}
