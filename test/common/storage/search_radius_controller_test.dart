import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/search_radius_controller.dart';
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

  /// 0km는 뜻이 서지 않는다(반경 0인 검색). 최소 1km로 잘린다
  /// (사용자 지적 2026-09-19).
  test('0km를 고르면 최소값으로 잘린다', () async {
    final ProviderContainer container = await _container();

    await container.read(searchRadiusControllerProvider.notifier).select(0);

    expect(
      container.read(searchRadiusControllerProvider),
      AppPreferences.minSearchRadiusKm,
    );
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

    expect(
      container.read(searchRadiusControllerProvider),
      AppPreferences.minSearchRadiusKm,
    );
  });

  // Discover 빈 상태의 "반경 넓히기"가 쓰는 동작. 예전에는 이 버튼이 빈 콜백이라
  // 눌러도 아무 일이 없었다.
  group('반경 넓히기', () {
    test('한 단계 넓힌다', () async {
      final ProviderContainer container = await _container(
        initial: <String, Object>{'search_radius_km': 20.0},
      );

      final bool widened = await container
          .read(searchRadiusControllerProvider.notifier)
          .widen();

      expect(widened, isTrue);
      expect(container.read(searchRadiusControllerProvider), 30);
    });

    test('넓힌 값이 저장돼 복원된다', () async {
      final ProviderContainer container = await _container(
        initial: <String, Object>{'search_radius_km': 20.0},
      );

      await container.read(searchRadiusControllerProvider.notifier).widen();

      expect(container.read(appPreferencesProvider).searchRadiusKm, 30);
    });

    // 0km는 "현재 위치만"이라 한 단계(10km)보다 기본값 복귀가 예측 가능하다.
    /// 낡은 저장값이 0이어도 읽을 때 최소값으로 잘리므로, 거기서 한 단계 넓힌다.
    test('낡은 0km 저장값에서도 한 단계 넓힌다', () async {
      final ProviderContainer container = await _container(
        initial: <String, Object>{'search_radius_km': 0.0},
      );

      await container.read(searchRadiusControllerProvider.notifier).widen();

      expect(
        container.read(searchRadiusControllerProvider),
        AppPreferences.minSearchRadiusKm + searchRadiusStepKm,
      );
    });

    test('상한을 넘지 않는다', () async {
      final ProviderContainer container = await _container(
        initial: <String, Object>{'search_radius_km': 95.0},
      );

      await container.read(searchRadiusControllerProvider.notifier).widen();

      expect(container.read(searchRadiusControllerProvider), 100);
    });

    // 상한에서 조용히 아무 일도 안 하면 화면이 "고장 났다"와 구분하지 못한다.
    test('이미 상한이면 false를 돌려준다', () async {
      final ProviderContainer container = await _container(
        initial: <String, Object>{'search_radius_km': 100.0},
      );

      final bool widened = await container
          .read(searchRadiusControllerProvider.notifier)
          .widen();

      expect(widened, isFalse);
      expect(container.read(searchRadiusControllerProvider), 100);
    });
  });
}
