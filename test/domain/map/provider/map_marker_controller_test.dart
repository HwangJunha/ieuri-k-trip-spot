import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_bounds.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_marker.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_tuning.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_viewport_result.dart';
import 'package:ieuri_k_trip_spot/domain/map/provider/map_marker_controller.dart';

/// 지도 마커 누적 규칙. 화면을 옮겨도 보고 있던 장소가 사라지지 않아야 하고,
/// 검색으로 찾은 곳은 어떤 경우에도 남아야 한다.
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

  test('한 번에 한 묶음만 더한다', () {
    final ProviderContainer c = container();
    c.read(mapMarkerControllerProvider.notifier).absorb(resultOf(40), visible);

    expect(
      c.read(mapMarkerControllerProvider).length,
      MapTuning.markersPerBatch,
    );
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

  /// SPEC-0036 AC-015. 「이 지역 재검색」은 화면을 갈아 끼우지 않고 **더한다** —
  /// 10건이 표시되어 있었다면 20건이 된다.
  test('다시 흡수하면 앞선 장소를 두고 다음 묶음이 더해진다', () {
    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    controller.absorb(resultOf(30), visible);
    final List<String> first = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .toList();
    expect(first, hasLength(MapTuning.markersPerBatch));

    controller.absorb(resultOf(30), visible);
    final List<String> second = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .toList();

    expect(
      second,
      hasLength(MapTuning.markersPerBatch * 2),
      reason: '교체가 아니라 누적이어야 한다',
    );
    expect(second.take(first.length), first, reason: '처음 10건이 그대로 남는다');
  });

  /// SPEC-0036 AC-004. 이 세션에서 이미 표시한 장소는 다시 후보가 되지 않는다.
  test('이미 표시한 장소는 다음 묶음에 없다', () {
    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    controller.absorb(resultOf(30), visible);
    final Set<String> first = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .toSet();

    controller.absorb(resultOf(30), visible);
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
      c.read(mapMarkerControllerProvider.notifier).absorb(resultOf(50), visible);
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
        c.read(mapMarkerControllerProvider).where(
          (MapMarker m) => m.id == 'e1',
        ),
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
        c.read(mapMarkerControllerProvider).where(
          (MapMarker m) => m.id == 'e1',
        ),
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
