import 'cell_geometry.dart';

/// 전국 지도의 설정값(SPEC-0030 §11, POL-044).
///
/// **출발점이지 확정값이 아니다.** 실측으로 조정한다. 호출부에 숫자를 박지 않고
/// 여기를 통해 쓰는 이유가 그것이다.
class NationalMapConfig {
  const NationalMapConfig._();

  /// 좌표 축약 격자(도). 약 1km.
  ///
  /// 시군구의 최소 면적이 이보다 크므로 판정에 충분하다.
  static const double dedupeGridDegrees = 0.01;

  /// 사진 스캔 배치 크기. 진행률 갱신 주기와 중단 지점 저장 빈도의 균형.
  static const int photoScanBatchSize = 200;

  /// 동기화 실패 재시도 횟수(POL-040 — 시간이 아니라 횟수로 제한한다).
  static const int syncRetryLimit = 3;

  /// 한국 영역(R25). 이 밖의 좌표는 판정을 시도하지 않는다.
  ///
  /// 실제 경계보다 넉넉하게 잡는다 — 여기서 거르는 목적은 해외 사진을 싸게
  /// 쳐내는 것이지 국경을 정밀히 그리는 게 아니다. 애매한 좌표는 통과시키고
  /// 판정기가 정확히 가린다.
  static const GeoBounds koreaBounds = GeoBounds(
    minLng: 124.0,
    minLat: 32.5,
    maxLng: 132.0,
    maxLat: 39.5,
  );
}
