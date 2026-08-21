import 'dart:math' as math;

import 'cell_geometry.dart';

/// 경위도를 화면 좌표로 옮기는 계산(설계 §3).
///
/// **경도를 그대로 쓰면 지도가 가로로 늘어진다.** 36°N에서 경도 1도의 실거리는
/// 위도 1도의 약 0.81배다. `cos(위도)`로 줄여서 비율을 맞춘다.
///
/// 순수 계산이라 위젯 없이 검증할 수 있다. 화면 크기를 받아 배율과 여백을
/// 정하고, 그 뒤로는 [toScreen]/[toGeo]가 서로의 역이다.
class CellProjection {
  const CellProjection._({
    required this.bounds,
    required this.scale,
    required this.offsetX,
    required this.offsetY,
    required this.lngScale,
  });

  /// [bounds]를 [width]×[height]에 비율을 지켜 담는 투영을 만든다.
  ///
  /// [cover]가 참이면 **짧은 쪽을 채운다** — 세로로 긴 폰에서 `fit`으로 맞추면
  /// 한국이 세로로 길어 좌우에 빈 바다가 크게 남고 지도가 작아 보인다. 넘치는
  /// 부분은 확대·이동으로 본다.
  ///
  /// 남는 쪽은 가운데 정렬한다.
  factory CellProjection.fit({
    required GeoBounds bounds,
    required double width,
    required double height,
    double padding = 0,
    bool cover = false,
  }) {
    final double midLat = (bounds.minLat + bounds.maxLat) / 2;
    final double lngScale = math.cos(midLat * math.pi / 180);

    final double spanX = (bounds.maxLng - bounds.minLng) * lngScale;
    final double spanY = bounds.maxLat - bounds.minLat;

    final double usableW = width - padding * 2;
    final double usableH = height - padding * 2;
    // 폭이 0 이하인 화면에서도 계산이 깨지지 않게 막는다.
    final double safeW = usableW > 0 ? usableW : 1;
    final double safeH = usableH > 0 ? usableH : 1;

    final double scale = spanX <= 0 || spanY <= 0
        ? 1
        : cover
        ? math.max(safeW / spanX, safeH / spanY)
        : math.min(safeW / spanX, safeH / spanY);

    return CellProjection._(
      bounds: bounds,
      scale: scale,
      offsetX: padding + (safeW - spanX * scale) / 2,
      offsetY: padding + (safeH - spanY * scale) / 2,
      lngScale: lngScale,
    );
  }

  final GeoBounds bounds;

  /// 보정된 1도당 화면 픽셀.
  final double scale;

  final double offsetX;
  final double offsetY;

  /// 경도에 곱하는 위도 보정 계수.
  final double lngScale;

  /// 경위도 -> 화면 좌표. 위도는 위아래가 뒤집힌다(북쪽이 화면 위).
  ({double dx, double dy}) toScreen(GeoPoint p) => (
    dx: offsetX + (p.lng - bounds.minLng) * lngScale * scale,
    dy: offsetY + (bounds.maxLat - p.lat) * scale,
  );

  /// 화면 좌표 -> 경위도. [toScreen]의 역이며 탭 히트 테스트에 쓴다.
  GeoPoint toGeo(double dx, double dy) => GeoPoint(
    bounds.minLng + (dx - offsetX) / (lngScale * scale),
    bounds.maxLat - (dy - offsetY) / scale,
  );
}
