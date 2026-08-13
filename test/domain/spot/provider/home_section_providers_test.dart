import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/location_providers.dart';
import 'package:ieuri_k_trip_spot/common/storage/app_preferences.dart';
import 'package:ieuri_k_trip_spot/common/storage/search_radius_controller.dart';
import 'package:ieuri_k_trip_spot/domain/event/model/festival.dart';
import 'package:ieuri_k_trip_spot/domain/event/provider/event_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/popular_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/home_section_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot/provider/spot_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../event/event_test_doubles.dart';
import '../spot_test_doubles.dart';

/// 홈 세 섹션의 provider 테스트(SPEC-0013 R15·R16·R19·R20).
void main() {
  // 반경 컨트롤러가 SharedPreferences를 동기로 읽으므로 바인딩과 목 값이 필요하다.
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer makeContainer({
    FakeSpotRepository? spotRepository,
    FakeEventRepository? eventRepository,
  }) {
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        locationServiceProvider.overrideWithValue(FakeLocationService()),
        spotRepositoryProvider.overrideWithValue(
          spotRepository ?? FakeSpotRepository(),
        ),
        if (eventRepository != null)
          eventRepositoryProvider.overrideWithValue(eventRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Near you (R16)', () {
    test('AC-15.1 · 서버 응답으로 섹션 상태를 구성한다', () async {
      final container = makeContainer(
        spotRepository: FakeSpotRepository(
          feed: <TouristSpot>[homeSpot('a'), homeSpot('b')],
          pageSize: 10,
        ),
      );

      final List<TouristSpot> spots = await container.read(
        nearbySpotsSectionProvider.future,
      );

      expect(spots.map((TouristSpot s) => s.id), <String>['a', 'b']);
    });

    test('AC-16.1 · 설정된 반경을 인자로 조회한다', () async {
      await prefs.setDouble('search_radius_km', 30);
      final repository = FakeSpotRepository(
        feed: <TouristSpot>[homeSpot('a')],
        pageSize: 10,
      );
      final container = makeContainer(spotRepository: repository);

      await container.read(nearbySpotsSectionProvider.future);

      expect(repository.requestedRadiiMeters.single, 30000);
    });

    test('AC-16.2 · 반경이 바뀌면 다음 조회에 반영된다', () async {
      final repository = FakeSpotRepository(
        feed: <TouristSpot>[homeSpot('a')],
        pageSize: 10,
      );
      final container = makeContainer(spotRepository: repository);
      await container.read(nearbySpotsSectionProvider.future);

      await container.read(searchRadiusControllerProvider.notifier).select(50);
      await container.read(nearbySpotsSectionProvider.future);

      expect(repository.requestedRadiiMeters.last, 50000);
    });

    test('AC-16.3 · 반경 내 spot이 없으면 빈 상태다', () async {
      final container = makeContainer(
        spotRepository: FakeSpotRepository(feed: const <TouristSpot>[]),
      );

      final List<TouristSpot> spots = await container.read(
        nearbySpotsSectionProvider.future,
      );

      expect(spots, isEmpty);
    });
  });

  group('Popular (R18)', () {
    test('AC-18.1 · 서버가 준 순서를 그대로 쓴다', () async {
      // 정렬은 계약이다(POL-019) — 클라이언트가 likeCount로 다시 정렬하지 않는다.
      // 서버가 일부러 뒤섞어 줬다고 가정해도 순서가 보존되어야 한다.
      final repository = FakeSpotRepository()
        ..popular = <PopularSpot>[
          PopularSpot(spot: homeSpot('a'), likeCount: 12),
          PopularSpot(spot: homeSpot('b'), likeCount: 99),
        ];
      final container = makeContainer(spotRepository: repository);

      final List<PopularSpot> items = await container.read(
        popularSpotsSectionProvider.future,
      );

      expect(items.map((PopularSpot p) => p.spot.id), <String>['a', 'b']);
      expect(items.first.likeCount, 12);
    });

    test('AC-18.4 · 조건을 만족하는 spot이 없으면 빈 상태다', () async {
      final container = makeContainer(spotRepository: FakeSpotRepository());

      expect(await container.read(popularSpotsSectionProvider.future), isEmpty);
    });

    test('설정된 반경을 인자로 조회한다', () async {
      await prefs.setDouble('search_radius_km', 30);
      final repository = FakeSpotRepository()
        ..popular = <PopularSpot>[
          PopularSpot(spot: homeSpot('a'), likeCount: 12),
        ];
      final container = makeContainer(spotRepository: repository);

      await container.read(popularSpotsSectionProvider.future);

      expect(repository.popularRadiiMeters.single, 30000);
    });
  });

  group('Happening Now (R17)', () {
    test('AC-17.4 · 진행 중 축제가 0건이면 빈 상태다', () async {
      final container = makeContainer(
        eventRepository: FakeEventRepository(festivals: const <Festival>[]),
      );

      expect(await container.read(happeningNowEventsProvider.future), isEmpty);
    });

    test('설정된 반경을 인자로 조회한다', () async {
      await prefs.setDouble('search_radius_km', 30);
      final eventRepository = FakeEventRepository();
      final container = makeContainer(eventRepository: eventRepository);

      await container.read(happeningNowEventsProvider.future);

      expect(eventRepository.lastRadiusMeters, 30000);
    });
  });

  group('섹션 독립성 (R19·R20)', () {
    test('AC-19.1 · 한 섹션이 실패해도 나머지는 정상이다', () async {
      final container = makeContainer(
        spotRepository: FakeSpotRepository(pageFailure: SpotFailure.network),
        // Happening Now도 페이크를 준다 — 없으면 실제 GraphQL 클라이언트로 나가
        // `secureStorageProvider` 미오버라이드에서 죽는다(SPEC-0013로 event가
        // 실데이터가 되면서 생긴 새 요구다).
        eventRepository: FakeEventRepository(festivals: const <Festival>[]),
      );
      // Near you는 실패한다.
      //
      // **`.future`를 await 하지 않는다** — 오류 상태의 Future를 붙잡으면 완결되지
      // 않고 30초 타임아웃까지 매달린다(CLAUDE.md §8). 상태 자체를 관찰한다.
      // 구독은 autoDispose provider가 조회 도중 폐기되는 것도 함께 막는다.
      final completer = Completer<void>();
      container.listen(nearbySpotsSectionProvider, (
        _,
        AsyncValue<List<TouristSpot>> next,
      ) {
        // Riverpod 3은 실패를 `AsyncLoading(error: …)`로 실어 보내며 이때
        // `isLoading`이 **여전히 true다**. `isLoading`으로 기다리면 영원히
        // 완결되지 않는다 — 실측으로 확인한 동작이라 `hasError`로 판정한다.
        if ((next.hasError || next.hasValue) && !completer.isCompleted) {
          completer.complete();
        }
      }, fireImmediately: true);
      await completer.future;

      expect(container.read(nearbySpotsSectionProvider).hasError, isTrue);

      // 나머지 두 섹션은 그 실패와 무관하게 **자기 상태를 갖는다** — 한 섹션의
      // 실패가 다른 섹션으로 번지지 않는다는 것이 이 단언의 뜻이다.
      expect(await container.read(popularSpotsSectionProvider.future), isEmpty);
      expect(await container.read(happeningNowEventsProvider.future), isEmpty);
    });

    test('AC-20.1·20.2 · 재시도는 그 섹션만 다시 조회한다', () async {
      final repository = FakeSpotRepository(
        feed: <TouristSpot>[homeSpot('a')],
        pageSize: 10,
        pageFailure: SpotFailure.network,
        // 첫 호출만 실패하고 두 번째부터 성공한다.
        failPageTimes: 1,
      );
      final container = makeContainer(
        spotRepository: repository,
        eventRepository: FakeEventRepository(festivals: const <Festival>[]),
      );

      // 첫 조회는 실패한다. 오류 Future를 붙잡지 않도록 상태로 기다린다(위와 동일).
      final failed = Completer<void>();
      final sub = container.listen(nearbySpotsSectionProvider, (
        _,
        AsyncValue<List<TouristSpot>> next,
      ) {
        if ((next.hasError || next.hasValue) && !failed.isCompleted) {
          failed.complete();
        }
      }, fireImmediately: true);
      await failed.future;
      expect(container.read(nearbySpotsSectionProvider).hasError, isTrue);

      // 다른 섹션을 한 번 읽어 두고, 재시도 후에도 다시 불리지 않는지 본다.
      await container.read(popularSpotsSectionProvider.future);

      // 재시도 — 이 섹션의 provider 하나만 무효화한다(AC-20.1).
      container.invalidate(nearbySpotsSectionProvider);
      final List<TouristSpot> spots = await container.read(
        nearbySpotsSectionProvider.future,
      );
      sub.close();

      expect(spots.single.id, 'a');
      // Near you만 두 번 조회됐다 — 재시도가 다른 섹션을 건드리지 않았다.
      expect(repository.spotPageCallCount, 2);
    });
  });
}
