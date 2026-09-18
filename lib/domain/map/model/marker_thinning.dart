import 'map_bounds.dart';
import 'map_marker.dart';

/// 화면에 그릴 마커를 솎아낸다.
///
/// **왜 필요한가.** 서버는 뷰포트 안의 spot을 상한까지 전부 준다(강남 한 화면에
/// 500건). 그걸 그대로 찍으면 마커가 서로 겹쳐 지도가 보이지 않고, 겹친 것들은
/// 어차피 개별로 읽히지도 않는다 — 같은 건물에 있는 가게 열 곳을 따로 찍어 봐야
/// 사용자에게는 덩어리 하나다.
///
/// 화면을 격자로 나누고 **칸마다 하나만 남긴다.** 그리드 방식을 쓰는 이유는 결과가
/// 뷰포트에만 의존해 안정적이기 때문이다 — 거리 기반으로 훑으면 입력 순서가 조금만
/// 달라져도 남는 마커가 바뀌어 화면이 깜빡인다.
///
/// 순수 계산이라 그대로 테스트된다.
List<MapMarker> thinMarkers({
  required List<MapMarker> markers,
  required MapBounds viewport,
  required int columns,
  required int maxCount,
}) {
  if (markers.isEmpty) return const <MapMarker>[];

  final double latSpan = viewport.latSpan;
  final double lngSpan = viewport.lngSpan;
  if (latSpan <= 0 || lngSpan <= 0) return const <MapMarker>[];

  // 칸 하나에 마커 하나. 먼저 온 것이 그 칸을 차지한다 — 서버가 관련도 순으로
  // 주므로 앞쪽이 대체로 더 알려진 곳이다.
  final Map<int, MapMarker> chosen = <int, MapMarker>{};
  for (final MapMarker marker in markers) {
    final int col = (((marker.longitude - viewport.minLng) / lngSpan) * columns)
        .floor()
        .clamp(0, columns - 1);
    final int row = (((marker.latitude - viewport.minLat) / latSpan) * columns)
        .floor()
        .clamp(0, columns - 1);
    chosen.putIfAbsent(row * columns + col, () => marker);
    if (chosen.length >= maxCount) break;
  }

  // 문화행사를 격자 밖으로 통과시키던 예외는 걷어냈다 — 그 마커를 더 이상 만들지
  // 않는다(사용자 결정 2026-09-18).
  return chosen.values.toList();
}
