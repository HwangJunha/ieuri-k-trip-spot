import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/retry_budget.dart';
import '../model/retry_exhausted.dart';
import '../model/spot_category_selection.dart';
import '../model/spot_detail.dart';
import '../model/spot_failure.dart';
import '../model/spot_reaction.dart';
import '../repository/spot_repository.dart';
import 'retry_budget_providers.dart';
import 'retry_counting.dart';
import 'spot_providers.dart';
import 'swipe_providers.dart';

part 'spot_detail_providers.g.dart';

/// 관광지 상세 컨트롤러(SPEC-0003). [contentId]별 패밀리 — 상세 진입마다 해당 id의
/// 인스턴스를 로드한다.
///
/// - 첫 빌드: `spotDetail(id)`을 조회해 [SpotDetail]을 상태로 둔다. 실패는 `AsyncError`로
///   노출돼 뷰가 SPOT_NOT_FOUND·UPSTREAM_* 등 오류 상태를 그린다(spec §6).
/// - [react]: 좋아요/싫어요 탭 시 `likeCount`를 **낙관적으로 즉시** 갱신하고
///   `reactToSpot`을 발사한다. 실패 시 이전 값으로 **롤백**한다(AC-30) — 스와이프와 달리
///   개수가 화면에 보이는 값이라 되돌려야 한다(spec §4).
/// - 재평가는 이전 반응을 덮어쓰는 것으로 계산한다(SPEC-0002 규약): LIKE→DISLIKE면
///   직전 +1을 되돌려 순변화 −1. 같은 반응 반복은 순변화 0.
/// [retry]로 자동 재시도를 1회로 묶는다(SPEC-0006 R1) — 스와이프와 같은 정책이다.
@Riverpod(retry: spotRetryPolicy)
class SpotDetailController extends _$SpotDetailController {
  SpotRepository get _repository => ref.read(spotRepositoryProvider);

  /// 이 세션에서 사용자가 이 상세에 마지막으로 보낸 반응(null=아직 없음). 낙관적
  /// 델타 계산의 기준 — 서버 왕복 없이 덮어쓰기 순변화를 구하려고 로컬로 들고 있다.
  SpotReaction? _myReaction;

  /// 이 상세의 재시도 예산(SPEC-0006 R4). 스와이프와 같은 이유로 컨트롤러 바깥의
  /// keepAlive provider에 둔다 — 재빌드가 카운터를 초기화하면 상한이 무의미해진다.
  SpotRetryBudget get _budget =>
      ref.read(spotRetryBudgetProvider(detailRetryScope(contentId)).notifier);

  RetryBudget get _budgetState =>
      ref.read(spotRetryBudgetProvider(detailRetryScope(contentId)));

  @override
  Future<SpotDetail> build(String contentId) {
    // 상한 소진 상태면 repository를 호출하지 않는다(AC-11·AC-12). 원인은 예산이 들고
    // 있던 실제 실패를 쓴다 — 스와이프 쪽과 같은 이유다.
    final RetryBudget budget = _budgetState;
    if (budget.isExhausted) {
      throw RetryExhausted(budget.lastFailure ?? SpotFailure.network);
    }
    return _fetchDetail();
  }

  /// 상세를 조회하고 실패를 상한에 계상한다. 계상 규칙은 스와이프와 동일하다(§2.3).
  Future<SpotDetail> _fetchDetail() async {
    try {
      return await _repository.fetchSpotDetail(contentId);
    } catch (error) {
      // 축제가 종료돼 서버에서 삭제된 경우(SPEC-0007 AC-43). 이 화면은 오류 상태를
      // 그대로 그리지만(사용자가 직접 연 화면이라 조용히 넘기면 더 혼란스럽다),
      // 뒤에 남아 있는 스와이프 세션에서는 같은 카드를 걷어내 다시 뜨지 않게 한다.
      if (error is SpotFailure && error.isSpotMissing) {
        _dropFromSwipeSessions(contentId);
      }

      if (!countsTowardRetryBudget(error)) rethrow;

      _budget.countFailure(error);
      if (_budgetState.isExhausted) throw RetryExhausted(error);
      rethrow;
    }
  }

  /// 사라진 [spotId]를 스와이프 세션에서 제거한다. 어떤 선택으로 연 세션인지 모르므로
  /// 살아 있는 세션 전부에 알린다 — 해당 id가 없는 세션은 무시한다.
  ///
  /// **살아 있는 세션만 훑는다.** 예전에는 `SpotCategory.values`로 카테고리 10개를
  /// 확인했지만, 다중 선택 이후로 가능한 조합이 2^n이라 열거할 수 없다 —
  /// [liveSwipeSessions]에 세션이 스스로 등록해 둔 명부를 쓴다. 없는 세션을 read하면
  /// 사용자가 열지도 않은 피드가 위치·목록 조회를 시작하므로 [Ref.exists]로 한 번 더
  /// 거른다(명부가 컨테이너를 넘어 남을 수 있다).
  ///
  /// 세션을 오류로 만들거나 배너를 띄우지 않는다(§4.2) — 사용자가 한 행동의 결과가
  /// 아니기 때문이다.
  void _dropFromSwipeSessions(String spotId) {
    for (final SpotCategorySelection selection in liveSwipeSessions.toList(
      growable: false,
    )) {
      final SwipeControllerProvider provider = swipeControllerProvider(
        selection,
      );
      if (!ref.exists(provider)) continue;
      ref.read(provider.notifier).dropMissingCard(spotId);
    }
  }

  /// 상세에서 [reaction]을 보낸다. 낙관적으로 `likeCount`를 갱신하고 `reactToSpot`을
  /// 발사하며, 실패 시 개수와 내 반응 상태를 모두 롤백한다.
  Future<void> react(SpotReaction reaction) async {
    final SpotDetail? current = state.value;
    if (current == null) return;

    final SpotReaction? previousReaction = _myReaction;
    final int delta = _likeDelta(previousReaction, reaction);

    // 낙관적: 개수와 내 반응을 먼저 반영한다.
    _myReaction = reaction;
    state = AsyncData<SpotDetail>(
      current.copyWithLikeCount(current.likeCount + delta),
    );

    try {
      await _repository.reactToSpot(current.id, reaction);
    } catch (error, stack) {
      // 실패 롤백(AC-30): 델타를 빼는 게 아니라 낙관 반영 직전 스냅샷(current·
      // previousReaction)을 그대로 복원한다 — 단순하고, 반응이 겹쳐도 어긋나지 않는다.
      // 오류는 재던져 뷰가 피드백(스낵바 등)을 띄우게 한다.
      _myReaction = previousReaction;
      state = AsyncData<SpotDetail>(current);

      // 대상이 이미 삭제된 축제면(SPEC-0007 AC-44) 스와이프 세션에서도 걷어낸다.
      // 롤백은 위에서 이미 했고, 재시도 큐에는 넣지 않는다 — 결과가 같다.
      if (error is SpotFailure && error.isSpotMissing) {
        _dropFromSwipeSessions(current.id);
      }
      developer.log(
        'reactToSpot failed (rolled back)',
        name: 'SpotDetailController',
        error: error,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// [previous] 반응을 [next]로 덮어쓸 때 `likeCount`의 순변화. LIKE는 +1, DISLIKE는
  /// LIKE를 취소했을 때만 −1(DISLIKE 자체는 개수에 기여하지 않는다).
  int _likeDelta(SpotReaction? previous, SpotReaction next) {
    final int before = previous == SpotReaction.like ? 1 : 0;
    final int after = next == SpotReaction.like ? 1 : 0;
    return after - before;
  }

  /// 사용자의 명시적 재시도(R3, AC-26). 상한을 무시하고 1회 조회하며, 성공하면
  /// 카운터를 0으로 되돌린다(AC-9). 실패하면 종료 상태를 유지한다(AC-10).
  Future<void> reload() async {
    state = const AsyncLoading<SpotDetail>();
    state = await AsyncValue.guard(() async {
      try {
        final SpotDetail detail = await _fetchDetail();
        _budget.reset();
        return detail;
      } on RetryExhausted {
        rethrow;
      } catch (error) {
        if (_budgetState.isExhausted) throw RetryExhausted(error);
        rethrow;
      }
    });
  }
}
