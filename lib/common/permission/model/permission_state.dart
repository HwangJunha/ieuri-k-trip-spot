/// 런타임 권한 상태를 앱 도메인 관점으로 표현한 값 (SPEC-0001).
///
/// 플러그인의 `PermissionStatus`를 앱이 실제로 처리하는 네 가지 결과로 매핑한다:
/// [granted], [denied](다음 실행 때 다시 물음), 그리고 "설정 열기" 경로를 여는 두
/// 종단 상태 [permanentlyDenied]·[restricted] (R5). 플러그인의 `limited`/
/// `provisional`은 [granted]로 합친다 — 부분 허용도 우리 목적상 허용으로 본다.
///
/// 이 값들은 **안정 식별자**로, 사용자 표시 문구와 분리되어 있다 (POL-023). UI가
/// 상태를 지역화 문자열로 매핑하며, 그 반대 방향은 없다.
enum PermissionState {
  granted,
  denied,
  permanentlyDenied,
  restricted;

  /// 앱이 재요청하면 안 되는, 사용자가 내린 최종 결정인지 여부 (R6): 허용, 영구거부,
  /// 정책상 restricted. 단순 [denied]는 결정된 게 *아니다* — iOS/Android가 OS
  /// 다이얼로그를 다시 띄울 수 있다.
  bool get isDecided => this != PermissionState.denied;

  /// 이제 OS 설정 앱을 통해서만 바꿀 수 있는 상태인지 여부 (R5): 앱이 더는 권한
  /// 다이얼로그를 직접 띄울 수 없다.
  bool get needsSettings =>
      this == PermissionState.permanentlyDenied ||
      this == PermissionState.restricted;
}
