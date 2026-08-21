import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/map_cell.dart';
import '../repository/national_map_repository.dart';
import 'national_map_providers.dart';

part 'visit_controller.g.dart';

/// 방문 등록·해제(R3·R4·R30·R33).
///
/// **낙관적 업데이트를 한다** — 누르면 즉시 칠하고 실패하면 되돌린다. 서버가
/// 변경된 칸을 돌려주므로 성공 시에는 그 값으로 캐시를 고친다(재조회 없음).
@riverpod
class VisitController extends _$VisitController {
  @override
  bool build() => false; // 요청이 도는 중인지

  /// 시군구 코드로 방문을 등록한다.
  ///
  /// 사진 동기화와 현재 위치 등록이 **같은 경로를 쓴다** — 좌표 수만 다르다.
  /// 사진이 몇 장이든 코드로 축약되므로 요청은 1회다.
  ///
  /// 낙관적 표시는 하지 않는다 — 어떤 칸이 칠해질지는 서버의 칸 묶음 규칙에
  /// 달렸고, 그건 응답(`updatedCells`)이 알려 준다.
  Future<RecordVisitsResult> record(List<String> districtCodes) async {
    if (districtCodes.isEmpty) {
      return const RecordVisitsResult(
        updatedCells: <MapCell>[],
        unknownDistrictCodes: <String>[],
      );
    }

    state = true;
    try {
      final RecordVisitsResult result = await ref
          .read(nationalMapRepositoryProvider)
          .recordVisits(districtCodes);
      ref.read(mapCellsProvider.notifier).applyUpdated(result.updatedCells);
      return result;
    } finally {
      state = false;
    }
  }

  /// 칸 id로 방문을 해제한다.
  ///
  /// 여기서는 낙관적으로 지운다 — 어떤 칸이 바뀔지 이미 알기 때문이다.
  Future<void> remove(String cellId) async {
    final MapCells notifier = ref.read(mapCellsProvider.notifier);
    notifier.setVisitedOptimistically(<String>{cellId}, visited: false);

    state = true;
    try {
      final MapCell? updated = await ref
          .read(nationalMapRepositoryProvider)
          .removeVisit(cellId);
      if (updated != null) notifier.applyUpdated(<MapCell>[updated]);
    } on Object {
      // 되돌린다.
      notifier.setVisitedOptimistically(<String>{cellId}, visited: true);
      rethrow;
    } finally {
      state = false;
    }
  }
}
