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
}
