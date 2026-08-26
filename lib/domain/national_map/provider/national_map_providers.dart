import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../../../common/network/network_retry_policy.dart';
import '../../auth/provider/session_scope.dart';
import '../model/cell_detail.dart';
import '../model/cell_geometry.dart';
import '../model/cell_shape_builder.dart';
import '../model/cell_shape_key.dart';
import '../model/cell_shape_source.dart';
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
@Riverpod(keepAlive: true, retry: defaultNetworkRetry)
class MapCells extends _$MapCells {
  /// 도형 조립에 넘길 키. **서버에서 칸을 받을 때 한 번 만들고 그대로 둔다** —
  /// 방문 표시가 바뀌어도 이 인스턴스는 바뀌지 않는다([cellShapeKeysProvider]).
  List<CellShapeKey>? _shapeKeys;

  @override
  Future<List<MapCell>> build() async {
    // 로그인이 바뀌어 다시 조회하는 경우다 — 이전 사용자의 키를 남기지 않는다.
    _shapeKeys = null;

    // 비인증에서도 서버는 161칸을 주지만(viewerVisited 전부 false) 굳이 부르지
    // 않는다 — 로그인하면 watch가 다시 부른다.
    if (!ref.watchSignedIn()) {
      _shapeKeys = const <CellShapeKey>[];
      return const <MapCell>[];
    }
    final List<MapCell> cells = await ref
        .watch(nationalMapRepositoryProvider)
        .fetchCells();
    _shapeKeys = <CellShapeKey>[
      for (final MapCell c in cells) CellShapeKey.of(c),
    ];
    return cells;
  }

  /// 도형용 키를 준다. 아직 칸을 받지 못했으면 받을 때까지 기다린다.
  Future<List<CellShapeKey>> shapeKeys() async {
    final List<CellShapeKey>? ready = _shapeKeys;
    if (ready != null) return ready;
    await future;
    return _shapeKeys ?? const <CellShapeKey>[];
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

/// 도형 조립에 쓰이는 칸 정보만 추린 것.
///
/// **[mapCellsProvider]와 [cellGeometriesProvider] 사이의 차단막이다.** 사진
/// 스캔은 지역을 찾을 때마다 방문 표시를 바꾸는데, 도형은 그 값을 쓰지 않는다.
/// 그런데도 도형이 칸 목록을 통째로 watch하던 탓에 **지역 하나가 칠해질 때마다
/// 161칸 도형이 다시 만들어지고 화면이 로딩으로 떨어졌다**(사용자 지적
/// 2026-08-26). [CellShapeKey]의 동등성이 id·시도·시군구코드로만 정해지므로,
/// 방문 표시만 바뀐 갱신은 여기까지 내려오지 않는다.
///
/// **[MapCells]가 이 목록을 직접 들고 있다.** 방문 표시를 바꾸는 두 메서드는 칸의
/// 묶음도 시도도 건드리지 않으므로 키는 처음 만든 그대로다 — 그래서 여기서는
/// 그 인스턴스를 꺼내 오기만 하면 되고, 동등성 비교로 새 목록을 걸러 낼 필요조차
/// 없다.
@Riverpod(keepAlive: true, retry: neverRetry)
Future<List<CellShapeKey>> cellShapeKeys(Ref ref) =>
    ref.watch(mapCellsProvider.notifier).shapeKeys();

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
///
/// **그래서 [cellShapeKeysProvider]를 watch한다.** 칸 목록을 직접 watch하면
/// 방문 표시가 바뀔 때마다 여기까지 다시 돌아 화면이 로딩으로 떨어진다.
// **재시도하지 않는다**(2026-08-26). 상위를 기다릴 뿐 자기가 서버를 부르지
// 않는다 — 여기서 재시도하면 이미 소진된 상위를 다시 깨워 왕복이 곱해진다.
@Riverpod(keepAlive: true, retry: neverRetry)
Future<List<CellGeometry>> cellGeometries(Ref ref) async {
  final List<MapCell> cells = <MapCell>[
    for (final CellShapeKey k in await ref.watch(cellShapeKeysProvider.future))
      k.toCell(),
  ];

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

  // **파싱과 조립을 한 isolate에서 끝낸다.** 예전에는 파싱만 `compute`로 넘기고
  // 조립은 메인에서 했는데, 그러면 13만 개가 넘는 중간 좌표가 메인으로 복사돼 오고
  // 조립(~250ms)이 UI 스레드에 그대로 얹혔다. 원문만 넘기고 완성된 1만여 점만
  // 돌려받으면 그 무게가 메인에 아예 오지 않는다.
  //
  // **원문을 여기서 읽는다** — `districtBoundariesProvider`를 watch하면 파싱된
  // 결과를 받게 되어 다시 그 복사 비용이 생긴다. 그쪽은 위치 판정·사진 스캔이
  // 쓰는 별개 경로로 남는다.
  final String raw = await rootBundle.loadString(districtBoundaryAssetPath);
  return compute(
    CellShapeBuilder.parseAndBuild,
    CellShapeBuildRequest(geoJson: raw, cells: cells),
  );
}

/// 시도별 진척(R21). **클라이언트가 센다** — 161칸을 이미 갖고 있다.
// [cellGeometries]와 같은 이유로 재시도하지 않는다 — `mapCells`의 파생이다.
@Riverpod(retry: neverRetry)
Future<List<ProvinceProgress>> provinceProgress(Ref ref) async {
  final List<MapCell> cells = await ref.watch(mapCellsProvider.future);
  return provinceProgressOf(cells);
}

/// 칸 상세(R11·R22). 칸 id로 부르는 family다.
///
/// 광역시 칸은 장소가 수천 건이라 커서로 이어 읽는다(스펙 §11).
@Riverpod(retry: defaultNetworkRetry)
class CellDetailController extends _$CellDetailController {
  @override
  Future<CellDetail> build(String cellId) =>
      ref.watch(nationalMapRepositoryProvider).fetchCellDetail(cellId: cellId);

  // **`loadMore`가 없다**(2026-08-25). 서버가 `spots`를 배열로 바꾸면서 커서가
  // 사라져 이어 읽을 수단 자체가 없다 — `first` 상한 50이 전부다.
}
