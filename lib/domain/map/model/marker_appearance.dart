import 'map_marker.dart';

/// 마커 등장 판정과 연출 배율(SPEC-0025 R9·R10).
///
/// ## 왜 이것이 테스트의 본체인가
///
/// 연출 자체는 네이티브 SDK가 그리므로 단위 테스트로 볼 수 없다(설계 §4.6). 반면
/// "이번에 새로 보이게 된 마커가 무엇인가"는 순수 계산이고, AC R9-1·R10-1~3이 전부
/// 이 판정에 걸려 있다. 연출을 넣지 못하더라도 이 판정은 남긴다(설계 §4.1) — 나중에
/// 연출 경로가 열리면 얹기만 하면 된다.
abstract final class MarkerAppearance {
  /// 마커의 **안정적인 식별자**.
  ///
  /// **풀 인덱스를 쓰면 안 된다**(설계 §4.2). `drawMarkers`는 `Poi`를 지우지 않고
  /// 재사용하므로 같은 인덱스에 다른 장소가 들어온다 — 인덱스로 비교하면 새로 나타난
  /// 마커를 "원래 있던 것"으로 오판한다.
  ///
  /// 종류가 다르면 같은 id라도 다른 마커다(`MapMarkerController._keyOf`와 같은 규약).
  static String keyOf(MapMarker marker) => '${marker.kind.name}:${marker.id}';

  /// [previous]에 견줘 [next]에서 **새로 나타난** 마커들.
  ///
  /// 순서는 [next] 그대로 유지한다 — 그려지는 차례대로 연출이 걸려야 자연스럽다.
  ///
  /// 숨김 상태였다가 다시 보이게 된 것도 신규 등장이다(AC R10-2). [previous]에는
  /// **실제로 보이던 마커만** 넘긴다 — 숨긴 것까지 넘기면 다시 나타나는 마커를
  /// 기존 것으로 오판한다.
  static List<MapMarker> newcomers({
    required List<MapMarker> previous,
    required List<MapMarker> next,
  }) {
    final Set<String> before = previous.map(keyOf).toSet();
    return next
        .where((MapMarker m) => !before.contains(keyOf(m)))
        .toList(growable: false);
  }

  /// 연출 시작 배율. 여기서 시작해 1.0까지 커진다(R9).
  ///
  /// 0에서 시작하지 않는 이유는 완전히 사라진 상태에서 커지면 "없던 것이 튀어나온다"로
  /// 읽혀 산만하기 때문이다 — 작게 시작하는 것으로 충분하다.
  static const double startScale = 0.4;

  /// 연출에 쓰는 시간(ms). 지도 갱신이 잦으므로 짧게 둔다 — 길면 갱신마다 마커가
  /// 계속 꿈틀거린다.
  static const int durationMillis = 220;

  /// 진행도 [t](0~1) → 크기 배율(AC R9-2~4).
  ///
  /// 시작(0)에서 [startScale], 끝(1)에서 정확히 **1.0**이다 — 끝 값이 1이 아니면
  /// 연출이 끝난 마커의 크기가 연출 없는 마커와 달라져 R11이 깨진다.
  ///
  /// 감속 곡선(ease-out)을 쓴다. 선형은 끝에서 뚝 멈춰 기계적으로 보인다.
  static double scaleAt(double t) {
    final double clamped = t.clamp(0.0, 1.0);
    // ease-out quadratic: 1 - (1-t)^2. t=0 → 0, t=1 → 1.
    final double eased = 1 - (1 - clamped) * (1 - clamped);
    return startScale + (1 - startScale) * eased;
  }
}
