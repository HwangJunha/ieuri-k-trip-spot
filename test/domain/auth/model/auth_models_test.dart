// 인증 모델 테스트를 한 파일에 모았다.
//
// **파일을 쪼개지 않는 이유는 속도다** — flutter test는 파일마다 격리된 VM을 띄우므로
// 파일 수가 곧 실행 시간이다. 모델별 구분은 group으로 충분하다(CLAUDE.md §8).

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_failure.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_session.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/auth_state.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/me.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/password_policy.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_credential.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_provider.dart';
import 'package:ieuri_k_trip_spot/domain/auth/model/sns_registration_result.dart';

void main() {
  // ─── auth_failure ────────────────────────────────────────────

  test('maps known codes to the matching failure kind', () {
    expect(
      AuthFailure.fromCode('INVALID_CREDENTIALS').kind,
      AuthFailureKind.invalidCredentials,
    );
    expect(
      AuthFailure.fromCode('EMAIL_TAKEN').kind,
      AuthFailureKind.emailAlreadyInUse,
    );
    // 서버가 실제로 주는 코드다(실측). unknown으로 떨어지면 사용자는
    // "문제가 발생했습니다"만 보고 만료가 원인인 줄 알 수 없다.
    expect(
      AuthFailure.fromCode('SNS_VERIFICATION_FAILED').kind,
      AuthFailureKind.snsVerificationFailed,
    );
  });

  test('maps an unknown code to unknown, preserving the field', () {
    final AuthFailure failure = AuthFailure.fromCode(
      'WHATEVER',
      field: 'email',
    );
    expect(failure.kind, AuthFailureKind.unknown);
    expect(failure.field, 'email');
  });

  // ─── auth_session ────────────────────────────────────────────

  test('AuthSession carries the server-provided token type and expiries', () {
    const AuthSession session = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      tokenType: 'Bearer',
      accessTokenExpiresIn: 300,
      refreshTokenExpiresIn: 2592000,
    );

    expect(session.tokenType, 'Bearer');
    expect(session.accessTokenExpiresIn, 300);
    expect(session.refreshTokenExpiresIn, 2592000);
    expect(session.user, isNull);
  });

  test('copyWith attaches the Me user without touching the tokens', () {
    const AuthSession tokens = AuthSession(accessToken: 'a', refreshToken: 'r');
    const Me me = Me(id: '7', email: 'a@b.com', nickname: 'Traveler');

    final AuthSession full = tokens.copyWith(user: me);

    expect(full.accessToken, 'a');
    expect(full.user, me);
  });

  test('equality includes tokens, expiries, and user', () {
    const AuthSession a = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      accessTokenExpiresIn: 300,
    );
    const AuthSession b = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      accessTokenExpiresIn: 300,
    );
    const AuthSession c = AuthSession(
      accessToken: 'a',
      refreshToken: 'r',
      accessTokenExpiresIn: 999,
    );

    expect(a, b);
    expect(a, isNot(c));
  });

  // ─── me ──────────────────────────────────────────────────────

  test('Me round-trips through JSON', () {
    const Me me = Me(
      id: '7',
      email: 'a@b.com',
      nickname: 'Traveler',
      profileImageUrl: 'https://x/y.png',
      status: MemberStatus.active,
      emailVerified: true,
      roles: <String>['USER'],
      permissions: <String>['spot:read'],
      createdAt: '2026-01-01T00:00:00Z',
    );

    final Me restored = Me.fromJson(me.toJson());

    expect(restored, me);
  });

  test('parses the wire status enum', () {
    final Me me = Me.fromJson(<String, dynamic>{
      'id': '1',
      'email': 'a@b.com',
      'nickname': 'n',
      'status': 'SUSPENDED',
      'emailVerified': false,
      'roles': <dynamic>[],
      'permissions': <dynamic>[],
      'createdAt': '',
    });

    expect(me.status, MemberStatus.suspended);
  });

  // ─── password_policy ─────────────────────────────────────────

  group('PasswordPolicy', () {
    test('accepts a letter+digit+special password of 8+ chars', () {
      expect(PasswordPolicy.isValid('abcd123!'), isTrue);
    });

    test('rejects a password shorter than 8', () {
      expect(PasswordPolicy.isValid('ab1!'), isFalse);
    });

    test('rejects a password missing a special character', () {
      expect(PasswordPolicy.isValid('abcd1234'), isFalse);
    });

    test('rejects a password missing a digit', () {
      expect(PasswordPolicy.isValid('abcdefg!'), isFalse);
    });
  });

  // ─── sns_credential ──────────────────────────────────────────

  test('carries the authorization code when the provider gave one', () {
    const SnsCredential credential = SnsCredential(
      provider: SnsProvider.apple,
      idToken: 'id-token',
      authorizationCode: 'apple-code',
    );

    expect(credential.authorizationCode, 'apple-code');
  });

  test('defaults the authorization code to null without throwing', () {
    // code를 노출하지 않는 provider(카카오)의 정상 경로 — 생성 자체가
    // 실패하면 안 된다(R7).
    const SnsCredential credential = SnsCredential(
      provider: SnsProvider.kakao,
      idToken: 'id-token',
    );

    expect(credential.authorizationCode, isNull);
  });

  test('the authorization code participates in equality', () {
    const SnsCredential withCode = SnsCredential(
      provider: SnsProvider.google,
      idToken: 'id-token',
      authorizationCode: 'code',
    );
    const SnsCredential withoutCode = SnsCredential(
      provider: SnsProvider.google,
      idToken: 'id-token',
    );

    expect(withCode, isNot(withoutCode));
    expect(
      withCode,
      const SnsCredential(
        provider: SnsProvider.google,
        idToken: 'id-token',
        authorizationCode: 'code',
      ),
    );
  });

  // ─── sns_provider ────────────────────────────────────────────

  test('wireName matches the server Provider enum names', () {
    expect(SnsProvider.google.wireName, 'GOOGLE');
    expect(SnsProvider.apple.wireName, 'APPLE');
    expect(SnsProvider.kakao.wireName, 'KAKAO');
  });

  test('covers exactly the three supported providers', () {
    expect(SnsProvider.values, <SnsProvider>[
      SnsProvider.google,
      SnsProvider.apple,
      SnsProvider.kakao,
    ]);
  });

  test('애플 기기에서는 셋 다 쓴다', () {
    expect(snsProvidersFor(isApplePlatform: true), <SnsProvider>[
      SnsProvider.google,
      SnsProvider.apple,
      SnsProvider.kakao,
    ]);
  });

  test('안드로이드에서는 애플을 뺀다', () {
    // webAuthenticationOptions 없이는 무조건 예외가 나므로, 눌러도 실패만 하는
    // 버튼을 보여주지 않는다.
    expect(snsProvidersFor(isApplePlatform: false), <SnsProvider>[
      SnsProvider.google,
      SnsProvider.kakao,
    ]);
  });

  // ─── sns_registration_result ─────────────────────────────────

  test('needsVerification is false when the email is already verified', () {
    const SnsRegistrationResult result = SnsRegistrationResult(
      emailVerified: true,
    );
    expect(result.needsVerification, isFalse);
  });

  test('needsVerification is true when unverified and a handle is present', () {
    const SnsRegistrationResult result = SnsRegistrationResult(
      emailVerified: false,
      verificationId: 'v-1',
    );
    expect(result.needsVerification, isTrue);
  });

  test('needsVerification is false when unverified but no handle', () {
    const SnsRegistrationResult result = SnsRegistrationResult(
      emailVerified: false,
    );
    expect(result.needsVerification, isFalse);
  });

  group('AuthState.emailVerified — 라우터 게이트의 판정 근거 (SPEC-0024 R10)', () {
    AuthState stateWith({required bool verified}) => AuthState(
      session: AuthSession(
        accessToken: 'a',
        refreshToken: 'r',
        user: Me(
          id: 'm-1',
          email: 'a@b.com',
          nickname: 'tester',
          emailVerified: verified,
        ),
      ),
    );

    test('서버가 인증됨을 주면 참이다', () {
      expect(stateWith(verified: true).emailVerified, isTrue);
    });

    test('서버가 미인증을 주면 거짓이다 — 게이트가 막는 경우다', () {
      expect(stateWith(verified: false).emailVerified, isFalse);
    });

    test('me를 아직 못 읽었으면 참으로 본다', () {
      // 토큰은 있는데 me 조회가 아직 끝나지 않은 구간이다. 거짓을 주면 인증을
      // 마친 사용자가 조회 실패 한 번에 인증 화면으로 튕긴다.
      const AuthState state = AuthState(
        session: AuthSession(accessToken: 'a', refreshToken: 'r'),
      );
      expect(state.emailVerified, isTrue);
    });

    test('미인증 상태에서도 참이다 — 인증 게이트가 판정을 가져간다', () {
      expect(AuthState.unauthenticated.emailVerified, isTrue);
    });
  });
}
