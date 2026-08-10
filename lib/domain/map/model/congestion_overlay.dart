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

/// 좌표가 어느 구역 안인지 찾는다(R27 — 구역 선택).
///
/// 겹치는 구역이 있으면 **먼저 오는 것을 고른다.** 서울시 구역은 대체로 겹치지 않지만
/// 관광특구가 인접 구역과 일부 겹치는 경우가 있어, 순서를 정해 두지 않으면 같은 곳을
/// 눌렀을 때 다른 구역이 뜬다.
CongestionOverlay? overlayAt({
  required double latitude,
  required double longitude,
  required List<CongestionOverlay> overlays,
}) {
  for (final CongestionOverlay overlay in overlays) {
    if (_containsPoint(overlay.boundary.polygon, latitude, longitude)) {
      return overlay;
    }
  }
  return null;
}

/// 점이 다각형 내부인지 판정한다(ray casting).
///
/// 폴리곤 좌표는 `[lng, lat]` 순서다(GeoJSON 규약) — 이 함수 안에서만 그 순서를 알고,
/// 밖에서는 위도·경도를 이름으로 받는다.
///
/// 경계선 위의 점은 구현상 한쪽으로 갈리는데, 구역 선택에서는 어느 쪽이든 상관없다 —
/// 사용자가 경계선을 픽셀 단위로 정확히 누르는 일은 없다.
bool _containsPoint(List<List<double>> polygon, double lat, double lng) {
  bool inside = false;
  for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final double lngI = polygon[i][0];
    final double latI = polygon[i][1];
    final double lngJ = polygon[j][0];
    final double latJ = polygon[j][1];

    // 수평 반직선이 이 변과 교차하는가.
    if ((latI > lat) != (latJ > lat) &&
        lng < (lngJ - lngI) * (lat - latI) / (latJ - latI) + lngI) {
      inside = !inside;
    }
  }
  return inside;
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
