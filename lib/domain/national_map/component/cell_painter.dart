import 'package:flutter/material.dart';

import '../model/cell_geometry.dart';
import '../model/cell_projection.dart';
import '../model/landmark_kind.dart';
import '../model/province_palette.dart';
import 'landmark_icons.dart';

/// 전국 지도 161칸을 그리는 팔레트.
///
/// 참조 디자인은 스크래치 지도(긁어서 채우는 종이 지도)다. 그 **개념**만 가져오고
/// 색은 앱과 어울리게 눌렀다 — 포스터의 하늘색 바다·형광 원색을 그대로 옮기면
/// 웜 톤인 앱 안에서 이 화면만 떠 보인다.
///
/// **방문 칸은 시도별로 색이 다르다**(`ProvincePalette`). 하나의 브랜드색으로만
/// 칠하면 몇 칸을 채우든 빨간 얼룩으로 보여 채우는 재미가 사라진다.
class CellPalette {
  const CellPalette({
    required this.unvisitedFill,
    required this.border,
    required this.selectedBorder,
    required this.overlapFill,
    required this.fallbackVisitedFill,
    required this.iconColor,
    required this.iconAccent,
  });

  /// 화면 테마에서 팔레트를 만든다. 색을 위젯마다 고르지 않고 여기 모은다.
  factory CellPalette.of(ColorScheme scheme) => CellPalette(
    // 미방문은 "빈 칸"이지 "비활성"이 아니다. 배경보다 한 단 진해야 칸의 모양이
    // 보이고, 채워야 할 곳이 몇인지 읽힌다.
    unvisitedFill: scheme.surfaceDim,
    // 칸 사이는 배경색으로 벌린다 — 선을 긋는 것보다 종이를 오려 붙인 느낌이 난다.
    border: scheme.surface,
    selectedBorder: scheme.onSurface,
    overlapFill: scheme.tertiary,
    fallbackVisitedFill: scheme.primary,
    // 아이콘은 칸 색 위에 얹히므로 흰색이어야 어느 시도에서든 읽힌다.
    iconColor: const Color(0xFFFFFFFF),
    iconAccent: const Color(0x9EFFFFFF),
  );

  final Color unvisitedFill;
  final Color border;
  final Color selectedBorder;

  /// 공유 지도에서 나와 상대가 함께 방문한 칸(R37).
  final Color overlapFill;

  /// 시도 색을 모르는 칸의 방문 색.
  final Color fallbackVisitedFill;

  final Color iconColor;
  final Color iconAccent;
}

/// 161칸을 그린다(설계 §3).
///
/// 지도 타일 위에 얹지 않고 직접 그린다. 칸은 지리적 정확도가 목적이 아니라
/// "내가 채운 기록"을 보여주는 도형이다.
class CellPainter extends CustomPainter {
  const CellPainter({
    required this.cells,
    required this.visitedCellIds,
    required this.palette,
    this.overlappingCellIds,
    this.selectedCellId,
    this.padding = 12,
    this.showLandmarks = true,
    this.cover = false,
  });

  /// 그릴 칸 도형. 각자 서버 칸 id와 시도 코드를 갖고 있다.
  final List<CellGeometry> cells;

  /// 방문한 **칸 id**.
  final Set<String> visitedCellIds;

  /// 겹치는 칸 id(공유 지도 전용). null이면 겹침 UI를 그리지 않는다.
  final Set<String>? overlappingCellIds;

  final String? selectedCellId;
  final CellPalette palette;
  final double padding;

  /// 랜드마크 그림을 그릴지. 작은 미리보기에서는 끈다.
  final bool showLandmarks;

  /// 짧은 쪽을 채울지. 세로로 긴 화면에서 빈 바다를 줄인다.
  final bool cover;

  /// 아이콘을 그리는 최소 칸 크기(px). 이보다 작으면 뭉개져서 생략한다.
  static const double _minIconBox = 22;

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty) return;

    final CellProjection projection = projectionFor(size, padding: padding);

    final Paint fill = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..color = palette.border;

    Path? selectedPath;

    // 1) 칸을 칠한다.
    for (final CellGeometry cell in cells) {
      final Path path = _pathOf(cell, projection);

      fill.color = _fillOf(cell);
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);

      if (cell.cellId == selectedCellId) selectedPath = path;
    }

    // 2) 랜드마크는 칸을 다 칠한 뒤 얹는다 — 섞어 그리면 이웃 칸에 가린다.
    if (showLandmarks) {
      for (final CellGeometry cell in cells) {
        if (!visitedCellIds.contains(cell.cellId)) continue;
        _paintLandmark(canvas, cell, projection);
      }
    }

    // 3) 선택된 칸은 맨 위에 다시 그려 이웃 칸의 테두리에 가리지 않게 한다.
    if (selectedPath != null) {
      canvas.drawPath(
        selectedPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6
          ..strokeJoin = StrokeJoin.round
          ..isAntiAlias = true
          ..color = palette.selectedBorder,
      );
    }
  }

  /// 칸의 화면상 크기에 맞춰 랜드마크를 그린다.
  ///
  /// **작은 칸에는 그리지 않는다.** 20px 칸에 그림을 넣으면 무엇인지 안 보이고
  /// 얼룩만 남아 오히려 지저분해진다.
  void _paintLandmark(
    Canvas canvas,
    CellGeometry cell,
    CellProjection projection,
  ) {
    final LandmarkKind? landmark = cell.landmark;
    if (landmark == null) return;

    final List<GeoPoint> ring = cell.polygons.first;
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    for (final GeoPoint p in ring) {
      final ({double dx, double dy}) s = projection.toScreen(p);
      if (s.dx < minX) minX = s.dx;
      if (s.dx > maxX) maxX = s.dx;
      if (s.dy < minY) minY = s.dy;
      if (s.dy > maxY) maxY = s.dy;
    }

    final double w = maxX - minX;
    final double h = maxY - minY;
    final double box = w < h ? w : h;
    if (box < _minIconBox) return;

    // 칸이 클수록 크게, 다만 한없이 커지지는 않게 묶는다.
    final double iconSize = (box * 0.62).clamp(14.0, 34.0);
    final ({double dx, double dy}) c = projection.toScreen(cell.center);

    LandmarkIcons.paint(
      canvas,
      landmark,
      center: Offset(c.dx, c.dy),
      size: iconSize,
      color: palette.iconColor,
      accentColor: palette.iconAccent,
    );
  }

  Color _fillOf(CellGeometry cell) {
    final String id = cell.cellId;
    if (overlappingCellIds != null && overlappingCellIds!.contains(id)) {
      return palette.overlapFill;
    }
    if (!visitedCellIds.contains(id)) return palette.unvisitedFill;
    return ProvincePalette.of(
      cell.provinceCode,
      fallback: palette.fallbackVisitedFill,
    );
  }

  Path _pathOf(CellGeometry cell, CellProjection projection) {
    final Path path = Path();
    for (final List<GeoPoint> ring in cell.polygons) {
      if (ring.isEmpty) continue;
      final ({double dx, double dy}) first = projection.toScreen(ring.first);
      path.moveTo(first.dx, first.dy);
      for (int i = 1; i < ring.length; i++) {
        final ({double dx, double dy}) p = projection.toScreen(ring[i]);
        path.lineTo(p.dx, p.dy);
      }
      path.close();
    }
    return path;
  }

  /// 이 칸 목록 전체를 [size] 안에 담는 투영.
  ///
  /// 탭 좌표를 경위도로 되돌릴 때 화면과 **같은 투영**을 써야 하므로 밖에서도
  /// 만들 수 있게 열어 둔다.
  CellProjection projectionFor(Size size, {double padding = 12}) =>
      CellProjection.fit(
        bounds: boundsOf(cells),
        width: size.width,
        height: size.height,
        padding: padding,
        cover: cover,
      );

  /// 칸 목록 전체를 감싸는 경위도 사각형.
  static GeoBounds boundsOf(List<CellGeometry> cells) {
    GeoBounds bounds = cells.first.bounds;
    for (int i = 1; i < cells.length; i++) {
      bounds = bounds.merge(cells[i].bounds);
    }
    return bounds;
  }

  @override
  bool shouldRepaint(CellPainter old) =>
      old.cells != cells ||
      old.selectedCellId != selectedCellId ||
      old.showLandmarks != showLandmarks ||
      old.cover != cover ||
      old.palette.unvisitedFill != palette.unvisitedFill ||
      !setEquals(old.visitedCellIds, visitedCellIds) ||
      !setEquals(old.overlappingCellIds, overlappingCellIds);

  static bool setEquals(Set<String>? a, Set<String>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
