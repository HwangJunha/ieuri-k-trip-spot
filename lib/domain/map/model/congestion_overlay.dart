import 'congestion_area.dart';
import 'map_tuning.dart';

/// 폴리곤 하나를 그리는 데 필요한 것 전부 — 경계(정적)와 혼잡도(실시간)를 조인한
/// 결과다(R26).
class CongestionOverlay {
  const CongestionOverlay({required this.area, required this.boundary});

  final CongestionArea area;
  final CongestionAreaBoundary boundary;

  /// 표시용 구역명. 둘 다 이름을 갖고 있으나 **실시간 응답 쪽을 신뢰한다** — 경계는
  /// 캐시라 언어 전환 직후 잠시 이전 언어일 수 있다(설계 §5.2).
  String get name => area.name;
}

/// 임계 줌 미만에서는 폴리곤을 그리지 않는다(R25).
///
/// **표시 여부와 조회 여부가 같은 판정을 쓴다.** 게이트를 렌더링에만 두고 조회를
/// 계속하면 일일 쿼터를 지키는 장치가 무의미해진다(설계 §5.1) — 그래서 provider가
/// 조회 전에 이 함수를 먼저 본다.
bool shouldShowCongestion(int zoomLevel) =>
    zoomLevel >= MapTuning.polygonMinZoom;

/// 실시간 혼잡도와 캐시된 경계를 구역 id로 조인한다(R26).
///
/// **양쪽에 다 있는 구역만 남는다:**
/// - 혼잡도에는 있는데 경계 캐시에 없으면 **그 구역만 건너뛴다.** 오류로 올리지
///   않는다 — 서울시가 구역을 추가했는데 캐시가 낡은 경우가 여기 해당하고, 나머지
///   120곳을 못 그릴 이유가 되지 않는다.
/// - 경계에만 있고 혼잡도에 없으면 채색하지 않는다. 값이 없는 구역을 회색으로라도
///   칠하면 "데이터가 있는데 낮다"로 읽힌다.
///
/// 입력 순서를 유지한다 — 겹치는 폴리곤의 그리기 순서가 호출마다 달라지면 화면이
/// 깜빡인다.
List<CongestionOverlay> joinCongestionOverlays({
  required List<CongestionArea> areas,
  required Map<String, CongestionAreaBoundary> boundaries,
}) {
  final List<CongestionOverlay> overlays = <CongestionOverlay>[];
  for (final CongestionArea area in areas) {
    final CongestionAreaBoundary? boundary = boundaries[area.id];
    if (boundary == null) continue;
    overlays.add(CongestionOverlay(area: area, boundary: boundary));
  }
  return overlays;
}
