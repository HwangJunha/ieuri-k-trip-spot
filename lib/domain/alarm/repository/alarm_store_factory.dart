import 'package:shared_preferences/shared_preferences.dart';

import 'device_id_store.dart';
import 'sent_registration_store.dart';

/// 알림 도메인의 로컬 저장소 두 개를 만든다(SPEC-0028 R20).
///
/// **왜 이 파일이 따로 있는가.** provider 파일이 [SharedPreferences] 구현체를 직접
/// 짓지 않게 하려는 것이다. 어느 저장소가 어떤 백엔드를 쓰는지는 repository 계층의
/// 사정이고, provider는 인터페이스만 알면 된다(CLAUDE.md §3).
///
/// 두 저장소 모두 비밀값을 담지 않는다 — 하나는 기기 식별자, 하나는 되돌릴 수 없는
/// 지문이다. 토큰·비밀값은 `common/storage/SecureStorage`가 담당한다(CLAUDE.md §7).
abstract final class AlarmStores {
  static DeviceIdStore deviceId(SharedPreferences prefs) =>
      SharedPreferencesDeviceIdStore(prefs);

  static SentRegistrationStore sentRegistration(SharedPreferences prefs) =>
      SharedPreferencesSentRegistrationStore(prefs);
}
