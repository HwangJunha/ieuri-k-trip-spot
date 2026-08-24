import '../model/device_registration.dart';
import '../model/notification_preference.dart';

/// 알림 도메인의 데이터 접근 경계(SPEC-0028). 구현은 GraphQL이고 생성 타입은 이
/// 인터페이스를 넘지 않는다(CLAUDE.md §3 · POL-020).
///
/// 실패는 전부 `AlarmFailure`를 던진다 — null로 뭉개면 호출부가 "없음"과 "실패"를
/// 구분하지 못한다. 등록·해제 경로는 그 실패를 잡아 로그만 남기고(R12·AC12.3),
/// 설정 토글은 사용자에게 알린다.
abstract interface class AlarmRepository {
  /// 이 기기의 푸시 토큰을 등록한다(R1). **업서트다** — 같은 `deviceId`로 다시 부르면
  /// 서버가 레코드를 새로 만들지 않고 덮어쓴다(AC1.2). 등록·토큰 로테이션·언어 변경이
  /// 전부 이 호출이다.
  Future<void> registerDeviceToken(DeviceRegistration registration);

  /// 이 기기의 토큰을 해제한다(R2). 멱등이라 이미 없는 토큰을 지워도 성공이다(AC2.2).
  ///
  /// **세션이 사라지기 전에 불러야 한다** — 인증을 요구하므로 순서가 뒤집히면
  /// 실패한다(설계 §3.2).
  Future<void> deleteDeviceToken(String deviceId);

  /// 카테고리별 수신 설정(R19). 서버가 두 카테고리를 항상 돌려준다(AC19.1).
  Future<List<NotificationPreference>> fetchPreferences();

  /// 카테고리 하나를 토글한다(R19). **반영 후 전체 설정을 돌려준다** — 이 값으로
  /// 캐시를 갈아 끼우면 재조회가 필요 없다(AC19.3).
  Future<List<NotificationPreference>> updatePreference({
    required NotificationCategory category,
    required bool enabled,
  });
}
