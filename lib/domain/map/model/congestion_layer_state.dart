import 'congestion_overlay.dart';

/// 혼잡도 레이어가 화면에서 취할 수 있는 상태(R29·R25·R30).
///
/// **마커 레이어와 독립이다.** `mapViewport`와 `seoulCongestion`이 별개 최상위
/// 필드이므로, 한쪽 실패가 다른 쪽을 가리지 않도록 상태를 따로 계산한다(설계 §6.3).
/// 혼잡도가 죽어도 지도는 정상 조작 가능하고 spot·행사 마커는 계속 보인다 — 전면
/// 오류 화면으로 덮지 않는다.
sealed class CongestionLayerState {
  const CongestionLayerState();

  /// 출처 표기를 노출해야 하는가(R30).
  ///
  /// 공공누리 1유형은 출처 표시가 **필수**다. 폴리곤이 실제로 보이는 동안만 표기하면
  /// 되므로, 줌 게이트로 숨겼거나 데이터가 없을 때는 띄우지 않는다 — 아무것도 안
  /// 그리면서 "서울시 데이터 출처"만 떠 있으면 무엇의 출처인지 알 수 없다.
  bool get showsAttribution => switch (this) {
    CongestionShown(overlays: final List<CongestionOverlay> o) => o.isNotEmpty,
    _ => false,
  };
}

/// 줌이 임계값 미만이라 그리지 않는다(R25).
///
/// **조회조차 하지 않은 상태다.** 이 상태에서는 `seoulCongestion`을 호출하지 않아
/// 일일 쿼터를 아낀다(설계 §5.1). 오류가 아니므로 안내도 띄우지 않는다 — 사용자가
/// 축소한 결과일 뿐이다.
class CongestionHiddenByZoom extends CongestionLayerState {
  const CongestionHiddenByZoom();
}

/// 조회 중.
class CongestionLoading extends CongestionLayerState {
  const CongestionLoading();
}

/// 폴리곤을 그린다.
class CongestionShown extends CongestionLayerState {
  const CongestionShown(this.overlays);

  /// 경계와 조인된 결과(R26). 비어 있을 수 있다 — 지도가 서울 밖이면 걸치는 구역이
  /// 없다. 그건 오류가 아니라 정상이다.
  final List<CongestionOverlay> overlays;
}

/// 업스트림이 성능 저하 상태다(R11·R29).
///
/// **오류 화면으로 덮지 않는다.** 서버가 이것을 GraphQL 오류가 아니라 `degraded`
/// 표식으로 내려주는 이유가 여기 있다(spec §7.6) — 한 레이어만 없는 상태이며 지도는
/// 정상 사용 가능하다.
///
/// **안내도 띄우지 않는다**(사용자 결정, 2026-08-12). 혼잡도는 부가 데이터라 없어도
/// 지도가 제 역할을 다 하고, 실패를 알려도 사용자가 할 수 있는 일이 없다 — 배너는
/// 검색창 아래 자리만 차지했다. 폴리곤·범례·출처가 함께 빠지는 것으로 충분하다
/// ([showsAttribution]이 false라 셋이 한 판정을 공유한다).
class CongestionDegraded extends CongestionLayerState {
  const CongestionDegraded();
}
