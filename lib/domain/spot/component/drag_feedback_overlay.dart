import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';

/// 드래그 방향 라벨 오버레이(spec §3): 오른쪽으로 끌면 LIKE(초록), 왼쪽으로 끌면
/// NOPE(적색)가 변위에 비례해 페이드인한다. 카드 기울기·다음 카드 스케일업은
/// DiscoverSwipeView가 담당하고, 이 위젯은 라벨만 그린다.
///
/// [dragX]는 수평 변위(px, 오른쪽 양수). [width]는 카드 폭 — 변위를 0~1 강도로
/// 정규화하는 데 쓴다.
class DragFeedbackOverlay extends StatelessWidget {
  const DragFeedbackOverlay({
    super.key,
    required this.dragX,
    required this.width,
  });

  final double dragX;
  final double width;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 변위 절반 폭에서 강도 1.0 도달(라벨이 임계 전에 충분히 보이도록).
    final double intensity = width == 0
        ? 0
        : (dragX.abs() / (width / 2)).clamp(0.0, 1.0);
    final bool isLike = dragX > 0;

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
