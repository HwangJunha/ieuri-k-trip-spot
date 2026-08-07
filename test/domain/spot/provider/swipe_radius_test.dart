import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/search_radius_controller.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/swipe_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../spot_test_doubles.dart';

/// SPEC-0011 R13 — 설정한 검색 반경이 **실제 조회에 실린다.**
///
/// 저장·복원만 검증하던 시절에는 전부 통과하면서도 Discover는 늘 서버 기본값으로
/// 조회했다. 값이 저장되는 것과 그 값이 쓰이는 것은 다른 문제다.

Future<ProviderContainer> _container(
  FakeSpotRepository repo, {
  double? radiusKm,
}) async {
  SharedPreferences.setMockInitialValues(
    radiusKm == null ? <String, Object>{} : <String, Object>{
      'search_radius_km': radiusKm,
    },
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ProviderContainer container = ProviderContainer(
    overrides: [
      spotRepositoryProvider.overrideWithValue(repo),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> _load(ProviderContainer container) async {
  container.listen(swipeControllerProvider(null), (_, _) {},
      fireImmediately: true);
  await container.read(swipeControllerProvider(null).future);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('설정한 반경이 미터로 조회에 실린다', () async {
    final FakeSpotRepository repo = FakeSpotRepository();
    final ProviderContainer container = await _container(repo, radiusKm: 1);

    await _load(container);

    expect(repo.requestedRadiiMeters, <int?>[1000]);
  });

  test('저장한 적 없으면 기본 20km가 실린다', () async {
    final FakeSpotRepository repo = FakeSpotRepository();
    final ProviderContainer container = await _container(repo);

    await _load(container);

    expect(repo.requestedRadiiMeters, <int?>[20000]);
  });

  // 0km는 "현재 위치만"을 뜻하지 **빈 결과**가 아니다(R13 네 번째 기준). 반경 0인
  // 원을 보내면 아무것도 안 걸리므로 인자를 빼고 서버 기본값·거리순에 맡긴다.
  test('0km는 반경 인자를 보내지 않는다', () async {
    final FakeSpotRepository repo = FakeSpotRepository();
    final ProviderContainer container = await _container(repo, radiusKm: 0);

    await _load(container);

    expect(repo.requestedRadiiMeters, <int?>[null]);
  });

  // 사용자가 보고한 증상: 반경을 바꿔도 Discover에 새 데이터가 안 들어왔다.
  // 값을 watch하지 않으면 재빌드 계기가 없어 옛 카드가 그대로 남는다.
  test('반경을 바꾸면 피드를 다시 받는다', () async {
    final FakeSpotRepository repo = FakeSpotRepository();
    final ProviderContainer container = await _container(repo, radiusKm: 50);
    await _load(container);
    expect(repo.requestedRadiiMeters, <int?>[50000]);

    await container.read(searchRadiusControllerProvider.notifier).select(1);
    await container.read(swipeControllerProvider(null).future);

    expect(
      repo.requestedRadiiMeters,
      <int?>[50000, 1000],
      reason: '새 반경으로 다시 조회해야 한다',
    );
  });

  test('반경 단위 변환은 km→m다', () {
    expect(radiusMetersOf(1), 1000);
    expect(radiusMetersOf(20), 20000);
    expect(radiusMetersOf(100), 100000);
    expect(radiusMetersOf(0), isNull);
  });
}
