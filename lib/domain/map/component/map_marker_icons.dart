import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../model/map_marker.dart';

/// 지도 마커 아이콘을 런타임에 그린다.
///
/// **에셋 PNG 대신 캔버스로 그리는 이유**: 종류(2종) × 상태를 조합한 이미지를 전부
/// 파일로 두면 해상도별로 관리해야 하고, 클러스터는 개수가 들어가 정적 이미지로
/// 만들 수 없다. 한 곳에서 그리면 모양 규칙이 코드로 남는다.
///
/// **종류는 모양으로 구분한다**(R21). 색으로만 구분하면 아래 혼잡도 폴리곤 채색과
/// 섞여 읽기 어려워진다(설계 §4.1) — 그래서 spot은 원, 행사는 각진 다이아몬드다.
abstract final class MapMarkerIcons {
  /// 마커 한 변(논리 픽셀). 터치 타깃이 아니라 그림 크기다.
  static const int markerSize = 36;

  /// 개별 마커 아이콘. [kind]에 따라 모양이 달라진다.
  static Future<Uint8List> marker(MapMarkerKind kind, Color color) =>
      _draw(markerSize, markerSize, (Canvas canvas, Size size) {
        final Paint fill = Paint()..color = color;
        final Paint stroke = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;
        final Offset center = Offset(size.width / 2, size.height / 2);
        final double r = size.width / 2 - 3;

        switch (kind) {
          case MapMarkerKind.spot:
            canvas
              ..drawCircle(center, r, fill)
              ..drawCircle(center, r, stroke);
          case MapMarkerKind.culturalEvent:
            // 45도 돌린 사각형(다이아몬드). 원과 실루엣이 뚜렷이 달라 색을 못 봐도
            // 구분된다.
            final Path path = Path()
              ..moveTo(center.dx, center.dy - r)
              ..lineTo(center.dx + r, center.dy)
              ..lineTo(center.dx, center.dy + r)
              ..lineTo(center.dx - r, center.dy)
              ..close();
            canvas
              ..drawPath(path, fill)
              ..drawPath(path, stroke);
        }
      });

  /// 클러스터 배지. 개수를 안에 적고, 개수가 클수록 원이 커진다(R2).
  ///
  /// 크기를 로그로 키우는 이유는, 선형으로 키우면 500개짜리가 화면을 덮기 때문이다.
  static Future<Uint8List> cluster(int count, Color color) {
    final int size = _clusterSize(count);
    return _draw(size, size, (Canvas canvas, Size canvasSize) {
      final Offset center = Offset(canvasSize.width / 2, canvasSize.height / 2);
      final double r = canvasSize.width / 2 - 2;

      canvas
        ..drawCircle(center, r, Paint()..color = color.withValues(alpha: 0.92))
        ..drawCircle(
          center,
          r,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );

      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: '$count',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.36,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        center - Offset(painter.width / 2, painter.height / 2),
      );
    });
  }

  /// 클러스터 원의 지름. 10개 이하 40, 100개 44, 1000개 52쯤이 된다.
  static int _clusterSize(int count) =>
      (36 + 8 * math.log(math.max(count, 1)) / math.ln10).round().clamp(36, 60);

  static Future<Uint8List> _draw(
    int width,
    int height,
    void Function(Canvas canvas, Size size) paint,
  ) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Size size = Size(width.toDouble(), height.toDouble());
    paint(Canvas(recorder), size);

    final ui.Image image = await recorder.endRecording().toImage(width, height);
    final ByteData? data = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    image.dispose();
    return data!.buffer.asUint8List();
  }
}
