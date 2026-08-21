import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../model/cell_detail.dart';
import '../model/cell_geometry.dart';
import '../model/cell_geometry_index.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import '../repository/national_map_repository.dart';
import '../repository/national_map_repository_impl.dart';
import 'cell_geometry_provider.dart';

part 'national_map_providers.g.dart';

@riverpod
NationalMapRepository nationalMapRepository(Ref ref) =>
    NationalMapRepositoryImpl(ref.watch(graphqlClientProvider));

/// 161칸 + 뷰어의 방문 여부(R6·R20).
///
/// 앱 세션당 한 번 조회하고 붙들어 둔다 — 161칸은 고정이고 방문 등록·해제는
/// 뮤테이션 응답으로 이 캐시를 직접 고친다(재조회하지 않는다).
@Riverpod(keepAlive: true)
class MapCells extends _$MapCells {
  @override
  Future<List<MapCell>> build() =>
      ref.watch(nationalMapRepositoryProvider).fetchCells();

  /// 뮤테이션이 돌려준 칸으로 캐시를 고친다(계약 §7.1).
  ///
  /// 서버가 변경된 노드를 주므로 목록 전체를 다시 받지 않는다.
  void applyUpdated(Iterable<MapCell> updated) {
    final List<MapCell>? current = state.value;
    if (current == null || updated.isEmpty) return;

    final Map<String, MapCell> byId = <String, MapCell>{
      for (final MapCell c in updated) c.id: c,
    };
    state = AsyncData<List<MapCell>>(<MapCell>[
      for (final MapCell c in current) byId[c.id] ?? c,
    ]);
  }

  /// 낙관적으로 방문 표시를 바꾼다. 실패하면 [applyUpdated] 없이 되돌린다.
  void setVisitedOptimistically(Set<String> cellIds, {required bool visited}) {
    final List<MapCell>? current = state.value;
    if (current == null || cellIds.isEmpty) return;

    state = AsyncData<List<MapCell>>(<MapCell>[
      for (final MapCell c in current)
        cellIds.contains(c.id) ? c.copyWith(visited: visited) : c,
    ]);
  }
}

/// 시도별 진척(R21). **클라이언트가 센다** — 161칸을 이미 갖고 있다.
@riverpod
Future<List<ProvinceProgress>> provinceProgress(Ref ref) async {
  final List<MapCell> cells = await ref.watch(mapCellsProvider.future);
  return provinceProgressOf(cells);
}

/// 서버 칸과 렌더링 도형을 이은 인덱스.
///
/// 지도를 그리려면 둘이 다 있어야 하므로 여기서 합쳐 한 번만 계산한다.
@riverpod
Future<CellGeometryIndex> cellGeometryIndex(Ref ref) async {
  final List<MapCell> cells = await ref.watch(mapCellsProvider.future);
  final List<CellGeometry> geometries = await ref.watch(
    cellGeometriesProvider.future,
  );
  return CellGeometryIndex.build(cells: cells, geometries: geometries);
}

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.
@riverpod
Future<CellDetail> cellDetail(Ref ref, String cellId) => ref
    .watch(nationalMapRepositoryProvider)
    .fetchCellDetail(cellId: cellId);
