/// 설정에서 드나드는 화면들의 라우트 이름.
///
/// **왜 `common/`에 있는가.** [loginRouteName]과 같은 이유다(`auth_route.dart`).
/// 설정 홈은 차단 목록(`domain/community`)과 찜한 장소(`domain/spot`)로 보내고,
/// 홈(`domain/spot`)은 설정(`domain/settings`)으로 보낸다. 이름을 쓰겠다고 서로의
/// `view/`를 import하면 기능 간 의존이 생기므로(CLAUDE.md §3), 둘 이상이 쓰는 이
/// 값만 공용으로 올린다(§4).
///
/// 화면 자체는 각 기능이 그대로 소유한다. 여기 있는 것은 **이름뿐**이고, 각
/// 화면의 `routeName`이 이 상수를 돌려주므로 진실의 출처는 하나다.
library;

/// 설정 홈. 홈 화면 우상단에서 진입한다(SPEC-0011 R1).
const String settingsRouteName = 'settings';

/// 차단한 사용자 목록. 화면은 `domain/community`가 소유하고 진입점만 설정에 있다
/// (SPEC-0011 R2).
const String blockedUsersRouteName = 'blocked-users';

/// 찜한 장소 목록. **하단 탭에서만 들어간다** — 설정의 활동 항목에서는 뺐다
/// (좋아요를 누른 장소가 곧 이 목록이라 탭과 중복이었다).
const String likedSpotsRouteName = 'liked';

/// 내가 쓴 글(SPEC-0011 R3). 설정 홈 아래에 중첩된다.
const String myPostsRouteName = 'settings-my-posts';

/// 프로필 수정(SPEC-0011 R4~R6). 설정 홈 아래에 중첩된다.
const String profileEditRouteName = 'settings-profile';

/// 이메일 변경(SPEC-0011 R7·R8). 프로필 수정 아래에 중첩된다.
///
/// **두 단계(주소 입력 → 코드 입력)가 라우트 하나를 쓴다.** 단계를 라우트로 나누면
/// `verificationId`를 route extra로 넘겨야 하고, 그러면 뒤로 가기로 돌아온 주소
/// 화면이 이미 죽은 검증 건을 들고 있게 된다. 단계 전이는 controller 상태가 쥔다.
const String emailChangeRouteName = 'settings-email-change';

/// 커뮤니티 글 상세. 화면은 `domain/community`가 소유하고, "내가 쓴 글"(R3)도 여기로
/// 보낸다 — 둘 이상이 쓰게 되어 이름만 공용으로 올렸다.
const String postDetailRouteName = 'post-detail';

/// 글 작성·수정. 위와 같은 이유로 이름만 공용이다 — "내가 쓴 글"의 빈 상태가
/// "첫 글 쓰기"로 보낸다.
const String postComposerRouteName = 'post-composer';
