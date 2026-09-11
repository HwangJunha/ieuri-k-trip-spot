/// 전국 지도 화면이 무엇을 그릴지.
///
/// 화면에서 떼어낸 이유는 **이 판정 하나가 사용자가 본 버그의 전부였기 때문이다.**
/// 갱신 중 잠깐 로딩이 되는 것과 보여 줄 값이 아직 없는 것을 구분하지 못해, 사진
/// 스캔이 지역을 칠할 때마다 지도가 통째로 사라졌다(사용자 지적 2026-08-26).
/// 위젯 밖에 두면 GPS도 자산도 없이 그 규칙만 확인할 수 있다.
enum MapScreenViewState {
  /// 지도를 그린다. 갱신 중이어도 들고 있는 값으로 계속 그린다.
  map,

  /// 아직 아무것도 못 받았고 실패도 아니다.
  loading,

  /// 아무것도 못 받은 채 실패했다.
  error;

  /// [hasCells]·[hasGeometries]는 **값을 들고 있는지**다(로딩 중이어도 참일 수
  /// 있다). [failed]는 둘 중 하나라도 오류인지다.
  ///
  /// 값이 다 있으면 오류여도 지도를 그린다 — 그건 갱신이 실패한 것이지, 이미
  /// 그려 둔 지도를 치울 이유가 아니다.
  ///
  /// **빈 칸 목록은 지도가 아니다**(SPEC-0034 R2). 161칸은 서버가 부팅 시 개수를
  /// 강제하는 고정 집합이라(SPEC-0030) 빈 목록은 정상 결과일 수 없다 — 조회가
  /// 덜 됐거나 실패한 것이다. 예전에는 "값이 non-null인가"만 봤는데 빈 리스트도
  /// non-null이라 그대로 지도 상태를 통과했고, **칸이 하나도 없는 빈 화면이
  /// 정상처럼 그려졌다.**
  ///
  /// 그래서 [settled]가 필요하다. 조회가 끝나지 않았는데 비어 있는 것은 아직
  /// 안 온 것(로딩)이고, 끝났는데 비어 있으면 오류다.
  static MapScreenViewState of({
    required bool hasCells,
    required bool hasGeometries,
    required bool failed,
    required bool settled,
  }) {
    if (hasCells && hasGeometries) return MapScreenViewState.map;
    if (failed) return MapScreenViewState.error;
    // 조회가 끝났는데도 그릴 값이 없다 — 기다려 봐야 오지 않는다.
    if (settled) return MapScreenViewState.error;
    return MapScreenViewState.loading;
  }
}
