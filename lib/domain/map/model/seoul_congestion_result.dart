import 'congestion_area.dart';

/// 혼잡도 1회 조회의 결과(R6~R11).
///
/// **[degraded]는 오류가 아니라 데이터다**(spec §7.6). 서버가 업스트림 장애를
/// GraphQL 오류로 던지지 않는 이유는, 오류로 만들면 클라이언트의 오류 분기로 들어가
/// 지도 전체가 실패한 것처럼 다뤄지기 때문이다 — 실제로는 한 레이어만 없는 상태이며
/// 지도와 마커는 정상이다(R29).
class SeoulCongestionResult {
  const SeoulCongestionResult({
    required this.areas,
    required this.degraded,
    this.staleSince,
  });

  const SeoulCongestionResult.empty()
    : areas = const <CongestionArea>[],
      degraded = false,
      staleSince = null;

  /// 뷰포트에 걸치는 구역들. **비어 있는 것이 정상일 수 있다** — 지도가 서울 밖이면
  /// 걸치는 구역이 없다(spec §7.4).
  final List<CongestionArea> areas;

  /// 업스트림이 성능 저하 상태인가. 참이면 혼잡도 레이어만 안내로 대체하고 마커와
  /// 지도 조작은 그대로 둔다(R29).
  final bool degraded;

  /// [degraded]일 때 마지막으로 성공한 시점(있으면). 캐시된 데이터와 함께 온다.
  final DateTime? staleSince;
}
