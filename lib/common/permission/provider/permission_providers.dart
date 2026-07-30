import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/permission_kind.dart';
import '../model/permission_state.dart';
import '../service/permission_service.dart';

part 'permission_providers.g.dart';

/// [PermissionService]를 노출한다. provider 뒤에 두어 부트 코디네이터가 직접
/// 생성하지 않고 읽으며(never construct), 테스트는 실제 `permission_handler`
/// 플러그인 대신 fake로 override 한다 (CLAUDE.md §5). autoDispose(기본값): const
/// 무상태 래퍼라 살아남을 게 없다.
@riverpod
PermissionService permissionService(Ref ref) => const PermissionService();

/// 최초 실행 권한 시퀀스(위치 → 알림)가 끝까지 실행됐는지 여부. 스플래시는 라우팅 전에
/// 이 값을 기다린다 — 그래야 위치가 허용되는 순간(시퀀스 중간, 선택 권한인 알림 프롬프트가
/// 아직 남은 시점)에 곧바로 떠나버리지 않는다 (SPEC-0001 §최초실행, R2 순차).
///
/// keepAlive: 스플래시보다 오래 살아야 하는 부트 시퀀스 래치. 한 번 켜지면 세션 동안
/// 다시 꺼지지 않는다.
@Riverpod(keepAlive: true)
class PermissionBootComplete extends _$PermissionBootComplete {
  @override
  bool build() => false;

  /// 부트 권한 시퀀스가 끝났음을 표시한다. 멱등(idempotent).
  void complete() => state = true;
}

/// 앱 전역 런타임 권한 상태 (SPEC-0001 §영구거부처리): [PermissionKind]별 마지막으로
/// 알려진 [PermissionState]. 빈 상태(아직 아무것도 조회 안 함)로 시작한다.
///
/// keepAlive: 권한 상태는 한 화면보다 오래 사는 부트 시퀀스 관심사다 — 이후 기능들이
/// "설정 열기" 경로 노출 여부를 판단하려고 읽고(R5), 앱 resume 훅이 이를 갱신한다
/// (CLAUDE.md §5 근거). 메모리에만 둔다: OS가 진실의 원천이므로 저장하지 않고 다시
/// 조회한다 (스펙 — "상태만 보관").
@Riverpod(keepAlive: true)
class PermissionController extends _$PermissionController {
  @override
  Map<PermissionKind, PermissionState> build() =>
      const <PermissionKind, PermissionState>{};

  PermissionService get _service => ref.read(permissionServiceProvider);

  /// [kind]의 마지막으로 알려진 상태, 조회한 적 없으면 `null`.
  PermissionState? stateOf(PermissionKind kind) => state[kind];

  /// 위치가 허용됐는지 여부. 스플래시 게이트가 이 값에 막힌다 — 위치는 필수라, 허용되기
  /// 전까지 앱은 스플래시를 떠나지 않는다 ([AMEND] SPEC-0001: R4의 "거부해도 블로킹
  /// 없음"을 위치에 한해 오버라이드. 알림은 선택 유지).
  bool get isLocationGranted =>
      state[PermissionKind.location] == PermissionState.granted;

  /// 스플래시가 부트 다이얼로그를 기다리는 대신 위치용 "설정 열기" 경로를 노출해야 하는지
  /// 여부 (R5): 위치를 이제 설정에서만 다시 켤 수 있는 상태
  /// (`permanentlyDenied`/`restricted`). 아직 단순 `denied`인 동안에는 부트 게이트가
  /// 계속 프롬프트를 띄우므로, 스플래시는 설정 노출 대신 대기 상태로 남는다.
  bool get isLocationBlocked =>
      (state[PermissionKind.location] ?? PermissionState.denied).needsSettings;

  /// 프롬프트 없이 OS 상태를 조회해 기록한다 (R6 게이트: 부트 코디네이터가 먼저 이걸
  /// 호출하고 [isDecided]면 요청을 건너뛴다).
  Future<PermissionState> check(PermissionKind kind) async {
    final PermissionState result = await _service.status(kind);
    _record(kind, result);
    return result;
  }

  /// [kind]에 대해 OS 다이얼로그를 띄우고 결과를 기록한다. 인앱 사전설명을 수락한 뒤에만
  /// 호출한다 (SPEC-0001).
  Future<PermissionState> request(PermissionKind kind) async {
    final PermissionState result = await _service.request(kind);
    _record(kind, result);
    return result;
  }

  /// 이미 조회했던 모든 권한을 OS에서 다시 읽는다. 앱 `resumed` 라이프사이클에 연결되어,
  /// 설정에서 돌아왔을 때 바뀐 권한을 재시작 없이 반영한다 (R5 두 번째 criterion).
  Future<void> refreshAll() async {
    if (state.isEmpty) return;
    final Map<PermissionKind, PermissionState> next =
        <PermissionKind, PermissionState>{};
    for (final PermissionKind kind in state.keys) {
      next[kind] = await _service.status(kind);
    }
    state = Map<PermissionKind, PermissionState>.unmodifiable(next);
  }

  /// OS 설정 앱을 연다 (R5). 설정이 열렸는지 여부를 반환한다.
  Future<bool> openSettings() => _service.openSettings();

  /// OS가 [kind]에 대해 조용히 프롬프트를 멈춘 경우(재요청해도 더는 안 뜨는 단순
  /// `denied`) 설정 필요 상태로 승격시킨다. 필수 위치 흐름이 무한 반복 대신 설정 경로로
  /// 넘어가게 한다. 이미 종단 상태면 아무 것도 하지 않는다.
  void markNeedsSettings(PermissionKind kind) {
    if ((state[kind] ?? PermissionState.denied).needsSettings) return;
    _record(kind, PermissionState.permanentlyDenied);
  }

  void _record(PermissionKind kind, PermissionState result) {
    state = Map<PermissionKind, PermissionState>.unmodifiable(
      <PermissionKind, PermissionState>{...state, kind: result},
    );
  }
}
