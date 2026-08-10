import 'map_marker.dart';

/// 뷰포트 1회 조회의 결과(R1·R2·R3·R12).
///
/// [markers]와 [clusters]는 **상호배타적이다** — 서버가 줌을 보고 한쪽만 채운다.
/// 둘 다 비었으면 결과 없음이고, 둘 다 차 있으면 계약 위반이다(설계 §4.2).
///
/// spot과 문화행사를 **한 목록에 섞어 담는다**(R21). 항상 함께 표시하고 토글 필터를
/// 두지 않으므로 나눠 들고 다닐 이유가 없다 — 종류는 [MapMarker.kind]가 말한다.
class MapViewportResult {
  const MapViewportResult({
    required this.markers,
    required this.clusters,
    required this.truncated,
  });

  const MapViewportResult.empty()
    : markers = const <MapMarker>[],
      clusters = const <MapCluster>[],
      truncated = false;

  final List<MapMarker> markers;
  final List<MapCluster> clusters;

  /// 결과가 줌별 상한에 걸려 일부만 왔는가(R3). 참이면 확대를 유도하는 안내를
  /// 띄우되 **마커를 지우거나 지도를 막지 않는다** — 보이는 것은 유효한 결과다.
  final bool truncated;

  /// 그릴 것이 하나도 없는가. 클러스터도 마커도 없으면 참이다.
  bool get isEmpty => markers.isEmpty && clusters.isEmpty;
}
