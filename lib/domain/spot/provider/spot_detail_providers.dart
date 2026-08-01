import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/spot_category.dart';
import '../model/spot_detail.dart';
import '../model/spot_reaction.dart';
import '../repository/spot_repository.dart';
import 'spot_providers.dart';

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
@riverpod
class SpotDetailController extends _$SpotDetailController {
  SpotRepository get _repository => ref.read(spotRepositoryProvider);

  /// 이 세션에서 사용자가 이 상세에 마지막으로 보낸 반응(null=아직 없음). 낙관적
  /// 델타 계산의 기준 — 서버 왕복 없이 덮어쓰기 순변화를 구하려고 로컬로 들고 있다.
  SpotReaction? _myReaction;

  @override
  Future<SpotDetail> build(String contentId, SpotCategory category) =>
      _repository.fetchSpotDetail(contentId, category);

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

  /// 오류 상태에서 상세를 다시 로드한다(재시도 CTA용, AC-26).
  Future<void> reload() async {
    state = const AsyncLoading<SpotDetail>();
    state = await AsyncValue.guard(() => build(contentId, category));
  }
}
