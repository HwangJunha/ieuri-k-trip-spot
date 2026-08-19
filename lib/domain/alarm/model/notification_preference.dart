/// 카테고리별 푸시 수신 설정(SPEC-0028 R19).
library;

/// 알림 카테고리. 트리거 3종을 두 값으로 묶는다 — 답변과 답글은 사용자에게 같은
/// 성격의 알림이고 목적지도 같은 화면이라 나눌 이유가 없다(계약).
enum NotificationCategory {
  /// DM 새 메시지.
  message('MESSAGE'),

  /// 내 질문에 달린 답변, 내 답변에 달린 답글.
  spotQa('SPOT_QA');

  const NotificationCategory(this.wireName);

  /// 서버 enum 문자열. 표시 문구와 분리된 안정 식별자다(POL-023).
  final String wireName;

  /// 모르는 값이면 null이다. 서버가 카테고리를 더해도 구버전 앱이 죽지 않는다.
  static NotificationCategory? fromWire(String? wire) {
    if (wire == null) return null;
    for (final NotificationCategory category in values) {
      if (category.wireName == wire) return category;
    }
    return null;
  }
}

/// 카테고리 1건의 수신 여부.
///
/// [enabled]가 참이어도 기기의 OS 알림 설정이 꺼져 있으면 알림은 표시되지 않는다 —
/// 둘은 직렬로 걸리며 서버는 OS 쪽 상태를 알지 못한다(설계 §7).
class NotificationPreference {
  const NotificationPreference({
    required this.category,
    required this.enabled,
  });

  final NotificationCategory category;
  final bool enabled;

  NotificationPreference copyWith({bool? enabled}) => NotificationPreference(
    category: category,
    enabled: enabled ?? this.enabled,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreference &&
          other.category == category &&
          other.enabled == enabled;

  @override
  int get hashCode => Object.hash(category, enabled);

  @override
  String toString() => 'NotificationPreference($category, enabled: $enabled)';
}

/// 목록 단위 조회를 한자리에 모은다.
extension NotificationPreferenceList on List<NotificationPreference> {
  /// 해당 카테고리의 수신 여부. 목록에 없으면 **켜짐**으로 본다 — 서버는 두 카테고리를
  /// 항상 돌려주지만(AC19.1), 응답이 비어도 사용자가 "꺼져 있다"고 오해하는 것보다
  /// 기본값 쪽이 낫다(AC10.3).
  bool isEnabled(NotificationCategory category) =>
      where(
        (NotificationPreference p) => p.category == category,
      ).firstOrNull?.enabled ??
      true;
}
