import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/national_map_canvas.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_geometry.dart';

CellGeometry _sq(String id, double lng, double lat, {String province = '41'}) {
  final ring = <GeoPoint>[
    GeoPoint(lng, lat),
    GeoPoint(lng + 1, lat),
    GeoPoint(lng + 1, lat + 1),
    GeoPoint(lng, lat + 1),
  ];
  return CellGeometry(
    cellId: id,
    provinceCode: province,
    polygons: <List<GeoPoint>>[ring],
    center: GeoPoint(lng + .5, lat + .5),
    bounds: GeoBounds.of(ring),
  );
}

void main() {
  // 확대·이동이 죽었던 적이 있다 — 안쪽 GestureDetector가 opaque라
  // InteractiveViewer의 드래그를 통째로 가로챘다. 그 회귀를 여기서 막는다.
  testWidgets('드래그로 지도가 움직인다', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: NationalMapCanvas(
              cells: <CellGeometry>[_sq('1', 127, 37), _sq('2', 128, 37)],
              visitedCellIds: const <String>{},
            ),
          ),
        ),
      ),
    );

    final iv = tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    final c = iv.transformationController!;
    expect(c.value.getTranslation().x, 0);

    await tester.drag(find.byType(InteractiveViewer), const Offset(-40, -30));
    await tester.pumpAndSettle();

    expect(c.value.getTranslation().x, isNot(0));
  });

  // 핀치만으로는 확대할 수 있다는 것을 알기 어렵다.
  testWidgets('더블탭으로 확대되고 다시 누르면 되돌아온다', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: NationalMapCanvas(
              cells: <CellGeometry>[_sq('1', 127, 37), _sq('2', 128, 37)],
              visitedCellIds: const <String>{},
            ),
          ),
        ),
      ),
    );

    final InteractiveViewer iv = tester.widget<InteractiveViewer>(
      find.byType(InteractiveViewer),
    );
    final TransformationController c = iv.transformationController!;
    expect(c.value.getMaxScaleOnAxis(), 1);

    await tester.tapAt(const Offset(150, 150));
    await tester.tapAt(const Offset(150, 150));
    await tester.pumpAndSettle();
    expect(c.value.getMaxScaleOnAxis(), greaterThan(2));

    // 한 번 더 하면 원래대로.
    await tester.tapAt(const Offset(150, 150));
    await tester.tapAt(const Offset(150, 150));
    await tester.pumpAndSettle();
    expect(c.value.getMaxScaleOnAxis(), closeTo(1, 0.01));
  });

  // 팬을 살리려고 탭을 InteractiveViewer 밖으로 옮겼다. 변환 역산이 맞는지
  // 확인한다 — 틀리면 누른 곳과 다른 칸이 잡힌다.
  testWidgets('탭하면 칸이 잡힌다', (WidgetTester tester) async {
    String? tapped;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: NationalMapCanvas(
              cells: <CellGeometry>[_sq('1', 127, 37), _sq('2', 128, 37)],
              visitedCellIds: const <String>{},
              onCellTap: (String id) => tapped = id,
            ),
          ),
        ),
      ),
    );

    // 왼쪽 절반 = 칸 1
    await tester.tapAt(const Offset(80, 150));
    await tester.pump();
    expect(tapped, '1');

    // 오른쪽 절반 = 칸 2
    await tester.tapAt(const Offset(220, 150));
    await tester.pump();
    expect(tapped, '2');
  });

  // 제주는 화면에서만 위로 올려 그린다. 그리기와 히트 테스트가 같은 오프셋을
  // 써야 보이는 곳과 눌리는 곳이 맞는다 — 어긋나면 조용히 틀린다.
  testWidgets('제주는 올려 그린 자리에서 눌린다', (WidgetTester tester) async {
    String? tapped;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: NationalMapCanvas(
              // 위아래로 붙은 두 칸. 아래쪽이 제주다.
              cells: <CellGeometry>[
                _sq('main', 127, 37),
                _sq('jeju', 127, 36, province: '50'),
              ],
              visitedCellIds: const <String>{},
              onCellTap: (String id) => tapped = id,
            ),
          ),
        ),
      ),
    );

    // 제주 칸의 아래쪽 가장자리 근처. 오프셋이 없으면 여기가 제주 밖이다.
    await tester.tapAt(const Offset(150, 285));
    await tester.pump();

    // 12px 올려 그렸으므로 화면 아래쪽 12px 띠는 이제 제주가 아니다.
    expect(tapped, isNot('main'));
  });
}
