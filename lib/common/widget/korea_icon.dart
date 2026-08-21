import 'package:flutter/material.dart';

/// 한반도 실루엣 아이콘.
///
/// 하단 탭의 전국 지도 자리에 쓴다. `Icons.public`(지구본)을 쓰던 것을 바꿨다 —
/// 지구본은 "전국"이라는 뜻이 드러나지 않는다.
///
/// **남한만이 아니라 한반도 전체다.** "한반도"라고 하면 북한까지 포함한 모양을
/// 뜻하고, 그 모양에서 제주는 보통 빼고 그린다.
///
/// 도형은 **Natural Earth**(퍼블릭 도메인) 1:110m 국가 경계에서 가져왔다. 그
/// 축척의 원본이 이미 남 19점·북 44점이라 아이콘에 그대로 쓸 만큼 단순하다 —
/// 따로 줄이지 않았다.
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
      ..strokeWidth = filled ? 0 : 1.5
      ..strokeJoin = StrokeJoin.round;

    // **하나로 합쳐 그린다.** 두 Path를 따로 그리면 미선택(외곽선) 상태에서
    // 국경선이 그어져 남북이 갈라져 보인다. 한반도는 이어진 하나여야 한다.
    canvas.drawPath(_peninsula, paint);
    canvas.restore();
  }

  /// 한반도 전체. 남·북을 union으로 합쳐 국경선을 없앤다.
  ///
  /// 매 프레임 합치지 않도록 한 번만 만든다 — `Path.combine`은 싸지 않다.
  static final Path _peninsula = Path.combine(
    PathOperation.union,
    _north(),
    _south(),
  );

  /// 북쪽 절반.
  static Path _north() => Path()
    ..moveTo(17.94, 2.94)
    ..lineTo(17.94, 2.94)
    ..lineTo(18.21, 3.37)
    ..lineTo(17.49, 3.22)
    ..lineTo(16.66, 4.05)
    ..lineTo(16.09, 4.88)
    ..lineTo(16.16, 6.64)
    ..lineTo(15.18, 7.18)
    ..lineTo(14.84, 7.61)
    ..lineTo(14.12, 8.33)
    ..lineTo(12.85, 8.73)
    ..lineTo(12.02, 9.39)
    ..lineTo(11.96, 10.45)
    ..lineTo(11.74, 10.72)
    ..lineTo(12.50, 11.11)
    ..lineTo(13.58, 12.18)
    ..lineTo(13.30, 12.78)
    ..lineTo(12.49, 12.94)
    ..lineTo(11.14, 13.05)
    ..lineTo(10.40, 14.16)
    ..lineTo(9.55, 14.07)
    ..lineTo(9.43, 14.29)
    ..lineTo(8.50, 13.83)
    ..lineTo(8.27, 14.29)
    ..lineTo(7.71, 14.49)
    ..lineTo(7.65, 14.03)
    ..lineTo(7.15, 13.81)
    ..lineTo(6.64, 13.42)
    ..lineTo(7.16, 12.34)
    ..lineTo(7.61, 12.05)
    ..lineTo(7.44, 11.61)
    ..lineTo(7.93, 10.29)
    ..lineTo(7.80, 9.89)
    ..lineTo(6.69, 9.62)
    ..lineTo(5.79, 8.97)
    ..lineTo(7.34, 7.40)
    ..lineTo(9.44, 6.09)
    ..lineTo(10.75, 4.36)
    ..lineTo(11.66, 5.12)
    ..lineTo(13.31, 5.21)
    ..lineTo(13.01, 3.92)
    ..lineTo(15.95, 2.87)
    ..lineTo(16.71, 1.50)
    ..lineTo(17.94, 2.94)
    ..close();

  /// 남쪽 절반.
  static Path _south() => Path()
    ..moveTo(9.43, 14.29)
    ..lineTo(9.55, 14.07)
    ..lineTo(10.40, 14.16)
    ..lineTo(11.14, 13.05)
    ..lineTo(12.49, 12.94)
    ..lineTo(13.30, 12.78)
    ..lineTo(13.58, 12.18)
    ..lineTo(15.22, 15.07)
    ..lineTo(15.70, 16.65)
    ..lineTo(15.71, 19.47)
    ..lineTo(14.99, 20.81)
    ..lineTo(13.26, 21.28)
    ..lineTo(11.74, 22.29)
    ..lineTo(10.02, 22.50)
    ..lineTo(9.81, 21.17)
    ..lineTo(10.16, 19.34)
    ..lineTo(9.32, 16.79)
    ..lineTo(10.74, 16.38)
    ..lineTo(9.43, 14.29)
    ..close();

  @override
  bool shouldRepaint(_KoreaPainter old) =>
      old.color != color || old.filled != filled;
}
