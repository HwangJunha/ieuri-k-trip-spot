import 'dart:async';

import 'package:flutter/material.dart';

/// 재발송 버튼 + 남은 쿨다운 카운트다운(SPEC-0011 R8, 디자인 §4).
///
/// **서버가 거절하기를 기다리지 않고 클라이언트가 미리 막는다.** 남은 시간이 있으면
/// 버튼을 비활성으로 두고 "N초 후에 다시 보낼 수 있습니다"를 보여준다 — 눌러 본 뒤
/// `RESEND_COOLDOWN_ACTIVE`를 받는 것보다 낫다.
///
/// **초당 다시 그리는 범위를 이 위젯 안으로 가둔다.** 남은 초를 provider 상태에
/// 넣으면 화면 전체가 매초 다시 그려진다. 여기서는 [cooldownUntil]이라는 고정된
/// 시각만 받고, 타이머는 이 위젯이 자기 안에서 돌린다(CLAUDE.md §1.6).
class ResendCountdownButton extends StatefulWidget {
  const ResendCountdownButton({
    super.key,
    required this.cooldownUntil,
    required this.label,
    required this.countdownLabel,
    required this.onResend,
    this.enabled = true,
  });

  /// 이 시각 전에는 누를 수 없다. null이면 즉시 누를 수 있다.
  final DateTime? cooldownUntil;

  /// 쿨다운이 끝났을 때의 버튼 문구.
  final String label;

  /// 남은 초를 받아 카운트다운 문구를 만든다.
  final String Function(int seconds) countdownLabel;

  final VoidCallback onResend;

  /// 쿨다운과 별개로 화면이 버튼을 막을 수 있다(전송 중 등).
  final bool enabled;

  @override
  State<ResendCountdownButton> createState() => _ResendCountdownButtonState();
}

class _ResendCountdownButtonState extends State<ResendCountdownButton> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _syncTicker();
  }

  @override
  void didUpdateWidget(ResendCountdownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 재발송에 성공하면 새 마감 시각이 내려온다 — 그때 타이머를 다시 건다.
    if (oldWidget.cooldownUntil != widget.cooldownUntil) _syncTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// 남은 시간이 있을 때만 타이머를 돌린다. 0이 되면 스스로 멈춘다 — 화면에 머무는
  /// 내내 초당 setState를 도는 것을 막는다.
  void _syncTicker() {
    _ticker?.cancel();
    if (_remainingSeconds() <= 0) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      setState(() {});
      if (_remainingSeconds() <= 0) timer.cancel();
    });
  }

  /// 남은 초(올림). 0.2초 남았을 때 "0초"라고 쓰면 버튼이 아직 안 눌리는데 눌릴 것처럼
  /// 보이므로 올림이 맞다.
  int _remainingSeconds() {
    final DateTime? until = widget.cooldownUntil;
    if (until == null) return 0;
    final Duration left = until.difference(DateTime.now());
    return left.isNegative ? 0 : (left.inMilliseconds / 1000).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final int remaining = _remainingSeconds();
    final bool waiting = remaining > 0;
    return TextButton(
      onPressed: widget.enabled && !waiting ? widget.onResend : null,
      child: Text(waiting ? widget.countdownLabel(remaining) : widget.label),
    );
  }
}
