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

class _NationalMapCanvasState extends State<NationalMapCanvas> {
  /// 지도 둘레 여백. 지도가 거의 정사각형이라(1.06:1) 여백을 키우면 눈에 띄게
  /// 작아진다.
  static const double _padding = 4;

  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 탭 지점을 경위도로 되돌려 칸을 찾는다.
  ///
  /// **화면과 같은 투영을 써야 한다** — 배율이나 여백이 어긋나면 누른 곳과
  /// 다른 칸이 잡힌다.
  void _handleTap(TapUpDetails details, Size size) {
    if (widget.onCellTap == null || widget.cells.isEmpty) return;

    final CellProjection projection = CellProjection.fit(
      bounds: CellPainter.boundsOf(widget.cells),
      width: size.width,
      height: size.height,
      padding: _padding,
      cover: widget.cover,
    );

    final Offset local = details.localPosition;
    final GeoPoint point = projection.toGeo(local.dx, local.dy);
    final CellGeometry? hit = CellHitTest.cellAt(widget.cells, point);
    if (hit != null) widget.onCellTap!(hit.cellId);
  }

  @override
  Widget build(BuildContext context) {
    final CellPalette palette = CellPalette.of(Theme.of(context).colorScheme);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);

        return InteractiveViewer(
          transformationController: _controller,
          minScale: 1,
          maxScale: 6,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (TapUpDetails d) => _handleTap(d, size),
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
          ),
        );
      },
    );
  }
}
