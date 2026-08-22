import 'package:flutter/material.dart';

import '../model/cell_geometry.dart';
import '../model/cell_projection.dart';
import 'landmark_category_tint.dart';
import 'landmark_icon_cache.dart';

/// 전국 지도 161칸을 그리는 팔레트.
///
/// 참조 디자인은 스크래치 지도(긁어서 채우는 종이 지도)다. 그 **개념**만 가져오고
/// 색은 앱과 어울리게 눌렀다 — 포스터의 하늘색 바다·형광 원색을 그대로 옮기면
/// 웜 톤인 앱 안에서 이 화면만 떠 보인다.
///
/// **방문 칸은 카테고리별 틴트다**(SPEC-0031). 시도별 18색을 쓰던 것을 바꿨다 —
/// 이제 칸마다 랜드마크 아이콘이 얹히므로 면 색은 그 랜드마크의 성격을 거들고,
/// 아이콘이 묻히지 않게 연해야 한다.
class CellPalette {
  const CellPalette({
    required this.unvisitedFill,
    required this.border,
    required this.selectedBorder,
    required this.fallbackVisitedFill,
  });

  /// 화면 테마에서 팔레트를 만든다. 색을 위젯마다 고르지 않고 여기 모은다.
  factory CellPalette.of(ColorScheme scheme) => CellPalette(
    // 미방문은 "빈 칸"이지 "비활성"이 아니다. 배경보다 한 단 진해야 칸의 모양이
    // 보이고, 채워야 할 곳이 몇인지 읽힌다.
    unvisitedFill: scheme.surfaceDim,
    // 칸 사이는 배경색으로 벌린다 — 선을 긋는 것보다 종이를 오려 붙인 느낌이 난다.
    border: scheme.surface,
    selectedBorder: scheme.onSurface,
    fallbackVisitedFill: scheme.primary,
  );

  final Color unvisitedFill;
  final Color border;
  final Color selectedBorder;

  /// 카테고리를 모르는 칸의 방문 색.
  final Color fallbackVisitedFill;
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
    this.iconCache,
    this.overlappingCellIds,
    this.selectedCellId,
    this.padding = 12,
    this.showLandmarks = true,
    this.cover = false,
    this.minIconBox = defaultMinIconBox,
  });

  /// 아이콘 그림 캐시. null이면 아이콘을 그리지 않는다(작은 미리보기·테스트).
  final LandmarkIconCache? iconCache;

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
  final double minIconBox;

  /// [minIconBox]의 기본값. SPEC-0030에서 쓰던 값을 승계한다(스펙 R15).
  static const double defaultMinIconBox = 22;

  /// 제주의 시도 코드.
  static const String _jejuProvince = '50';

  /// 제주를 화면에서 이만큼 위로 올린다.
  ///
  /// 제주는 본토에서 한참 남쪽이라 지도를 화면에 맞추면 아래쪽에 홀로 떨어져
  /// 하단 바에 닿아 보인다. 종이 지도가 제주를 네모 상자에 따로 담는 것과 같은
  /// 이유로 **화면에서만** 당겨 올린다 — 좌표 자체는 건드리지 않는다.
  ///
  /// **히트 테스트도 같은 값을 써야 한다**(`CellPainter.screenOffsetOf`).
  /// 어긋나면 보이는 곳과 눌리는 곳이 달라진다.
  static const Offset _jejuOffset = Offset(0, -12);

  /// 이 칸을 화면에서 옮길 양. 대부분 0이다.
  static Offset screenOffsetOf(CellGeometry cell) =>
      cell.provinceCode == _jejuProvince ? _jejuOffset : Offset.zero;

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
    //
    // **모든 칸에 그린다**(SPEC-0031 §5). 미방문 칸도 무채색 아이콘을 얹어 무엇이
    // 있는 곳인지 미리 보여 준다 — 방문 여부는 **어느 변형을 쓸지**만 가른다.
    final LandmarkIconCache? cache = iconCache;
    if (showLandmarks && cache != null) {
      final Set<String> filled = overlappingCellIds ?? visitedCellIds;
      for (final CellGeometry cell in cells) {
        _paintLandmark(
          canvas,
          cell,
          projection,
          cache,
          visited: filled.contains(cell.cellId),
        );
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
  /// **작은 칸에는 그리지 않는다.** 22px보다 좁은 칸에 그림을 넣으면 무엇인지
  /// 안 보이고 얼룩만 남아 오히려 지저분해진다(R18).
  ///
  /// **칸 도형으로 자르지 않는다.** 아이콘은 칸을 설명하는 기호이지 칸의 무늬가
  /// 아니다 — 클리핑하면 실루엣이 잘려 무엇인지 알 수 없게 된다.
  void _paintLandmark(
    Canvas canvas,
    CellGeometry cell,
    CellProjection projection,
    LandmarkIconCache cache, {
    required bool visited,
  }) {
    final String? slug = cell.landmarkSlug;
    if (slug == null) return;

    final LandmarkIconPicture? info = cache.pictureOf(
      LandmarkIconKey(slug, visited: visited),
    );
    // 캐시 미스면 이번 프레임은 면 색만 그린다. paint()에서 await하지 않는다.
    if (info == null) return;

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
    if (box < minIconBox) return;

    // 칸이 클수록 크게, 다만 한없이 커지지는 않게 묶는다.
    //
    // **하한을 [minIconBox]로 두면 안 된다.** 그러면 22px 칸에 22px 아이콘이
    // 들어가 칸을 가득 채우고 이웃까지 넘본다 — 지도가 아이콘 벽이 된다.
    // 하한은 표시 하한(22)보다 낮아야 하고, 상한도 칸 대비 비율로 묶는다.
    final double iconSize = (box * 0.52).clamp(12.0, 30.0);
    final ({double dx, double dy}) c = projection.toScreen(cell.center);
    final Offset shift = screenOffsetOf(cell);

    // 그림은 120×120 viewBox 기준이라 칸 크기에 맞춰 줄인다.
    // save/restore로 감싸지 않으면 이후 칸이 전부 같은 변환을 물려받는다.
    final double scale = iconSize / info.size.width;
    canvas
      ..save()
      ..translate(
        c.dx + shift.dx - iconSize / 2,
        c.dy + shift.dy - iconSize / 2,
      )
      ..scale(scale)
      ..drawPicture(info.picture)
      ..restore();
  }

  Color _fillOf(CellGeometry cell) {
    final String id = cell.cellId;

    // 겹침 모드(공유 지도)에서는 **겹치는 칸만** 칠한다 — 이 화면이 답하는
    // 질문은 "어디가 겹치나"이지 "이 사람이 어디를 갔나"가 아니다.
    //
    // **색은 전국 지도와 같은 시도색이다.** 한 가지 색으로만 칠하면 칸이 늘수록
    // 지도가 통째로 빨개져 채우는 재미가 사라진다(실기기 확인).
    final Set<String>? overlapping = overlappingCellIds;
    if (overlapping != null && !overlapping.contains(id)) {
      return palette.unvisitedFill;
    }

    if (overlapping == null && !visitedCellIds.contains(id)) {
      return palette.unvisitedFill;
    }
    // 방문 칸은 **카테고리 틴트**다(SPEC-0031). 시도색을 쓰던 것을 바꿨다 —
    // 아이콘이 면 위에 얹히므로 면이 진하면 아이콘이 묻힌다.
    return LandmarkCategoryTint.of(
      cell.landmarkCategory,
      fallback: palette.fallbackVisitedFill,
    );
  }

  Path _pathOf(CellGeometry cell, CellProjection projection) {
    final Offset shift = screenOffsetOf(cell);
    final Path path = Path();
    for (final List<GeoPoint> ring in cell.polygons) {
      if (ring.isEmpty) continue;
      final ({double dx, double dy}) first = projection.toScreen(ring.first);
      path.moveTo(first.dx + shift.dx, first.dy + shift.dy);
      for (int i = 1; i < ring.length; i++) {
        final ({double dx, double dy}) p = projection.toScreen(ring[i]);
        path.lineTo(p.dx + shift.dx, p.dy + shift.dy);
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
      old.minIconBox != minIconBox ||
      old.palette.unvisitedFill != palette.unvisitedFill ||
      // 캐시가 비동기로 채워지므로 올라온 그림 수가 바뀌면 다시 그려야 한다.
      // 인스턴스만 비교하면 프리로드가 끝나도 화면이 갱신되지 않는다.
      old.iconCache != iconCache ||
      old.iconCache?.length != iconCache?.length ||
      !setEquals(old.visitedCellIds, visitedCellIds) ||
      !setEquals(old.overlappingCellIds, overlappingCellIds);

  static bool setEquals(Set<String>? a, Set<String>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
