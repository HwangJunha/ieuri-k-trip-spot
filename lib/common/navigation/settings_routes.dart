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

/// 찜한 장소 목록. 하단 탭이자 설정의 진입점이다.
const String likedSpotsRouteName = 'liked';
