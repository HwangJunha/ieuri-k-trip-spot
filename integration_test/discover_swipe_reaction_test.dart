import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/permission/provider/permission_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/secure_storage.dart';
import 'package:ieuri_k_trip_spot/domain/auth/provider/auth_repository_provider.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/auth_test_doubles.dart';
import 'support/pump_until.dart';
import 'support/spot_swipe_test_doubles.dart';

/// 여정 #2 (통합 테스트 — 위젯 트리 안에 머무름): 위치 권한이 이미 허용된 상태에서
/// 시작 → Discover 탭으로 이동 → 맨 위 카드를 오른쪽(LIKE)으로 스와이프 → 맨 위
/// 카드가 사라지고 다음 카드가 올라오는지, 그리고 낙관적 반응 기록(reactToSpot)이
/// 발사됐는지 확인한다.
///
/// 시작 상태(격리, e2e-flow-testing skill §7): 언어 선택 완료 + 인증 완료 +
/// 온보딩 완료 + 위치 권한 허용을 명시적으로 세운다. 인증은 실제
/// `AuthController._restoreSession` 로직이 그대로 돌게 시크릿 저장소를 미리 채워
/// 세운다(로그인 UI를 거치지 않되, 컨트롤러/라우터 가드는 실제 코드 그대로). 이
/// 여정은 로그인/권한 다이얼로그 자체를 검증하지 않는다(그건 여정 #1의 몫) —
/// 스와이프 → 반응 → 다음 카드 전환만 검증한다. 카드 스택은 controlled 응답
/// (FakeSpotRepository)을 쓴다(e2e-flow-testing skill §6 — 기본은 controlled,
/// 실서버는 스모크 하나로 충분).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'a user who swipes the top card right sees it replaced by the next card, '
    'and the reaction is recorded',
    (WidgetTester tester) async {
      final FakeSpotRepository repo = FakeSpotRepository(feed: swipeSpots(3));
      final SecureStorage secure = await seededAuthenticatedStorage();

      SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            secureStorageProvider.overrideWithValue(secure),
            authRepositoryProvider.overrideWithValue(
              const FixedMeAuthRepository(),
            ),
            spotRepositoryProvider.overrideWithValue(repo),
            locationServiceProvider.overrideWithValue(
              const FixedLocationService(),
            ),
            permissionServiceProvider.overrideWithValue(
              const GrantedPermissionService(),
            ),
          ],
          child: const KTripSpotApp(),
        ),
      );

      // 콜드 스타트: 스플래시가 최소 브랜드 노출 시간을 채우고, 언어/인증/온보딩이
      // 이미 세팅돼 있으므로 라우터가 곧장 홈(5탭 셸)까지 밀어준다. 진행 바가
      // 계속 도는 스플래시는 pumpAndSettle이 끝나지 않으니, 하단 내비가 뜰 때까지
      // 조건부로 pump한다.
      await tester.pumpUntil(
        () =>
            find.byKey(const Key('bottom_nav_discover')).evaluate().isNotEmpty,
        timeout: const Duration(seconds: 15),
      );

      // Discover 탭으로 이동 (키로 타겟팅 — 라벨은 로케일마다 다르다).
      await tester.tap(find.byKey(const Key('bottom_nav_discover')));
      await tester.pumpAndSettle();

      // 첫 카드가 뜰 때까지 대기(고정 시간이 아니라 위젯 등장 조건). 카드 스택은
      // 맨 위 카드 아래 다음 카드도 미리 깔아 둔다(스케일업 애니메이션용, spec §3)
      // — 그래서 s1이 이 시점에 이미 트리에 있는 건 정상이며, s0가 맨 위(활성
      // 드래그 대상)인지가 검증 포인트다.
      await tester.pumpUntilFinder(find.byKey(const ValueKey<String>('s0')));

      expect(find.byKey(const ValueKey<String>('s0')), findsOneWidget);

      // 맨 위 카드를 카드 폭 이상 오른쪽으로 드래그(LIKE 확정 임계값 28% 초과).
      final Offset start = tester.getCenter(
        find.byKey(const ValueKey<String>('s0')),
      );
      final TestGesture gesture = await tester.startGesture(start);
      await gesture.moveBy(const Offset(220, 0));
      await tester.pump();
      await gesture.moveBy(const Offset(220, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // 맨 위 카드가 제거되고 다음 카드가 올라온다.
      expect(find.byKey(const ValueKey<String>('s0')), findsNothing);
      expect(find.byKey(const ValueKey<String>('s1')), findsOneWidget);

      // 낙관적 기록: reactToSpot이 비동기 발사됐는지 확인(카드 제거는 이미 확정,
      // 여기서는 발사 여부만 조건 대기로 확인한다 — 고정 시간 대기 없이).
      await tester.pumpUntil(() => repo.recordedReactions.isNotEmpty);
      expect(repo.recordedReactions.single.$1, 's0');
    },
  );
}
