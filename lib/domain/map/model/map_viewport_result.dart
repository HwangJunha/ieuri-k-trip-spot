import 'map_marker.dart';

/// 뷰포트 1회 조회의 결과(R1·R3·R12).
///
/// **클러스터는 없다.** 계약 초안에는 저줌에서 서버가 묶어 주는 `clusters`가 있었으나
/// 서버가 제거했다(2026-08-10 라이브 스키마 확인). 저줌에서 마커가 몰리는 문제는
/// 클라이언트의 격자 솎아내기가 맡는다(`marker_thinning.dart`).
///
/// spot과 문화행사를 **한 목록에 섞어 담는다**(R21). 항상 함께 표시하고 토글 필터를
/// 두지 않으므로 나눠 들고 다닐 이유가 없다 — 종류는 [MapMarker.kind]가 말한다.
class MapViewportResult {
  const MapViewportResult({required this.markers, required this.truncated});

  const MapViewportResult.empty()
    : markers = const <MapMarker>[],
      truncated = false;

  final List<MapMarker> markers;

  /// 결과가 줌별 상한에 걸려 일부만 왔는가(R3). 참이면 확대를 유도하는 안내를
  /// 띄우되 **마커를 지우거나 지도를 막지 않는다** — 보이는 것은 유효한 결과다.
  final bool truncated;

  /// 그릴 것이 하나도 없는가.
  bool get isEmpty => markers.isEmpty;
}
