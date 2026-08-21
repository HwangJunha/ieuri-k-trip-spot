import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../model/cell_detail.dart';
import '../model/cell_geometry.dart';
import '../model/cell_shape_builder.dart';
import '../model/district_boundary.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import '../repository/national_map_repository.dart';
import '../repository/national_map_repository_impl.dart';
import 'district_resolver_provider.dart';

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

  /// 낙관적으로 방문 표시를 바꾼다. 실패하면 되돌린다.
  void setVisitedOptimistically(Set<String> cellIds, {required bool visited}) {
    final List<MapCell>? current = state.value;
    if (current == null || cellIds.isEmpty) return;

    state = AsyncData<List<MapCell>>(<MapCell>[
      for (final MapCell c in current)
        cellIds.contains(c.id) ? c.copyWith(visited: visited) : c,
    ]);
  }
}

/// 칸 도형(R20).
///
/// **서버가 정한 칸 정의로 원본 경계를 런타임에 합친다.** 별도의 도형 자산을 두지
/// 않는 이유는 묶음 규칙이 서버 소유이기 때문이다 — 클라이언트가 규칙을 따로
/// 가지면 서버가 바꿀 때 조용히 어긋난다.
///
/// 조립에 ~250ms가 들어 한 번만 하고 붙들어 둔다. 방문 여부는 여기 없다
/// (도형은 방문과 무관하게 그대로다) — 색칠은 [mapCellsProvider]가 정한다.
@Riverpod(keepAlive: true)
Future<List<CellGeometry>> cellGeometries(Ref ref) async {
  final List<MapCell> cells = await ref.watch(mapCellsProvider.future);
  final List<DistrictBoundary> boundaries = await ref.watch(
    districtBoundariesProvider.future,
  );
  return CellShapeBuilder.build(cells: cells, boundaries: boundaries);
}

/// 시도별 진척(R21). **클라이언트가 센다** — 161칸을 이미 갖고 있다.
@riverpod
Future<List<ProvinceProgress>> provinceProgress(Ref ref) async {
  final List<MapCell> cells = await ref.watch(mapCellsProvider.future);
  return provinceProgressOf(cells);
}

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.
///
/// 광역시 칸은 장소가 수천 건이라 커서로 이어 읽는다(스펙 §11).
@riverpod
class CellDetailController extends _$CellDetailController {
  @override
  Future<CellDetail> build(String cellId) =>
      ref.watch(nationalMapRepositoryProvider).fetchCellDetail(cellId: cellId);

  /// 다음 페이지를 이어 붙인다.
  ///
  /// 이미 읽는 중이거나 더 없으면 아무 일도 하지 않는다 — 스크롤 끝에서 여러 번
  /// 불려도 요청이 겹치지 않는다.
  Future<void> loadMore() async {
    final CellDetail? current = state.value;
    if (_loading || current == null || !current.hasMore) return;

    _loading = true;
    try {
      final CellDetail next = await ref
          .read(nationalMapRepositoryProvider)
          .fetchCellDetail(cellId: cellId, after: current.endCursor);
      state = AsyncData<CellDetail>(current.copyWithMore(next));
    } on Object {
      // 이어 읽기 실패는 이미 보이는 목록을 지우지 않는다 — 다시 시도하면 된다.
    } finally {
      _loading = false;
    }
  }

  bool _loading = false;
}
