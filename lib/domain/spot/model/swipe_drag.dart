import 'dart:math' as math;
import 'dart:ui' show Offset;

import 'spot_reaction.dart';

/// 드래그가 확정된 방향. 상하 스와이프를 받으면서 "어느 쪽으로 날아갈지"가
/// 반응(LIKE/DISLIKE)만으로는 정해지지 않아 따로 둔다 — 위로 민 것과 오른쪽으로
/// 민 것은 **같은 LIKE지만 카드가 날아가는 방향이 다르다**.
enum SwipeDirection {
  left,
  right,
  up,
  down;

  /// 이 방향이 뜻하는 반응.
  ///
  /// **서버 enum은 LIKE/DISLIKE 둘뿐이다**(`spot_schema.graphql:23-26`). 위/아래를
  /// 새 반응으로 만들면 스키마를 바꿔야 하므로, 방향만 늘리고 반응은 기존 둘에
  /// 매핑한다 — 위는 좋아요(슈퍼라이크 제스처), 아래는 관심 없음이다.
  SpotReaction get reaction => switch (this) {
    SwipeDirection.right || SwipeDirection.up => SpotReaction.like,
    SwipeDirection.left || SwipeDirection.down => SpotReaction.dislike,
  };

  /// 카드가 날아갈 단위 방향.
  Offset get unit => switch (this) {
    SwipeDirection.left => const Offset(-1, 0),
    SwipeDirection.right => const Offset(1, 0),
    SwipeDirection.up => const Offset(0, -1),
    SwipeDirection.down => const Offset(0, 1),
  };
}

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

  /// 세로 확정 임계값: 카드 높이의 비율.
  ///
  /// 가로보다 **작게 잡는다** — 엄지를 위아래로 미는 거리는 좌우로 미는 거리보다
  /// 짧아, 같은 비율이면 위/아래가 훨씬 무겁게 느껴진다.
  static const double verticalConfirmFraction = 0.18;

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

  /// 2차원 변위의 확정 진행도(0~1). 가로·세로 중 **더 많이 진행된 쪽**을 쓴다.
  ///
  /// 다음 카드 스케일업과 라벨 강도가 이 값을 공유하므로, 어느 방향으로 밀든
  /// 임계에 가까워질수록 같은 세기로 반응한다.
  static double progress2D(Offset drag, Size2D size) {
    final double h = progress(drag.dx, size.width);
    final double v = size.height <= 0
        ? 0
        : (drag.dy.abs() / (size.height * verticalConfirmFraction)).clamp(
            0.0,
            1.0,
          );
    return math.max(h, v);
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

  /// 2차원 판정. 확정이 아니면 null(스프링백).
  ///
  /// **가로와 세로 중 지배적인 축 하나만 고른다** — 대각선으로 밀었을 때 두 축이
  /// 동시에 확정되면 카드가 어디로 갈지 정해지지 않는다. 임계 대비 진행도가 더 큰
  /// 축이 이긴다(속도도 같은 기준으로 비교).
  static SwipeDirection? resolve2D({
    required Offset drag,
    required Size2D size,
    required Offset velocity,
  }) {
    final bool horizontal = confirms(
      dragX: drag.dx,
      width: size.width,
      velocity: velocity.dx,
    );
    final bool vertical =
        (size.height > 0 &&
            drag.dy.abs() >= size.height * verticalConfirmFraction) ||
        velocity.dy.abs() >= flingVelocity;

    if (!horizontal && !vertical) return null;

    // 둘 다 확정이면 진행도가 큰 축이 이긴다.
    if (horizontal && vertical) {
      final double h = progress(drag.dx, size.width);
      final double v = size.height <= 0
          ? 0
          : (drag.dy.abs() / (size.height * verticalConfirmFraction));
      if (h >= v) {
        return drag.dx > 0 ? SwipeDirection.right : SwipeDirection.left;
      }
      return drag.dy > 0 ? SwipeDirection.down : SwipeDirection.up;
    }

    if (horizontal) {
      final bool right =
          drag.dx > 0 || (drag.dx == 0 && velocity.dx > 0);
      return right ? SwipeDirection.right : SwipeDirection.left;
    }
    final bool down = drag.dy > 0 || (drag.dy == 0 && velocity.dy > 0);
    return down ? SwipeDirection.down : SwipeDirection.up;
  }

  /// 변위 비례 기울기(rad). 카드 폭 절반에서 [maxTiltRadians]에 닿는다.
  static double tilt(double dragX, double width) {
    if (width <= 0) return 0;
    return (dragX / (width / 2)).clamp(-1.0, 1.0) * maxTiltRadians;
  }

  /// 아래에 깔린 다음 카드의 크기. 끌수록 [nextCardRestScale] → 1.0으로 올라온다.
  static double nextCardScale(double dragX, double width) =>
      nextCardRestScale + (1 - nextCardRestScale) * progress(dragX, width);

  /// 2차원 변위 기준의 다음 카드 크기.
  static double nextCardScale2D(Offset drag, Size2D size) =>
      nextCardRestScale + (1 - nextCardRestScale) * progress2D(drag, size);
}

/// 카드 크기(순수 값). `dart:ui`의 `Size`를 쓰지 않는 이유는 model 계층을
/// 프레임워크에서 떼어 놓기 위해서다(CLAUDE.md §3) — `Offset`은 순수 값 타입이라
/// 예외로 쓰지만, 크기는 의미가 분명한 이름을 붙여 둔다.
class Size2D {
  const Size2D(this.width, this.height);

  final double width;
  final double height;
}
