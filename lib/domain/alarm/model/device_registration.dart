/// 기기 토큰 등록에 싣는 값(SPEC-0028 R1·R20). 순수 도메인.
library;

/// 토큰이 속한 OS. 발송 페이로드 형식이 갈리므로 서버가 알아야 한다(계약).
enum DevicePlatform {
  ios('IOS'),
  android('ANDROID');

  const DevicePlatform(this.wireName);

  final String wireName;
}

/// `registerDeviceToken` 한 번에 보내는 값 묶음.
///
/// **업서트다** — 같은 [deviceId]로 다시 부르면 서버가 새 레코드를 만들지 않고 토큰과
/// 언어를 덮어쓴다(AC1.2·AC20.2). 등록·토큰 로테이션·언어 변경을 모두 이 한 연산의
/// 재호출로 처리하며 갱신 전용 연산이 없다.
class DeviceRegistration {
  const DeviceRegistration({
    required this.deviceId,
    required this.fcmToken,
    required this.languageCode,
    required this.platform,
  });

  /// 클라이언트가 만들어 보관하는 기기 식별자. 같은 기기의 재등록을 이 값으로 판별한다.
  ///
  /// FCM 토큰 자체는 로테이션되므로 식별자가 될 수 없다 — 토큰을 키로 삼으면
  /// 로테이션마다 새 행이 쌓이고 옛 토큰으로 계속 발송을 시도하게 된다(계약).
  final String deviceId;

  final String fcmToken;

  /// 서버 `Locale` enum 값(EN·KO·JA·ZH). 지원하지 않는 기기 언어는 EN으로 떨어진다
  /// (AC20.3) — 그 폴백은 [languageFromDeviceCode]가 한다.
  final String languageCode;

  final DevicePlatform platform;

  /// 이 등록값을 한 문자열로 접은 지문(R20).
  ///
  /// 포그라운드 복귀마다 무조건 재등록하면 불필요한 왕복이 생기므로, 직전에 보낸
  /// 지문과 다를 때만 보낸다(설계 §8). 토큰이 로테이션되거나 기기 언어가 바뀌면
  /// 값이 달라진다.
  ///
  /// **원문을 되돌릴 수 없어야 한다** — 이 값은 일반 저장소에 남으므로 등록값 자체가
  /// 남아서는 안 된다. 암호학적 강도는 필요하지 않다: 비교 대상이 공격자가 아니라
  /// 같은 기기의 직전 값이고, 충돌해도 재등록을 한 번 건너뛸 뿐이다.
  String get digest => Object.hash(
    deviceId,
    fcmToken,
    languageCode,
    platform,
  ).toRadixString(16);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceRegistration &&
          other.deviceId == deviceId &&
          other.fcmToken == fcmToken &&
          other.languageCode == languageCode &&
          other.platform == platform;

  @override
  int get hashCode => Object.hash(deviceId, fcmToken, languageCode, platform);

  /// 토큰은 원문으로 남기지 않는다(POL-013·POL-047).
  @override
  String toString() =>
      'DeviceRegistration($deviceId, $languageCode, $platform, '
      'token: ${fcmToken.isEmpty ? 'empty' : 'set'})';
}

/// 기기 OS 언어 코드를 서버 `Locale` 값으로 옮긴다.
///
/// **앱 언어 설정이 아니라 기기 OS 언어를 쓴다** — 알림은 앱 밖에서 표시되므로
/// 사용자가 그 순간 읽는 언어는 OS 언어다(설계 §8).
///
/// 지원하지 않는 언어는 `EN`이다(AC20.3 · POL-039의 폴백 규약).
String languageFromDeviceCode(String deviceLanguageCode) =>
    switch (deviceLanguageCode.toLowerCase().split('_').first.split('-').first) {
      'ko' => 'KO',
      'ja' => 'JA',
      'zh' => 'ZH',
      _ => 'EN',
    };
