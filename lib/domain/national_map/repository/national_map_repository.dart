import '../model/cell_detail.dart';
import '../model/map_cell.dart';
import '../model/shared_map.dart';

/// 전국 지도 데이터 접근 경계(SPEC-0030). 생성된 `*.graphql.dart` 타입은 구현체
/// 안에만 있고 이 인터페이스에는 도메인 모델만 오간다(POL-020, CLAUDE.md §3).
abstract interface class NationalMapRepository {
  /// 161칸 + 뷰어의 방문 여부(R6·R20). 한 화면 한 왕복이다.
  Future<List<MapCell>> fetchCells();

  /// 칸 상세 — 대표 이미지와 장소 목록(R11·R22).
  Future<CellDetail> fetchCellDetail({
    required String cellId,
    int? first,
    String? after,
  });

  /// 방문 등록(R30·R33).
  ///
  /// **시군구 코드를 보낸다** — 칸 id가 아니다. 로컬 판정 결과를 그대로 넣는다.
  /// 멱등이라 이미 방문한 코드를 다시 보내도 오류가 아니며, 그 경우 결과의
  /// `updatedCells`가 비어 온다.
  Future<RecordVisitsResult> recordVisits(List<String> districtCodes);

  /// 방문 해제(R4).
  ///
  /// **칸 id를 보낸다** — 그 칸에 속한 모든 시군구의 기록이 함께 해제된다.
  Future<MapCell?> removeVisit(String cellId);

  /// 공유 링크 발급(R36). 유효한 링크가 있으면 같은 것이 온다.
  Future<MapShareLink> createShareLink();

  /// 공유 링크 폐기(R14). 발급 때 받은 `shareUrl`을 그대로 넘긴다.
  Future<void> revokeShareLink(String shareUrl);

  /// 공유 링크로 남의 지도 조회(R37).
  Future<SharedMap> fetchSharedMap(String token);
}

/// 방문 등록 결과.
class RecordVisitsResult {
  const RecordVisitsResult({
    required this.updatedCells,
    required this.unknownDistrictCodes,
  });

  /// **이번 요청으로 방문이 된 칸만** 담긴다. 이미 방문한 칸은 빠진다.
  ///
  /// 이 목록으로 캐시를 고친다 — 재조회하지 않는다.
  final List<MapCell> updatedCells;

  /// 서버가 모른다고 답한 시군구 코드(`DISTRICT_NOT_FOUND`).
  ///
  /// **나머지는 정상 기록된다** — 부분 성공이라 실패로 다루지 않는다.
  final List<String> unknownDistrictCodes;

  bool get hasUnknownDistricts => unknownDistrictCodes.isNotEmpty;
}
