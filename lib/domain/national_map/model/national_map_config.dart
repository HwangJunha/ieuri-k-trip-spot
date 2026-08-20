import 'cell_geometry.dart';

/// 전국 지도의 설정값(SPEC-0030 §11, POL-044).
///
/// **출발점이지 확정값이 아니다.** 실측으로 조정한다. 호출부에 숫자를 박지 않고
/// 여기를 통해 쓰는 이유가 그것이다 — 값을 바꿀 때 한 곳만 고치면 된다.
class NationalMapConfig {
  const NationalMapConfig._();

  /// 좌표 축약 격자(도). 약 1km.
  ///
  /// 시군구의 최소 면적이 이보다 크므로 판정에 충분하다.
  static const double dedupeGridDegrees = 0.01;

  /// `resolveDistricts` 한 번에 보내는 좌표 상한.
  ///
  /// 계약이 500건을 상한으로 명시한다(§7.4). 넘겨 보내면 `TOO_MANY_COORDINATES`다.
  static const int resolveBatchSize = 500;

  /// 사진 스캔 배치 크기. 진행률 갱신 주기와 중단 지점 저장 빈도의 균형.
  static const int photoScanBatchSize = 200;

  /// 동기화 실패 재시도 횟수(POL-040 — 시간이 아니라 횟수로 제한한다).
  static const int syncRetryLimit = 3;

  /// 한국 영역(R25·R2). 이 밖의 좌표는 서버에 보내지 않는다.
  ///
  /// 자산의 실제 범위(경도 124.61~130.92, 위도 33.19~38.61)보다 넉넉하게 잡는다 —
  /// 여기서 거르는 목적은 해외 사진을 쳐내는 것이지 국경을 정밀히 그리는 게 아니다.
  /// 애매한 좌표는 보내고 서버가 판정하게 두는 편이 낫다(R2는 판정 실패를 오류로
  /// 보지 않는다).
  static const GeoBounds koreaBounds = GeoBounds(
    minLng: 124.0,
    minLat: 32.5,
    maxLng: 132.0,
    maxLat: 39.5,
  );
}
