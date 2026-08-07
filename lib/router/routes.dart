import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/onboarding/view/language_selection_screen.dart';
import '../common/onboarding/view/splash_screen.dart';
import '../common/widget/floating_bottom_nav_scaffold.dart';
import '../domain/auth/view/email_verification_screen.dart';
import '../domain/auth/view/login_screen.dart';
import '../domain/auth/model/sns_credential.dart';
import '../domain/auth/view/password_reset_screen.dart';
import '../domain/auth/view/sign_up_screen.dart';
import '../domain/auth/view/sns_sign_up_screen.dart';
import '../domain/community/model/target_category.dart';
import '../domain/community/view/blocked_users_screen.dart';
import '../domain/community/view/community_screen.dart';
import '../domain/community/view/hidden_posts_screen.dart';
import '../domain/community/view/post_composer_screen.dart';
import '../domain/community/view/post_detail_screen.dart';
import '../domain/onboarding/view/onboarding_screen.dart';
import '../domain/settings/view/account_deletion_screen.dart';
import '../domain/settings/view/my_posts_screen.dart';
import '../domain/settings/view/preferences_screen.dart';
import '../domain/settings/view/settings_screen.dart';
import '../domain/spot/model/spot_category.dart';
import '../domain/spot/view/discover_screen.dart';
import '../domain/spot/view/home_screen.dart';
import '../domain/spot/view/liked_spots_screen.dart';
import '../domain/spot/view/map_screen.dart';
import '../domain/spot/view/spot_detail_view.dart';

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
  // category는 쿼리 파라미터다. 서버의 `intro`/`infoItems`가 필수 인자로 요구하는데
  // 조회 중인 응답의 필드를 인자로 쓸 수 없어, 스와이프 피드가 이미 가진 값을 넘긴다.
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
        category: _spotCategoryFrom(state.uri.queryParameters['category']),
        initialThumbnailUrl: state.uri.queryParameters['thumb'],
        // 어느 피드에서 열렸는지(R11). category(관광지의 카테고리)와 다른 값이며,
        // 파라미터가 없으면 전체 피드(null)로 본다 — 직접 진입도 같은 경로다.
        feedCategory: _feedCategoryFrom(state.uri.queryParameters['feed']),
      ),
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: _slideUpFromBottom,
    ),
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
      GoRoute(
        path: 'preferences',
        name: PreferencesScreen.routeName,
        builder: (_, _) => const PreferencesScreen(),
      ),
      GoRoute(
        path: 'delete-account',
        name: AccountDeletionScreen.routeName,
        builder: (_, _) => const AccountDeletionScreen(),
      ),
    ],
  ),
  // The post-onboarding 5-tab shell. Each tab keeps its own navigation stack.
  StatefulShellRoute.indexedStack(
    builder: (_, _, StatefulNavigationShell shell) =>
        FloatingBottomNavScaffold(navigationShell: shell),
    branches: <StatefulShellBranch>[
      _branch('/home', HomeScreen.routeName, const HomeScreen()),
      _branch('/map', MapScreen.routeName, const MapScreen()),
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

/// 쿼리 파라미터로 온 카테고리 이름을 [SpotCategory]로 되돌린다.
///
/// 서버가 아직 매핑되지 않은 enum 값을 추가했거나 파라미터가 빠진 경우엔
/// [SpotCategory.touristSpot]으로 떨어진다 — 상세 화면 전체를 실패시키는 것보다
/// 낫고, 이때 운영 정보·이용안내가 실제와 다르면 서버가 빈 값을 주므로 해당 섹션이
/// 렌더되지 않는다.
/// 피드 필터를 되돌린다. [_spotCategoryFrom]과 달리 **null이 유효한 값**이다 —
/// "전체" 피드를 뜻하므로 기본값으로 떨어뜨리면 안 된다.
SpotCategory? _feedCategoryFrom(String? name) =>
    SpotCategory.values.where((SpotCategory c) => c.name == name).firstOrNull;

/// 컴포저에 넘어온 카테고리 제안을 되돌린다. **null이 유효한 값이다** — 커뮤니티
/// 탭에서 열면 제안이 없고 사용자가 직접 고른다(가이드 §5).
///
/// `SpotCategory`와 값이 같아도 다른 타입이다 — 커뮤니티가 자기 enum을 소유한다.
TargetCategory? _targetCategoryFrom(String? name) => TargetCategory.values
    .where((TargetCategory c) => c.name == name)
    .firstOrNull;

SpotCategory _spotCategoryFrom(String? name) =>
    SpotCategory.values.where((SpotCategory c) => c.name == name).firstOrNull ??
    SpotCategory.touristSpot;

/// One tab branch of the bottom-nav shell: a single-route stack.
StatefulShellBranch _branch(String path, String name, Widget screen) =>
    StatefulShellBranch(
      routes: <RouteBase>[
        GoRoute(path: path, name: name, builder: (_, _) => screen),
      ],
    );
