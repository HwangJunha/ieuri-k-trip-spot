import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/location/coordinates.dart';
import '../common/onboarding/view/language_selection_screen.dart';
import '../common/onboarding/view/splash_screen.dart';
import '../common/widget/floating_bottom_nav_scaffold.dart';
import '../domain/auth/view/email_verification_screen.dart';
import '../domain/auth/view/login_screen.dart';
import '../domain/auth/model/sns_credential.dart';
import '../domain/auth/view/password_reset_screen.dart';
import '../domain/auth/view/sign_up_screen.dart';
import '../domain/auth/view/sns_sign_up_screen.dart';
import '../common/model/target_category.dart';
import '../domain/community/view/blocked_users_screen.dart';
import '../domain/community/view/community_screen.dart';
import '../domain/community/view/hidden_posts_screen.dart';
import '../domain/community/view/post_composer_screen.dart';
import '../domain/community/view/post_detail_screen.dart';
import '../domain/dm/view/conversation_list_screen.dart';
import '../domain/dm/view/conversation_screen.dart';
import '../domain/onboarding/view/onboarding_screen.dart';
import '../domain/settings/view/account_deletion_screen.dart';
import '../domain/settings/view/email_change_screen.dart';
import '../domain/settings/view/my_posts_screen.dart';
import '../domain/settings/view/preferences_screen.dart';
import '../domain/settings/view/profile_edit_screen.dart';
import '../domain/settings/view/required_terms_screen.dart';
import '../domain/settings/view/settings_screen.dart';
import '../domain/settings/view/terms_screen.dart';
import '../domain/map/view/map_screen.dart';
import '../domain/map/view/region_recommendation_screen.dart';
import '../common/category/spot_category.dart';
import '../common/category/spot_category_selection.dart';
import '../domain/spot/view/discover_screen.dart';
import '../domain/spot/view/home_screen.dart';
import '../domain/spot/view/liked_spots_screen.dart';
import '../domain/spot/view/search_screen.dart';
import '../domain/spot/view/spot_detail_view.dart';
import '../domain/spot_qa/view/my_questions_screen.dart';
import '../domain/spot_qa/view/spot_qa_composer_screen.dart';
import '../domain/spot_qa/view/spot_question_detail_screen.dart';
import '../domain/spot_qa/view/spot_questions_screen.dart';

/// The app's flat route table. Each screen owns its `routeName`; navigation is
/// by name (`context.goNamed(Screen.routeName)`), so no path strings leak into
/// widgets. The auth gate lives in the router's `redirect` (see app_router.dart).
List<RouteBase> buildRoutes() => <RouteBase>[
  GoRoute(
    path: '/',
    name: SplashScreen.routeName,
    builder: (_, _) => const SplashScreen(),
  ),
  GoRoute(
    path: '/language',
    name: LanguageSelectionScreen.routeName,
    builder: (_, _) => const LanguageSelectionScreen(),
  ),
  GoRoute(
    path: '/login',
    name: LoginScreen.routeName,
    // The sign-up / reset flows pass the email to prefill via `extra`.
    builder: (_, GoRouterState state) => LoginScreen(
      prefilledEmail: state.extra is String ? state.extra as String : null,
    ),
  ),
  GoRoute(
    path: '/sign-up',
    name: SignUpScreen.routeName,
    builder: (_, _) => const SignUpScreen(),
  ),
  GoRoute(
    path: '/email-verification',
    name: EmailVerificationScreen.routeName,
    builder: (_, GoRouterState state) {
      final args = state.extra is EmailVerificationArgs
          ? state.extra as EmailVerificationArgs
          : const EmailVerificationArgs(verificationId: '', email: '');
      return EmailVerificationScreen(
        verificationId: args.verificationId,
        email: args.email,
        password: args.password,
      );
    },
  ),
  GoRoute(
    path: '/password-reset',
    name: PasswordResetScreen.routeName,
    builder: (_, _) => const PasswordResetScreen(),
  ),
  GoRoute(
    path: '/sns-sign-up',
    name: SnsSignUpScreen.routeName,
    // Entered after SNS auth with the verified credential passed via `extra`.
    builder: (_, GoRouterState state) =>
        SnsSignUpScreen(credential: state.extra! as SnsCredential),
  ),
  GoRoute(
    path: '/onboarding',
    name: OnboardingScreen.routeName,
    builder: (_, _) => const OnboardingScreen(),
  ),
  // 관광지 상세(SPEC-0003). 셸 밖의 최상위 라우트라 루트 내비게이터에 push되어 하단
  // 탭을 덮고, Discover 스와이프 스택은 셸 브랜치에 그대로 보존된다(R9). id는 경로
  // 파라미터로 받는다(모델 객체가 아니라 식별자만 넘긴다, §6).
  //
  // **category 쿼리 파라미터는 사라졌다**(SPEC-0020). 서버의 `intro`/`infoItems`가
  // 카테고리를 요구해 스와이프 피드가 가진 값을 실어 보냈으나, 이제 서버가 spot
  // 자신의 카테고리로 해석하므로 상세를 여는 데 필요 없다 — 인자가 줄어 폴백으로
  // 잘못된 카테고리가 실릴 여지도 함께 사라졌다.
  //
  // 전환은 아래→위 진입, 위→아래 종료다(SPEC-0006 R6·R7, AC-17·AC-20). 기본
  // 좌우 슬라이드는 "옆으로 넘어간다"를 뜻해 스와이프 스택 위로 덮이는 이 화면의
  // 성격과 어긋난다. 시스템 뒤로가기와 명시적 닫기가 같은 `CustomTransitionPage`를
  // 지나므로 종료 전환도 자동으로 같아진다(AC-22).
  //
  // thumb는 스와이프 카드가 이미 가진 썸네일 URL이다. 본문 조회가 끝나기 전에도
  // 같은 이미지를 그려 깜빡임을 없앤다(R8, AC-24). 없으면(직접 진입) 조회 결과로
  // 대체되며 오류가 아니다(AC-25).
  GoRoute(
    path: '/spot/:id',
    name: SpotDetailView.routeName,
    pageBuilder: (_, GoRouterState state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: SpotDetailView(
        contentId: state.pathParameters['id']!,
        initialThumbnailUrl: state.uri.queryParameters['thumb'],
        // 어느 스와이프 세션에서 열렸는지(R11) — 그 세션의 **카테고리 선택**이다.
        // 파라미터가 아예 없으면 스와이프 밖에서 들어온 것이라 null이며, 그때는
        // 소비할 카드 스택이 없다(직접 진입·검색·좋아요·지도).
        swipeCategory: _swipeCategoryFrom(
          state.uri.queryParameters['category'],
        ),
      ),
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: _slideUpFromBottom,
    ),
  ),
  // 장소 질문/답변(SPEC-0026). 셸 밖의 최상위 라우트라 하단 탭을 덮는다 — 관광지
  // 상세·글 상세와 같은 성격이다.
  //
  // **경로 파라미터는 id뿐이다**(CLAUDE.md §6). 질문 상세는 `spotId`로 목록
  // provider를 찾아 그 안에서 `questionId`를 집는다 — 서버에 질문 단건 조회가 없어
  // 목록이 유일한 출처이기 때문이다(스키마 §Query).
  //
  // **작성은 목록의 자식이 아니라 최상위다.** 자식으로 두면 GoRouter가 부모까지
  // 함께 쌓아, 장소 상세에서 곧장 작성으로 보냈을 때 뒤에 빈 목록이 깔린다 —
  // "빈 목록을 거치지 않고 바로 작성으로"(설계 §진입점)가 깨진다. 질문 상세는
  // 반대로 자식이 맞다: 목록에서만 들어오고 뒤로 가기가 목록이어야 한다.
  //
  // 최상위 두 경로의 선언 순서상 `/spot/:spotId/qa/compose`가 `:questionId`보다
  // 먼저 와야 한다 — 뒤에 두면 `compose`가 questionId로 먹힌다.
  GoRoute(
    path: '/spot/:spotId/qa/compose',
    name: SpotQaComposerScreen.routeName,
    // `spot`은 **표시용 힌트**다(장소 상세의 `thumb`와 같은 성격) — 질문을 올린 뒤
    // 「내 질문」 목록에 장소명을 적어 두는 데만 쓴다. 없으면(딥링크) 빈 문자열이며,
    // 그때는 서버 조회가 장소명을 채운다. 작성 자체는 이 값에 의존하지 않는다.
    builder: (_, GoRouterState state) => SpotQaComposerScreen(
      catalogId: state.pathParameters['spotId']!,
      spotTitle: state.uri.queryParameters['spot'] ?? '',
    ),
  ),
  GoRoute(
    path: '/spot/:spotId/qa',
    name: SpotQuestionsScreen.routeName,
    builder: (_, GoRouterState state) =>
        SpotQuestionsScreen(catalogId: state.pathParameters['spotId']!),
    routes: <RouteBase>[
      GoRoute(
        path: ':questionId',
        name: SpotQuestionDetailScreen.routeName,
        builder: (_, GoRouterState state) => SpotQuestionDetailScreen(
          catalogId: state.pathParameters['spotId']!,
          questionId: state.pathParameters['questionId']!,
        ),
      ),
    ],
  ),
  // 검색 페이지(SPEC-0013 R10). **셸 밖의 최상위 라우트**라 루트 내비게이터에
  // push되어 하단 탭을 덮는다 — 검색은 탭 전환이 아니라 홈에서 밀고 올라오는
  // 전체 화면 흐름이다(설계 §1).
  //
  // 전환도 그 성격을 따라 아래→위다. 관광지 상세와 같은 `_slideUpFromBottom`을
  // 쓰므로 두 화면이 같은 방식으로 열리고 닫힌다.
  //
  // 인자를 받지 않는다 — 질의는 라우트가 아니라 검색 상태(keepAlive)가 쥔다.
  // 질의를 URL에 실으면 상세를 다녀올 때마다 라우트를 갈아 끼워야 하고, 그러면
  // 결과 목록이 다시 조회된다(AC-13.2가 유지를 요구한다).
  // `pick=1`이면 결과를 골랐을 때 상세로 가는 대신 그 spot을 돌려주고 닫는다 —
  // 지도(SPEC-0014)가 검색으로 위치를 찾을 때 쓴다. 홈에서 열면 없으므로 기존
  // 동작 그대로다.
  GoRoute(
    path: '/search',
    name: SearchScreen.routeName,
    pageBuilder: (_, GoRouterState state) => CustomTransitionPage<Object?>(
      key: state.pageKey,
      child: SearchScreen(
        returnsPickedSpot: state.uri.queryParameters['pick'] == '1',
      ),
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: _slideUpFromBottom,
    ),
  ),
  // 지역 추천 목록(SPEC-0015). **셸 밖의 최상위 라우트**라 루트 내비게이터에 push되어
  // 하단 탭을 덮는다 — 검색 화면과 같은 성격이다.
  //
  // 인자를 받지 않고 **고른 지역의 좌표를 돌려주고 닫힌다**(`Coordinates`). 지도
  // 컨트롤러는 지도 화면이 소유하므로 카메라 이동은 그쪽에서 한다 — 검색이 고른
  // 장소를 돌려주는 규약(`pick=1`)과 같다.
  // 지역 추천(SPEC-0015). `extra`로 **지도가 보고 있던 중심 좌표**를 받는다 —
  // 화면이 "내 위치 / 지도 중심"을 토글하는데, 지도를 떠난 뒤에는 그 값을 물어볼
  // 곳이 없어서다. 딥링크처럼 지도를 거치지 않고 들어오면 null이고, 그때는 내
  // 위치만 쓸 수 있다.
  GoRoute(
    path: '/region-recommendations',
    name: RegionRecommendationScreen.routeName,
    builder: (_, GoRouterState state) =>
        RegionRecommendationScreen(mapCenter: state.extra as Coordinates?),
  ),
  // 커뮤니티 글 상세(SPEC-0010 R13). 셸 밖의 최상위 라우트라 루트 내비게이터에
  // push되어 하단 탭을 덮는다 — 관광지 상세와 같은 성격이다.
  //
  // 라우트 파라미터는 **id뿐이다**(CLAUDE.md §6 — 모델 객체가 아니라 식별자만
  // 넘긴다). 상세는 그 id로 `post(id:)`를 다시 조회하며, 차단·숨김이면 오류가 아니라
  // null이 와서 "볼 수 없는 글" 안내가 뜬다(가이드 §6). 딥링크로 바로 들어와도
  // 같은 경로다.
  GoRoute(
    path: '/post/:id',
    name: PostDetailScreen.routeName,
    builder: (_, GoRouterState state) =>
        PostDetailScreen(postId: state.pathParameters['id']!),
  ),
  // 글 작성·수정(SPEC-0010). 셸 밖의 최상위 라우트라 하단 탭을 덮는다.
  //
  // 장소는 **쿼리 파라미터**이며 선택 항목이다. 커뮤니티 탭에서 열면 없고, 관광지
  // 상세에서 열면 그 spot의 id·이름·카테고리가 실려 이미 정해진 채로 열린다 —
  // 장소가 없어도 등록된다(가이드 §5).
  //
  // `editPostId`가 있으면 수정 모드다. **id만 실린다** — 제목·본문·사진은 화면이
  // 그 id로 `post(id:)`를 다시 조회해서 채운다. 예전에는 제목·본문을 쿼리 파라미터로
  // 실어 보냈는데, 사진 키 목록은 URL에 담기 어려워(길이·이스케이프) 결국 수정
  // 화면이 사진 없는 새 글처럼 열렸다. 셋을 한 조회에서 함께 받는 편이 맞다.
  //
  // 장소 이름만 표시 전용 값으로 남는다. 모델 객체가 아니라 값만 넘기는 것이라
  // §6과 어긋나지 않는다.
  GoRoute(
    path: '/post-composer',
    name: PostComposerScreen.routeName,
    builder: (_, GoRouterState state) => PostComposerScreen(
      initialSpotId: state.uri.queryParameters['spotId'],
      initialSpotTitle: state.uri.queryParameters['spotTitle'],
      initialCategory: _targetCategoryFrom(
        state.uri.queryParameters['category'],
      ),
      editPostId: state.uri.queryParameters['editPostId'],
    ),
  ),
  // 대화 목록·대화(SPEC-0017 R8). 셸 밖의 최상위 라우트라 하단 탭을 덮는다 —
  // 대화는 탭 전환이 아니라 둘러보기 앱바에서 밀고 올라오는 전체 화면 흐름이다.
  //
  // **진입 경로가 하나로 줄었다**(SPEC-0021) — 피드 항목의 DM 아이콘이 사라져
  // 목록에서 재진입하는 길만 남았다. 새 대화를 시작하는 화면은 후속 채팅 스펙이
  // 만든다.
  //
  // 대화 라우트는 **conversationId만 받는다**(CLAUDE.md §6). 상대 정보는 화면이
  // 메시지에서 되짚는다 — 모델 객체를 라우트로 넘기지 않는다.
  GoRoute(
    path: '/conversations',
    name: ConversationListScreen.routeName,
    builder: (_, _) => const ConversationListScreen(),
    routes: <RouteBase>[
      GoRoute(
        path: ':id',
        name: ConversationScreen.routeName,
        builder: (_, GoRouterState state) =>
            ConversationScreen(conversationId: state.pathParameters['id']!),
      ),
    ],
  ),
  // 「내 질문」(SPEC-0026 후속). **설정의 자식이 아니라 최상위다** — 설정과 장소 상세
  // 양쪽에서 진입하는데 설정 아래에 두면 장소 상세에서 열었을 때 뒤로 가기가 설정
  // 홈으로 빠진다(내가 쓴 글과 다른 점이다).
  //
  // 인자가 없다 — 목록의 출처가 로컬 기록이라 장소에 종속되지 않는다.
  GoRoute(
    path: '/my/questions',
    name: MyQuestionsScreen.routeName,
    builder: (_, _) => const MyQuestionsScreen(),
  ),
  // 차단한 사용자 목록(가이드 §6). 커뮤니티 앱바에서 진입하며 셸 밖이라 탭을 덮는다.
  GoRoute(
    path: '/blocked-users',
    name: BlockedUsersScreen.routeName,
    builder: (_, _) => const BlockedUsersScreen(),
  ),
  // 내가 숨긴 글 목록(2차 가이드 §2).
  //
  // SPEC-0011 R2로 커뮤니티 앱바에서 **차단 목록만** 빠지고 숨긴 글은 남았다.
  // SPEC-0010은 "둘 다 내가 안 보이게 한 것을 되돌리는 화면이라 같은 자리에 있어야
  // 한다"는 근거로 둘을 묶어 놨는데, 차단이 설정으로 옮겨가면서 **그 근거가 깨졌다**.
  // 스펙의 결정이므로 따르되, 나중에 "왜 하나만 남았나"를 되짚을 수 있게 남긴다.
  GoRoute(
    path: '/hidden-posts',
    name: HiddenPostsScreen.routeName,
    builder: (_, _) => const HiddenPostsScreen(),
  ),
  // 설정(SPEC-0011 R1). 하위 화면을 **자식 라우트로 중첩한다** — 뒤로 가기가 설정
  // 홈을 거쳐 진입 직전 화면으로 돌아가야 한다(R1 세 번째 기준).
  //
  // 셸 밖의 최상위 라우트라 하단 탭을 덮는다(관광지 상세·글 상세와 같은 성격).
  GoRoute(
    path: '/settings',
    name: SettingsScreen.routeName,
    builder: (_, _) => const SettingsScreen(),
    routes: <RouteBase>[
      GoRoute(
        path: 'my-posts',
        name: MyPostsScreen.routeName,
        builder: (_, _) => const MyPostsScreen(),
      ),
      // 프로필 수정(R4~R6). 설정 홈의 프로필 요약을 탭하면 여기로 온다.
      GoRoute(
        path: 'profile',
        name: ProfileEditScreen.routeName,
        builder: (_, _) => const ProfileEditScreen(),
        routes: <RouteBase>[
          // 이메일 변경(R7·R8). **두 단계가 라우트 하나를 쓴다** — 단계를 나누면
          // `verificationId`를 route extra로 넘겨야 하고, 뒤로 가기로 돌아온 주소
          // 화면이 죽은 검증 건을 들고 있게 된다. 전이는 controller 상태가 쥔다.
          GoRoute(
            path: 'email',
            name: EmailChangeScreen.routeName,
            builder: (_, _) => const EmailChangeScreen(),
          ),
        ],
      ),
      GoRoute(
        path: 'preferences',
        name: PreferencesScreen.routeName,
        builder: (_, _) => const PreferencesScreen(),
      ),
      // 약관 동의 관리(R9·R10). 설정 계열이라 필수 약관 게이트가 막지 않는다 —
      // 미동의 상태에서도 여기서 무엇에 동의했는지 볼 수 있어야 한다(R11).
      GoRoute(
        path: 'terms',
        name: TermsScreen.routeName,
        builder: (_, _) => const TermsScreen(),
      ),
      GoRoute(
        path: 'delete-account',
        name: AccountDeletionScreen.routeName,
        builder: (_, _) => const AccountDeletionScreen(),
      ),
    ],
  ),
  // 필수 약관 동의 안내(R11·R12). 게이트가 막았을 때 착지하는 곳이라 **설정 아래가
  // 아니라 최상위**다 — 게이트는 로그인 직후에도 걸리는데, 그때 설정 홈을 뒤에 깔면
  // 뒤로 가기가 게이트에 다시 막힌 화면으로 돌아간다.
  GoRoute(
    path: '/required-terms',
    name: RequiredTermsScreen.routeName,
    builder: (_, _) => const RequiredTermsScreen(),
  ),
  // The post-onboarding 5-tab shell. Each tab keeps its own navigation stack.
  StatefulShellRoute.indexedStack(
    builder: (_, _, StatefulNavigationShell shell) =>
        FloatingBottomNavScaffold(navigationShell: shell),
    branches: <StatefulShellBranch>[
      _branch('/home', HomeScreen.routeName, const HomeScreen()),
      _branch('/map', MapScreen.routeName, const MapScreen()),
      // SPEC-0021 R9: 세그먼트 토글이 걷히면서 둘러보기 탭이 다시 추천 스와이프
      // 하나가 됐다. **라우트 이름과 탭 위치는 그대로다**(AC9.3·AC9.4) —
      // 가리키는 위젯만 `DiscoverScreen`으로 돌아간다.
      _branch('/discover', DiscoverScreen.routeName, const DiscoverScreen()),
      // SPEC-0008 R-12·R-13: 탭 3·4의 목적지만 교체한다. 탭 수(5)와 Discover의
      // 가운데 강조는 그대로다(AC-40) — 셸 구조는 건드리지 않는다.
      _branch('/liked', LikedSpotsScreen.routeName, const LikedSpotsScreen()),
      _branch('/community', CommunityScreen.routeName, const CommunityScreen()),
    ],
  ),
];

/// 아래에서 위로 밀어 올리는 전환(SPEC-0006 AC-17). 같은 builder가 역방향 재생으로
/// 위→아래 종료가 되므로(AC-20), 시스템 뒤로가기와 명시적 닫기가 같은 연출을 쓴다
/// (AC-22). 곡선·지속시간은 수용 기준에 없어 구현 재량이다.
Widget _slideUpFromBottom(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) => SlideTransition(
  position: animation.drive(
    Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic)),
  ),
  child: child,
);

/// 스와이프 피드의 선택 집합을 쿼리 파라미터에서 되돌린다(SPEC-0020).
///
/// 값은 **콤마로 이은 카테고리 코드**다(`LODGING,TOURIST_SPOT`). 코드만 있으면
/// 되므로 [SpotCategory.ofCode]로 만든다 — 이 값은 세션을 찾는 키로만 쓰이고 화면에
/// 라벨을 그리지 않는다.
///
/// **null이 유효한 값이다** — 스와이프 피드 밖에서 들어온 진입(검색·좋아요·지도·
/// 딥링크)이며, 그때는 소비할 카드 스택이 없다. 빈 문자열도 같게 본다.
///
/// 예전에는 Dart enum 이름을 되돌렸는데, `SpotCategory.values` 조회가 사라지면서
/// 단순 문자열 파싱이 됐다 — 지도 마커가 서버 `code`를 싣고 라우터가 enum 이름과
/// 비교해 **항상 폴백으로 떨어지던 어긋남**도 표기가 하나로 통일되며 사라졌다.
/// 스와이프 세션의 카테고리 선택을 되돌린다.
///
/// **파라미터 부재(null)와 빈 값('')은 다르다.** 부재는 스와이프 밖에서 들어온
/// 것이고, 빈 값은 "전체"로 보던 세션이다 — 둘 다 null로 접었더니 전체로 보던
/// 사용자가 좋아요를 눌러도 카드가 소비되지 않았다(SPEC-0020 회귀).
SpotCategorySelection? _swipeCategoryFrom(String? codes) {
  if (codes == null) return null;
  return SpotCategorySelection(
    codes.split(',').where((String c) => c.isNotEmpty).map(SpotCategory.ofCode),
  );
}

/// 컴포저에 넘어온 카테고리 제안을 되돌린다. **null이 유효한 값이다** — 커뮤니티
/// 탭에서 열면 제안이 없고 사용자가 직접 고른다(가이드 §5).
///
/// `SpotCategory`와 값이 같아도 다른 타입이다 — 커뮤니티가 자기 enum을 소유한다.
TargetCategory? _targetCategoryFrom(String? name) => TargetCategory.values
    .where((TargetCategory c) => c.name == name)
    .firstOrNull;

/// One tab branch of the bottom-nav shell: a single-route stack.
StatefulShellBranch _branch(String path, String name, Widget screen) =>
    StatefulShellBranch(
      routes: <RouteBase>[
        GoRoute(path: path, name: name, builder: (_, _) => screen),
      ],
    );
