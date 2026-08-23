import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../model/cell_geometry.dart';
import '../model/cell_projection.dart';
import 'landmark_icon_cache.dart';
import 'province_cell_tint.dart';

/// 전국 지도 161칸을 그리는 팔레트.
///
/// 참조 디자인은 스크래치 지도(긁어서 채우는 종이 지도)다. 그 **개념**만 가져오고
/// 색은 앱과 어울리게 눌렀다 — 포스터의 하늘색 바다·형광 원색을 그대로 옮기면
/// 웜 톤인 앱 안에서 이 화면만 떠 보인다.
///
/// **방문 칸은 시도색이다**(`ProvinceCellTint`). 참조 지도가 "전국 8도에 포인트
/// 색상을 입혀 도장 깨기하듯이 색을 정복"이라고 정한 그 체계다. 다만 그림이 면
/// 위에 얹히므로 원본보다 밝게 눌러 쓴다.
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
    this.iconSize = defaultIconSize,
    this.zoomScale = 1,
  });

  /// 아이콘 그림 캐시. null이면 아이콘을 그리지 않는다(작은 미리보기·테스트).
  final LandmarkIconCache? iconCache;

  /// 현재 확대 배율.
  ///
  /// 그림 크기를 화면 기준으로 일정하게 유지하는 데 쓴다 — 확대하면 칸이 커지는
  /// 만큼 그림도 커져야 상대 크기가 유지된다.
  final double zoomScale;

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

  /// 화면에서 그림이 차지하는 크기(px). **칸 면적과 무관하게 일정하다.**
  ///
  /// 칸에 맞춰 크기를 정하면 부천(2.4pt)에는 아무것도 못 넣는다. 값은 칸 색이
  /// 말하고 위치는 그림이 말하도록 역할을 나눈다.
  final double iconSize;

  /// [iconSize]의 기본값. 22px 아래로는 무엇인지 알아볼 수 없다(스펙 R18).
  static const double defaultIconSize = 26;

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
      // **얇게 유지한다.** 굵으면 서울 주변처럼 칸이 작은 곳에서 선이 칸보다
      // 두꺼워져 지도가 선 덩어리로 보인다(실기기 확인).
      ..strokeWidth = 0.9
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
      final List<Offset> spots = _spreadIconSpots(paths);
      for (int i = 0; i < cells.length; i++) {
        _paintLandmark(
          canvas,
          cells[i],
          paths[i],
          spots[i],
          cache,
          visited: filled.contains(cells[i].cellId),
        );
      }
    }

    // 3) 칸 테두리는 **그림 위에** 그린다.
    //
    // 그림이 칸 위에 떠 있으므로 테두리를 먼저 그리면 겹치는 자리에서 경계가
    // 끊겨 보인다. 어디까지가 한 칸인지가 곧 탭할 대상이라 경계는 살아 있어야 한다.
    //
    // **테두리는 방문 여부와 무관하게 같다.** 방문 칸만 시도색으로 굵게 둘러
    // 봤는데, 선이 아이콘보다 눈에 먼저 들어와 지도가 지저분해졌다(실기기 확인).
    // 방문 여부는 면 색이 이미 말해 준다 — 테두리까지 쓸 이유가 없다.
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

  /// 칸 위에 랜드마크 그림을 **균등한 크기로 얹는다**.
  ///
  /// **칸을 채우지 않는다.** 채우려면 칸 도형으로 잘라야 하는데, 실제 행정구역은
  /// 크기가 608배(면적)까지 벌어지고 모양도 오목·복잡해서 작은 칸에서는 그림이
  /// 조각나고 큰 칸에서는 엉뚱한 부분만 남는다. 실제로 해보고 버린 방식이다.
  ///
  /// 대신 **면적과 무관하게 같은 크기로** 칸 중심에 띄운다. 조사해 보니 출시된
  /// 한국 색칠지도 앱 8종이 전부 이 방식이고, 기상청 날씨알리미는 우리와 같은
  /// 규모(150~200개)를 균등 사각 마커로 처리한다. 값은 칸 색이, 위치는 마커가
  /// 맡아 **면적 편차가 가독성에 영향을 주지 않는다.**
  ///
  /// 칸보다 그림이 클 수 있고 이웃과 겹칠 수 있다 — 의도다. 그래야 부천처럼
  /// 2.4pt인 칸도 무엇이 있는 곳인지 보인다.
  void _paintLandmark(
    Canvas canvas,
    CellGeometry cell,
    Path cellPath,
    Offset spot,
    LandmarkIconCache cache, {
    required bool visited,
  }) {
    final String? slug = cell.landmarkSlug;
    if (slug == null) return;

    // **확대하면 카드가 커지고 그림도 상세본으로 바뀐다.**
    // 화면상 크기를 고정하면 확대해도 그대로라 "가까이 가서 본다"가 성립하지
    // 않는다. 다만 무한정 커지면 지도를 덮으므로 상한을 둔다.
    final double onScreen = iconSize * zoomScale.clamp(1.0, _maxIconGrowth);
    final LandmarkDetail detail = detailForZoom(zoomScale);

    final LandmarkIconPicture? info = cache.pictureOf(
      LandmarkIconKey(slug, visited: visited, detail: detail),
    );
    // 캐시 미스면 이번 프레임은 면 색만 그린다. paint()에서 await하지 않는다.
    if (info == null) return;

    final Rect bounds = cellPath.getBounds();
    if (bounds.isEmpty) return;

    // 칸 면적과 무관하게 일정하되, 확대하면 함께 커진다.
    final double drawSize = onScreen;

    // 칸이 카드보다 훨씬 작으면 이웃을 심하게 덮는다. 그럴 때만 조금 줄인다.
    // 카드는 작아져도 모양이 온전해 픽토그램보다 덜 줄여도 된다.
    final double roomy = bounds.longestSide * zoomScale;
    final double fit = roomy < drawSize
        ? (0.7 + 0.3 * (roomy / drawSize)).clamp(0.7, 1.0)
        : 1.0;
    final double size = drawSize * fit / zoomScale;
    final double scale = size / info.size.width;

    // 미방문은 옅게 — 스크래치 지도는 긁어야 그림이 드러난다.
    final double opacity = visited ? 1.0 : _unvisitedIconOpacity;

    // **기본본과 상세본은 담기는 그릇이 다르다.**
    //
    // - 기본본은 **칸 모양대로 그려진 지도 조각**이다. 칸에 맞춰 구도를 짰으므로
    //   칸 윤곽으로 잘라야 의도대로 보인다 — 네모 카드에 담으면 칸이 안 채워진다.
    // - 상세본은 **칸을 무시한 랜드마크 초상**이다. 칸 윤곽으로 자르면 얇은 칸에서
    //   랜드마크가 잘려 무엇인지 알 수 없게 된다. 그래서 둥근 카드에 담는다.
    if (detail == LandmarkDetail.simple) {
      _paintCellFilling(canvas, cellPath, bounds, info, opacity);
      return;
    }

    final Rect card = Rect.fromCenter(
      center: spot,
      width: size,
      height: size,
    );
    final RRect rounded = RRect.fromRectAndRadius(
      card,
      Radius.circular(size * _cardCornerRatio),
    );

    canvas.save();
    if (opacity < 0.99) {
      canvas.saveLayer(
        card.inflate(size * 0.2),
        Paint()
          ..color = const Color(0xFFFFFFFF).withValues(alpha: opacity),
      );
    }

    // 그림은 카드 안쪽만 남긴다.
    canvas
      ..save()
      ..clipRRect(rounded)
      // 겹침을 푼 자리에 놓는다([_spreadIconSpots]).
      ..translate(card.left, card.top)
      ..scale(scale)
      ..drawPicture(info.picture)
      ..restore();

    // 테두리는 **방문 여부와 무관하게 흰색**이다. 도 구분은 칸 면 색이 맡는다 —
    // 테두리까지 색을 쓰면 그림보다 선이 먼저 눈에 들어온다(실기기 확인).
    //
    // **바깥쪽으로 그린다.** 안쪽으로 그리면 그 굵기만큼 그림을 덮어 카드 안이
    // 좁아진다 — 원하는 것은 테 안이 그림으로 꽉 찬 모습이다.
    canvas.drawRRect(
      rounded.inflate(size * _cardBorderRatio / 2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * _cardBorderRatio
        ..isAntiAlias = true
        ..color = palette.border,
    );

    if (opacity < 0.99) canvas.restore();
    canvas.restore();
  }

  /// 기본본을 **칸 윤곽 안에** 채워 그린다.
  ///
  /// 그림은 120×120 안에 칸 모양에 맞춰 구성돼 있으므로, 칸의 경계 상자에
  /// 그대로 펼쳐 놓고 칸 모양으로 잘라내면 설계한 구도가 그대로 나온다.
  void _paintCellFilling(
    Canvas canvas,
    Path cellPath,
    Rect bounds,
    LandmarkIconPicture info,
    double opacity,
  ) {
    canvas.save();
    if (opacity < 0.99) {
      canvas.saveLayer(
        bounds.inflate(2),
        Paint()
          ..color = const Color(0xFFFFFFFF).withValues(alpha: opacity),
      );
    }

    // 칸 경계 상자를 그림이 꽉 채우도록 늘린다. 종횡비를 맞추지 않고 상자에
    // 맞추는 이유는 **빈 곳을 남기지 않기 위해서다** — 그림은 이미 이 칸의
    // 형태를 보고 그렸으므로 약간의 늘어남은 의도한 범위 안이다.
    canvas
      ..save()
      ..clipPath(cellPath)
      ..translate(bounds.left, bounds.top)
      ..scale(bounds.width / info.size.width, bounds.height / info.size.height)
      ..drawPicture(info.picture)
      ..restore();

    if (opacity < 0.99) canvas.restore();
    canvas.restore();
  }

  /// 확대해도 카드가 이 배 이상 커지지는 않는다.
  ///
  /// 무한정 커지면 카드가 지도를 덮어 어디가 어디인지 알 수 없다.
  static const double _maxIconGrowth = 3.2;

  /// 이 배율에서 쓸 그림 단계 — **언제나 기본본이다.**
  ///
  /// 확대하면 랜드마크 초상(상세본)으로 바꿔 보여 주는 방식을 만들어 두었지만
  /// 쓰지 않는다. 확대는 **같은 지도를 가까이 보는 것**이지 다른 그림으로
  /// 갈아타는 것이 아니어서, 칸 모양이던 그림이 갑자기 네모 카드로 바뀌면
  /// 지도가 무너져 보인다(실기기 확인).
  ///
  /// 에셋(`<slug>@detail.svg`)은 남겨 둔다 — 칸 상세 화면처럼 한 곳을 크게
  /// 보여 주는 자리에서는 초상이 맞다.
  static LandmarkDetail detailForZoom(double zoom) => LandmarkDetail.simple;

  /// 카드 모서리 반경(카드 크기 대비).
  static const double _cardCornerRatio = 0.26;

  /// 카드 테두리 굵기(카드 크기 대비).
  ///
  /// 얇게 둔다 — 테는 카드를 지도에서 떼어 놓는 역할이면 충분하고, 굵으면
  /// 그림이 들어갈 자리를 먹는다.
  static const double _cardBorderRatio = 0.055;

  /// 아이콘이 서로 겹치지 않게 자리를 벌린다.
  ///
  /// 실측하면 군포↔의왕의 칸 중심 거리가 **3.6pt**인데 아이콘은 26px다 — 그냥
  /// 중심에 놓으면 수도권에서 아이콘이 서로 완전히 덮는다(경기도에서만 558쌍).
  ///
  /// 지도 라벨 배치에서 쓰는 방식대로 **서로 밀어낸다.** 칸 도형은 건드리지
  /// 않으므로 지도 형태는 그대로다 — 도형을 손대려던 앞선 시도들과 다른 점이다.
  ///
  /// 밀어낸 자리가 제 칸에서 너무 멀어지면 어느 칸의 것인지 알 수 없으니,
  /// 원래 자리에서 [_maxIconDrift] 안에 묶는다.
  List<Offset> _spreadIconSpots(List<Path> paths) {
    // **결과를 재활용한다.** 161개를 6회 밀어내는 O(n²) 연산이라 매 프레임 돌면
    // 확대·이동이 버벅인다. 칸과 배율이 그대로면 자리도 그대로다.
    final _SpreadKey key = _SpreadKey(cells, zoomScale, iconSize);
    final List<Offset>? hit = _spreadCache[key];
    if (hit != null) return hit;

    final List<Offset> home = <Offset>[
      for (final Path p in paths) p.getBounds().center,
    ];
    final List<Offset> spot = List<Offset>.of(home);
    final double want = iconSize / zoomScale * 0.82;
    final double drift = _maxIconDrift / zoomScale;

    for (int pass = 0; pass < _spreadPasses; pass++) {
      for (int i = 0; i < spot.length; i++) {
        double mx = 0;
        double my = 0;
        for (int j = 0; j < spot.length; j++) {
          if (i == j) continue;
          final double dx = spot[i].dx - spot[j].dx;
          final double dy = spot[i].dy - spot[j].dy;
          final double d2 = dx * dx + dy * dy;
          if (d2 >= want * want || d2 < 1e-9) continue;
          final double d = math.sqrt(d2);
          final double push = (want - d) / 2;
          mx += dx / d * push;
          my += dy / d * push;
        }
        if (mx == 0 && my == 0) continue;
        Offset next = spot[i] + Offset(mx, my) * _spreadRate;
        // 제 칸에서 멀어지지 않게 묶는다.
        final Offset off = next - home[i];
        final double len = off.distance;
        if (len > drift) next = home[i] + off * (drift / len);
        spot[i] = next;
      }
    }

    // 캐시는 몇 개만 들고 있는다 — 배율이 연속으로 바뀌면 항목이 무한히 는다.
    if (_spreadCache.length >= _spreadCacheMax) {
      _spreadCache.remove(_spreadCache.keys.first);
    }
    _spreadCache[key] = spot;
    return spot;
  }

  /// 밀어낸 자리 캐시. 칸 목록·배율·크기가 같으면 다시 계산하지 않는다.
  static final Map<_SpreadKey, List<Offset>> _spreadCache =
      <_SpreadKey, List<Offset>>{};

  /// 캐시에 둘 최대 항목 수.
  static const int _spreadCacheMax = 12;

  /// 밀어내기 반복 횟수. 많을수록 고르게 퍼지지만 매 프레임 비용이 는다.
  static const int _spreadPasses = 6;

  /// 한 번에 미는 비율. 1이면 진동하므로 눌러 둔다.
  static const double _spreadRate = 0.5;

  /// 아이콘이 제 칸 중심에서 벗어날 수 있는 최대 거리(px).
  ///
  /// 너무 크면 어느 칸의 아이콘인지 알 수 없다.
  static const double _maxIconDrift = 14;

  /// 미방문 칸 그림의 불투명도.
  ///
  /// 디자인 시스템이 "투명도는 미방문 아이콘을 55%로 낮추는 단 하나의 용도"라고
  /// 정해 둔 값을 따른다.
  static const double _unvisitedIconOpacity = 0.55;

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
    // **방문 칸은 시도색이다.** 카테고리 틴트를 쓰다가 되돌렸다 — 참조 지도가
    // "전국 8도에 포인트 색상을 입혀 도장 깨기하듯이 색을 정복"이라고 명시하고,
    // 실제로 그 편이 채우는 맛이 크다. 카테고리는 161칸에 5색뿐이라 어디를
    // 채웠는지가 아니라 무엇을 채웠는지만 말해 준다.
    return ProvinceCellTint.of(
      cell.provinceCode,
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

  /// 화면 맞춤에 쓰는 경위도 사각형.
  ///
  /// **먼 섬은 기준에서 뺀다.** 울릉군(독도 포함)이 동쪽 131.9도에 있어 그대로
  /// 계산하면 지도 폭이 7.3도가 되는데, 본토는 5.0도뿐이다. 차이인 2.3도는 전부
  /// 빈 바다라 화면을 그만큼 낭비하고, `cover`로 확대할 때 본토가 한쪽으로
  /// 밀려 잘린다(실기기 확인: 가로 748px 중 318px이 화면 밖).
  ///
  /// 뺀 섬도 **그리기는 그대로 그린다** — 화면 밖으로 나가면 확대·이동으로 본다.
  static GeoBounds boundsOf(List<CellGeometry> cells) {
    GeoBounds? main;
    for (final CellGeometry c in cells) {
      if (_isFarIsland(c)) continue;
      main = main == null ? c.bounds : main.merge(c.bounds);
    }
    if (main != null) return main;

    // 전부 먼 섬이면(작은 미리보기 등) 원래대로 전체를 감싼다.
    GeoBounds bounds = cells.first.bounds;
    for (int i = 1; i < cells.length; i++) {
      bounds = bounds.merge(cells[i].bounds);
    }
    return bounds;
  }

  /// 본토에서 멀리 떨어져 화면 맞춤을 망치는 섬인지.
  static bool _isFarIsland(CellGeometry cell) {
    final double lng = cell.center.lng;
    return lng > _mainlandMaxLng || lng < _mainlandMinLng;
  }

  /// 본토로 볼 경도 범위. 울릉군(130.9)과 서해 먼 섬을 제외한다.
  static const double _mainlandMinLng = 125.6;
  static const double _mainlandMaxLng = 130.2;

  @override
  bool shouldRepaint(CellPainter old) =>
      old.cells != cells ||
      old.selectedCellId != selectedCellId ||
      old.showLandmarks != showLandmarks ||
      old.cover != cover ||
      old.iconSize != iconSize ||
      old.zoomScale != zoomScale ||
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

/// [CellPainter._spreadIconSpots] 캐시 키.
///
/// 배율은 조금씩 바뀌므로 그대로 키로 쓰면 캐시가 안 맞는다. 0.1 단위로
/// 뭉뚱그려 같은 구간이면 같은 자리를 쓴다 — 그 차이는 눈에 띄지 않는다.
@immutable
class _SpreadKey {
  _SpreadKey(this.cells, double zoom, this.iconSize)
    : zoomBucket = (zoom * 10).round();

  final List<CellGeometry> cells;
  final int zoomBucket;
  final double iconSize;

  @override
  bool operator ==(Object other) =>
      other is _SpreadKey &&
      identical(other.cells, cells) &&
      other.zoomBucket == zoomBucket &&
      other.iconSize == iconSize;

  @override
  int get hashCode => Object.hash(identityHashCode(cells), zoomBucket, iconSize);
}
