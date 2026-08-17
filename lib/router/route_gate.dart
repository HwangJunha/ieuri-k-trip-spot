/// 라우터 리다이렉트의 **판정 로직만** 떼어 놓은 순수 함수들(SPEC-0011 R11·R12).
///
/// **왜 분리하는가.** 게이트는 앱 전체의 진입을 좌우해서 틀리면 화면이 통째로 막히거나
/// 통째로 새는데, 리다이렉트가 실제로 일어나는지를 위젯 테스트로 확인하는 것은 느리고
/// 불안정하다(설계 §9 — 그건 범위 밖이다). 판정을 순수 함수로 두면 그 자리에서 표처럼
/// 검증할 수 있다.
///
/// 여기에는 Flutter도 Riverpod도 GoRouter도 들어오지 않는다 — 입력은 값뿐이다.
library;

/// 게이트가 참조하는 경로들. 위젯은 이름(`Screen.routeName`)으로 이동하므로 원시
/// 경로가 필요한 곳은 리다이렉트뿐이다.
const String splashPath = '/';
const String languagePath = '/language';
const String loginPath = '/login';
const String onboardingPath = '/onboarding';

/// 필수 약관 미동의 상태에서 사용자를 보내는 곳(R11).
const String requiredTermsPath = '/required-terms';

/// 이메일 인증 미완 상태에서 사용자를 보내는 곳(SPEC-0024 R10-1).
const String emailVerificationPath = '/email-verification';

/// 탈퇴 화면. 인증 미완 상태에서도 열려 있어야 한다 — 인증할 수 없는 주소로
/// 가입한 사용자가 계정을 지우고 나갈 유일한 길이다.
const String deleteAccountPath = '/settings/delete-account';

/// 설정 계열의 뿌리. 미동의 상태에서도 **설정 계열은 열려 있다**(R11 네 번째 기준) —
/// 로그아웃·탈퇴·언어 변경이 여기 있어서 막으면 사용자가 빠져나갈 길이 없다.
const String settingsPath = '/settings';

/// 로그인·온보딩을 마친 사용자의 착지점. 앱의 핵심 동선이 스와이프라 홈이 아니라
/// Discover로 보낸다 — 홈은 하단 탭으로 언제든 갈 수 있다.
const String discoverPath = '/discover';

/// 미인증 사용자에게 허용되는 경로(SPEC-0005 §10.2).
const Set<String> authPaths = <String>{
  loginPath,
  '/sign-up',
  '/sns-sign-up',
  '/email-verification',
  '/password-reset',
};

/// 인증 상태를 나눈 게이트 입력. `AsyncValue`를 그대로 받지 않는 이유는
/// 이 파일을 Riverpod에서 떼어 놓기 위해서다.
enum AuthGateState {
  /// 아직 판정되지 않음(토큰 확인 중). 보호 화면을 **한 프레임도** 그리면 안 된다.
  loading,

  /// 로그인하지 않음.
  unauthenticated,

  /// 로그인했지만 이메일 인증 미완(SPEC-0024 R10). 온보딩보다 앞이다 — 서버가
  /// 미인증 토큰의 대부분을 거부하므로(R9) 온보딩을 먼저 태우면 그 안의 서버
  /// 호출이 실패한다.
  emailVerificationRequired,

  /// 로그인했지만 온보딩 미완.
  onboardingRequired,

  /// 로그인·온보딩 완료.
  ready,
}

/// 필수 약관 상태를 세 갈래로 나눈 게이트 입력.
enum TermsGateState {
  /// 아직 조회되지 않음/조회 중.
  loading,

  /// 미동의 필수 약관이 있음 → 동의 화면으로 보낸다(R11).
  unmet,

  /// 필수 약관 충족 → 게이트가 열린다.
  satisfied,
}

/// 게이트 판정(SPEC-0005 §10 + SPEC-0011 R11·R12).
///
/// 판정 순서는 **언어 → 인증 → 온보딩 → 필수 약관 → 목적지**다(설계 §3). 게이트가
/// 하나뿐이어야 하는 이유는 순환이다 — 둘이 각자 리다이렉트하면 서로를 되돌리며
/// 무한히 튕긴다.
///
/// 돌려주는 값은 GoRouter의 규약 그대로다: `null`이면 [location]을 그대로 두고,
/// 문자열이면 그곳으로 보낸다.
///
/// [languageChosen]은 로컬 저장값, [auth]는 인증 provider, [terms]는 약관 provider에서
/// 온다. 셋 다 `ref.read`로 동기적으로 읽을 수 있는 값이라 리다이렉트가 네트워크를
/// 기다리지 않는다.
/// [emailVerificationHoldsHandle]은 인증 화면이 서버 `verificationId`를 들고 있는지다
/// — 가입 직후 경로로 들어왔다는 뜻이며, 그때만 세션 없이 이 화면에 머물 수 있다.
/// 라우터는 `extra`를 판정에 쓰지 않으므로 호출부가 값으로 넘긴다.
String? resolveGate({
  required String location,
  required bool languageChosen,
  required AuthGateState auth,
  required TermsGateState terms,
  bool emailVerificationHoldsHandle = false,
}) {
  // 스플래시는 자기 초기 내비게이션을 스스로 몬다.
  if (location == splashPath) return null;

  // 1) 언어 선택이 먼저다(SPEC-0005 §10.1).
  if (!languageChosen) {
    return location == languagePath ? null : languagePath;
  }

  // 2) 인증이 아직 판정되지 않았으면 보호 화면을 그리지 않는다(SPEC-0005 AC-1·AC-2).
  //    대기 화면은 빈 화면이나 에러 화면이 아니어야 하므로 스플래시로 보낸다. 인증이
  //    필요 없는 경로는 그대로 두어 로그인 흐름을 막지 않는다.
  if (auth == AuthGateState.loading) {
    if (authPaths.contains(location) || location == languagePath) return null;
    return splashPath;
  }

  // 3) 미인증은 인증 경로에 고정한다(§10.2).
  if (auth == AuthGateState.unauthenticated) {
    // **인증 화면은 예외다.** 이 경로는 두 역할을 겸한다 — 가입 직후(토큰 없음)와
    // 게이트에 걸린 미인증 세션(토큰 있음). 뒤쪽에서 로그아웃하면 세션이 사라져
    // 여기 조건에 걸리는데, `authPaths`에 들어 있다는 이유로 통과시키면 사용자가
    // **화면을 빠져나갈 수 없다** — 실제로 로그아웃 버튼이 먹지 않는 교착이 났다.
    //
    // 세션 없이 이 화면에 머물 수 있는 것은 가입 직후 경로뿐이고, 그때는 화면이
    // `verificationId`를 들고 있다. 라우터는 그 값을 볼 수 없으므로 화면이
    // [emailVerificationHoldsHandle]로 알려 준다.
    if (location == emailVerificationPath) {
      return emailVerificationHoldsHandle ? null : loginPath;
    }
    return authPaths.contains(location) ? null : loginPath;
  }

  // 4) 이메일 인증 미완 → 인증 화면(SPEC-0024 R10-1·R10-4). 온보딩·약관보다
  //    앞이다 — 서버가 미인증 토큰의 비허용 오퍼레이션을 거부하므로(R9) 그 뒤의
  //    화면들은 어차피 데이터를 못 읽는다.
  //
  //    화면을 띄운 뒤 가리지 않고 리다이렉트로 막는다(R10-2) — 한 프레임이라도
  //    메인이 보이면 안 된다.
  if (auth == AuthGateState.emailVerificationRequired) {
    return _emailVerificationAllows(location) ? null : emailVerificationPath;
  }

  // 5) 인증했지만 온보딩 미완 → 온보딩(§10.3).
  if (auth == AuthGateState.onboardingRequired) {
    return location == onboardingPath ? null : onboardingPath;
  }

  // 6) 필수 약관 게이트(SPEC-0011 R11). 온보딩 다음이고 목적지 앞이다.
  if (terms != TermsGateState.satisfied) {
    // 조회 중에는 **통과시키지 않는다** — 통과시키면 미동의 사용자가 홈을 보게 되고,
    // 조회가 끝난 뒤 튕겨 나가 화면이 깜빡인다. 인증 대기와 같은 자리(스플래시)에
    // 세워 두되, 이미 허용 목적지에 있다면 그대로 둔다.
    if (_termsAllows(location)) return null;
    return terms == TermsGateState.loading ? splashPath : requiredTermsPath;
  }

  // 7) 통과한 사용자를 진입 전 화면(로그인·온보딩·언어·동의)에 두지 않는다(§10.4).
  if (authPaths.contains(location) ||
      location == onboardingPath ||
      location == languagePath ||
      location == requiredTermsPath) {
    return discoverPath;
  }
  return null;
}

/// 이메일 인증 미완 상태에서 허용되는 목적지(SPEC-0024 R10-2).
///
/// 인증 화면에서 나갈 수 있는 곳은 세 곳뿐이다(설계 §3) — 인증 성공 시 메인,
/// 로그아웃, 탈퇴. 앞의 둘은 상태 변화라 경로가 필요 없고, **탈퇴만 경로를 탄다**.
///
/// 설정 계열 전체를 여는 약관 게이트와 달리 여기서는 탈퇴 화면 하나만 연다.
/// 미인증 토큰으로는 프로필 조회·수정이 서버에서 거부되므로(R9) 설정을 열어 줘도
/// 오류 화면만 보게 된다. 로그아웃은 설정 화면 안에 있지만, 인증 화면 자체에
/// 로그아웃 경로를 두는 것이 설계 §3의 요구다.
bool _emailVerificationAllows(String location) =>
    location == emailVerificationPath || location == deleteAccountPath;

/// 미동의 상태에서 허용되는 목적지(R11 네 번째 기준): **설정 계열과 동의 화면뿐**이다.
/// 홈·탐색·커뮤니티는 전부 막힌다.
bool _termsAllows(String location) =>
    location == requiredTermsPath ||
    location == settingsPath ||
    location.startsWith('$settingsPath/');

/// 게이트가 풀린 뒤 돌아갈 목적지를 고른다(R12 — 원래 가려던 곳으로 복귀).
///
/// [intended]가 없거나 그 자체가 진입 전 화면이면(동의 화면·로그인 등) 복귀할 곳이
/// 없다는 뜻이므로 기본 착지점으로 보낸다.
String destinationAfterGate(String? intended) {
  if (intended == null || intended.isEmpty) return discoverPath;
  if (intended == splashPath ||
      intended == languagePath ||
      intended == onboardingPath ||
      intended == requiredTermsPath ||
      authPaths.contains(intended)) {
    return discoverPath;
  }
  return intended;
}
