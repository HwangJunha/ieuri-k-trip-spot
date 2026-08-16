/// 둘러보기 탭의 라우트 이름.
///
/// **왜 `common/`에 있는가.** 온보딩(`domain/onboarding`)이 끝나면 이 탭으로
/// 보내는데, 화면 자체는 `domain/spot`이 소유한다. 이름을 쓰겠다고 온보딩이
/// `domain/spot/view/`를 import하면 기능 간 의존이 생기므로(CLAUDE.md §3), 둘 이상이
/// 쓰는 이 값만 공용으로 올린다(§4) — `loginRouteName`과 같은 선례다.
///
/// **이름은 SPEC-0021에서도 그대로다**(AC9.4). 화면 소유권이 `domain/feed`에서
/// `domain/spot`으로 돌아왔지만, 온보딩·로그인 후 착지가 이 이름에 걸려 있어 바꾸면
/// 그 경로가 끊긴다. `DiscoverScreen.routeName`이 이 상수를 돌려주므로 진실의
/// 출처는 하나다.
const String discoverRouteName = 'discover';
