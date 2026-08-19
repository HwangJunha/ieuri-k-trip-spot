import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/storage/app_preferences.dart';
import '../repository/alarm_store_factory.dart';
import '../repository/device_id_store.dart';
import '../repository/sent_registration_store.dart';

part 'alarm_store_providers.g.dart';

/// 알림 도메인의 로컬 저장소 provider(SPEC-0028 R20).
///
/// 저장소 배선만 이 파일에 모은다 — 등록 판단은 `push_registration_controller.dart`가
/// 하고, 그쪽은 인터페이스만 안다(CLAUDE.md §3).
///
/// 두 저장소 모두 비밀값을 담지 않는다: 하나는 기기 식별자, 하나는 되돌릴 수 없는
/// 지문이다. 비밀값은 `common/storage/SecureStorage`가 담당한다(CLAUDE.md §7).
@Riverpod(keepAlive: true)
DeviceIdStore deviceIdStore(Ref ref) =>
    AlarmStores.deviceId(ref.watch(sharedPreferencesProvider));

@Riverpod(keepAlive: true)
SentRegistrationStore sentRegistrationStore(Ref ref) =>
    AlarmStores.sentRegistration(ref.watch(sharedPreferencesProvider));
