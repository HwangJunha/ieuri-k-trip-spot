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
  static MapScreenViewState of({
    required bool hasCells,
    required bool hasGeometries,
    required bool failed,
  }) {
    if (hasCells && hasGeometries) return MapScreenViewState.map;
    if (failed) return MapScreenViewState.error;
    return MapScreenViewState.loading;
  }
}
