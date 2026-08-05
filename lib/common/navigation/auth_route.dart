/// 로그인 화면의 라우트 이름.
///
/// **왜 `common/`에 있는가.** 로그인으로 보내는 것은 auth만의 일이 아니다 — 언어
/// 선택(`common/onboarding`)이 끝난 뒤에도, 커뮤니티에서 미인증 사용자가 쓰기를
/// 시도했을 때도 같은 곳으로 간다. 이름을 쓰겠다고 `domain/auth/view/`를 import하면
/// 기능 간 의존이 생기므로(CLAUDE.md §3), 둘 이상이 쓰는 이 값만 공용으로 올린다
/// (§4).
///
/// 화면 자체는 여전히 `domain/auth`가 소유한다. 여기 있는 것은 **이름 하나**이고,
/// `LoginScreen.routeName`이 이 상수를 돌려주므로 진실의 출처는 하나다.
const String loginRouteName = 'login';
