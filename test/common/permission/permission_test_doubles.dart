import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/repository/rationale_shown_store.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
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
