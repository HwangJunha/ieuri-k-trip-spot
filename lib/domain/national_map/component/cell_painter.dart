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
      // 그림 위에 그리므로 얇으면 묻힌다. 칸을 오려 붙인 인상을 유지하되
      // 경계가 읽히는 최소 굵기다.
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..color = palette.border;

    Path? selectedPath;

    // 칸 도형은 두 번 쓴다 — 면을 칠할 때, 그리고 그림을 그 모양으로 자를 때.
    // 두 번 만들지 않고 들고 간다.
    final List<Path> paths = <Path>[
      for (final CellGeometry cell in cells) _pathOf(cell, projection),
    ];

    // 1) 칸 면을 칠한다. 테두리는 그림을 얹은 뒤에 그린다(3단계).
    for (int i = 0; i < cells.length; i++) {
      final CellGeometry cell = cells[i];
      final Path path = paths[i];

      fill.color = _fillOf(cell);
      canvas.drawPath(path, fill);

      if (cell.cellId == selectedCellId) selectedPath = path;
    }

    // 2) 랜드마크는 칸을 다 칠한 뒤 얹는다 — 섞어 그리면 이웃 칸에 가린다.
    //
    // **모든 칸에 그린다**(SPEC-0031 §5). 미방문 칸도 무채색 그림을 얹어 무엇이
    // 있는 곳인지 미리 보여 준다 — 방문 여부는 **어느 변형을 쓸지**만 가른다.
    final LandmarkIconCache? cache = iconCache;
    if (showLandmarks && cache != null) {
      final Set<String> filled = overlappingCellIds ?? visitedCellIds;
      for (int i = 0; i < cells.length; i++) {
        _paintLandmark(
          canvas,
          cells[i],
          paths[i],
          projection,
          cache,
          visited: filled.contains(cells[i].cellId),
        );
      }
    }

    // 3) 칸 테두리는 **그림 위에** 그린다.
    //
    // 그림이 칸을 가득 채우므로 테두리를 먼저 그리면 그림에 덮여 칸 경계가
    // 사라진다. 그러면 어디까지가 한 칸인지 알 수 없어 탭할 대상이 보이지 않는다.
    for (final Path path in paths) {
      canvas.drawPath(path, stroke);
    }

    // 4) 선택된 칸은 맨 위에 다시 그려 이웃 칸의 테두리에 가리지 않게 한다.
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

  /// 칸을 랜드마크 그림으로 **채운다**.
  ///
  /// 참조는 스크래치 지도다 — 칸 하나하나가 그림으로 꽉 차 있고, 긁어내면 그
  /// 면적만큼 색이 드러난다. 채우는 재미가 **면적**에서 나온다.
  ///
  /// 그래서 그림을 칸 가운데 배지로 얹지 않고 **칸을 덮도록 키운 뒤 칸 도형으로
  /// 자른다.** 가장자리가 잘리는 것은 의도다 — 작은 칸에서는 그림의 일부만
  /// 남는데, 종이 스크래치 지도도 그렇다.
  ///
  /// **작은 칸에는 그리지 않는다.** 22px보다 좁으면 무엇인지 안 보이고 얼룩만
  /// 남는다(R18).
  void _paintLandmark(
    Canvas canvas,
    CellGeometry cell,
    Path cellPath,
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

    final Rect bounds = cellPath.getBounds();
    if (bounds.isEmpty) return;

    final double box = bounds.shortestSide;
    if (box < minIconBox) return;

    // **칸을 덮을 만큼 키운다.** 긴 쪽에 맞추면 짧은 쪽이 남고, 짧은 쪽에 맞추면
    // 긴 쪽이 빈다 — 덮으려면 긴 쪽 기준이다(cover).
    final double drawSize = bounds.longestSide * _iconCoverage;
    final double scale = drawSize / info.size.width;

    canvas
      ..save()
      // 칸 밖으로 넘친 부분을 잘라낸다. 이웃 칸을 침범하지 않는다.
      ..clipPath(cellPath);

    // **미방문은 옅게 얹는다.** 스크래치 지도는 긁기 전이 단색이고 긁어야 그림이
    // 드러난다. 미방문까지 진하게 채우면 방문해도 "드러나는" 맛이 없고, 지도
    // 전체가 회색으로 무거워진다. 방문 칸만 또렷하게 두어 대비를 만든다.
    if (!visited) {
      canvas.saveLayer(
        bounds,
        Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: _unvisitedIconOpacity),
      );
    }

    canvas
      ..translate(
        bounds.center.dx - drawSize / 2,
        bounds.center.dy - drawSize / 2,
      )
      ..scale(scale)
      ..drawPicture(info.picture);

    if (!visited) canvas.restore();
    canvas.restore();
  }

  /// 미방문 칸 그림의 불투명도.
  ///
  /// 디자인 시스템이 "투명도는 미방문 아이콘을 55%로 낮추는 단 하나의 용도"라고
  /// 정해 둔 값을 따른다.
  static const double _unvisitedIconOpacity = 0.55;

  /// 그림이 칸의 긴 변 대비 차지하는 비율.
  ///
  /// 1보다 크게 둬서 모서리까지 덮는다 — 딱 1이면 칸이 정사각형이 아닌 이상
  /// 네 귀퉁이가 빈다. 너무 키우면 그림의 가운데만 남아 무엇인지 알 수 없다.
  static const double _iconCoverage = 1.15;

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
