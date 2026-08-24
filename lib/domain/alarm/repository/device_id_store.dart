import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// 이 기기의 식별자를 보관한다(SPEC-0028 R20).
///
/// 앱이 만들어 보관하며 최초 1회 생성 후 바뀌지 않는다. 서버는 이 값으로 같은 기기의
/// 재등록을 판별해 레코드를 업서트한다(AC1.2) — FCM 토큰은 로테이션되므로 식별자가
/// 될 수 없다.
///
/// **`flutter_secure_storage`가 아니라 [SharedPreferences]를 쓴다.** 비밀값이 아니라
/// 식별자다(설계 §8). `seen_answer_counts_store.dart`가 같은 판단을 하고 있으며,
/// CLAUDE.md §7이 보안 저장소를 요구하는 대상은 토큰·비밀값이다.
///
/// 앱을 지우면 사라진다. 그래도 문제가 없는 이유는 재설치 시 새 `deviceId`로 등록되고,
/// 옛 토큰은 FCM이 `UNREGISTERED`로 응답할 때 서버가 지우기 때문이다(R4).
abstract interface class DeviceIdStore {
  /// 보관된 식별자를 돌려주고, 없으면 만들어 저장한 뒤 돌려준다.
  Future<String> readOrCreate();
}

class SharedPreferencesDeviceIdStore implements DeviceIdStore {
  SharedPreferencesDeviceIdStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _key = 'alarm_device_id';

  @override
  Future<String> readOrCreate() async {
    final String? saved = _prefs.getString(_key);
    if (saved != null && saved.isNotEmpty) return saved;

    final String created = _generate();
    await _prefs.setString(_key, created);
    return created;
  }

  /// 기기를 가로질러 겹치지 않을 만큼만 무작위면 된다 — 추측 불가성이 필요한 비밀값이
  /// 아니라 서버가 행을 구분하는 키다. 128비트를 16진수로 적는다.
  static String _generate() {
    final Random random = Random.secure();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < 32; i++) {
      buffer.write(random.nextInt(16).toRadixString(16));
    }
    return buffer.toString();
  }
}
