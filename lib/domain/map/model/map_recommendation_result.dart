import 'map_marker.dart';

/// 지도 영역 기준 추천 1회 조회의 결과(SPEC-0036).
///
/// **개수를 함께 들고 다니는 이유**: 「영역 안 후보가 소진되었는가」(FR-009)는 받은
/// 목록만 봐서는 알 수 없다. 요청한 수보다 적게 왔을 때만 소진이며, 클라이언트가
/// 격자로 솎아 낸 뒤의 수로 판정하면 **가짜 소진**이 된다 — SPEC-0035에서 실제로
/// 터졌던 실패(요청 수와 표시 수를 같게 두었더니 열 장 만에 소진 화면)가 그것이다.
///
/// 판정을 이 모델이 들고 있으면 화면이 그 구분을 다시 하지 않아도 된다.
class MapRecommendationResult {
  const MapRecommendationResult({
    required this.markers,
    required this.exhausted,
  });

  const MapRecommendationResult.empty()
    : markers = const <MapMarker>[],
      exhausted = true;

  /// 추천 점수 내림차순으로 온 장소. 동점은 id 오름차순이며, 같은 영역·같은 제외
  /// 목록이면 **항상 같은 순서**다(QR-001) — 클라이언트가 다시 정렬하거나 섞지
  /// 않는다.
  final List<MapMarker> markers;

  /// 영역 안에 아직 표시하지 않은 장소가 없는가(FR-008·FR-009).
  ///
  /// 서버가 요청한 수보다 적게 준 것이 유일한 근거다. 빈 결과는 오류가 아니라
  /// 소진이다(AC-012).
  final bool exhausted;

  bool get isEmpty => markers.isEmpty;
}
