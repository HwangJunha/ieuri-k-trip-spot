import '../model/cell_detail.dart';
import '../model/map_cell.dart';
import '../model/map_relation.dart';
import '../model/shared_map.dart';

/// 전국 지도 데이터 접근 경계(SPEC-0030). 생성된 `*.graphql.dart` 타입은 구현체
/// 안에만 있고 이 인터페이스에는 도메인 모델만 오간다(POL-020, CLAUDE.md §3).
abstract interface class NationalMapRepository {
  /// 161칸 + 뷰어의 방문 여부(R6·R20). 한 화면 한 왕복이다.
  Future<List<MapCell>> fetchCells();

  /// 칸 상세 — 대표 이미지와 장소 목록(R11·R22).
  ///
  /// **이어 읽을 수단이 없다**(2026-08-25). 서버가 `spots`를 커서 연결에서 배열로
  /// 바꿔 `after`가 사라졌고, [first]는 상한 50으로 잘린다.
  Future<CellDetail> fetchCellDetail({required String cellId, int? first});

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

  /// 내 관계 목록 한 페이지. 겹침은 **조회 시점에 재계산**된 값이다.
  Future<MapRelationPage> fetchRelations({int? first, String? after});

  /// 공유 링크로 관계를 맺는다. **양쪽 목록에 서로 추가된다.**
  ///
  /// 이미 맺어진 상대면 오류가 아니라 그대로 성공한다(멱등).
  Future<void> createRelation(String shareUrl);

  /// 관계를 **내 목록에서만** 지운다. 상대 목록의 나는 남는다.
  Future<void> removeRelation(String memberId);
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
