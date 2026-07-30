import 'package:permission_handler/permission_handler.dart';

import '../model/permission_kind.dart';
import '../model/permission_state.dart';

/// `permission_handler` 위의 얇은 래퍼 (SPEC-0001 §도메인배치): 상태 조회, 요청(OS
/// 다이얼로그 노출), 설정 이동. 위치를 읽거나 푸시 토큰을 획득하는 건 스코프 밖이다
/// (R1, R7).
///
/// 호출자는 [PermissionKind]/[PermissionState]로만 대화하므로 플러그인의
/// `Permission`/`PermissionStatus`가 provider/component/view로 새지 않는다
/// (CLAUDE.md §3). 부트 코디네이터와 그 테스트가 플러그인이 아니라 추상화에 의존하도록
/// 인터페이스 + 플러그인 기반 기본 구현으로 나눴다.
abstract interface class PermissionService {
  /// 실제 앱에서 쓰는 플러그인 기반 구현.
  const factory PermissionService() = PermissionHandlerService;

  /// 프롬프트 없이 현재 상태 조회 — R6(이미 결정된 권한은 재요청 안 함) 준수에 사용.
  Future<PermissionState> status(PermissionKind kind);

  /// OS 권한 다이얼로그를 띄우고 결과를 매핑한다. iOS에선 다이얼로그가 설치당 최대 1회만
  /// 뜨므로, 호출자는 인앱 사전설명 뒤에 이 호출을 두어 단 한 번의 프롬프트를 낭비하지
  /// 않아야 한다 (SPEC-0001).
  Future<PermissionState> request(PermissionKind kind);

  /// 영구거부된 권한을 사용자가 바꿀 수 있도록 OS 설정 앱을 연다 (R5). 설정이 실제로
  /// 열렸는지 여부를 반환한다.
  Future<bool> openSettings();
}

/// 실제 `permission_handler` 플러그인으로 동작하는 [PermissionService].
class PermissionHandlerService implements PermissionService {
  const PermissionHandlerService();

  @override
  Future<PermissionState> status(PermissionKind kind) async =>
      _map(await _permission(kind).status);

  @override
  Future<PermissionState> request(PermissionKind kind) async =>
      _map(await _permission(kind).request());

  @override
  Future<bool> openSettings() => openAppSettings();

  /// 포그라운드 위치만 — 절대 `locationAlways`는 안 씀 (R1, R7).
  Permission _permission(PermissionKind kind) => switch (kind) {
    PermissionKind.location => Permission.locationWhenInUse,
    PermissionKind.notification => Permission.notification,
  };

  PermissionState _map(PermissionStatus status) => switch (status) {
    PermissionStatus.granted ||
    PermissionStatus.limited ||
    PermissionStatus.provisional => PermissionState.granted,
    PermissionStatus.denied => PermissionState.denied,
    PermissionStatus.permanentlyDenied => PermissionState.permanentlyDenied,
    PermissionStatus.restricted => PermissionState.restricted,
  };
}
