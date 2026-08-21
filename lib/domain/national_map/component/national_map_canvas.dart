import 'package:flutter/material.dart';

import '../model/cell_geometry.dart';
import '../model/cell_hit_test.dart';
import '../model/cell_projection.dart';
import 'cell_painter.dart';

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

  /// 직전 탭의 시각과 위치. 더블탭 판별에 쓴다.
  DateTime? _lastTapAt;
  Offset? _lastTapPos;

  /// 두 번의 탭이 이 안에 들어오면 더블탭이다.
  static const Duration _doubleTapWindow = Duration(milliseconds: 300);

  void _onStart(ScaleStartDetails d) {
    _pressAt = d.localFocalPoint;
    _moved = false;
  }

  void _onUpdate(ScaleUpdateDetails d) {
    final Offset? from = _pressAt;
    if (from == null) return;
    if (d.pointerCount > 1 ||
        (d.localFocalPoint - from).distance > _tapSlop) {
      _moved = true;
    }
  }

  void _onEnd(Size size) {
    final Offset? at = _pressAt;
    _pressAt = null;
    if (_moved || at == null) return; // 끌기·핀치였다

    final DateTime now = DateTime.now();
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

  @override
  void initState() {
    super.initState();
    _animation.addListener(() {
      final Animation<Matrix4>? z = _zoom;
      if (z != null) _controller.value = z.value;
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
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
        return InteractiveViewer(
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
              padding: _padding,
              cover: widget.cover,
            ),
          ),
        );
      },
    );
  }
}
