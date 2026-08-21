import 'package:flutter/material.dart';

import '../model/cell_geometry.dart';
import '../model/cell_projection.dart';

/// 전국 지도 161칸을 그리는 팔레트.
///
/// 참조 디자인은 스크래치 지도(긁어서 채우는 종이 지도)다. 그 **개념**만 가져오고
/// 색은 앱 팔레트를 쓴다 — 포스터의 하늘색 바다·회색 칸을 그대로 옮기면 웜 코럴
/// 톤인 앱 안에서 이 화면만 떠 보인다.
///
/// 미방문은 표면 톤으로 가라앉히고 방문은 브랜드 코럴로 채운다. "채워나간다"가
/// 한눈에 읽히는 것이 이 화면의 목적이다.
class CellPalette {
  const CellPalette({
    required this.visitedFill,
    required this.unvisitedFill,
    required this.border,
    required this.selectedBorder,
    required this.overlapFill,
  });

  /// 화면 테마에서 팔레트를 만든다. 색을 위젯마다 고르지 않고 여기 모은다.
  factory CellPalette.of(ColorScheme scheme) => CellPalette(
    visitedFill: scheme.primary,
    // 미방문은 "빈 칸"이지 "비활성"이 아니다. `surfaceContainerHighest`는 배경과
    // 너무 가까워 칸이 사라져 보였다(실측) — 한 단 더 진한 `surfaceDim`을 쓴다.
    unvisitedFill: scheme.surfaceDim,
    // 칸 사이는 배경색으로 벌린다 — 선을 긋는 것보다 종이를 오려 붙인 느낌이 난다.
    border: scheme.surface,
    selectedBorder: scheme.onSurface,
    overlapFill: scheme.tertiary,
  );

  final Color visitedFill;
  final Color unvisitedFill;
  final Color border;
  final Color selectedBorder;

  /// 공유 지도에서 나와 상대가 함께 방문한 칸(R37).
  final Color overlapFill;
}

/// 161칸을 그린다(설계 §3).
///
/// 지도 타일 위에 얹지 않고 직접 그린다. 칸은 지리적 정확도가 목적이 아니라
/// "내가 채운 기록"을 보여주는 도형이다.
class CellPainter extends CustomPainter {
  const CellPainter({
    required this.cells,
    required this.cellIdOf,
    required this.visitedCellIds,
    required this.palette,
    this.overlappingCellIds,
    this.selectedCellId,
    this.padding = 12,
  });

  final List<CellGeometry> cells;

  /// 도형 코드 -> 서버 칸 id.
  ///
  /// 도형 자산의 `code`와 서버의 `id`는 서로 다른 체계라 이 맵으로 잇는다
  /// (`CellGeometryIndex`).
  final Map<String, String> cellIdOf;

  /// 방문한 **칸 id**.
  final Set<String> visitedCellIds;

  /// 겹치는 칸 id(공유 지도 전용). null이면 겹침 UI를 그리지 않는다.
  final Set<String>? overlappingCellIds;

  final String? selectedCellId;
  final CellPalette palette;
  final double padding;

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty) return;

    final CellProjection projection = projectionFor(size, padding: padding);

    final Paint fill = Paint()..style = PaintingStyle.fill;
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeJoin = StrokeJoin.round
      ..color = palette.border;

    Path? selectedPath;

    for (final CellGeometry cell in cells) {
      final Path path = _pathOf(cell, projection);

      final String? cellId = cellIdOf[cell.code];
      fill.color = _fillOf(cellId);
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);

      if (cellId != null && cellId == selectedCellId) selectedPath = path;
    }

    // 선택된 칸은 맨 위에 다시 그려 이웃 칸의 테두리에 가리지 않게 한다.
    if (selectedPath != null) {
      canvas.drawPath(
        selectedPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeJoin = StrokeJoin.round
          ..color = palette.selectedBorder,
      );
    }
  }

  Color _fillOf(String? cellId) {
    if (cellId == null) return palette.unvisitedFill;
    if (overlappingCellIds != null && overlappingCellIds!.contains(cellId)) {
      return palette.overlapFill;
    }
    return visitedCellIds.contains(cellId)
        ? palette.visitedFill
        : palette.unvisitedFill;
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
      old.palette.visitedFill != palette.visitedFill ||
      old.cellIdOf.length != cellIdOf.length ||
      !setEquals(old.visitedCellIds, visitedCellIds) ||
      !setEquals(old.overlappingCellIds, overlappingCellIds);

  static bool setEquals(Set<String>? a, Set<String>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
