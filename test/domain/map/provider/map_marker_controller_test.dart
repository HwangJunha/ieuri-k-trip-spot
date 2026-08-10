import 'package:flutter/foundation.dart';
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

  test('조회 결과를 흡수해 화면 상한까지 채운다', () {
    final ProviderContainer c = container();
    c.read(mapMarkerControllerProvider.notifier).absorb(resultOf(40), visible);

    expect(
      c.read(mapMarkerControllerProvider).length,
      MapTuning.maxDrawnMarkers,
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

  /// 서버는 관련도 순으로 늘 같은 결과를 준다 — 섞지 않으면 같은 자리에서 재검색해도
  /// 화면이 그대로다(사용자 지적).
  test('재검색하면 다른 장소가 나온다', () {
    final ProviderContainer c = container();
    final MapMarkerController controller = c.read(
      mapMarkerControllerProvider.notifier,
    );

    controller.absorb(resultOf(60), visible);
    final Set<String> first = c
        .read(mapMarkerControllerProvider)
        .map((MapMarker m) => m.id)
        .toSet();

    // 섞기는 무작위라 한 번은 우연히 같을 수 있다 — 여러 번 중 한 번이라도 달라지면
    // 재검색이 새 결과를 준다는 뜻이다.
    bool changed = false;
    for (int i = 0; i < 10 && !changed; i++) {
      controller.absorb(resultOf(60), visible, replaceShown: true);
      final Set<String> next = c
          .read(mapMarkerControllerProvider)
          .map((MapMarker m) => m.id)
          .toSet();
      if (!setEquals(first, next)) changed = true;
    }

    expect(changed, isTrue, reason: '재검색해도 매번 같은 장소만 나온다');
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
