import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/cell_geometry.dart';
import '../model/cell_geometry_source.dart';

part 'cell_geometry_provider.g.dart';

/// 칸 도형 자산의 경로.
const String cellGeometryAssetPath = 'asset/geo/korea_cells.json';

/// 161칸의 도형(설계 §3).
///
/// 앱에 내장한 자산이라 세션 내내 바뀌지 않는다 — 한 번 읽고 붙들어 둔다.
/// 파싱에 약 7천 점을 훑으므로 화면을 드나들 때마다 다시 하지 않는다.
@Riverpod(keepAlive: true)
Future<List<CellGeometry>> cellGeometries(Ref ref) async {
  final String raw = await rootBundle.loadString(cellGeometryAssetPath);
  return CellGeometrySource.parse(raw);
}
