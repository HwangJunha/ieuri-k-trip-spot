import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/swipe_drag.dart';

/// 드래그 방향 라벨 오버레이(spec §3): 오른쪽·위로 끌면 LIKE(초록), 왼쪽·아래로
/// 끌면 NOPE(적색)가 변위에 비례해 페이드인한다. 카드 기울기·다음 카드 스케일업은
/// DiscoverSwipeView가 담당하고, 이 위젯은 라벨만 그린다.
///
/// [drag]는 2차원 변위(px, 오른쪽·아래가 양수). [size]는 카드 크기 — 변위를 0~1
/// 강도로 정규화하는 데 쓴다.
class DragFeedbackOverlay extends StatelessWidget {
  const DragFeedbackOverlay({
    super.key,
    required this.drag,
    required this.size,
  });

  final Offset drag;
  final Size2D size;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    // **지배적인 축 하나만 라벨을 낸다** — 대각선으로 밀 때 LIKE와 NOPE가 함께
    // 떠오르면 어느 쪽으로 확정될지 읽히지 않는다. 판정(`resolve2D`)과 같은
    // 기준으로 축을 고른다.
    final double h = size.width == 0
        ? 0
        : (drag.dx.abs() / (size.width / 2)).clamp(0.0, 1.0);
    final double v = size.height == 0
        ? 0
        : (drag.dy.abs() /
                  (size.height * SwipeDrag.verticalConfirmFraction * 2))
              .clamp(0.0, 1.0);

    final bool horizontal = h >= v;
    final double intensity = horizontal ? h : v;
    final bool isLike = horizontal ? drag.dx > 0 : drag.dy < 0;

    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: isLike ? Alignment.topLeft : Alignment.topRight,
          child: Opacity(
            opacity: intensity,
            child: _Label(
              text: isLike ? l10n.discoverLikeLabel : l10n.discoverNopeLabel,
              color: isLike ? Colors.green : Colors.red,
              // 방향에 맞춰 살짝 기울인 스탬프 느낌.
              angle: isLike ? -0.35 : 0.35,
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text, required this.color, required this.angle});

  final String text;
  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
