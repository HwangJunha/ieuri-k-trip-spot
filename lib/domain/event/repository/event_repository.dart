import '../../../common/pagination/page.dart';
import '../model/festival.dart';

/// Data access for tourism events. Returns domain models only — the generated
/// GraphQL types never cross this boundary (CLAUDE.md §3).
abstract interface class EventRepository {
  /// 반경 내에서 오늘이 행사 기간에 포함된 축제(SPEC-0013 R17).
  ///
  /// 경계 포함이며 '오늘'의 기준은 **서버 시각**이다 — 클라이언트가 날짜를 다시
  /// 판정하지 않는다(AC-17.1~17.3은 서버 기준 테스트다).
  ///
  /// **반경 내 진행 중 축제가 0건인 것은 흔한 정상 상태다**(AC-17.4) — 오류가
  /// 아니라 빈 페이지로 돌아온다.
  /// [hasOrigin]은 원문/번역 구분이다(SPEC-0019). true면 요청 언어로 **쓰인** 축제만,
  /// false면 **번역된** 축제만, null이면 둘 다 온다.
  Future<CursorPage<Festival>> fetchOngoingFestivals({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    bool? hasOrigin,
    int? first,
    String? after,
  });
}
