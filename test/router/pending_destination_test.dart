import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/navigation/pending_destination.dart';
import 'package:ieuri_k_trip_spot/router/app_router.dart';
import 'package:ieuri_k_trip_spot/router/route_gate.dart';

/// 푸시 목적지 보관 슬롯(SPEC-0028 R17). 순수 로직이라 라우터를 세우지 않는다.

void main() {
  group('PendingDestination 슬롯 경합 (§3.3)', () {
    test('푸시 목적지가 약관 게이트보다 우선한다', () {
      final PendingDestination pending = PendingDestination();

      // 푸시로 열려 목적지가 가장 먼저 들어간다.
      pending.rememberIfAbsent('/conversations/42');
      // 그 뒤 약관 게이트가 막으며 자기 값을 넣으려 한다.
      pending.rememberIfAbsent('/discover');

      expect(
        pending.takeLocation(),
        '/conversations/42',
        reason: '덮어쓰면 사용자가 알림을 눌렀는데 엉뚱한 곳에 착지한다',
      );
    });

    test('remember는 여전히 덮어쓴다 — 약관 게이트 단독 경로는 그대로다', () {
      final PendingDestination pending = PendingDestination()
        ..remember('/a')
        ..remember('/b');

      expect(pending.takeLocation(), '/b');
    });

    test('한 번 꺼내면 비어 재소비되지 않는다 (AC17.4)', () {
      final PendingDestination pending = PendingDestination()
        ..rememberIfAbsent('/conversations/42');

      expect(pending.takeLocation(), '/conversations/42');
      expect(pending.hasDestination, isFalse);
      expect(
        pending.takeLocation(),
        isNull,
        reason: '두 번째 소비는 비어 있어야 한다 — 기본 착지점 변환은 라우터가 한다',
      );
    });

    test('비어 있으면 보관한 것이 없다고 답한다', () {
      expect(PendingDestination().hasDestination, isFalse);
    });

    test('보관하면 값이 있다고 답한다', () {
      final PendingDestination pending = PendingDestination()
        ..rememberIfAbsent('/spot/7/qa/13');

      expect(pending.hasDestination, isTrue);
    });

    test('진입 전 화면은 보관해도 기본 착지점으로 떨어진다', () {
      final PendingDestination pending = PendingDestination()
        ..rememberIfAbsent(loginPath);

      // 슬롯은 값을 그대로 돌려주고, 진입 전 화면 판정은 라우터가 얹는다.
      expect(
        destinationAfterGate(pending.takeLocation()),
        discoverPath,
        reason: '로그인 화면으로 되돌리면 게이트를 통과한 의미가 없다',
      );
    });
  });

  group('resolveGate — 푸시 목적지를 꺼내는 시점 (R17)', () {
    // 라우터의 소비 조건은 `target == null && auth == ready && location != splash`다.
    // 그 세 가지가 각각 왜 필요한지를 순수 함수 수준에서 고정한다.

    test('판정 전에는 스플래시로 되돌린다 — 목적지로 가지 않는다 (AC17.1)', () {
      final String? target = resolveGate(
        location: '/conversations/42',
        languageChosen: true,
        auth: AuthGateState.loading,
        terms: TermsGateState.satisfied,
        locationPermission: LocationGateState.granted,
      );

      expect(target, splashPath);
    });

    test('미인증이면 로그인으로 보낸다 (AC17.3)', () {
      final String? target = resolveGate(
        location: '/conversations/42',
        languageChosen: true,
        auth: AuthGateState.unauthenticated,
        terms: TermsGateState.satisfied,
        locationPermission: LocationGateState.granted,
      );

      expect(target, loginPath);
    });

    test('미인증 상태의 로그인 화면은 통과다 — 여기서 꺼내면 안 된다', () {
      final String? target = resolveGate(
        location: loginPath,
        languageChosen: true,
        auth: AuthGateState.unauthenticated,
        terms: TermsGateState.satisfied,
        locationPermission: LocationGateState.granted,
      );

      expect(
        target,
        isNull,
        reason:
            '`target == null`만 보고 꺼내면 로그인하던 사용자를 목적지로 끌어내 '
            '로그인을 마칠 수 없다 — 그래서 auth == ready를 함께 본다',
      );
    });

    test('스플래시는 판정 전에도 통과다 — 여기서 꺼내면 안 된다', () {
      final String? target = resolveGate(
        location: splashPath,
        languageChosen: true,
        auth: AuthGateState.loading,
        terms: TermsGateState.satisfied,
        locationPermission: LocationGateState.granted,
      );

      expect(
        target,
        isNull,
        reason: '스플래시는 무조건 null이라 여기서 꺼내면 AC17.1을 어긴다',
      );
    });

    test('게이트를 전부 통과하면 목적지에 머문다 — 이때 꺼낸다 (AC17.2)', () {
      final String? target = resolveGate(
        location: '/conversations/42',
        languageChosen: true,
        auth: AuthGateState.ready,
        terms: TermsGateState.satisfied,
        locationPermission: LocationGateState.granted,
      );

      expect(target, isNull);
    });

    test('알림 설정 화면은 미동의 상태에서도 열린다', () {
      final String? target = resolveGate(
        location: '/settings/notifications',
        languageChosen: true,
        auth: AuthGateState.ready,
        terms: TermsGateState.unmet,
        locationPermission: LocationGateState.granted,
      );

      expect(
        target,
        isNull,
        reason: '설정 계열은 약관 게이트가 열어 둔다',
      );
    });
  });

  // 실기기 회귀(2026-08-21): 설정>약관에서 필수 항목을 끄면
  // `/required-terms => /home => /home => /required-terms`로 무한히 튕겼다.
  //
  // 원인은 보관 슬롯을 **꺼내는 조건**이었다. 약관 게이트가 아직 잡고 있어도
  // `/required-terms`는 허용 화면이라 `resolveGate`가 null을 주는데, 그 null을
  // "게이트를 전부 통과했다"로 읽고 슬롯을 소비해 사용자를 `/home`으로 돌려보냈다.
  // `/home`은 다시 막혀 `/required-terms`로 오고, 왕복이 닫힌다.
  group('약관 미충족 중에는 보관 목적지를 꺼내지 않는다', () {
    String? redirectAt(
      String location,
      TermsGateState terms,
      PendingDestination pending,
    ) => resolveRedirect(
      location: location,
      languageChosen: true,
      auth: AuthGateState.ready,
      terms: terms,
      locationPermission: LocationGateState.granted,
      pending: pending,
    );

    test('동의 화면에 머무는 동안 슬롯을 소비하지 않는다', () {
      final PendingDestination pending = PendingDestination();

      // 홈으로 가려다 게이트에 막힌다 — 이때 목적지가 보관된다.
      expect(
        redirectAt('/home', TermsGateState.unmet, pending),
        requiredTermsPath,
      );
      expect(pending.location, '/home');

      // 동의 화면에 도착. **여기서 되돌려 보내면 루프다.**
      expect(
        redirectAt(requiredTermsPath, TermsGateState.unmet, pending),
        isNull,
        reason: '아직 동의하지 않았다 — 보관된 /home으로 보내면 다시 막혀 튕긴다',
      );
      expect(pending.location, '/home', reason: '동의 전에는 슬롯이 남아 있어야 한다');
    });

    test('동의를 마치면 그때 원래 목적지로 돌아간다 (R12)', () {
      final PendingDestination pending = PendingDestination();
      redirectAt('/home', TermsGateState.unmet, pending);

      expect(
        redirectAt(requiredTermsPath, TermsGateState.satisfied, pending),
        '/home',
        reason: '복귀가 사라지면 이 수정이 R12를 깬 것이다',
      );
      expect(pending.hasDestination, isFalse, reason: '한 번 쓰면 비워진다');
    });

    test('미충족 중에도 설정 계열로 빠져나갈 수 있다', () {
      final PendingDestination pending = PendingDestination();
      redirectAt('/home', TermsGateState.unmet, pending);

      // 로그아웃·탈퇴가 여기 있어서 막히면 빠져나갈 길이 없다.
      expect(redirectAt(settingsPath, TermsGateState.unmet, pending), isNull);
      expect(
        redirectAt('/settings/terms', TermsGateState.unmet, pending),
        isNull,
      );
    });

    test('게이트를 통과한 뒤에는 푸시 목적지를 꺼낸다 (AC17.2)', () {
      // 이 수정이 SPEC-0028의 소비 경로까지 막지 않았는지 확인한다.
      final PendingDestination pending = PendingDestination()
        ..rememberIfAbsent('/conversations/42');

      expect(
        redirectAt('/home', TermsGateState.satisfied, pending),
        '/conversations/42',
      );
    });
  });
}
