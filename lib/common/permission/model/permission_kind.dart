/// 앱 최초 실행 시 요청하는 런타임 권한 (SPEC-0001).
///
/// 실제로 필요한 두 가지만 둔다: 포그라운드 위치("사용 중에만")와 알림. 백그라운드
/// /"항상" 위치, 카메라, 마이크, 사진은 의도적으로 제외한다 (R1, R7). 순수 도메인
/// enum — `permission_handler`의 `Permission` 상수는 service 밖으로 새지 않는다
/// (CLAUDE.md §3).
enum PermissionKind { location, notification }
