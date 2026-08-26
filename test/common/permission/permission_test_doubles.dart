import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/repository/rationale_shown_store.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/common/permission/service/permission_service.dart';

/// Scripted [PermissionService] for tests — no `permission_handler` plugin.
///
/// [initial] is the state each kind reports from [status]. [requestResult] is
/// what [request] returns *and* what a subsequent [status] then reports (the OS
/// remembers the decision). [requestResults] scripts a *sequence* of outcomes
/// per kind for the mandatory-location loop (deny then grant, etc.); it takes
/// precedence over [requestResult] and the last value repeats once exhausted.
/// Every call is recorded in [calls] so tests can assert the boot coordinator
/// honored R6 (no request on a decided permission) and R2 (sequential order).
class FakePermissionService implements PermissionService {
  FakePermissionService({
    Map<PermissionKind, PermissionState>? initial,
    Map<PermissionKind, PermissionState>? requestResult,
    Map<PermissionKind, List<PermissionState>>? requestResults,
  }) : _state = <PermissionKind, PermissionState>{
         PermissionKind.location: PermissionState.denied,
         PermissionKind.notification: PermissionState.denied,
         ...?initial,
       },
       _requestResult =
           requestResult ?? const <PermissionKind, PermissionState>{},
       _requestResults = <PermissionKind, List<PermissionState>>{
         for (final MapEntry<PermissionKind, List<PermissionState>> e
             in (requestResults ??
                     const <PermissionKind, List<PermissionState>>{})
                 .entries)
           e.key: List<PermissionState>.of(e.value),
       };

  final Map<PermissionKind, PermissionState> _state;
  final Map<PermissionKind, PermissionState> _requestResult;
  final Map<PermissionKind, List<PermissionState>> _requestResults;

  final List<String> calls = <String>[];
  int openSettingsCount = 0;

  /// Lets a test simulate the user flipping a permission in Settings before the
  /// resume re-check re-reads it.
  void setStatus(PermissionKind kind, PermissionState value) =>
      _state[kind] = value;

  @override
  Future<PermissionState> status(PermissionKind kind) async {
    calls.add('status:${kind.name}');
    return _state[kind]!;
  }

  @override
  Future<PermissionState> request(PermissionKind kind) async {
    calls.add('request:${kind.name}');
    final PermissionState result = _nextRequestResult(kind);
    _state[kind] = result; // the OS now reports the decided state
    return result;
  }

  /// Pops the next scripted outcome for [kind] (keeping the last one when the
  /// queue runs dry), falling back to [requestResult] then a granted default.
  PermissionState _nextRequestResult(PermissionKind kind) {
    final List<PermissionState>? queue = _requestResults[kind];
    if (queue != null && queue.isNotEmpty) {
      return queue.length == 1 ? queue.first : queue.removeAt(0);
    }
    return _requestResult[kind] ?? PermissionState.granted;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCount++;
    return true;
  }
}

/// 메모리에만 담는 [RationaleShownStore].
///
/// 각 테스트는 "아직 아무것도 물어보지 않은" 상태에서 시작한다 — 디스크를 쓰면
/// 테스트끼리 기록이 새어 순서에 따라 결과가 달라진다.
class FakeRationaleShownStore implements RationaleShownStore {
  final Set<PermissionKind> shown = <PermissionKind>{};

  @override
  bool wasShown(PermissionKind kind) => shown.contains(kind);

  @override
  Future<void> markShown(PermissionKind kind) async => shown.add(kind);
}

/// 라우터를 세우는 위젯 테스트가 위치 게이트를 통과하도록 권한을 허용으로
/// 심어 준다(2026-08-26).
///
/// **왜 필요한가.** 위치 게이트(`route_gate.dart` 2번)는 권한 상태가 아직 조회되지
/// 않았으면(`null`) 스플래시에 세운다 — 앱을 켠 직후 허용해 둔 사용자에게까지
/// 안내 화면이 번쩍이지 않게 하려는 것이다. 그런데 `PermissionBootGate`를 띄우지
/// 않는 테스트에서는 그 상태를 채워 줄 주체가 없어 영영 `null`이고, 그러면
/// 게이트가 모든 경로를 스플래시로 되돌려 `pumpAndSettle`이 타임아웃한다.
///
/// 위치 자체를 시험하는 테스트는 이것을 쓰지 말고 직접 상태를 만들어야 한다.
FakePermissionService grantedPermissionService() => FakePermissionService(
  initial: <PermissionKind, PermissionState>{
    PermissionKind.location: PermissionState.granted,
    PermissionKind.notification: PermissionState.granted,
  },
);

Future<void> seedGrantedPermissions(ProviderContainer container) async {
  // `refreshAll()`이 아니라 `check()`다 — 전자는 **이미 조회된 종류만** 다시 읽어
  // 상태가 비어 있으면 곧바로 돌아온다(`if (state.isEmpty) return`). 부트 게이트를
  // 띄우지 않는 테스트에서는 그 상태가 언제나 비어 있다.
  await container
      .read(permissionControllerProvider.notifier)
      .check(PermissionKind.location);
}
