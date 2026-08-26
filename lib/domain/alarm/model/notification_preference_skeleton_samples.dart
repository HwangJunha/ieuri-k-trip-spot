/// 로딩 중 뼈대를 그리기 위한 더미 알림 설정. **화면에 값이 보이지는 않는다** —
/// `AppSkeleton`이 제목·설명을 뼈대로 덮으므로 줄 수만 레이아웃에 남는다.
///
/// 실제 목록과 **같은 두 카테고리**를 그대로 둔다. 이 화면의 토글은 서버 응답과
/// 무관하게 항상 둘이므로(설계 §6), 뼈대도 두 줄이어야 데이터가 도착할 때 줄
/// 수가 바뀌지 않는다.
library;

import 'notification_preference.dart';

const List<NotificationPreference>
notificationPreferenceSkeletonSamples = <NotificationPreference>[
  NotificationPreference(category: NotificationCategory.message, enabled: true),
  NotificationPreference(category: NotificationCategory.spotQa, enabled: true),
];
