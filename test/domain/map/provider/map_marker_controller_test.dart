import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_bounds.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_failure.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_marker.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_tuning.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_recommendation_result.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_viewport_result.dart';
import 'package:ieuri_k_trip_spot/domain/map/provider/map_marker_controller.dart';
import 'package:ieuri_k_trip_spot/domain/map/provider/map_providers.dart';
import 'package:ieuri_k_trip_spot/domain/map/repository/map_repository.dart';

/// 지도 마커 누적 규칙. 화면을 옮겨도 보고 있던 장소가 사라지지 않아야 하고,
/// 검색으로 찾은 곳은 어떤 경우에도 남아야 한다.
/// 정해진 추천 결과만 답하는 repository. 나머지 연산은 이 테스트가 건드리지 않는다.
final class FakeMapRepository implements MapRepository {
  FakeMapRepository(this.markers, {this.exhausted = false, this.failure});

  final List<MapMarker> markers;
  final bool exhausted;

  /// 던지게 할 오류. 서버에 아직 배포되지 않은 필드를 부르는 상황을 세운다.
  final Object? failure;

  List<String>? lastExcluded;
  int? lastFirst;
  MapBounds? lastBbox;

  @override
  Future<MapRecommendationResult> fetchRecommendedSpots({
    required MapBounds bbox,
    required List<String> excludedIds,
    int? first,
  }) async {
    lastBbox = bbox;
    lastExcluded = excludedIds;
    lastFirst = first;
    if (failure != null) throw failure!;
    return MapRecommendationResult(markers: markers, exhausted: exhausted);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

/// 좁은 범위에 몰린 [total]곳. 격자가 칸마다 하나만 남기므로, 솎인 것을 기억하지
/// 않으면 같은 추천이 계속 되돌아온다.
final class FakeDenseRepository implements MapRepository {
  FakeDenseRepository(this.total);

  final int total;

  @override
  Future<MapRecommendationResult> fetchRecommendedSpots({
    required MapBounds bbox,
    required List<String> excludedIds,
    int? first,
  }) async {
    final List<MapMarker> all = <MapMarker>[
      for (int i = 0; i < total; i++)
        MapMarker(
          id: 'v$i',
          name: 'v$i',
          latitude: 37.5060 + (i % 25) * 0.00035,
          longitude: 127.0060 + (i ~/ 25) * 0.0011,
          kind: MapMarkerKind.spot,
        ),
    ];
    final List<MapMarker> take = all
        .where((MapMarker m) => !excludedIds.contains(m.id))
        .take(first ?? 10)
        .toList();
    return MapRecommendationResult(
      markers: take,
      exhausted: take.length < (first ?? 10),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

/// 요청한 bbox 안에 고르게 후보를 두는 서버. 조회 영역과 화면이 다르면 받은 것이
/// 화면 밖일 수 있다는 점을 드러낸다.
final class FakeBoundsRepository implements MapRepository {
  @override
  Future<MapRecommendationResult> fetchRecommendedSpots({
    required MapBounds bbox,
    required List<String> excludedIds,
    int? first,
  }) async {
    final List<MapMarker> all = <MapMarker>[
      for (int i = 0; i < 200; i++)
        MapMarker(
          id: '${bbox.minLat.toStringAsFixed(3)}_$i',
          name: 'v$i',
          latitude: bbox.minLat + (i % 20) * bbox.latSpan / 20,
          longitude: bbox.minLng + (i ~/ 20) * bbox.lngSpan / 20,
          kind: MapMarkerKind.spot,
        ),
    ];
    final List<MapMarker> take = all
        .where((MapMarker m) => !excludedIds.contains(m.id))
        .take(first ?? 10)
        .toList();
    return MapRecommendationResult(
      markers: take,
      exhausted: take.length < (first ?? 10),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  const MapBounds visible = MapBounds(
    minLat: 37.50,
    minLng: 127.00,
    maxLat: 37.52,
    maxLng: 127.02,
  );

  MapMarker markerAt(String id, double lat, double lng) => MapMarker(
    id: id,
    name: id,
    latitude: lat,
    longitude: lng,
    kind: MapMarkerKind.spot,
  );

  /// 화면 안에 골고루 흩어진 마커 [count]개.
  MapViewportResult resultOf(int count) => MapViewportResult(
    markers: <MapMarker>[
      for (int i = 0; i < count; i++)
        markerAt('m$i', 37.505 + (i % 5) * 0.003, 127.005 + (i ~/ 5) * 0.003),
    ],
    truncated: false,
  );

  ProviderContainer container() {
    final ProviderContainer c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  /// 격자와 상한을 걷어냈다(사용자 결정 2026-09-18) — 받은 추천은 전부 그린다.
  /// 골라내던 시절에는 10개를 받아 서너 개만 남아 화면이 비어 보였다.
  test('받은 추천을 전부 더한다', () {
    final ProviderContainer c = container();
    // 픽스처는 화면 안에 30개까지 놓는다 — 그 밖은 애초에 그릴 대상이 아니다.
    c.read(mapMarkerControllerProvider.notifier).absorb(resultOf(30), visible);

    expect(c.read(mapMarkerControllerProvider), hasLength(30));
  });

  /// 지도를 옮길 때마다 통째로 갈아 끼우면 보고 있던 장소가 사라졌다 나타나 화면이
  /// 깜빡인다.
  test('두 번째 흡수에도 이전 마커가 남는다', () {
    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    controller.absorb(resultOf(3), visible);
    final List<MapMarker> first = c.read(mapMarkerControllerProvider);

    controller.absorb(resultOf(6), visible);
    final List<MapMarker> second = c.read(mapMarkerControllerProvider);

    for (final MapMarker m in first) {
      expect(second.contains(m), isTrue, reason: '${m.id}가 사라졌다');
    }
  });

  /// SPEC-0036 AC-015. 「이 지역 재검색」은 화면을 갈아 끼우지 않고 **더한다**.
  test('다시 흡수하면 앞선 장소를 두고 새 장소가 더해진다', () {
    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    controller.absorb(resultOf(10), visible);
    final List<String> first = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .toList();
    expect(first, hasLength(10));

    controller.absorb(resultOf(20), visible);
    final List<String> second = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .toList();

    expect(second, hasLength(20), reason: '교체가 아니라 누적이어야 한다');
    expect(second.take(first.length), first, reason: '처음 것이 그대로 남는다');
  });

  /// SPEC-0036 AC-004. 이 세션에서 이미 표시한 장소는 다시 후보가 되지 않는다.
  test('이미 표시한 장소는 다음 묶음에 없다', () {
    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    controller.absorb(resultOf(10), visible);
    final Set<String> first = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .toSet();

    controller.absorb(resultOf(20), visible);
    final List<String> added = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .skip(first.length)
        .toList();

    expect(added, isNotEmpty);
    for (final String id in added) {
      expect(first.contains(id), isFalse, reason: '$id를 또 보여 줬다');
    }
  });

  /// SPEC-0036 AC-002·QR-001. 셔플을 없앴으므로 같은 입력은 같은 결과를 준다.
  test('같은 조건으로 두 번 계산하면 순서가 같다', () {
    List<String> pick() {
      final ProviderContainer c = container();
      c
          .read(mapMarkerControllerProvider.notifier)
          .absorb(resultOf(50), visible);
      return c
          .read(mapMarkerControllerProvider)
          .map((MapMarker m) => m.id)
          .toList();
    }

    expect(pick(), pick(), reason: '무작위 요소가 남아 있다');
  });

  /// SPEC-0036 AC-008. 더할 새 장소가 없으면 그 사실을 알린다 — 호출자가 「더 보기」
  /// 수단을 거두는 근거다. 이미 표시된 것은 그대로 남는다.
  test('더할 새 장소가 없으면 false를 주고 표시된 것은 남는다', () {
    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    // 후보를 다 소비할 때까지 흡수한다. 격자가 칸마다 하나만 남기므로 한 번에
    // 몇 개가 들어갈지는 후보의 배치에 달렸다 — 「더 이상 안 들어간다」까지 민다.
    final MapViewportResult candidates = resultOf(12);
    while (controller.absorb(candidates, visible)) {}

    final List<MapMarker> shown = c.read(mapMarkerControllerProvider);
    expect(shown, isNotEmpty, reason: '후보를 하나도 못 넣었다');

    expect(
      controller.absorb(candidates, visible),
      isFalse,
      reason: '같은 후보를 또 더할 수 있다고 한다',
    );
    expect(c.read(mapMarkerControllerProvider), shown, reason: '표시가 지워졌다');
  });

  /// SPEC-0036 AC-006. 영역을 옮겨도 표시 기록은 유지된다 — 앞 영역에서 본 장소가
  /// 새 영역에도 있으면 다시 고르지 않는다.
  test('영역을 옮겨도 앞서 본 장소는 다시 나오지 않는다', () {
    const MapBounds neighbour = MapBounds(
      minLat: 37.51,
      minLng: 127.01,
      maxLat: 37.53,
      maxLng: 127.03,
    );

    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    controller.absorb(resultOf(30), visible);
    final Set<String> seen = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .toSet();

    // 겹치는 영역을 같은 후보로 조회한다.
    controller.absorb(resultOf(30), neighbour);
    final List<String> added = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .skip(seen.length)
        .toList();

    for (final String id in added) {
      expect(seen.contains(id), isFalse, reason: '$id가 새 영역에서 또 나왔다');
    }
  });

  /// SPEC-0036 FR-012. 문화행사는 이 변경의 대상이 아니라 기존대로 표시된다.
  ///
  /// 제외 목록에 넣으면 재검색 한 번에 행사가 지도에서 영구히 사라지고, 아무것도
  /// 견주지 않으면 같은 행사가 쌓여 같은 자리에 핀이 겹쳐 박힌다 — 양쪽 다 틀렸다.
  group('문화행사 (FR-012)', () {
    MapViewportResult eventResult() => MapViewportResult(
      markers: <MapMarker>[
        MapMarker(
          id: 'e1',
          name: 'e1',
          latitude: 37.51,
          longitude: 127.01,
          kind: MapMarkerKind.culturalEvent,
        ),
      ],
      truncated: false,
    );

    test('여러 번 흡수해도 같은 행사가 겹쳐 쌓이지 않는다', () {
      final ProviderContainer c = container();
      final MapMarkerController controller = c.read(
        mapMarkerControllerProvider.notifier,
      );

      controller.absorb(eventResult(), visible);
      controller.absorb(eventResult(), visible);
      controller.absorb(eventResult(), visible);

      expect(
        c
            .read(mapMarkerControllerProvider)
            .where((MapMarker m) => m.id == 'e1'),
        hasLength(1),
        reason: '같은 자리에 핀이 겹쳐 박힌다',
      );
    });

    /// 제외 목록은 세션 내내 남으므로, 행사가 거기 들어가면 화면에서 지워진 뒤
    /// 다시는 돌아오지 못한다.
    test('표시에서 밀려난 행사는 다시 후보가 된다', () {
      final ProviderContainer c = container();
      final MapMarkerController controller = c.read(
        mapMarkerControllerProvider.notifier,
      );

      controller.absorb(eventResult(), visible);
      // 화면을 비운 상태를 만든다 — 보관 상한에 밀렸거나 로그아웃한 뒤와 같다.
      controller.clear();

      expect(
        controller.absorb(eventResult(), visible),
        isTrue,
        reason: '행사가 제외 목록에 갇혔다',
      );
      expect(
        c
            .read(mapMarkerControllerProvider)
            .where((MapMarker m) => m.id == 'e1'),
        hasLength(1),
      );
    });
  });

  test('지도 이동으로 인한 흡수는 화면 안 마커를 지우지 않는다', () {
    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    controller.absorb(resultOf(3), visible);
    final List<MapMarker> before = c.read(mapMarkerControllerProvider);

    controller.absorb(resultOf(6), visible);
    final List<MapMarker> after = c.read(mapMarkerControllerProvider);

    expect(after.length, greaterThanOrEqualTo(before.length));
  });

  /// SPEC-0036 S4. 「다음 장소」는 이미 표시한 것을 서버에 제외 목록으로 보내
  /// 받아 온다 — 커서도 오프셋도 없다(POL-037).
  group('다음 묶음 조회 (loadNextBatch)', () {
    const MapBounds bbox = MapBounds(
      minLat: 37.49,
      minLng: 126.99,
      maxLat: 37.53,
      maxLng: 127.03,
    );

    ProviderContainer withRepository(FakeMapRepository repository) {
      final ProviderContainer c = ProviderContainer(
        overrides: [mapRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(c.dispose);
      return c;
    }

    /// FR-004. 두 번째 요청에 첫 묶음이 제외로 실려야 「다음」이 된다.
    test('앞서 표시한 장소를 제외 목록으로 보낸다', () async {
      final FakeMapRepository repository = FakeMapRepository(<MapMarker>[
        markerAt('a', 37.5025, 127.0025),
        markerAt('b', 37.5175, 127.0175),
      ]);
      final MapMarkerController controller = withRepository(
        repository,
      ).read(mapMarkerControllerProvider.notifier);

      await controller.loadNextBatch(
        bbox: bbox,
        visible: visible,
        batchSize: 2,
      );
      expect(repository.lastExcluded, isEmpty, reason: '첫 요청은 제외가 없다');

      await controller.loadNextBatch(
        bbox: bbox,
        visible: visible,
        batchSize: 2,
      );
      expect(repository.lastExcluded, containsAll(<String>['a', 'b']));
    });

    /// FR-009. 판정은 서버가 준 수로 한다 — 격자에 솎여 못 그린 장소는 제외 목록에
    /// 없어 다음 요청에 다시 오므로, 그린 수로 판정하면 가짜 소진이다.
    test('소진 여부를 그대로 전한다', () async {
      final FakeMapRepository exhausted = FakeMapRepository(<MapMarker>[
        markerAt('a', 37.505, 127.005),
      ], exhausted: true);
      final MapMarkerController controller = withRepository(
        exhausted,
      ).read(mapMarkerControllerProvider.notifier);

      expect(
        await controller.loadNextBatch(
          bbox: bbox,
          visible: visible,
          batchSize: 10,
        ),
        isTrue,
      );
    });

    /// 서버에 `mapRecommendedSpots`가 아직 배포되지 않으면 이 조회가 실패한다
    /// (실기기 2026-09-18, `FieldUndefined`). 그때 **실패를 그대로 던져야** 화면이
    /// 문화행사를 따로 그리고 소진 판정을 건드리지 않을 수 있다 — 여기서 삼키고
    /// 「소진」이나 「빈 결과」로 바꾸면 화면이 그 둘을 구분할 수 없다(FR-009).
    test('조회가 실패하면 삼키지 않고 던진다', () async {
      final FakeMapRepository repository = FakeMapRepository(
        const <MapMarker>[],
        failure: MapFailure.network,
      );
      final MapMarkerController controller = withRepository(
        repository,
      ).read(mapMarkerControllerProvider.notifier);

      await expectLater(
        () => controller.loadNextBatch(
          bbox: bbox,
          visible: visible,
          batchSize: 10,
        ),
        throwsA(isA<MapFailure>()),
      );
    });

    /// 실패한 조회가 마커를 남기면 다음 조회에서 그 장소가 제외되어 영영 못 본다
    /// (FR-004).
    test('실패한 조회는 마커를 남기지 않는다', () async {
      final FakeMapRepository repository = FakeMapRepository(
        const <MapMarker>[],
        failure: MapFailure.network,
      );
      final ProviderContainer c = withRepository(repository);

      await c
          .read(mapMarkerControllerProvider.notifier)
          .loadNextBatch(bbox: bbox, visible: visible, batchSize: 10)
          .onError((Object? error, StackTrace stack) => false);

      expect(c.read(mapMarkerControllerProvider), isEmpty);
    });

    /// **보고 있는 화면으로 조회한다.** 넓은 조회 영역으로 물으면 서버가 그 기준
    /// 앞에서부터 주어 받은 추천이 전부 화면 밖일 수 있다 — 확대할수록 심해져
    /// 아무것도 안 들어왔다(실측: 확대 후 보관 0개).
    test('화면 영역과 묶음 크기를 그대로 보낸다', () async {
      final FakeMapRepository repository = FakeMapRepository(
        const <MapMarker>[],
      );
      final MapMarkerController controller = withRepository(
        repository,
      ).read(mapMarkerControllerProvider.notifier);

      await controller.loadNextBatch(
        bbox: bbox,
        visible: visible,
        batchSize: 7,
      );

      expect(repository.lastFirst, 7);
      expect(repository.lastBbox, visible, reason: '넓은 조회 영역으로 물었다');
    });
  });

  /// 실기기 지적(2026-09-18): 「확대를 했으면 데이터를 끌고 와야 하는데 안 끌고 온다」.
  ///
  /// 조회 영역이 화면보다 넓으면 서버가 그 기준 앞에서부터 주므로, 확대해 화면이
  /// 좁아질수록 받은 추천이 전부 화면 밖이라 버려진다(실측: 보관 0개).
  test('확대해도 그 영역의 장소가 들어온다', () async {
    const MapBounds zoomed = MapBounds(
      minLat: 37.505,
      minLng: 127.015,
      maxLat: 37.512,
      maxLng: 127.022,
    );

    final ProviderContainer c = ProviderContainer(
      overrides: [
        mapRepositoryProvider.overrideWithValue(FakeBoundsRepository()),
      ],
    );
    addTearDown(c.dispose);
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    // 넓게 보다가
    for (int r = 0; r < 4; r++) {
      await controller.loadNextBatch(
        bbox: visible.expanded(),
        visible: visible,
        batchSize: MapTuning.markersPerBatch,
      );
    }
    // 확대한다
    await controller.loadNextBatch(
      bbox: zoomed.expanded(),
      visible: zoomed,
      batchSize: MapTuning.markersPerBatch,
    );

    final Iterable<MapMarker> inZoom = c
        .read(mapMarkerControllerProvider)
        .where(
          (MapMarker m) =>
              m.latitude >= zoomed.minLat &&
              m.latitude <= zoomed.maxLat &&
              m.longitude >= zoomed.minLng &&
              m.longitude <= zoomed.maxLng,
        );

    expect(inZoom, isNotEmpty, reason: '확대했는데 아무것도 안 들어왔다');
  });

  /// 실기기 지적(2026-09-18): 금천 화면에 후보가 6곳뿐이고 롯데마트 맥스가 그중
  /// 4번째인데도 한 번도 뜨지 않았다.
  ///
  /// 표시 기록을 세션 내내 쌓으면 화면에서 사라진 뒤에도 영원히 제외되어, 그 자리로
  /// 돌아와도 다시 뜨지 않는다. 「이미 봤다」의 범위는 **지금 화면에 떠 있는 것**이다.
  test('다른 지역을 돌다 와도 그 화면의 장소가 전부 뜬다', () async {
    const MapBounds elsewhere = MapBounds(
      minLat: 38.00,
      minLng: 128.00,
      maxLat: 38.02,
      maxLng: 128.02,
    );

    final ProviderContainer c = ProviderContainer(
      overrides: [
        mapRepositoryProvider.overrideWithValue(FakeBoundsRepository()),
      ],
    );
    addTearDown(c.dispose);
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    // 다른 지역에서 한참 돌아다닌다.
    for (int r = 0; r < 8; r++) {
      await controller.loadNextBatch(
        bbox: elsewhere.expanded(),
        visible: elsewhere,
        batchSize: MapTuning.markersPerBatch,
      );
    }

    // 돌아온다.
    await controller.loadNextBatch(
      bbox: visible.expanded(),
      visible: visible,
      batchSize: MapTuning.markersPerBatch,
    );

    final Iterable<MapMarker> here = c
        .read(mapMarkerControllerProvider)
        .where(
          (MapMarker m) =>
              m.latitude >= visible.minLat &&
              m.latitude <= visible.maxLat &&
              m.longitude >= visible.minLng &&
              m.longitude <= visible.maxLng,
        );

    expect(here, isNotEmpty, reason: '옛 기록에 막혀 이 화면 장소가 안 들어온다');
  });

  group('검색 결과 고정 (pin)', () {
    test('고정한 마커가 맨 앞에 온다', () {
      final ProviderContainer c = container();
      final MapMarkerController controller = c.read(
        mapMarkerControllerProvider.notifier,
      );

      controller.absorb(resultOf(5), visible);
      controller.pin(markerAt('found', 37.51, 127.01));

      expect(c.read(mapMarkerControllerProvider).first.id, 'found');
    });

    /// 사용자가 방금 찾은 곳이 다음 조회에 밀려 사라지면 검색이 헛일이 된다.
    test('상한을 넘겨 흡수해도 고정한 마커는 남는다', () {
      final ProviderContainer c = container();
      final MapMarkerController controller = c.read(
        mapMarkerControllerProvider.notifier,
      );

      controller.pin(markerAt('found', 37.51, 127.01));
      // 보관 상한을 훌쩍 넘기도록 여러 번 흡수한다.
      for (int i = 0; i < 5; i++) {
        controller.absorb(resultOf(40), visible);
      }

      expect(
        c
            .read(mapMarkerControllerProvider)
            .any((MapMarker m) => m.id == 'found'),
        isTrue,
      );
    });

    test('같은 곳을 다시 고정해도 중복되지 않는다', () {
      final ProviderContainer c = container();
      final MapMarkerController controller = c.read(
        mapMarkerControllerProvider.notifier,
      );

      controller.pin(markerAt('found', 37.51, 127.01));
      controller.pin(markerAt('found', 37.51, 127.01));

      expect(
        c
            .read(mapMarkerControllerProvider)
            .where((MapMarker m) => m.id == 'found'),
        hasLength(1),
      );
    });

    /// 검색할 때마다 빨간 테두리가 하나씩 늘면 어느 것이 방금 찾은 곳인지 알 수
    /// 없다(사용자 지적).
    test('새로 고정하면 이전 고정의 강조가 꺼진다', () {
      final ProviderContainer c = container();
      final MapMarkerController controller = c.read(
        mapMarkerControllerProvider.notifier,
      );

      controller.pin(
        MapMarker(
          id: 'first',
          name: 'first',
          latitude: 37.51,
          longitude: 127.01,
          kind: MapMarkerKind.spot,
          isHighlighted: true,
        ),
      );
      controller.pin(
        MapMarker(
          id: 'second',
          name: 'second',
          latitude: 37.512,
          longitude: 127.012,
          kind: MapMarkerKind.spot,
          isHighlighted: true,
        ),
      );

      final List<MapMarker> markers = c.read(mapMarkerControllerProvider);
      expect(
        markers
            .where((MapMarker m) => m.isHighlighted)
            .map((MapMarker m) => m.id),
        <String>['second'],
        reason: '강조는 방금 찾은 곳 하나만 남아야 한다',
      );
      // 이전 마커 자체는 남는다 — 지웠다 사라지면 화면이 깜빡인다.
      expect(markers.any((MapMarker m) => m.id == 'first'), isTrue);
    });

    test('비우면 고정도 풀린다', () {
      final ProviderContainer c = container();
      final MapMarkerController controller = c.read(
        mapMarkerControllerProvider.notifier,
      );

      controller.pin(markerAt('found', 37.51, 127.01));
      controller.clear();

      expect(c.read(mapMarkerControllerProvider), isEmpty);
    });
  });
}
