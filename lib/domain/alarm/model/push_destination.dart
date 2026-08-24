/// 푸시 페이로드에서 복원한 이동 목적지(SPEC-0028 R11·R16).
///
/// **순수 함수로 둔 이유.** 딥링크가 틀리면 알림이 통째로 엉뚱한 데로 가는데, 그것을
/// 위젯 테스트로 확인하는 것은 느리고 불안정하다. `route_gate.dart`가 게이트 판정을
/// 순수 함수로 떼어 놓은 것과 같은 판단이다(설계 §4).
///
/// 이 파일은 `lib/router`를 import하지 않는다 — model은 순수해야 한다(CLAUDE.md §3).
/// 경로 문자열을 여기서 직접 조립하므로 라우트 경로가 바뀌면 이 파일도 바뀐다.
/// 그 결합은 테스트가 잡는다.
library;

/// 알림 종류. 서버가 FCM 데이터 페이로드의 `type`에 싣는 값이다.
///
/// GraphQL 계약 표면이 아니라 FCM 데이터 메시지의 형태라, 생성 타입이 아니라
/// 손으로 쓴 enum이다(계약 §FCM 페이로드).
enum PushNotificationType {
  /// DM 새 메시지 → 대화 화면.
  dm('DM'),

  /// 내 질문에 달린 답변 → 질문 상세.
  spotQaAnswer('SPOT_QA_ANSWER'),

  /// 내 답변에 달린 답글 → 같은 질문 상세. 답글 단독 화면이 없다.
  spotQaReply('SPOT_QA_REPLY');

  const PushNotificationType(this.wireName);

  /// 서버가 보내는 문자열. 표시 문구가 아니라 안정 식별자다.
  final String wireName;

  /// 모르는 값이면 null이다. **오류가 아니다** — 서버가 나중에 트리거를 더해도
  /// 구버전 앱이 죽지 않아야 한다(설계 §4).
  static PushNotificationType? fromWire(String? wire) {
    if (wire == null) return null;
    for (final PushNotificationType type in values) {
      if (type.wireName == wire) return type;
    }
    return null;
  }
}

/// 알림 하나가 가리키는 목적지. [location]은 GoRouter가 바로 쓸 수 있는 경로다.
///
/// 복원에 실패하면 이 객체가 만들어지지 않고 null이 된다 — "목적지를 모른다"를
/// 빈 문자열이나 기본 경로로 뭉개면 호출부가 기본 착지점으로 보낼지 판단할 수 없다.
class PushDestination {
  const PushDestination({required this.type, required this.location});

  final PushNotificationType type;

  /// `/conversations/:id` 또는 `/spot/:spotId/qa/:questionId`.
  final String location;

  /// FCM 데이터 페이로드에서 목적지를 복원한다(R11·R16).
  ///
  /// 알 수 없는 `type`이거나 목적지를 만드는 데 필요한 식별자가 빠졌으면 **null**이다.
  /// 호출부는 null을 받으면 기본 착지점으로 보낸다(AC16.4).
  ///
  /// 질문 상세는 `spotId`와 `questionId`가 **둘 다** 경로 파라미터라 하나만 오면
  /// 라우트를 만들 수 없다(AC16.4).
  static PushDestination? tryParse(Map<String, String> payload) {
    final PushNotificationType? type = PushNotificationType.fromWire(
      payload['type'],
    );
    if (type == null) return null;

    return switch (type) {
      PushNotificationType.dm => _dm(type, payload),
      PushNotificationType.spotQaAnswer ||
      PushNotificationType.spotQaReply => _spotQa(type, payload),
    };
  }

  static PushDestination? _dm(
    PushNotificationType type,
    Map<String, String> payload,
  ) {
    final String? conversationId = _value(payload, 'conversationId');
    if (conversationId == null) return null;
    return PushDestination(
      type: type,
      location: '/conversations/${Uri.encodeComponent(conversationId)}',
    );
  }

  static PushDestination? _spotQa(
    PushNotificationType type,
    Map<String, String> payload,
  ) {
    final String? spotId = _value(payload, 'spotId');
    final String? questionId = _value(payload, 'questionId');
    if (spotId == null || questionId == null) return null;
    return PushDestination(
      type: type,
      location:
          '/spot/${Uri.encodeComponent(spotId)}'
          '/qa/${Uri.encodeComponent(questionId)}',
    );
  }

  /// 값이 없거나 공백뿐이면 없는 것으로 본다 — 서버가 빈 문자열을 실어도 라우트를
  /// 만들면 안 된다.
  static String? _value(Map<String, String> payload, String key) {
    final String? raw = payload[key];
    if (raw == null) return null;
    final String trimmed = raw.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushDestination &&
          other.type == type &&
          other.location == location;

  @override
  int get hashCode => Object.hash(type, location);

  @override
  String toString() => 'PushDestination($type, $location)';
}
