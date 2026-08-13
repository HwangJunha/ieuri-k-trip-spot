import 'package:flutter/material.dart';

/// 상대가 입력 중임을 알리는 표시(R10).
///
/// **인스타그램식 말풍선이다** — "○○님이 입력 중이에요…" 같은 문장은 대화 흐름과
/// 톤이 다르고, 닉네임이 길면 줄을 넘겨 입력창을 밀어낸다. 받은 말풍선과 같은 자리·
/// 같은 모양에 점 세 개만 튀게 두면 문장 없이도 뜻이 통하고 번역도 필요 없다.
///
/// **이 위젯은 보이거나 안 보이거나만 그린다.** 타임아웃 판정은 notifier가 진다
/// (설계 §5) — 타이핑 이벤트는 유실될 수 있어 이벤트로만 켜고 끄면 마지막 이벤트가
/// 유실되는 순간 화면이 영원히 "입력 중"에 갇힌다. 그 판단을 위젯에 두면 화면마다
/// 규칙이 흩어진다.
///
/// **높이를 항상 예약한다** — 나타났다 사라질 때 메시지 리스트가 튀지 않게 빈
/// 상태에서도 같은 자리를 차지한다.
class TypingIndicatorBar extends StatelessWidget {
  const TypingIndicatorBar({super.key, this.nickname});

  /// 입력 중인 상대의 닉네임. null이면 아무도 입력 중이 아니다.
  ///
  /// 말풍선에 이름을 쓰지는 않는다 — 1:1 대화라 누구인지 이미 자명하다. 다만
  /// 스크린리더에는 남긴다.
  final String? nickname;

  /// 예약 높이. 말풍선 하나가 들어가는 높이다.
  static const double height = 34;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? who = nickname;
    return SizedBox(
      height: height,
      child: who == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Semantics(
                  // 점만 보고는 뜻을 알 수 없다 — 소리로는 문장으로 읽어 준다.
                  label: who,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      // 받은 말풍선과 같은 표면색 — 같은 사람이 말하는 자리다.
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: const _BouncingDots(),
                  ),
                ),
              ),
            ),
    );
  }
}

/// 차례로 튀어오르는 점 셋.
class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // 접근성 설정에서 애니메이션을 줄였으면 움직이지 않는다 — 점은 그대로 둔다.
    final bool animate = !MediaQuery.disableAnimationsOf(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < 3; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 4),
          _Dot(
            controller: _controller,
            // 점마다 위상을 어긋내야 물결처럼 보인다.
            phase: i * 0.18,
            color: theme.colorScheme.onSurfaceVariant,
            animate: animate,
          ),
        ],
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.controller,
    required this.phase,
    required this.color,
    required this.animate,
  });

  final AnimationController controller;
  final double phase;
  final Color color;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    const double size = 7;
    if (!animate) {
      return _circle(size, color.withValues(alpha: 0.6), 0);
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        // 0~1을 한 바퀴 돌리되 점마다 위상을 밀어 준다.
        final double t = (controller.value + phase) % 1.0;
        // 앞의 40%만 튀어오르고 나머지는 쉰다 — 계속 흔들리면 산만하다.
        final double lift = t < 0.4
            ? Curves.easeOut.transform(1 - (t / 0.4 - 0.5).abs() * 2)
            : 0;
        return _circle(
          size,
          color.withValues(alpha: 0.45 + lift * 0.55),
          -lift * 3,
        );
      },
    );
  }

  Widget _circle(double size, Color color, double dy) => Transform.translate(
    offset: Offset(0, dy),
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}
