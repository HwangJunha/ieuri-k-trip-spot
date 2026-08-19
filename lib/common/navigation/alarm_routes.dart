/// 알림 화면의 라우트 이름(SPEC-0028 §2).
///
/// **진입점과 화면의 주인이 다르다.** 설정 화면(`domain/settings`)이 알림 설정 화면
/// (`domain/alarm`)을 여는데, 설정이 alarm의 view를 import하면 기능 간 의존이 된다
/// (CLAUDE.md §3). `dm_routes.dart`·`spot_qa_routes.dart`와 같은 이유로 이름만
/// 공용으로 둔다.
library;

const String notificationSettingsRouteName = 'notificationSettings';
