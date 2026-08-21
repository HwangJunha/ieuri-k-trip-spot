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
  /// **탭을 `InteractiveViewer` 밖에서 받는다.** 안쪽에 `GestureDetector`를 두면
  /// `HitTestBehavior.opaque`가 드래그를 통째로 가로채 확대·이동이 죽는다
  /// (측정으로 확인: 팬 후 이동값이 0이었다). 대신 변환 행렬을 직접 역산한다.
  ///
  /// **화면과 같은 투영을 써야 한다** — 배율이나 여백이 어긋나면 누른 곳과
  /// 다른 칸이 잡힌다.
  void _handleTap(TapUpDetails details, Size size) {
    if (widget.onCellTap == null || widget.cells.isEmpty) return;

    // 확대·이동한 만큼 되돌린다. scene 좌표가 곧 CustomPaint의 좌표다.
    final Offset scene = _toScene(details.localPosition);

    final CellProjection projection = CellProjection.fit(
      bounds: CellPainter.boundsOf(widget.cells),
      width: size.width,
      height: size.height,
      padding: _padding,
      cover: widget.cover,
    );

    final GeoPoint point = projection.toGeo(scene.dx, scene.dy);
    final CellGeometry? hit = CellHitTest.cellAt(widget.cells, point);
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

        return GestureDetector(
          // 탭만 받고 드래그·핀치는 InteractiveViewer로 흘려보낸다.
          onTapUp: (TapUpDetails d) => _handleTap(d, size),
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 1,
            maxScale: 8,
            // 확대했을 때 가장자리 칸까지 닿게 한다 — 기본값은 경계에서 막힌다.
            boundaryMargin: const EdgeInsets.all(double.infinity),
            // cover로 좌우가 넘치므로 잘라 그린다.
            clipBehavior: Clip.hardEdge,
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
