/// 둘러보기 탭의 라우트 이름.
///
/// **왜 `common/`에 있는가.** 온보딩(`domain/onboarding`)이 끝나면 이 탭으로
/// 보내는데, 화면 자체는 SPEC-0017부터 `domain/feed`가 소유한다(추천 + 피드 토글).
/// 이름을 쓰겠다고 온보딩이 `domain/feed/view/`를 import하면 기능 간 의존이
/// 생기므로(CLAUDE.md §3), 둘 이상이 쓰는 이 값만 공용으로 올린다(§4) —
/// `loginRouteName`과 같은 선례다.
///
/// 화면은 여전히 `domain/feed`가 소유하며 `DiscoverTabScreen.routeName`이 이 상수를
/// 돌려주므로 진실의 출처는 하나다.
const String discoverRouteName = 'discover';
