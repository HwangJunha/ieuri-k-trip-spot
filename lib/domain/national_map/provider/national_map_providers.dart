import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/cell_geometry.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import 'cell_geometry_provider.dart';

part 'national_map_providers.g.dart';

/// 161칸과 뷰어의 방문 여부(R6·R20).
///
/// **아직 서버 계약이 없다.** `mapCells`·`recordVisits`를 비롯한 SPEC-0030의
/// 루트 필드가 서버에 존재하지 않아(슬라이스 1·2가 진행 중) repository를 붙이지
/// 못했다. 추측한 스키마로 오퍼레이션을 쓰면 코드젠은 통과하고 런타임에 깨진다
/// (CLAUDE.md §13) — 그래서 지금은 **앱 자산의 칸 목록을 전부 미방문으로** 낸다.
///
/// 서버가 나오면 이 provider의 본문만 repository 호출로 바꾼다. 화면과 계산은
/// 이미 [MapCell]에 맞춰져 있어 그대로 둔다.
@riverpod
Future<List<MapCell>> mapCells(Ref ref) async {
  final List<CellGeometry> geometries = await ref.watch(
    cellGeometriesProvider.future,
  );
  final Set<String> visited = ref.watch(localVisitedCellsProvider);

  return <MapCell>[
    for (final CellGeometry g in geometries)
      MapCell(
        code: g.code,
        districtCodes: g.districtCodes,
        // 서버가 활성 언어로 줄 값이다(R8). 그때까지는 자산의 이름을 쓴다.
        name: g.nameKo,
        provinceName: g.provinceNameKo,
        provinceCode: g.provinceCode,
        visited: visited.contains(g.code),
      ),
  ];
}

/// 이 기기에서 방문으로 표시한 칸.
///
/// **서버가 붙기 전까지의 임시 저장소다.** 앱을 껐다 켜면 사라진다 — 영속화하지
/// 않는 이유는, 서버가 나오면 이 provider 자체가 없어지기 때문이다. 지금 로컬 DB에
/// 스키마를 만들어 두면 그때 마이그레이션할 것이 생긴다.
@Riverpod(keepAlive: true)
class LocalVisitedCells extends _$LocalVisitedCells {
  @override
  Set<String> build() => const <String>{};

  /// 방문으로 표시한다. 이미 방문한 칸이면 아무 일도 일어나지 않는다(R3의 멱등).
  void record(String cellCode) {
    if (state.contains(cellCode)) return;
    state = <String>{...state, cellCode};
  }

  /// 방문을 해제한다. 없는 칸이어도 오류가 아니다(R4).
  void remove(String cellCode) {
    if (!state.contains(cellCode)) return;
    state = <String>{...state}..remove(cellCode);
  }

  /// 여러 칸을 한 번에 표시한다(사진 동기화 확인 후).
  void recordAll(Iterable<String> cellCodes) {
    state = <String>{...state, ...cellCodes};
  }
}

/// 시도별 진척(R21). 칸 목록에서 계산한다 — 서버가 다시 내려주지 않는다.
@riverpod
Future<List<ProvinceProgress>> provinceProgress(Ref ref) async {
  final List<MapCell> cells = await ref.watch(mapCellsProvider.future);
  return provinceProgressOf(cells);
}
