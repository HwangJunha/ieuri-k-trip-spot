import 'package:shared_preferences/shared_preferences.dart';

/// 직전에 서버로 보낸 기기 등록값의 **지문**을 적어 둔다(SPEC-0028 R20).
///
/// **포그라운드 복귀마다 무조건 재등록하면 불필요한 왕복이 생긴다.** 등록값이 직전에
/// 보낸 것과 다를 때만 보내려고 지문을 들고 있는다(설계 §8).
///
/// **이 저장소는 등록값의 내용을 알지 못한다.** 호출부가 접어 준 지문 문자열 하나만
/// 넣고 빼며, 원본은 들어오지 않는다 — 필요한 것은 "달라졌는가" 하나뿐이라 원본을
/// 보관할 이유가 없다. 지문 계산은 `DeviceRegistration.digest`가 한다.
///
/// 기록이 없거나 비어 있으면 "보낸 적 없음"으로 보고 다시 보낸다 — 등록은 업서트라
/// 중복 호출이 해롭지 않고, 최악은 왕복 한 번이다.
abstract interface class SentRegistrationStore {
  /// [digest]가 직전에 적어 둔 것과 다른지 판정한다. 적은 적이 없으면 참이다.
  bool hasChanged(String digest);

  /// 이 기기가 한 번이라도 등록을 보낸 적이 있는지.
  ///
  /// 보낸 적이 없으면 해제할 것도 없다 — 그때 `deleteDeviceToken`을 부르면 서버에
  /// 없는 것을 지우려는 왕복이 생기고, 세션이 이미 만료된 상황에서는 그것이
  /// `UNAUTHENTICATED`로 실패한다(실기기에서 실제로 관측됐다).
  bool get hasRegistration;

  Future<void> write(String digest);

  /// 로그아웃으로 등록을 해제했을 때 지운다 — 다음 로그인에서 반드시 다시 보내야 한다.
  Future<void> clear();
}

class SharedPreferencesSentRegistrationStore implements SentRegistrationStore {
  SharedPreferencesSentRegistrationStore(this._prefs);

  final SharedPreferences _prefs;

  /// 지문 하나만 둔다 — 어느 필드가 바뀌었는지는 알 필요가 없고, 하나라도 바뀌면
  /// 같은 한 가지 동작(재등록)을 한다.
  static const String _key = 'alarm_sent_registration_digest';

  @override
  bool hasChanged(String digest) {
    final String? saved = _prefs.getString(_key);
    if (saved == null || saved.isEmpty) return true;
    return saved != digest;
  }

  @override
  bool get hasRegistration {
    final String? saved = _prefs.getString(_key);
    return saved != null && saved.isNotEmpty;
  }

  @override
  Future<void> write(String digest) => _prefs.setString(_key, digest);

  @override
  Future<void> clear() => _prefs.remove(_key);
}
