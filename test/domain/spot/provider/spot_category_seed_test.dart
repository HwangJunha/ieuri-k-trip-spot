import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/liked_spots_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/view/liked_spots_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// 기본값 심기가 **빌드를 깨뜨리지 않는지** 지킨다(SPEC-0020 R4).
///
/// 회귀 대상: 가용 목록이 **이미 캐시된 상태로 화면이 열리면** `build` 안에서
/// 곧바로 `state =`가 실행되어 "Tried to modify a provider while the widget tree
/// was building"으로 화면이 빨갛게 떴다. 지도·좋아요 첫 진입에서 실제로 터졌고,
/// 두 번째 진입은 이미 선택이 차 있어 `seedDefault`가 조기 반환하는 바람에
/// 멀쩡해 보여 놓치기 쉬웠다.
///
/// 기존 화면 테스트들이 이걸 못 잡은 이유는 매번 새 컨테이너로 시작해 목록이
/// 비어 있었기 때문이다 — `listen` 경로만 타면 문제가 드러나지 않는다.
void main() {
  Future<SharedPreferences> prefs() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{'locale': 'en'});
    return SharedPreferences.getInstance();
  }

  testWidgets('목록이 이미 캐시된 뒤에 화면이 열려도 빌드 중 provider를 고치지 않는다', (
    WidgetTester tester,
  ) async {
    final SharedPreferences p = await prefs();
    final FakeSpotRepository repo = FakeSpotRepository(
      categories: const <SpotCategory>[catRestaurant, catTouristSpot],
    );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(p),
        spotRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    // **화면을 띄우기 전에 목록을 먼저 채운다** — 실제 앱에서 탭을 오가거나 다른
    // 화면이 이미 목록을 받아 둔 상태에 해당한다. 이 사전 로드가 회귀의 조건이다.
    await container.read(availableSpotCategoriesProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: LikedSpotsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 빌드 중 수정이면 여기서 예외가 잡힌다.
    expect(tester.takeException(), isNull);

    // 심기 자체는 여전히 동작해야 한다 — 예외를 피하려고 심기를 걸러 버리면
    // 아무 칩도 선택되지 않은 화면이 된다(AC4.1).
    expect(
      container.read(selectedLikedCategoryProvider).map((c) => c.code).toSet(),
      <String>{kDefaultSpotCategoryCode},
    );
  });
}
