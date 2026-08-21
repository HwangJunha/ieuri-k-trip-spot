import 'package:flutter/material.dart';

import '../model/landmark_kind.dart';

/// 랜드마크 유형별 그림(SPEC-0030).
///
/// 레퍼런스(스크래치 지도 포스터)처럼 **단순한 실루엣**이다. 칸 안에 20~60px로
/// 들어가도 무엇인지 읽혀야 하므로 디테일을 넣지 않는다.
///
/// 24×24 좌표계에 그리고 `canvas.scale`로 칸 크기에 맞춘다. 이미지 자산이 아니라
/// 도형이라 어떤 배율에서도 또렷하다.
class LandmarkIcons {
  const LandmarkIcons._();

  /// [kind]를 [center]에 [size]픽셀 크기로 그린다.
  ///
  /// [color]는 본체, [accentColor]는 문·창·그림자처럼 한 단 죽인 부분이다.
  static void paint(
    Canvas canvas,
    LandmarkKind kind, {
    required Offset center,
    required double size,
    required Color color,
    required Color accentColor,
  }) {
    canvas.save();
    // 24×24 좌표계의 가운데가 (12,12)다.
    final double scale = size / 24;
    canvas.translate(center.dx - size / 2, center.dy - size / 2);
    canvas.scale(scale);

    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..isAntiAlias = true;
    final Paint accent = Paint()
      ..style = PaintingStyle.fill
      ..color = accentColor
      ..isAntiAlias = true;
    final Paint line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color
      ..isAntiAlias = true;

    switch (kind) {
      case LandmarkKind.mountain:
        _mountain(canvas, fill, accent);
      case LandmarkKind.temple:
        _temple(canvas, fill, line);
      case LandmarkKind.fortress:
        _fortress(canvas, fill, accent);
      case LandmarkKind.hanok:
        _hanok(canvas, fill, accent, line);
      case LandmarkKind.sea:
        _sea(canvas, fill, line);
      case LandmarkKind.water:
        _water(canvas, line);
      case LandmarkKind.forest:
        _forest(canvas, fill, accent);
      case LandmarkKind.bridge:
        _bridge(canvas, line, accent);
      case LandmarkKind.food:
        _food(canvas, fill, accent, line);
      case LandmarkKind.modern:
        _modern(canvas, fill, accent);
      case LandmarkKind.tower:
        _tower(canvas, fill, line);
    }

    canvas.restore();
  }

  /// 봉우리 둘에 눈 덮인 정상.
  static void _mountain(Canvas canvas, Paint fill, Paint accent) {
    canvas.drawPath(
      _poly(<double>[2, 20, 9, 8, 13, 14, 16, 10, 22, 20]),
      fill,
    );
    // 눈은 본체보다 밝아야 하므로 흰색을 직접 쓴다.
    canvas.drawPath(
      _poly(<double>[9, 8, 6.6, 12, 11.4, 12]),
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..isAntiAlias = true,
    );
    // accent를 안 쓰면 lint가 뜨므로 그림자 한 줄로 쓴다.
    canvas.drawPath(_poly(<double>[16, 10, 14, 14, 18.5, 14]), accent);
  }

  /// 기와지붕과 기둥.
  static void _temple(Canvas canvas, Paint fill, Paint line) {
    canvas.drawPath(
      _poly(<double>[3, 10, 12, 4, 21, 10, 19, 10, 19, 11, 5, 11, 5, 10]),
      fill,
    );
    for (final double x in <double>[6, 10, 14, 18]) {
      canvas.drawLine(Offset(x, 12), Offset(x, 19), line);
    }
    canvas.drawPath(_poly(<double>[4, 20, 20, 20, 20, 21.5, 4, 21.5]), fill);
  }

  /// 성벽 요철과 문.
  static void _fortress(Canvas canvas, Paint fill, Paint accent) {
    canvas.drawPath(
      _poly(<double>[
        3, 9, 6, 9, 6, 7, 9, 7, 9, 9, 12, 9, 12, 7, 15, 7,
        15, 9, 18, 9, 18, 7, 21, 7, 21, 20, 3, 20,
      ]),
      fill,
    );
    canvas.drawPath(_poly(<double>[10, 13, 14, 13, 14, 20, 10, 20]), accent);
  }

  /// 처마 끝이 들린 한옥 지붕.
  static void _hanok(Canvas canvas, Paint fill, Paint accent, Paint line) {
    final Path roof = Path()
      ..moveTo(1, 12)
      ..quadraticBezierTo(4, 12, 5, 10)
      ..quadraticBezierTo(12, 3, 19, 10)
      ..quadraticBezierTo(20, 12, 23, 12)
      ..quadraticBezierTo(12, 8.5, 1, 12)
      ..close();
    canvas.drawPath(roof, fill);
    canvas.drawLine(const Offset(6, 12.5), const Offset(6, 20), line);
    canvas.drawLine(const Offset(18, 12.5), const Offset(18, 20), line);
    canvas.drawPath(_poly(<double>[9, 13.5, 15, 13.5, 15, 20, 9, 20]), accent);
    canvas.drawLine(const Offset(4, 20), const Offset(20, 20), line);
  }

  /// 해와 물결.
  static void _sea(Canvas canvas, Paint fill, Paint line) {
    canvas.drawCircle(const Offset(17, 7), 3.5, fill);
    _wave(canvas, line, 15);
    _wave(canvas, line, 20);
  }

  /// 물결선 셋. 덩어리로 칠하면 흰 얼룩이 된다.
  static void _water(Canvas canvas, Paint line) {
    _wave(canvas, line, 8);
    _wave(canvas, line, 14);
    _wave(canvas, line, 20);
  }

  static void _wave(Canvas canvas, Paint line, double y) {
    final Path p = Path()..moveTo(2, y);
    for (double x = 2; x < 22; x += 4) {
      p.quadraticBezierTo(x + 2, y - 3, x + 4, y);
    }
    canvas.drawPath(p, line);
  }

  /// 침엽수 둘.
  static void _forest(Canvas canvas, Paint fill, Paint accent) {
    canvas.drawPath(_poly(<double>[8, 4, 12, 11, 4, 11]), fill);
    canvas.drawPath(_poly(<double>[8, 8, 13, 16, 3, 16]), fill);
    canvas.drawPath(_poly(<double>[7, 16, 9, 16, 9, 20, 7, 20]), accent);
    canvas.drawPath(_poly(<double>[17, 7, 21, 14, 13, 14]), fill);
    canvas.drawPath(_poly(<double>[16, 14, 18, 14, 18, 20, 16, 20]), accent);
  }

  /// 현수교.
  static void _bridge(Canvas canvas, Paint line, Paint accent) {
    final Path arch = Path()
      ..moveTo(2, 16)
      ..quadraticBezierTo(12, 6, 22, 16);
    canvas.drawPath(arch, line);
    canvas.drawLine(const Offset(2, 18), const Offset(22, 18), line);

    final Paint thin = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round
      ..color = accent.color
      ..isAntiAlias = true;
    canvas.drawLine(const Offset(6, 13), const Offset(6, 18), thin);
    canvas.drawLine(const Offset(12, 10.5), const Offset(12, 18), thin);
    canvas.drawLine(const Offset(18, 13), const Offset(18, 18), thin);
  }

  /// 바구니에 담긴 열매.
  static void _food(Canvas canvas, Paint fill, Paint accent, Paint line) {
    canvas.drawCircle(const Offset(8, 9), 3, fill);
    canvas.drawCircle(const Offset(15.5, 9.5), 2.6, fill);
    canvas.drawLine(const Offset(12, 6.5), const Offset(12, 4), line);
    canvas.drawPath(
      _poly(<double>[3.5, 13, 20.5, 13, 18.5, 20.5, 5.5, 20.5]),
      accent,
    );
  }

  /// 건물 셋.
  static void _modern(Canvas canvas, Paint fill, Paint accent) {
    canvas.drawPath(_poly(<double>[3, 12, 9, 12, 9, 20, 3, 20]), fill);
    canvas.drawPath(_poly(<double>[10, 7, 16, 7, 16, 20, 10, 20]), fill);
    canvas.drawPath(_poly(<double>[17, 14, 21, 14, 21, 20, 17, 20]), fill);

    final Paint thin = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..color = accent.color
      ..isAntiAlias = true;
    for (final double y in <double>[10, 13, 16]) {
      canvas.drawLine(Offset(12, y), Offset(14, y), thin);
    }
  }

  /// 층탑.
  static void _tower(Canvas canvas, Paint fill, Paint line) {
    canvas.drawPath(_poly(<double>[6, 8, 18, 8, 16, 10, 8, 10]), fill);
    canvas.drawPath(_poly(<double>[7, 11, 17, 11, 15.5, 13, 8.5, 13]), fill);
    canvas.drawPath(_poly(<double>[8, 14, 16, 14, 14.5, 16, 9.5, 16]), fill);
    canvas.drawPath(_poly(<double>[9, 17, 15, 17, 15, 20, 9, 20]), fill);
    canvas.drawLine(const Offset(12, 4), const Offset(12, 8), line);
  }

  /// `[x0, y0, x1, y1, ...]`로 닫힌 다각형을 만든다.
  static Path _poly(List<double> xy) {
    final Path p = Path()..moveTo(xy[0], xy[1]);
    for (int i = 2; i < xy.length; i += 2) {
      p.lineTo(xy[i], xy[i + 1]);
    }
    return p..close();
  }
}
