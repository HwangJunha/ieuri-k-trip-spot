import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../../auth/provider/session_scope.dart';
import '../model/cell_detail.dart';
import '../model/cell_geometry.dart';
import '../model/cell_shape_builder.dart';
import '../model/cell_shape_source.dart';
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
///
/// **인증 상태를 watch한다.** `keepAlive`라 로그아웃해도 캐시가 남는데, 여기 담긴
/// `viewerVisited`는 사용자의 것이라 다음 사용자에게 이전 사람의 방문 칸이
/// 보였다(실기기 확인). watch가 그 순간 이 provider를 다시 만든다.
@Riverpod(keepAlive: true)
class MapCells extends _$MapCells {
  @override
  Future<List<MapCell>> build() async {
    // 비인증에서도 서버는 161칸을 주지만(viewerVisited 전부 false) 굳이 부르지
    // 않는다 — 로그인하면 watch가 다시 부른다.
    if (!ref.watchSignedIn()) return const <MapCell>[];
    return ref.watch(nationalMapRepositoryProvider).fetchCells();
  }

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

/// 미리 만들어 둔 칸 도형(SPEC-0031 방식 1).
///
/// 없거나 깨졌으면 빈 맵을 준다 — 그러면 [cellGeometries]가 원본 경계로 조립하는
/// 예전 방식으로 돌아간다.
@Riverpod(keepAlive: true)
Future<Map<String, List<List<GeoPoint>>>> cellShapes(Ref ref) async {
  try {
    final String raw = await rootBundle.loadString(CellShapeSource.assetPath);
    return compute(CellShapeSource.parse, raw);
  } on Object {
    return const <String, List<List<GeoPoint>>>{};
  }
}

/// 칸 도형(R20).
///
/// **크기가 고른 다각형을 쓴다**(SPEC-0031). 실제 시군구 경계를 합치면 폰 화면에서
/// 서울 주변이 2~3mm가 되어 칸마다 넣는 랜드마크 그림이 들어가지 않는다. 이유는
/// `CellShapeSource` 문서에 있다.
///
/// 도형 자산이 없으면 **예전 방식(원본 경계 합치기)으로 돌아간다.** 자산 하나로
/// 두 방식을 오갈 수 있어야 화면을 보며 판단할 수 있다.
///
/// 칸 묶음 규칙은 어느 쪽이든 서버 소유다 — 이 자산이 정하는 것은 모양뿐이다.
///
/// 조립 결과는 붙들어 둔다. 방문 여부는 여기 없다(도형은 방문과 무관하다) —
/// 색칠은 [mapCellsProvider]가 정한다.
@Riverpod(keepAlive: true)
Future<List<CellGeometry>> cellGeometries(Ref ref) async {
  final List<MapCell> cells = await ref.watch(mapCellsProvider.future);

  final Map<String, List<List<GeoPoint>>> shapes = await ref.watch(
    cellShapesProvider.future,
  );
  if (shapes.isNotEmpty) {
    final List<CellGeometry> out = CellShapeBuilder.buildFromShapes(
      cells: cells,
      shapes: shapes,
    );
    if (out.isNotEmpty) return out;
  }

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
