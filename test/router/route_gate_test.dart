import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/router/route_gate.dart';

/// 필수 약관 게이트 판정(SPEC-0011 R11·R12).
///
/// 리다이렉트가 실제로 일어나는지는 범위 밖이다(설계 §9) — 판정 자체를 순수 함수로
/// 떼어 표처럼 검증한다. 게이트가 틀리면 앱이 통째로 막히거나 통째로 새기 때문에
/// 이 테스트가 유일한 방어선이다.

String? _gate(
  String location, {
  bool languageChosen = true,
  AuthGateState auth = AuthGateState.ready,
  TermsGateState terms = TermsGateState.satisfied,
}) => resolveGate(
  location: location,
  languageChosen: languageChosen,
  auth: auth,
  terms: terms,
);

void main() {
  group('필수 약관 게이트 (R11)', () {
    test('미동의면 홈이 막히고 동의 화면으로 간다', () {
      expect(_gate('/home', terms: TermsGateState.unmet), requiredTermsPath);
    });

    test('미동의면 탐색과 커뮤니티도 막힌다', () {
      expect(
        _gate('/discover', terms: TermsGateState.unmet),
        requiredTermsPath,
      );
      expect(
        _gate('/community', terms: TermsGateState.unmet),
        requiredTermsPath,
      );
    });

    test('미동의여도 설정 홈은 열려 있다', () {
      // 로그아웃·탈퇴가 설정 안에 있어 막으면 빠져나갈 길이 없다(R11 네 번째 기준).
      expect(_gate('/settings', terms: TermsGateState.unmet), isNull);
    });

    test('미동의여도 설정 하위 화면은 열려 있다', () {
      expect(_gate('/settings/terms', terms: TermsGateState.unmet), isNull);
      expect(
        _gate('/settings/preferences', terms: TermsGateState.unmet),
        isNull,
      );
    });

    test('동의 화면 자체는 되돌리지 않는다', () {
      // 되돌리면 자기 자신으로 무한히 리다이렉트한다.
      expect(_gate(requiredTermsPath, terms: TermsGateState.unmet), isNull);
    });

    test('약관 조회 중에는 통과시키지 않고 스플래시에 세운다', () {
      // 통과시키면 미동의 사용자가 홈을 본 뒤 튕겨 나가 화면이 깜빡인다.
      expect(_gate('/home', terms: TermsGateState.loading), splashPath);
    });

    test('약관 조회 중에도 설정 계열은 막지 않는다', () {
      expect(_gate('/settings', terms: TermsGateState.loading), isNull);
    });

    test('동의를 마치면 게이트가 풀려 홈이 열린다', () {
      expect(_gate('/home', terms: TermsGateState.satisfied), isNull);
    });

    test('동의를 마치면 동의 화면에 머무르지 않는다', () {
      expect(
        _gate(requiredTermsPath, terms: TermsGateState.satisfied),
        discoverPath,
      );
    });
  });

  group('판정 순서 — 언어 → 인증 → 온보딩 → 약관', () {
    test('언어 미선택이 약관보다 먼저다', () {
      expect(
        _gate('/home', languageChosen: false, terms: TermsGateState.unmet),
        languagePath,
      );
    });

    test('미인증이 약관보다 먼저다', () {
      expect(
        _gate(
          '/home',
          auth: AuthGateState.unauthenticated,
          terms: TermsGateState.unmet,
        ),
        loginPath,
      );
    });

    test('온보딩 미완이 약관보다 먼저다', () {
      expect(
        _gate(
          '/home',
          auth: AuthGateState.onboardingRequired,
          terms: TermsGateState.unmet,
        ),
        onboardingPath,
      );
    });

    test('인증 판정 중에는 스플래시에 머문다', () {
      expect(_gate('/home', auth: AuthGateState.loading), splashPath);
    });

    test('인증 판정 중에도 로그인 화면은 막지 않는다', () {
      expect(_gate(loginPath, auth: AuthGateState.loading), isNull);
    });

    test('스플래시는 자기 내비게이션을 스스로 몬다', () {
      expect(_gate(splashPath, auth: AuthGateState.loading), isNull);
    });
  });

  group('목적지 복귀 (R12)', () {
    test('보관한 목적지로 돌아간다', () {
      expect(destinationAfterGate('/home'), '/home');
    });

    test('보관한 목적지가 없으면 기본 착지점으로 간다', () {
      expect(destinationAfterGate(null), discoverPath);
    });

    test('동의 화면 자체는 복귀 목적지가 될 수 없다', () {
      // 그 자리로 돌려보내면 게이트를 막 통과한 사용자가 다시 동의 화면을 본다.
      expect(destinationAfterGate(requiredTermsPath), discoverPath);
    });

    test('로그인·온보딩도 복귀 목적지가 될 수 없다', () {
      expect(destinationAfterGate(loginPath), discoverPath);
      expect(destinationAfterGate(onboardingPath), discoverPath);
    });
  });

  group('이메일 인증 게이트 (SPEC-0024 R10)', () {
    const AuthGateState unverified = AuthGateState.emailVerificationRequired;

    test('인증 미완이면 메인이 막히고 인증 화면으로 간다', () {
      // R10-1·R10-2. 화면을 띄운 뒤 가리는 게 아니라 아예 도달하지 못해야 한다.
      expect(_gate(discoverPath, auth: unverified), emailVerificationPath);
      expect(_gate('/home', auth: unverified), emailVerificationPath);
    });

    test('인증 미완이면 상세·커뮤니티 같은 하위 경로도 막힌다', () {
      expect(_gate('/spot/123', auth: unverified), emailVerificationPath);
      expect(_gate('/community', auth: unverified), emailVerificationPath);
    });

    test('인증 화면 자체는 그대로 둔다', () {
      expect(_gate(emailVerificationPath, auth: unverified), isNull);
    });

    test('탈퇴 화면은 열려 있다', () {
      // 인증할 수 없는 주소로 갇힌 사용자가 계정을 지우고 나갈 유일한 길이다.
      expect(_gate(deleteAccountPath, auth: unverified), isNull);
    });

    test('설정 계열의 나머지는 막힌다', () {
      // 약관 게이트와 다르다 — 미인증 토큰으로는 서버가 프로필 조회를 거부하므로
      // 열어 줘도 오류 화면만 보게 된다.
      expect(_gate(settingsPath, auth: unverified), emailVerificationPath);
      expect(
        _gate('/settings/profile', auth: unverified),
        emailVerificationPath,
      );
    });

    test('온보딩보다 앞서 판정된다', () {
      // 서버가 미인증 토큰의 비허용 오퍼레이션을 거부하므로(R9) 온보딩을 먼저
      // 태우면 그 안의 서버 호출이 실패한다.
      expect(_gate(onboardingPath, auth: unverified), emailVerificationPath);
    });

    test('언어 선택이 이메일 인증보다 앞선다', () {
      expect(
        _gate(discoverPath, languageChosen: false, auth: unverified),
        languagePath,
      );
    });

    test('인증을 마치면 게이트가 열린다', () {
      // R10-3. 판정 근거가 참으로 바뀌면 그다음 게이트(온보딩)로 넘어간다.
      expect(
        _gate(discoverPath, auth: AuthGateState.onboardingRequired),
        onboardingPath,
      );
      expect(_gate(discoverPath, auth: AuthGateState.ready), isNull);
    });

    test('인증을 마친 사용자를 인증 화면에 두지 않는다', () {
      expect(_gate(emailVerificationPath, auth: AuthGateState.ready),
          discoverPath);
    });
  });

  group('인증 화면에서 로그아웃한 뒤 (실기기 교착 회귀)', () {
    // 로그아웃하면 세션이 사라져 `unauthenticated`가 된다. `/email-verification`이
    // authPaths에 들어 있다는 이유로 통과시키면 **화면을 빠져나갈 수 없다** —
    // 실기기에서 로그아웃 버튼이 먹지 않는 교착이 났다.
    test('핸들이 없으면 로그인 화면으로 내보낸다', () {
      expect(
        resolveGate(
          location: emailVerificationPath,
          languageChosen: true,
          auth: AuthGateState.unauthenticated,
          terms: TermsGateState.satisfied,
          emailVerificationHoldsHandle: false,
        ),
        loginPath,
      );
    });

    test('가입 직후 경로는 세션 없이도 머문다', () {
      // 이쪽은 토큰이 없는 게 정상이다 — 화면이 서버 핸들을 들고 있고, 그것으로
      // 코드를 검증한 뒤 로그인 화면으로 간다.
      expect(
        resolveGate(
          location: emailVerificationPath,
          languageChosen: true,
          auth: AuthGateState.unauthenticated,
          terms: TermsGateState.satisfied,
          emailVerificationHoldsHandle: true,
        ),
        isNull,
      );
    });

    test('다른 인증 경로는 영향을 받지 않는다', () {
      expect(_gate(loginPath, auth: AuthGateState.unauthenticated), isNull);
      expect(_gate('/sign-up', auth: AuthGateState.unauthenticated), isNull);
    });
  });

  // **위치는 더 이상 게이트가 아니다**(2026-08-29).
  //
  // 2026-08-26에 위치 권한이 없으면 앱 전체를 `/location-required`로 대체했다가
  // App Store 심사에서 거절됐다 — Guideline 5.1.5("위치 서비스를 끄면 앱이
  // 동작하지 않는다")와 2.1(a)("데모 계정으로 앱에 접근할 수 없다"). 후자는
  // 위치 판정이 인증보다 앞이라 위치를 끈 심사자가 로그인 화면에조차 도달하지
  // 못한 결과였다.
  //
  // 이 그룹은 그 회귀를 막는다. 게이트는 위치를 아예 입력으로 받지 않으므로
  // 여기서 검증할 것은 "위치와 무관하게 열린다"는 사실 하나다.
  group('위치는 게이트가 아니다 (App Store 5.1.5·2.1(a) 회귀)', () {
    test('다섯 탭이 전부 열린다', () {
      for (final String tab in <String>[
        '/home',
        '/national-map',
        discoverPath,
        '/library',
        '/map',
      ]) {
        expect(_gate(tab), isNull, reason: '$tab이 막혔다');
      }
    });

    test('상세 같은 하위 경로도 열린다', () {
      expect(_gate('/spot/123'), isNull);
    });

    test('로그인 화면에 도달할 수 있다', () {
      // **심사자가 막힌 지점이 여기다.** 위치 판정이 인증보다 앞이라
      // `/login`이 `/location-required`로 갈아치워졌고, 데모 계정을 받고도
      // 입력할 화면이 나오지 않았다(Guideline 2.1(a)).
      expect(_gate(loginPath, auth: AuthGateState.unauthenticated), isNull);
      expect(_gate('/sign-up', auth: AuthGateState.unauthenticated), isNull);
    });

    test('좌표를 쓰지 않는 기능도 열린다', () {
      // 커뮤니티 읽기·쓰기, 좋아요 목록, DM은 좌표를 입력으로 쓰지 않는다 —
      // "전부 내 주변"이라는 전제가 과했다.
      for (final String path in <String>[
        '/library',
        '/post/1',
        '/conversations',
        '/settings',
      ]) {
        expect(_gate(path), isNull, reason: '$path이 막혔다');
      }
    });

    test('안내 화면은 남아 있고, 들어가면 머물 수 있다', () {
      // 게이트가 강제로 보내지는 않지만 화면 자체는 유효하다 — 각 탭의 안내에서
      // "위치 켜기"를 누르면 여기로 온다. 8)의 진입 전 화면 목록에 넣어 두면
      // 들어가자마자 Discover로 튕겨 나온다.
      expect(_gate(locationRequiredPath), isNull);
    });
  });
}
