/// 다이렉트 메시지 라우트 이름.
///
/// **왜 `common/`에 있는가.** 화면은 `domain/dm`이 소유하지만 진입점이 설정
/// (`domain/settings`)에 있다 — 이름을 쓰겠다고 `dm/view/`를 import하면 기능 간
/// 의존이 생기므로 이름만 공용으로 올린다(CLAUDE.md §3·§4).
///
/// 진실의 출처는 화면의 `routeName`이고 이 상수가 그 값을 준다.
library;

/// 대화 목록. 설정의 "메시지" 항목에서 들어간다.
const String conversationsRouteName = 'conversations';
