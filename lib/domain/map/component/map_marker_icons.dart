import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../model/congestion_palette.dart';
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
  ///
  /// **작게 유지한다.** 36pt로 그렸더니 500개가 겹쳐 지도가 통째로 가려졌다 —
  /// 마커는 "여기 뭔가 있다"를 알리는 표식이지 그 자체가 볼거리가 아니다.
  static const int markerSize = 18;

  /// 개별 마커 아이콘. [kind]에 따라 모양이 달라진다.
  static Future<Uint8List> marker(MapMarkerKind kind, Color color) =>
      _draw(markerSize, markerSize, (Canvas canvas, Size size) {
        final Paint fill = Paint()..color = color;
        final Paint stroke = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          // 작아진 만큼 테두리도 얇게 — 굵으면 알맹이가 안 보인다.
          ..strokeWidth = 1.5;
        final Offset center = Offset(size.width / 2, size.height / 2);
        final double r = size.width / 2 - 2;

        switch (kind) {
          case MapMarkerKind.spot:
            canvas
              ..drawCircle(center, r, fill)
              ..drawCircle(center, r, stroke);
          // **지금은 도달하지 않는다**(FR-012 개정 2026-09-18) — repository가 이
          // 종류의 마커를 만들지 않는다. `switch`가 모든 case를 덮어야 하므로
          // 남겨 둔다.
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

  /// 썸네일 마커 한 변. 사진이 알아볼 만하면서 지도를 덮지 않는 크기다.
  static const int photoMarkerSize = 44;

  /// 썸네일을 디코드할 너비.
  ///
  /// 캔버스가 화면 밀도만큼 촘촘히 그리므로(→[_pixelRatio]) 원본도 그만큼 커야 한다.
  /// 여기서 작게 받으면 캔버스를 아무리 촘촘히 그려도 원본에 정보가 없어 흐릿하다.
  static int get photoDecodeWidth => (photoMarkerSize * _pixelRatio).round();

  /// 사진이 들어간 네모 마커.
  ///
  /// **왜 사진인가.** 단색 점으로 그렸더니 카카오 지도가 기본으로 찍는 POI(약국·은행
  /// 아이콘 등)와 섞여, 무엇이 이 앱의 데이터인지 구분되지 않았다. 사진이 들어가면
  /// 한눈에 갈리고, 확대하지 않아도 어떤 장소인지 짐작할 수 있다.
  ///
  /// 종류는 **테두리 색**으로 구분한다(R21) — 사진이 주인공이라 도형을 바꾸면 사진이
  /// 잘린다. 아래쪽 꼬리가 위치를 정확히 가리킨다.
  static Future<Uint8List> photoMarker(
    ui.Image photo,
    Color borderColor, {
    bool highlighted = false,
  }) {
    const int tail = 6;
    return _draw(photoMarkerSize, photoMarkerSize + tail, (
      Canvas canvas,
      Size size,
    ) {
      const double radius = 8;
      final Rect box = Rect.fromLTWH(
        0,
        0,
        photoMarkerSize.toDouble(),
        photoMarkerSize.toDouble(),
      );
      final RRect rounded = RRect.fromRectAndRadius(
        box.deflate(2),
        const Radius.circular(radius),
      );

      // 아래쪽 꼬리 — 마커가 가리키는 지점을 분명히 한다.
      final Path pin = Path()
        ..moveTo(size.width / 2 - 5, box.bottom - 3)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width / 2 + 5, box.bottom - 3)
        ..close();
      canvas.drawPath(pin, Paint()..color = borderColor);

      // 사진을 둥근 사각형에 맞춰 채운다(cover). 비율이 달라도 찌그러지지 않게
      // 짧은 변을 기준으로 잘라 낸다.
      canvas.save();
      canvas.clipRRect(rounded);
      final double scale = math.max(
        rounded.width / photo.width,
        rounded.height / photo.height,
      );
      final double w = photo.width * scale;
      final double h = photo.height * scale;
      canvas.drawImageRect(
        photo,
        Rect.fromLTWH(0, 0, photo.width.toDouble(), photo.height.toDouble()),
        Rect.fromLTWH(
          rounded.left + (rounded.width - w) / 2,
          rounded.top + (rounded.height - h) / 2,
          w,
          h,
        ),
        Paint(),
      );
      canvas.restore();

      // 평소에는 얇은 흰 선으로 지도 배경과 사진을 떼어 놓는다.
      //
      // 종류를 알리는 색 테두리를 3px로 둘렀더니 사진이 그 안에 갇혀 보이고 마커가
      // 실제보다 커 보였다 — 종류 구분은 **꼬리 색**이 이미 하고 있으므로 테두리는
      // 사진 경계를 세우는 역할만 한다.
      //
      // **강조된 마커는 빨간 테두리를 두껍게 두른다** — 검색으로 찾은 그것이
      // 어느 마커인지 한눈에 갈려야 한다(사용자 요청, 2026-08-10).
      canvas.drawRRect(
        rounded,
        Paint()
          ..color = highlighted
              ? const Color(MapMarkerPalette.highlight)
              : Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = highlighted ? 3 : 1.5,
      );
    });
  }

  /// "내 위치" 점 한 변.
  ///
  /// 관광지 마커(44pt)보다 작게 둔다 — 내 위치는 **기준점**이지 볼거리가 아니라,
  /// 크면 주변 장소를 가린다.
  static const int myLocationSize = 22;

  /// 실시간 현재 위치를 가리키는 파란 점.
  ///
  /// **왜 이 모양인가.** 카카오맵·구글맵·네이버지도가 모두 같은 관용을 쓴다 —
  /// 진한 파란 원 + 흰 테두리 + 옅은 후광. 사용자가 이미 "이건 나다"로 읽는 기호라
  /// 새로 발명할 이유가 없다.
  ///
  /// 방향(heading)은 그리지 않는다. 나침반 값은 실내나 저속에서 크게 흔들려,
  /// 부채꼴이 제자리에서 빙빙 도는 것이 위치가 틀린 것보다 더 불안해 보인다.
  static Future<Uint8List> myLocationDot() =>
      _draw(myLocationSize, myLocationSize, (Canvas canvas, Size size) {
        final Offset center = Offset(size.width / 2, size.height / 2);
        const Color blue = Color(MapMarkerPalette.myLocation);

        // 옅은 후광 — 점이 지도 배경 위에서 떠 보이게 한다. 정확도 반경을 뜻하지
        // 않는다(그건 실제 오차와 무관한 고정 크기라 거짓이 된다).
        canvas
          ..drawCircle(
            center,
            size.width / 2,
            Paint()..color = blue.withValues(alpha: 0.18),
          )
          // 흰 테두리가 파란 점과 지도 사이를 갈라 준다 — 파란 계열 위(강·바다)에
          // 올라가도 묻히지 않는다.
          ..drawCircle(center, 7, Paint()..color = Colors.white)
          ..drawCircle(center, 5.5, Paint()..color = blue);
      });

  /// 클러스터 배지. 개수를 안에 적고, 개수가 클수록 원이 커진다(R2).
  ///
  /// 크기를 로그로 키우는 이유는, 선형으로 키우면 500개짜리가 화면을 덮기 때문이다.
  static Future<Uint8List> cluster(int count, Color color) {
    final int size = clusterSize(count);
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

  /// 클러스터 원의 지름. 10개 이하 44, 100개 52, 1000개 60쯤이 된다.
  ///
  /// **호출부가 이 값을 알아야 한다** — `KImage`에 선언하는 크기가 실제 PNG와 다르면
  /// 아이콘이 눌려 보인다.
  static int clusterSize(int count) =>
      (36 + 8 * math.log(math.max(count, 1)) / math.ln10).round().clamp(36, 60);

  static Future<Uint8List> _draw(
    int width,
    int height,
    void Function(Canvas canvas, Size size) paint,
  ) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // **비트맵을 화면 밀도만큼 촘촘히 그린다.**
    //
    // `KImage`의 width/height는 지도에 표시할 **논리 크기**다. 그런데 비트맵까지
    // 논리 크기로 만들면(44×50), 3배 해상도 기기에서 132×150으로 늘려 그리게 되어
    // 사진이 눈에 띄게 흐려진다 — 검색 화면의 같은 썸네일은 선명한데 지도만 흐릿한
    // 이유가 이것이었다.
    //
    // 캔버스를 [_pixelRatio]배로 스케일해 그리면, 좌표 계산은 논리 크기 그대로
    // 두면서 결과 비트맵만 촘촘해진다.
    final double scale = _pixelRatio;
    canvas.scale(scale);
    paint(canvas, Size(width.toDouble(), height.toDouble()));

    final ui.Image image = await recorder.endRecording().toImage(
      (width * scale).round(),
      (height * scale).round(),
    );
    final ByteData? data = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    image.dispose();
    return data!.buffer.asUint8List();
  }

  /// 기기의 화면 밀도. 아이콘 비트맵을 이 배율로 그려야 흐려지지 않는다.
  ///
  /// 상한을 3으로 둔다 — 그보다 촘촘히 그려도 눈에 띄는 차이가 없고 메모리만 는다.
  static double get _pixelRatio {
    final double ratio =
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    return ratio.clamp(1.0, 3.0);
  }
}
