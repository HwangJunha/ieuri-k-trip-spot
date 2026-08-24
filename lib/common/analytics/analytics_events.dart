/// 집계 이벤트 이름과 파라미터 키.
///
/// **한곳에 모으는 이유는 오타 때문이다.** 이름을 호출부마다 문자열로 적으면
/// `spot_like`와 `spot_liked`가 콘솔에서 서로 다른 이벤트로 잡히고, 몇 주치 데이터를
/// 합칠 수 없게 된다. 그때는 이미 늦다 — 지난 데이터는 고쳐 쓸 수 없다.
///
/// ## 표준 이벤트는 표준 이름을 쓴다
///
/// `login`·`sign_up`·`search`·`share`·`select_content`는 GA4 추천 이벤트라, 이름과
/// 파라미터 키를 맞추면 **콘솔이 별도 설정 없이 리포트를 만든다.** 우리 이름을 새로
/// 지으면 그 자동 리포트를 잃는다.
/// (https://developers.google.com/analytics/devguides/collection/ga4/reference/events)
///
/// ## 개인정보를 싣지 않는다
///
/// 회원 id·이메일·닉네임·좌표는 파라미터에 넣지 않는다. Firebase가 국가·기기·앱
/// 버전을 자동으로 붙이므로 사용자를 특정할 값을 더할 이유가 없다.
///
/// **검색어도 싣지 않는다.** GA4는 `search`에 `search_term`을 요구하지만, 검색어는
/// 사용자가 직접 입력한 문자열이라 개인을 가리킬 수 있다("내 집 앞 카페"). 대신
/// 결과 유무와 검색 종류만 남긴다 — 알고 싶은 것은 "결과가 없는 검색이 얼마나
/// 되는가"이지 무엇을 찾았는지가 아니다.
abstract final class AnalyticsEvents {
  // ── 인증 (GA4 표준) ────────────────────────────────────────────────────
  /// 로그인 완료. 파라미터: [method].
  static const String login = 'login';

  /// 가입 완료. 파라미터: [method].
  static const String signUp = 'sign_up';

  /// 온보딩을 끝까지 마쳤다. 첫 실행 이탈을 보는 값이다 — 여기까지 오지 못한
  /// 사용자는 앱을 다시 열지 않는 경우가 많다.
  static const String onboardingComplete = 'onboarding_complete';

  // ── 권한 ──────────────────────────────────────────────────────────────
  /// 권한 요청 결과. 파라미터: [permission], [granted].
  ///
  /// 거부율이 높으면 사전 설명 문구를 고쳐야 한다 — 숫자가 없으면 고칠 근거가 없다.
  static const String permissionResult = 'permission_result';

  // ── 탐색 ──────────────────────────────────────────────────────────────
  /// 검색 실행. 파라미터: [searchScope], [hasResult].
  ///
  /// **`search_term`을 싣지 않는다**(위 주석).
  static const String search = 'search';

  /// 지도에서 마커를 눌렀다. 파라미터: [markerKind].
  static const String mapSpotTap = 'map_spot_tap';

  /// 스팟 상세 진입. 파라미터: [from].
  ///
  /// **여러 이벤트를 잇는 값이다.** 지도·스와이프·검색·좋아요 목록 중 어느 경로가
  /// 실제로 상세까지 데려가는지는 이 파라미터로만 알 수 있다.
  static const String spotDetailView = 'spot_detail_view';

  // ── 스와이프 추천 ──────────────────────────────────────────────────────
  /// 스와이프로 판정했다. 파라미터: [liked].
  ///
  /// 좋아요와 패스를 한 이벤트로 묶고 파라미터로 가른다 — 나눠 놓으면 "몇 장 중
  /// 몇 장을 좋아했나"를 콘솔에서 다시 합쳐야 한다.
  static const String spotSwipe = 'spot_swipe';

  // ── 좋아요 ────────────────────────────────────────────────────────────
  /// 좋아요를 켜거나 껐다. 파라미터: [target], [liked].
  ///
  /// 스팟·게시글이 같은 이벤트를 쓰고 [target]으로 갈린다.
  static const String likeToggle = 'like_toggle';

  // ── 커뮤니티 ──────────────────────────────────────────────────────────
  /// 게시글을 올렸다. 파라미터: [hasPhoto].
  static const String postCreate = 'post_create';

  /// 공유했다(GA4 표준). 파라미터: [contentType].
  static const String share = 'share';

  // ── 전국 지도 ─────────────────────────────────────────────────────────
  /// 전국 지도 칸에 사진을 채웠다. 파라미터: [photoCount].
  static const String nationalMapPhotoAdd = 'national_map_photo_add';

  /// 전국 지도에 지역을 등록했다. 파라미터: [from] (`photo`·`current_location`).
  ///
  /// **호출부에서 남긴다.** 사진 스캔과 현재 위치 등록이 서버 호출
  /// (`VisitController.record`)에서 합류하므로, 거기 심으면 둘을 구분할 수 없다.
  static const String nationalMapRegionAdd = 'national_map_region_add';

  /// 나와 겹친 여행을 열어 봤다. 파라미터: [overlapCount].
  static const String overlapTripView = 'overlap_trip_view';

  // ── 설정 ──────────────────────────────────────────────────────────────
  /// 표시 언어를 바꿨다. 파라미터: [language].
  ///
  /// **외국인 대상 앱이라 실사용 언어 분포가 중요하다.** 기기 언어와 다를 수 있어
  /// 자동 수집되는 국가·기기 정보로는 알 수 없다.
  static const String languageChange = 'language_change';
}

/// 이벤트 파라미터 키.
///
/// 표준 이벤트의 키는 **GA4가 정한 이름을 그대로 쓴다**(`method`·`content_type`).
/// 우리가 새로 지으면 콘솔의 자동 리포트가 그 값을 읽지 못한다.
abstract final class AnalyticsParams {
  /// 인증 수단(`google`·`apple`·`kakao`·`email`). GA4 표준 키다.
  static const String method = 'method';

  /// 공유한 콘텐츠 종류. GA4 표준 키다.
  static const String contentType = 'content_type';

  /// 어떤 권한인가(`location`·`notification`·`photo`).
  static const String permission = 'permission';

  /// 권한을 허용했는가.
  static const String granted = 'granted';

  /// 검색 범위(`spot`·`region` 등). 검색어 자체가 아니다.
  static const String searchScope = 'search_scope';

  /// 결과가 있었는가. **결과 0건 검색의 비율**이 콘텐츠 보강 근거가 된다.
  static const String hasResult = 'has_result';

  /// 지도 마커 종류(`spot`·`cultural_event`).
  static const String markerKind = 'marker_kind';

  /// 상세로 들어온 경로(`map`·`swipe`·`search`·`liked`·`community`·`deep_link`).
  static const String from = 'from';

  /// 좋아요/패스 판정.
  static const String liked = 'liked';

  /// 좋아요 대상(`spot`·`post`).
  static const String target = 'target';

  /// 게시글에 사진을 붙였는가.
  static const String hasPhoto = 'has_photo';

  /// 한 번에 채운 사진 수.
  static const String photoCount = 'photo_count';

  /// 겹친 여행 수.
  static const String overlapCount = 'overlap_count';

  /// 바꾼 언어 코드(`ko`·`en`·`ja`·`zh`).
  static const String language = 'language';
}
