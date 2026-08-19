import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/navigation/pending_destination.dart';
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
      );

      expect(target, splashPath);
    });

    test('미인증이면 로그인으로 보낸다 (AC17.3)', () {
      final String? target = resolveGate(
        location: '/conversations/42',
        languageChosen: true,
        auth: AuthGateState.unauthenticated,
        terms: TermsGateState.satisfied,
      );

      expect(target, loginPath);
    });

    test('미인증 상태의 로그인 화면은 통과다 — 여기서 꺼내면 안 된다', () {
      final String? target = resolveGate(
        location: loginPath,
        languageChosen: true,
        auth: AuthGateState.unauthenticated,
        terms: TermsGateState.satisfied,
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
      );

      expect(target, isNull);
    });

    test('알림 설정 화면은 미동의 상태에서도 열린다', () {
      final String? target = resolveGate(
        location: '/settings/notifications',
        languageChosen: true,
        auth: AuthGateState.ready,
        terms: TermsGateState.unmet,
      );

      expect(
        target,
        isNull,
        reason: '설정 계열은 약관 게이트가 열어 둔다',
      );
    });
  });
}
