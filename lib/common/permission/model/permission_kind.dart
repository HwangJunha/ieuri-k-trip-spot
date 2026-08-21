/// 앱이 요청하는 런타임 권한.
///
/// [location]과 [notification]은 앱 최초 실행 시 부트 시퀀스에서 요청한다
/// (SPEC-0001 R1·R7). 백그라운드/"항상" 위치, 카메라, 마이크는 여전히 쓰지 않는다.
///
/// [photos]는 **부트 시퀀스에 없다** — SPEC-0030이 사진 동기화를 들이면서 추가했고,
/// 앱 진입 조건이 아니라 전국 지도에서 동기화를 시도할 때 요청한다. 거부해도
/// 앱의 다른 기능은 정상 동작한다(R31).
///
/// 순수 도메인 enum — `permission_handler`의 `Permission` 상수는 service 밖으로
/// 새지 않는다 (CLAUDE.md §3).
enum PermissionKind {
  location,
  notification,

  /// 사진 라이브러리 읽기(SPEC-0030 R31).
  ///
  /// 위치가 담긴 사진에서 좌표를 뽑기 위한 것이다. Android는 `READ_MEDIA_IMAGES`에
  /// 더해 `ACCESS_MEDIA_LOCATION`이 있어야 EXIF의 GPS가 지워지지 않는다.
  photos,
}
