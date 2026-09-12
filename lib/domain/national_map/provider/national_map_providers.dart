import 'package:flutter/foundation.dart' show FlutterError, compute;
import 'package:flutter/services.dart' show rootBundle;
// 재시도 확장이 `WidgetRef`를 받는다 — 부르는 쪽이 화면이다.
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/log/app_log.dart';
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

final Logger _log = appLogger('NationalMapProviders');

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
/// **`keepAlive`를 선언이 아니라 링크로 잡는다**(SPEC-0034 R3). 클래스에
/// `keepAlive: true`를 걸면 미인증 경로가 돌려준 빈 목록까지 함께 붙들려,
/// 세션 복원 전에 한 번 평가되면 빈 지도가 프로세스 수명 내내 남는다.
@Riverpod(retry: defaultNetworkRetry)
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
    //
    // **이 빈 값은 붙들지 않는다**(SPEC-0034 R3). 링크를 잡지 않고 돌아가므로
    // 구독이 끊기는 순간 버려지고, 다음 구독이 실제 조회를 다시 일으킨다. 예전에는
    // 클래스가 통째로 `keepAlive`라 이 빈 목록도 함께 붙들렸고, 앱 시작 직후 세션
    // 복원보다 이 provider가 먼저 평가되면 **세션이 복원된 뒤에도 빈 목록이 남아
    // 빈 지도가 그려졌다.**
    if (!ref.watchSignedIn()) {
      _shapeKeys = const <CellShapeKey>[];
      return const <MapCell>[];
    }

    // **링크는 await 전에 잡는다** — await 뒤면 그 사이 폐기됐을 때 죽은 Ref를
    // 만진다(`map_providers.dart`의 같은 주석).
    final link = ref.keepAlive();
    final List<MapCell> cells;
    try {
      cells = await ref.watch(nationalMapRepositoryProvider).fetchCells();
    } on Object {
      // 실패한 결과는 붙들지 않는다 — 붙들면 재시도가 같은 실패를 재사용한다(R1).
      link.close();
      rethrow;
    }
    // **빈 목록도 붙들지 않는다.** 161칸은 고정 집합이라 빈 결과는 정상이 아니고
    // (R2), 그것을 프로세스 수명 동안 캐시하면 재시도조차 손댈 수 없게 된다.
    if (cells.isEmpty) link.close();

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
///
/// **자산 부재와 파싱 실패를 구분한다**(SPEC-0034 R4). 예전에는 모든 예외를
/// 삼켜 빈 맵으로 만들었는데, 그 탓에 `asset/geo/cell-shapes.json`이 **파일도
/// 없고 `pubspec.yaml`에 선언도 없다는 사실이 아무 신호도 내지 않았다.** 폴백이
/// 실제로 동작해 지도는 그려지므로 폴백은 그대로 두되, 자산이 없다는 것과 있는데
/// 깨졌다는 것은 다른 사건이므로 다르게 다룬다.
///
/// 자산 생성은 이 스펙의 범위가 아니다(SPEC-0034 §7) — 그래서 여기서 던지지
/// 않는다. 던지면 폴백이 끊겨 지도가 통째로 사라진다.
@Riverpod(keepAlive: true)
Future<Map<String, List<List<GeoPoint>>>> cellShapes(Ref ref) async {
  final String raw;
  try {
    raw = await rootBundle.loadString(CellShapeSource.assetPath);
  } on FlutterError {
    // 자산이 없다. `pubspec.yaml`에 선언되지 않았거나 파일 자체가 없는 것으로,
    // 지금이 바로 이 상태다 — 폴백으로 그린다.
    _log.i('칸 도형 자산 없음(${CellShapeSource.assetPath}) — 경계 폴백으로 그린다');
    return const <String, List<List<GeoPoint>>>{};
  }

  try {
    return await compute(CellShapeSource.parse, raw);
  } on Object catch (error) {
    // 자산은 있는데 읽을 수 없다. 부재와 달리 이건 고쳐야 할 사건이다.
    // 좌표는 남기지 않는다(POL-013) — 타입만 적는다.
    _log.w('칸 도형 자산 파싱 실패: ${error.runtimeType} — 경계 폴백으로 그린다');
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
Future<CellGeometrySet> cellGeometries(Ref ref) async {
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
    if (out.isNotEmpty) {
      return CellGeometrySet(
        geometries: out,
        origin: CellShapeOrigin.shapeAsset,
      );
    }
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
  return CellGeometrySet(
    geometries: await compute(
      CellShapeBuilder.parseAndBuild,
      CellShapeBuildRequest(geoJson: raw, cells: cells),
    ),
    origin: CellShapeOrigin.boundaryFallback,
  );
}

/// 지도를 그리는 데 필요한 provider 전부(SPEC-0034 R1).
///
/// **재시도의 단위가 "지도에 필요한 데이터 전부"다.** 예전에는 화면의 재시도
/// 버튼이 칸 목록 하나만 무효화했는데, 세 provider가 모두 `keepAlive`이고
/// 형상 쪽은 `neverRetry`라 **형상이 실패하면 그 실패가 프로세스 수명 동안
/// 남았다** — 버튼을 아무리 눌러도 같은 실패가 재사용됐다.
///
/// 어느 것이 실패했는지 화면이 알아내서 골라 무효화하는 구조는 의존이 늘 때마다
/// 깨진다. 셋은 항상 함께 필요하고 함께 실패해도 무방하다.
///
/// **목록을 여기 한 곳에 둔다** — 화면 코드에 흩어지면 다음 사람이 새 의존을
/// 추가할 때 빠뜨린다. 지도에 의존을 더하면 이 목록에도 더한다.
///
/// 무효화 순서는 의존의 아래에서 위다 — 파생부터 버려야 상위를 다시 읽는다.
///
/// 자동 재시도는 넣지 않는다(R1). `neverRetry`는 그대로 두고, 바꾸는 것은
/// **사용자 재시도가 실제로 듣게 만드는 것** 하나다.
///
/// `Ref`와 `WidgetRef`는 `invalidate`를 각각 따로 선언할 뿐 공통 상위 타입이
/// 없다(riverpod 3.0.3). 그래서 확장을 양쪽에 하나씩 둔다 — 목록 자체는
/// [_nationalMapProviders] 한 곳이고, 부르는 쪽은 자기 ref로 부르기만 한다.
final List<ProviderOrFamily> _nationalMapProviders = <ProviderOrFamily>[
  cellGeometriesProvider,
  cellShapeKeysProvider,
  cellShapesProvider,
  mapCellsProvider,
];

/// 화면에서 부르는 재시도(SPEC-0034 R1).
extension NationalMapRetry on WidgetRef {
  void invalidateNationalMap() {
    for (final ProviderOrFamily p in _nationalMapProviders) {
      invalidate(p);
    }
  }
}

/// provider에서 부르는 재시도. [NationalMapRetry]와 같은 목록을 쓴다.
extension NationalMapRetryRef on Ref {
  void invalidateNationalMap() {
    for (final ProviderOrFamily p in _nationalMapProviders) {
      invalidate(p);
    }
  }
}

/// 테스트에서 부르는 재시도.
///
/// **화면이 부르는 것과 같은 목록을 쓴다** — 테스트가 자기 목록을 따로 세면
/// 화면이 provider 하나를 빠뜨려도 테스트는 통과한다. 그게 R1의 원래 버그다.
extension NationalMapRetryContainer on ProviderContainer {
  void invalidateNationalMap() {
    for (final ProviderOrFamily p in _nationalMapProviders) {
      invalidate(p);
    }
  }
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
