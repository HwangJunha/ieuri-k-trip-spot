import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import '../model/cell_geometry.dart';
import '../model/cell_hit_test.dart';
import '../model/cell_projection.dart';
import 'cell_painter.dart';
import 'landmark_icon_cache.dart';

/// 161칸을 그리고 탭을 받는 지도(R20·R22).
///
/// 확대·이동은 [InteractiveViewer]가 맡는다. 새 질의가 발생하지 않으므로
/// 뷰포트 조회 규약(POL-037)과 무관하다 — 칸은 이미 전량 갖고 있다.
class NationalMapCanvas extends StatefulWidget {
  const NationalMapCanvas({
    required this.cells,
    required this.visitedCellIds,
    this.overlappingCellIds,
    this.selectedCellId,
    this.onCellTap,
    this.cover = false,
    super.key,
  });

  final List<CellGeometry> cells;

  final Set<String> visitedCellIds;
  final Set<String>? overlappingCellIds;
  final String? selectedCellId;

  /// 칸을 누르면 그 **칸 id**를 준다. 칸이 아닌 곳을 누르면 호출하지 않는다.
  final ValueChanged<String>? onCellTap;

  /// 짧은 쪽을 채울지. 세로로 긴 화면에서 빈 바다를 줄인다.
  final bool cover;

  @override
  State<NationalMapCanvas> createState() => _NationalMapCanvasState();
}

class _NationalMapCanvasState extends State<NationalMapCanvas>
    with SingleTickerProviderStateMixin {
  /// 지도 둘레 여백. 지도가 거의 정사각형이라(1.06:1) 여백을 키우면 눈에 띄게
  /// 작아진다.
  static const double _padding = 4;

  /// 더블탭 한 번에 키우는 배율.
  static const double _doubleTapScale = 2.5;

  final TransformationController _controller = TransformationController();

  /// 이번 상호작용이 시작된 지점. 끝날 때 탭이었는지 판별하는 기준이다.
  Offset? _pressAt;

  /// 손가락이 이만큼 넘게 움직였으면 탭이 아니라 끌기다.
  static const double _tapSlop = 12;

  /// 끌기·핀치가 있었는지.
  bool _moved = false;

  /// 이번 상호작용에서 동시에 닿은 손가락의 최대 수.
  int _maxPointers = 0;

  /// 배율이 바뀌었는지(= 핀치였는지).
  bool _scaleChanged = false;

  /// 배율이 이만큼 넘게 바뀌면 핀치로 본다.
  static const double _scaleSlop = 0.02;

  /// 핀치가 끝난 뒤 이 시각까지는 탭을 받지 않는다.
  DateTime? _blockTapUntil;

  /// 핀치 직후 탭을 막는 시간. 두 손가락을 동시에 떼기 어려워 필요하다.
  static const Duration _afterPinchGuard = Duration(milliseconds: 220);

  /// 직전 탭의 시각과 위치. 더블탭 판별에 쓴다.
  DateTime? _lastTapAt;
  Offset? _lastTapPos;

  /// 두 번의 탭이 이 안에 들어오면 더블탭이다.
  static const Duration _doubleTapWindow = Duration(milliseconds: 300);

  /// 지금 화면에 닿아 있는 손가락 수. `Listener`가 직접 센다.
  int _livePointers = 0;

  /// 이번 터치에서 두 손가락 이상이 닿았는지.
  ///
  /// **모든 손가락을 뗄 때까지 유지한다.** 핀치 도중 하나를 먼저 떼면 남은
  /// 하나가 새 상호작용을 만드는데, 그것까지 탭이 아니어야 한다.
  bool _multiTouch = false;

  void _onPointerDown(PointerDownEvent e) {
    _livePointers++;
    if (_livePointers > 1) {
      _multiTouch = true;
      // 두 번째 손가락이 닿은 순간, 이미 진행 중이던 단일 터치도 탭이 아니다.
      _pressAt = null;
    }
  }

  void _onPointerUp(PointerEvent e) {
    if (_livePointers > 0) _livePointers--;
    if (_livePointers > 0) return;

    // 마지막 손가락이 떨어졌다. 멀티터치였다면 잠시 탭을 막는다 — 두 손가락을
    // 정확히 동시에 떼기는 어렵고, 늦게 떨어진 쪽이 새 탭으로 잡힌다.
    if (_multiTouch) {
      _multiTouch = false;
      _blockTapUntil = DateTime.now().add(_afterPinchGuard);
    }
  }

  void _onStart(ScaleStartDetails d) {
    // 이미 두 손가락이 닿아 있으면 시작부터 탭 후보가 아니다.
    _pressAt = _multiTouch || _livePointers > 1 ? null : d.localFocalPoint;
    _moved = false;
    _maxPointers = d.pointerCount;
    _scaleChanged = false;
  }

  void _onUpdate(ScaleUpdateDetails d) {
    final Offset? from = _pressAt;
    if (from == null) return;

    // 이번 상호작용에서 손가락이 최대 몇 개였는지 기억한다. 핀치 도중 하나를
    // 떼면 pointerCount가 1로 줄어드는데, 그 순간만 보면 탭처럼 보인다.
    if (d.pointerCount > _maxPointers) _maxPointers = d.pointerCount;

    // 배율이 바뀌었으면 핀치다. 손가락이 거의 안 움직여도 확대는 될 수 있다.
    if ((d.scale - 1).abs() > _scaleSlop) _scaleChanged = true;

    if (d.pointerCount > 1 || (d.localFocalPoint - from).distance > _tapSlop) {
      _moved = true;
    }
  }

  void _onEnd(Size size) {
    final Offset? at = _pressAt;
    _pressAt = null;

    // 끌기·핀치·확대였으면 탭이 아니다. `_multiTouch`는 Listener가 센 실제
    // 손가락 수라, InteractiveViewer가 놓치는 시차 접촉까지 잡는다.
    if (_moved ||
        _maxPointers > 1 ||
        _multiTouch ||
        _livePointers > 0 ||
        _scaleChanged ||
        at == null) {
      // **핀치 직후를 잠시 막는다.** 두 손가락을 동시에 떼기 어려워, 남은
      // 손가락이 곧바로 새 상호작용을 만들고 그것이 탭으로 잡힌다 — 실기기에서
      // 핀치할 때마다 상세가 열리던 원인이다.
      _blockTapUntil = DateTime.now().add(_afterPinchGuard);
      return;
    }

    final DateTime now = DateTime.now();
    // 핀치가 막 끝났으면 무시한다.
    final DateTime? blockUntil = _blockTapUntil;
    if (blockUntil != null && now.isBefore(blockUntil)) return;
    final DateTime? prev = _lastTapAt;
    final Offset? prevPos = _lastTapPos;
    final bool isDouble =
        prev != null &&
        prevPos != null &&
        now.difference(prev) < _doubleTapWindow &&
        (at - prevPos).distance <= _tapSlop * 2;

    if (isDouble) {
      _lastTapAt = null;
      _lastTapPos = null;
      _handleDoubleTap(at);
      return;
    }

    _lastTapAt = now;
    _lastTapPos = at;
    _handleTap(at, size);
  }

  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  Animation<Matrix4>? _zoom;

  /// 현재 확대 배율. 칸이 커지면 그림을 더 또렷하게 그린다(SPEC-0031 §5.1).
  double _zoomScale = 1;

  @override
  void initState() {
    super.initState();
    _animation.addListener(() {
      final Animation<Matrix4>? z = _zoom;
      if (z != null) _controller.value = z.value;
    });
    // **배율을 painter에 알린다.** 종이 지도와 달리 화면은 확대할 수 있으므로,
    // 칸이 손톱만 해지는 배율에서만 장면 그림을 드러낸다. 기본 배율에서 다
    // 그리면 2~3mm 칸에서 뭉개져 얼룩만 남는다.
    _controller.addListener(_onTransformChanged);
    _preloadIcons();
  }

  void _onTransformChanged() {
    final double next = _controller.value.getMaxScaleOnAxis();
    // 미세한 변화까지 setState하면 팬·핀치 중에 프레임이 낭비된다.
    if ((next - _zoomScale).abs() < 0.05) return;
    final LandmarkDetail before = _detailFor(_zoomScale);
    setState(() => _zoomScale = next);
    // 상세 단계가 바뀌는 순간에만 그 벌을 읽어 온다. 처음부터 322장을 다 들고
    // 있으면 진입이 느려지고, 대부분은 확대하지 않는다.
    if (_detailFor(next) != before) _preloadIcons();
  }

  /// 이 배율에서 쓸 그림 단계. [CellPainter]와 같은 기준을 써야 한다.
  static LandmarkDetail _detailFor(double zoom) =>
      CellPainter.detailForZoom(zoom);

  @override
  void didUpdateWidget(NationalMapCanvas old) {
    super.didUpdateWidget(old);
    // 방문 칸이 바뀌면 그 칸이 필요로 하는 변형이 달라진다. 칸 목록이 바뀌어도
    // 마찬가지다.
    if (old.cells != widget.cells ||
        !CellPainter.setEquals(old.visitedCellIds, widget.visitedCellIds) ||
        !CellPainter.setEquals(
          old.overlappingCellIds,
          widget.overlappingCellIds,
        )) {
      _preloadIcons();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformChanged);
    _iconCache.dispose();
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// 이 지도가 쓰는 아이콘 그림 캐시.
  final LandmarkIconCache _iconCache = LandmarkIconCache();

  /// 칸에 필요한 아이콘을 미리 디코딩한다(스펙 §4).
  ///
  /// **161칸 전부가 대상이다.** 미방문 칸도 무채색 아이콘을 그리므로 방문 여부는
  /// 어느 변형이 필요한지만 가른다. `paint()`에서 `await`할 수 없으니 여기서
  /// 채우고, 끝나면 다시 그린다.
  void _preloadIcons() {
    final Set<String> filled =
        widget.overlappingCellIds ?? widget.visitedCellIds;
    final LandmarkDetail detail = _detailFor(_zoomScale);
    // **방문한 칸을 먼저 싣는다**(사용자 지적 2026-08-25). 161장을 순서 없이
    // 실으면 컬러로 채워진 칸이 목록 뒤쪽에 걸릴 때 "내가 채운 지도"가 한참
    // 뒤에야 드러난다 — 그 사이 화면은 회색 덩어리다.
    //
    // 방문 칸은 보통 몇 개에서 몇십 개라 첫 묶음 한두 번이면 끝난다. 그것만
    // 먼저 떠도 지도가 살아나 보이고, 무채색 칸은 뒤따라 채워져도 티가 덜 난다.
    final List<LandmarkIconKey> visitedKeys = <LandmarkIconKey>[];
    final List<LandmarkIconKey> restKeys = <LandmarkIconKey>[];
    for (final CellGeometry cell in widget.cells) {
      final String? slug = cell.landmarkSlug;
      if (slug == null) continue;
      final bool isFilled = filled.contains(cell.cellId);
      (isFilled ? visitedKeys : restKeys).add(
        LandmarkIconKey(slug, visited: isFilled, detail: detail),
      );
    }
    final List<LandmarkIconKey> keys = <LandmarkIconKey>[
      ...visitedKeys,
      ...restKeys,
    ];
    if (keys.isEmpty) return;

    // **묶음마다 다시 그린다.** 예전에는 161장이 전부 끝난 뒤 한 번만 그려서,
    // 그때까지 회색 면만 보이다가 아이콘이 한꺼번에 나타났다 — 지도는 떴는데
    // 그림이 늦게 뜨는 것으로 읽혔다.
    unawaited(
      _iconCache.preload(
        keys,
        onBatch: () {
          if (mounted) setState(() {});
        },
      ),
    );
  }

  /// 더블탭으로 확대·복귀한다.
  ///
  /// 핀치만으로는 확대할 수 있다는 것을 알기 어렵다 — 특히 지도가 처음부터 꽉
  /// 차 있어 더 커질 수 있다는 신호가 없다.
  void _handleDoubleTap(Offset position) {
    final double current = _controller.value.getMaxScaleOnAxis();
    final Matrix4 target;

    if (current > 1.05) {
      // 이미 확대돼 있으면 원래대로 되돌린다.
      target = Matrix4.identity();
    } else {
      // 누른 지점이 제자리에 남도록 확대한다.
      final Offset scene = _toScene(position);
      target = Matrix4.identity()
        ..translateByDouble(position.dx, position.dy, 0, 1)
        ..scaleByDouble(
          _doubleTapScale,
          _doubleTapScale,
          _doubleTapScale,
          1,
        )
        ..translateByDouble(-scene.dx, -scene.dy, 0, 1);
    }

    _zoom = Matrix4Tween(begin: _controller.value, end: target).animate(
      CurvedAnimation(parent: _animation, curve: Curves.easeOutCubic),
    );
    _animation.forward(from: 0);
  }

  /// 탭 지점을 경위도로 되돌려 칸을 찾는다.
  ///
  /// **탭을 `InteractiveViewer` 밖에서 받는다.** 안쪽에 `GestureDetector`를 두면
  /// `HitTestBehavior.opaque`가 드래그를 통째로 가로채 확대·이동이 죽는다
  /// (측정으로 확인: 팬 후 이동값이 0이었다). 대신 변환 행렬을 직접 역산한다.
  ///
  /// **화면과 같은 투영을 써야 한다** — 배율이나 여백이 어긋나면 누른 곳과
  /// 다른 칸이 잡힌다.
  void _handleTap(Offset position, Size size) {
    if (widget.onCellTap == null || widget.cells.isEmpty) return;

    // 확대·이동한 만큼 되돌린다. scene 좌표가 곧 CustomPaint의 좌표다.
    final Offset scene = _toScene(position);

    final CellProjection projection = CellProjection.fit(
      bounds: CellPainter.boundsOf(widget.cells),
      width: size.width,
      height: size.height,
      padding: _padding,
      cover: widget.cover,
    );

    // 칸마다 화면 오프셋을 되돌려 경위도로 바꾼다 — 제주는 위로 올려 그리므로
    // 그 몫을 빼야 누른 곳과 잡히는 칸이 맞는다.
    final CellGeometry? hit = CellHitTest.cellAtVarying(widget.cells, (
      CellGeometry cell,
    ) {
      final Offset shift = CellPainter.screenOffsetOf(cell);
      return projection.toGeo(scene.dx - shift.dx, scene.dy - shift.dy);
    });
    if (hit != null) widget.onCellTap!(hit.cellId);
  }

  /// 뷰포트 좌표 -> 변환을 되돌린 장면 좌표.
  ///
  /// `vector_math`를 직접 import하지 않는다 — Flutter가 전이적으로 줄 뿐 이 앱의
  /// 의존이 아니다. `MatrixUtils`가 같은 일을 한다.
  Offset _toScene(Offset viewport) => MatrixUtils.transformPoint(
    Matrix4.inverted(_controller.value),
    viewport,
  );

  @override
  Widget build(BuildContext context) {
    final CellPalette palette = CellPalette.of(Theme.of(context).colorScheme);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);

        // **GestureDetector를 쓰지 않는다.** 바깥에 두면 InteractiveViewer의
        // 팬이 죽고, 안쪽에 `onDoubleTap`을 두면 단일 탭과 팬이 함께 죽는다
        // (behavior 3종을 다 재봤다). 대신 InteractiveViewer가 주는
        // 상호작용 콜백에서 탭·더블탭을 직접 판별한다.
        // **Listener로 실제 손가락 수를 센다.** InteractiveViewer의 콜백은
        // 제스처가 인식된 뒤에만 오고 `pointerCount`도 그 시점의 값이라, 두
        // 손가락이 미세하게 시차를 두고 닿으면 첫 손가락만으로 상호작용이
        // 시작·종료돼 탭으로 잡힌다 — 실기기에서 확대하려다 상세가 열리던
        // 원인이다. Listener는 제스처 경쟁에 끼지 않아 팬·줌을 방해하지 않는다.
        return Listener(
          behavior: HitTestBehavior.deferToChild,
          onPointerDown: _onPointerDown,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerUp,
          child: InteractiveViewer(
          transformationController: _controller,
          minScale: 1,
          maxScale: 8,
          // 확대했을 때 가장자리 칸까지 닿게 한다 — 기본값은 경계에서 막힌다.
          boundaryMargin: const EdgeInsets.all(double.infinity),
          // cover로 좌우가 넘치므로 잘라 그린다.
          clipBehavior: Clip.hardEdge,
          onInteractionStart: _onStart,
          onInteractionUpdate: _onUpdate,
          onInteractionEnd: (ScaleEndDetails _) => _onEnd(size),
          child: CustomPaint(
            size: size,
            painter: CellPainter(
              cells: widget.cells,
              visitedCellIds: widget.visitedCellIds,
              overlappingCellIds: widget.overlappingCellIds,
              selectedCellId: widget.selectedCellId,
              palette: palette,
              iconCache: _iconCache,
              zoomScale: _zoomScale,
              padding: _padding,
              cover: widget.cover,
              devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
            ),
          ),
          ),
        );
      },
    );
  }
}
