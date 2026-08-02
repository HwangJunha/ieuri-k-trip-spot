import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/discover_screen.dart';
import 'package:integration_test/integration_test.dart';

import 'support/app_boot_harness.dart';
import 'support/auth_test_doubles.dart';
import 'support/pump_until.dart';

/// SPEC-0005 여정: 부팅 시 인증 게이트.
///
/// 스펙 §4가 "실기기·에뮬레이터 확인이 필요한 것"으로 분류한 두 가지를 실제 앱
/// 부팅으로 확인한다 — 렌더링 차단(AC-1·AC-35)과 부팅 경로(AC-33·AC-34). 단위
/// 테스트는 게이트 로직을 프레임 단위로 닫지만, 스플래시 전환과 함께 앱이 실제로
/// 어디에 도달하는지는 부팅을 태워야 보인다.
///
/// 시작 상태는 [bootAppWith]가 세운다(언어 선택 완료 + 위치 권한 허용 + 저장된
/// 세션). 인증 흐름 자체가 검증 대상이므로 auth repository만 여정별로 바꾼다.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('만료된 세션으로 부팅해도 갱신이 선행되어 로그인 화면 없이 Discover에 도달한다', (
    WidgetTester tester,
  ) async {
    final ExpiredAccessTokenAuthRepository repo =
        ExpiredAccessTokenAuthRepository();
    final SecureStorage storage = await seededAuthenticatedStorage();
    await bootAppWith(tester, storage: storage, authRepo: repo);

    // 부팅 도중 보호 화면이 잠깐이라도 뜨면 안 된다(AC-1). 상태를 잠시라도
    // unauthenticated로 넘기면 라우터가 로그인으로 보내므로, 그 회귀도 함께 잡는다.
    await tester.pump();
    expect(
      find.byType(DiscoverScreen),
      findsNothing,
      reason: '인증이 해소되기 전에는 보호 화면이 열리지 않는다',
    );

    // 하단 내비가 뜰 때까지 조건부 대기 — 스플래시 진행 바가 계속 돌기 때문에
    // pumpAndSettle은 끝나지 않는다.
    await tester.pumpUntil(
      () => find.byKey(const Key('bottom_nav_discover')).evaluate().isNotEmpty,
      timeout: const Duration(seconds: 20),
    );

    expect(find.byType(DiscoverScreen), findsOneWidget);
    expect(repo.renewCalls, hasLength(1), reason: '갱신이 선행됐다');

    // 새 값이 함께 기록되고 이전 값이 남지 않는다(R12, AC-30).
    final StoredSession stored = await readStoredSession(storage);
    expect(stored.access, 'e2e-access-2');
    expect(stored.refresh, 'e2e-refresh-2');
  });

  testWidgets('부팅 중 네트워크가 끊겨 갱신이 실패하면 보호 화면을 열지 않고 저장값을 유지한다', (
    WidgetTester tester,
  ) async {
    final ExpiredAccessTokenAuthRepository repo =
        ExpiredAccessTokenAuthRepository(renewSucceeds: false);
    final SecureStorage storage = await seededAuthenticatedStorage();
    await bootAppWith(tester, storage: storage, authRepo: repo);

    await tester.pumpUntil(
      () => repo.renewCalls.isNotEmpty,
      timeout: const Duration(seconds: 20),
    );
    await tester.pump();

    // 인증이 미해소인 동안 보호 화면(홈)이 렌더링되면 안 된다(AC-1·AC-35).
    // `spots`가 인증 없이도 데이터를 반환하므로, 게이트가 새면 화면이 정상처럼
    // 채워져 결함이 눈에 띄지 않는다 — 그래서 이 확인이 필요하다.
    expect(
      find.byType(DiscoverScreen),
      findsNothing,
      reason: '미인증 상태에서 보호 화면이 열리면 게이트가 샌 것이다',
    );

    // R10 — 전송 실패에서는 저장된 값을 지우지 않는다. 복구 후 재시도 시 이 값으로
    // 갱신이 성공해야 한다(AC-29).
    final StoredSession stored = await readStoredSession(storage);
    expect(stored.refresh, 'e2e-refresh');
  });
}
