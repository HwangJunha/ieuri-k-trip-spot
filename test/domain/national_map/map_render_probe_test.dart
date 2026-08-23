@Tags(<String>['probe'])
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/cell_painter.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/component/landmark_icon_cache.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_geometry.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_shape_builder.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/district_boundary.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/district_boundary_source.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/map_cell.dart';

/// 실제 칸 도형 + 실제 아이콘으로 지도를 그려 PNG로 뽑는다.
///
/// **일반 테스트가 아니다.** 눈으로 확인하기 위한 도구이며 `probe` 태그가 붙어
/// 있어 기본 실행에서 빠진다. 서버에서 받아 둔 칸 목록 파일이 있어야 돈다.
///
///     flutter test --tags probe test/domain/national_map/map_render_probe_test.dart
void main() {
  const String cellsPath = '/Users/junha/.claude/jobs/885d26d9/tmp/cells.json';
  const String zoomEnv = String.fromEnvironment('ZOOM', defaultValue: '1');
  const String outPath =
      '/Users/junha/.claude/jobs/885d26d9/tmp/map_z$zoomEnv.png';

  testWidgets('전국 지도를 그려 저장한다', (WidgetTester tester) async {
    final File cellsFile = File(cellsPath);
    if (!cellsFile.existsSync()) {
      markTestSkipped('칸 목록 파일이 없다: $cellsPath');
      return;
    }

    final Map<String, dynamic> raw =
        json.decode(cellsFile.readAsStringSync()) as Map<String, dynamic>;
    final List<dynamic> rawCells =
        (raw['data'] as Map<String, dynamic>)['mapCells'] as List<dynamic>;

    final List<DistrictBoundary> boundaries = DistrictBoundarySource.parse(
      File('asset/geo/district-boundaries.geojson').readAsStringSync(),
    );

    // 두 변형을 한 화면에서 보려고 방문 칸을 임의로 정한다.
    const Set<String> visited = <String>{
      '1', '2', '3', '7', '16', '44', '62', '91', '129', '155',
      '12', '38', '76', '101', '136',
    };

    final List<MapCell> cells = <MapCell>[
      for (final dynamic c in rawCells)
        MapCell(
          id: c['id'] as String,
          districtCodes: <String>[
            for (final dynamic d in c['districtCodes'] as List<dynamic>)
              d as String,
          ],
          name: c['name'] as String,
          provinceName: '',
          provinceCode: c['provinceCode'] as String,
          visited: visited.contains(c['id']),
          center: const GeoPoint(127, 36),
        ),
    ];

    final List<CellGeometry> geometries = CellShapeBuilder.build(
      cells: cells,
      boundaries: boundaries,
    );
    expect(geometries, isNotEmpty);
    // ignore: avoid_print
    print('PROBE 칸 도형 ${geometries.length}개');
    // ignore: avoid_print
    print(
      'PROBE slug 있는 칸 '
      '${geometries.where((CellGeometry g) => g.landmarkSlug != null).length}개',
    );

    final LandmarkIconCache cache = LandmarkIconCache();
    await cache.preload(<LandmarkIconKey>[
      for (final CellGeometry g in geometries)
        if (g.landmarkSlug != null)
          LandmarkIconKey(g.landmarkSlug!, visited: visited.contains(g.cellId)),
    ]);
    final double zoom = double.parse(zoomEnv);
    await tester.binding.setSurfaceSize(const Size(430, 700));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            surface: Color(0xFFFFF6F0),
            surfaceDim: Color(0xFFEDE4E2),
            onSurface: Color(0xFF2B2B45),
            primary: Color(0xFFE4572E),
          ),
        ),
        home: Scaffold(
          backgroundColor: const Color(0xFFFFF6F0),
          body: RepaintBoundary(
            child: CustomPaint(
              size: const Size(430, 700),
              painter: CellPainter(
                cells: geometries,
                visitedCellIds: visited,
                palette: CellPalette.of(
                  const ColorScheme.light(
                    surface: Color(0xFFFFF6F0),
                    surfaceDim: Color(0xFFEDE4E2),
                    onSurface: Color(0xFF2B2B45),
                    primary: Color(0xFFE4572E),
                  ),
                ),
                iconCache: cache,
                zoomScale: zoom,
                padding: 4,
                cover: true,
              ),
            ),
          ),
        ),
      ),
    );

    // 아이콘 프리로드가 끝날 때까지 돌린다.
    for (int i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    final RenderRepaintBoundary boundary =
        tester.renderObject<RenderRepaintBoundary>(
          find.byType(RepaintBoundary).first,
        );
    final ui.Image image = await boundary.toImage(pixelRatio: 2.5);
    final ByteData? png = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    File(outPath).writeAsBytesSync(png!.buffer.asUint8List());
    image.dispose();
    // ignore: avoid_print
    print('PROBE 저장 $outPath');
  });
}
