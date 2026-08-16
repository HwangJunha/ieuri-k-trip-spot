import 'spot_reaction.dart';

/// 드래그 판정과 카드 배치를 위젯 밖으로 뽑아 놓은 순수 계산(SPEC-0025 §2.4).
///
/// 예전에는 이 계산이 전부 `_CardStackState.build` 안에 있어, AC R1·R3·R4를 확인하려면
/// 위젯 트리를 세우고 제스처를 흉내 내야 했다. 값 계산만 떼어 놓으면 같은 판정이
/// 단위 테스트가 된다.
abstract final class SwipeDrag {
  /// 확정 임계값: 카드 폭의 28%(SPEC-0002 §3 시작값).
  ///
  /// **비율로 둔다 — 픽셀로 환산하지 않는다.** 전체화면화로 카드가 좌우 패딩만큼
  /// 넓어지므로 같은 비율이 더 긴 물리 거리가 되지만, R3이 요구하는 것은 "같은
  /// 비율만큼 끌면 같은 결과"다(설계 §2.1, AC R3-3). 여기를 절대값으로 고정하면
  /// 화면 크기가 다른 기기에서 판정이 어긋난다.
  static const double confirmFraction = 0.28;

  /// fling 확정 속도 임계(px/s). 짧게 튕겨도 확정되게 한다.
  static const double flingVelocity = 800;

  /// 카드가 기울 수 있는 최대 각(rad). 카드 폭 절반을 끌면 최대치가 된다.
  static const double maxTiltRadians = 0.12;

  /// 다음 카드가 대기하는 크기. 끌수록 1.0에 가까워진다.
  static const double nextCardRestScale = 0.92;

  /// [dragX]만큼 끌었을 때 확정 진행도(0~1).
  ///
  /// 임계값에 도달하면 1이고 그 뒤로는 더 커지지 않는다 — 표시 강도(R4)와 다음 카드
  /// 스케일업이 이 값을 그대로 쓴다.
  static double progress(double dragX, double width) {
    if (width <= 0) return 0;
    final double threshold = width * confirmFraction;
    if (threshold <= 0) return 0;
    return (dragX.abs() / threshold).clamp(0.0, 1.0);
  }

  /// 손을 뗐을 때 확정되는가.
  ///
  /// 거리로 임계를 넘었거나(비율 기준), 빠르게 튕겼으면(fling) 확정이다. 둘 중
  /// 하나면 된다 — 짧게 튕기는 조작을 거리만으로 판정하면 "분명히 넘겼는데 돌아온다"가
  /// 된다.
  static bool confirms({
    required double dragX,
    required double width,
    required double velocity,
  }) =>
      (width > 0 && dragX.abs() >= width * confirmFraction) ||
      velocity.abs() >= flingVelocity;

  /// 확정 방향 → 반응(R3). 오른쪽이 좋아요, 왼쪽이 관심 없음.
  ///
  /// 거의 안 움직였는데 튕긴 경우가 있어 **속도도 함께 본다** — 변위가 0이면 방향을
  /// 변위로 정할 수 없다.
  static SpotReaction reactionFor({
    required double dragX,
    required double velocity,
  }) => (dragX > 0 || (dragX == 0 && velocity > 0))
      ? SpotReaction.like
      : SpotReaction.dislike;

  /// 손을 뗐을 때의 판정 결과. 확정이 아니면 null(스프링백).
  static SpotReaction? resolve({
    required double dragX,
    required double width,
    required double velocity,
  }) => confirms(dragX: dragX, width: width, velocity: velocity)
      ? reactionFor(dragX: dragX, velocity: velocity)
      : null;

  /// 변위 비례 기울기(rad). 카드 폭 절반에서 [maxTiltRadians]에 닿는다.
  static double tilt(double dragX, double width) {
    if (width <= 0) return 0;
    return (dragX / (width / 2)).clamp(-1.0, 1.0) * maxTiltRadians;
  }

  /// 아래에 깔린 다음 카드의 크기. 끌수록 [nextCardRestScale] → 1.0으로 올라온다.
  static double nextCardScale(double dragX, double width) =>
      nextCardRestScale +
      (1 - nextCardRestScale) * progress(dragX, width);
}
