import 'package:flutter/material.dart';

/// 한반도(남한) 실루엣 아이콘.
///
/// 하단 탭의 전국 지도 자리에 쓴다. Material에 한국 모양 아이콘이 없어
/// `Icons.public`(지구본)을 쓰고 있었는데, 전국 지도라는 뜻이 잘 드러나지 않는다.
///
/// **실제 경계 데이터에서 만들었다.** 다만 지리적 정확도가 목적이 아니라 24px에서
/// 읽히는 것이 목적이라, 위도 밴드마다 동·서 끝만 남겨 실루엣으로 눌렀다 —
/// 서해안의 만(灣)을 그대로 두면 24px에서 뾰족한 톱니로 보인다.
class KoreaIcon extends StatelessWidget {
  const KoreaIcon({this.size = 24, this.color, this.filled = false, super.key});

  final double size;
  final Color? color;

  /// 선택된 탭인지. 채우기와 외곽선을 가른다.
  final bool filled;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: _KoreaPainter(
        color: color ?? IconTheme.of(context).color ?? const Color(0xFF000000),
        filled: filled,
      ),
    ),
  );
}

class _KoreaPainter extends CustomPainter {
  const _KoreaPainter({required this.color, required this.filled});

  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);

    final Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = filled ? 0 : 1.6
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(_mainland(), paint);
    canvas.drawPath(_jeju(), paint);
    canvas.restore();
  }

  /// 본토 실루엣.
  static Path _mainland() => Path()
    ..moveTo(14.02, 1.50)
    ..lineTo(14.41, 2.28)
    ..lineTo(14.72, 3.06)
    ..lineTo(15.33, 3.85)
    ..lineTo(15.91, 4.63)
    ..lineTo(16.35, 5.41)
    ..lineTo(16.79, 6.19)
    ..lineTo(17.12, 6.97)
    ..lineTo(17.11, 7.76)
    ..lineTo(17.27, 8.54)
    ..lineTo(17.19, 9.32)
    ..lineTo(17.12, 10.10)
    ..lineTo(17.57, 10.88)
    ..lineTo(17.61, 11.67)
    ..lineTo(17.41, 12.45)
    ..lineTo(17.23, 13.23)
    ..lineTo(17.04, 14.01)
    ..lineTo(16.55, 14.79)
    ..lineTo(15.81, 15.58)
    ..lineTo(14.01, 16.36)
    ..lineTo(11.36, 17.14)
    ..lineTo(10.54, 17.92)
    ..lineTo(7.52, 17.92)
    ..lineTo(6.88, 17.14)
    ..lineTo(6.90, 16.36)
    ..lineTo(6.85, 15.58)
    ..lineTo(6.83, 14.79)
    ..lineTo(7.10, 14.01)
    ..lineTo(7.53, 13.23)
    ..lineTo(7.76, 12.45)
    ..lineTo(7.74, 11.67)
    ..lineTo(7.65, 10.88)
    ..lineTo(7.61, 10.10)
    ..lineTo(6.97, 9.32)
    ..lineTo(6.39, 8.54)
    ..lineTo(6.58, 7.76)
    ..lineTo(7.61, 6.97)
    ..lineTo(7.94, 6.19)
    ..lineTo(7.25, 5.41)
    ..lineTo(7.16, 4.63)
    ..lineTo(7.43, 3.85)
    ..lineTo(8.74, 3.06)
    ..lineTo(9.22, 2.28)
    ..lineTo(13.42, 1.50)
    ..close();

  /// 제주.
  static Path _jeju() => Path()
    ..moveTo(8.71, 21.65)
    ..lineTo(8.98, 21.38)
    ..lineTo(7.65, 21.38)
    ..lineTo(6.57, 22.29)
    ..lineTo(8.05, 22.50)
    ..lineTo(8.95, 21.53)
    ..close();

  @override
  bool shouldRepaint(_KoreaPainter old) =>
      old.color != color || old.filled != filled;
}
