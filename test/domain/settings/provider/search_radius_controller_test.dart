import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/domain/settings/provider/search_radius_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SPEC-0011 R13 — 반경 설정 저장·복원. 서버가 아니라 로컬 저장소가 진실이다.

Future<ProviderContainer> _container({Map<String, Object>? initial}) async {
  SharedPreferences.setMockInitialValues(initial ?? <String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ProviderContainer container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('저장된 적이 없으면 기본값 20km다', () async {
    final ProviderContainer container = await _container();

    expect(container.read(searchRadiusControllerProvider), 20);
  });

  test('저장하면 그 값이 복원된다', () async {
    final ProviderContainer container = await _container();

    await container.read(searchRadiusControllerProvider.notifier).select(45);

    expect(container.read(searchRadiusControllerProvider), 45);
  });

  test('0km는 유효값이라 기본값으로 되돌아가지 않는다', () async {
    // R13 네 번째 기준 — 0은 "현재 위치만"을 뜻하며 미설정과 다르다.
    final ProviderContainer container = await _container();

    await container.read(searchRadiusControllerProvider.notifier).select(0);

    expect(container.read(searchRadiusControllerProvider), 0);
  });

  test('새 컨테이너에서도 저장된 값을 읽는다', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProviderContainer first = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    await first.read(searchRadiusControllerProvider.notifier).select(7);
    first.dispose();

    final ProviderContainer second = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(second.dispose);

    expect(second.read(searchRadiusControllerProvider), 7);
  });

  test('범위를 벗어난 저장값은 경계로 잘린다', () async {
    // 이전 버전이 다른 범위로 저장했거나 저장소가 손상돼도 슬라이더가 죽지 않아야
    // 한다 — Slider는 min~max 밖의 value를 assert로 거부한다.
    final ProviderContainer container = await _container(
      initial: <String, Object>{'search_radius_km': 500.0},
    );

    expect(container.read(searchRadiusControllerProvider), 100);
  });

  test('범위 밖 선택도 경계로 잘려 저장된다', () async {
    final ProviderContainer container = await _container();

    await container.read(searchRadiusControllerProvider.notifier).select(-10);

    expect(container.read(searchRadiusControllerProvider), 0);
  });
}
