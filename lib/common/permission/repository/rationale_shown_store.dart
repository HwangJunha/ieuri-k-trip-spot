import 'package:shared_preferences/shared_preferences.dart';

import '../model/permission_kind.dart';

/// 선택 권한의 사전설명을 한 번이라도 보여 줬는지 적어 둔다(2026-08-26).
///
/// **권한 상태와는 다른 것을 기록한다.** `PermissionController`는 OS를 진실의
/// 원천으로 삼아 아무것도 저장하지 않는데(그게 맞다), 그 결과 "나중에"를 누르면
/// 어디에도 흔적이 남지 않는다. OS 입장에서는 여전히 미결정이라 다음 부팅에서
/// 또 물어보게 된다 — 사용자가 앱을 켤 때마다 같은 시트를 봤다(실기기 확인).
///
/// 선택 권한은 **선택**이다. 한 번 물어봤으면 그것으로 끝이고, 마음이 바뀐
/// 사용자는 설정에서 켠다. 그래서 "물어본 적이 있는가"를 여기에 남긴다.
///
/// 앱을 지웠다 다시 깔면 `SharedPreferences`도 함께 사라지므로 새 사용자처럼
/// 다시 한 번 물어본다 — 사용자가 기대하는 동작이다.
abstract interface class RationaleShownStore {
  /// [kind]의 사전설명을 보여 준 적이 있는지.
  bool wasShown(PermissionKind kind);

  /// 보여 줬다고 적는다. **누르기 전에** 적어야 한다 — 시트를 배리어 탭으로
  /// 닫아도 "물어본" 것이므로 다시 띄우지 않는다.
  Future<void> markShown(PermissionKind kind);
}

class SharedPreferencesRationaleShownStore implements RationaleShownStore {
  SharedPreferencesRationaleShownStore(this._prefs);

  final SharedPreferences _prefs;

  /// 권한 종류마다 따로 둔다 — 위치를 물어본 것이 알림을 물어본 것이 되면 안 된다.
  static String _keyOf(PermissionKind kind) =>
      'permission_rationale_shown_${kind.name}';

  @override
  bool wasShown(PermissionKind kind) => _prefs.getBool(_keyOf(kind)) ?? false;

  @override
  Future<void> markShown(PermissionKind kind) =>
      _prefs.setBool(_keyOf(kind), true);
}
