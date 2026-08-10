import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_bounds.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_marker.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/marker_thinning.dart';

/// 마커 솎아내기. 500건을 그대로 찍으면 마커가 겹쳐 지도가 보이지 않는다.
void main() {
  const MapBounds viewport = MapBounds(
    minLat: 37.50,
    minLng: 127.00,
    maxLat: 37.52,
    maxLng: 127.02,
  );

  MapMarker markerAt(
    String id,
    double lat,
    double lng, {
    MapMarkerKind kind = MapMarkerKind.spot,
  }) => MapMarker(id: id, name: id, latitude: lat, longitude: lng, kind: kind);

  test('같은 칸에 몰린 마커는 하나만 남는다', () {
    // 셋 다 뷰포트 좌하단 칸 안이다.
    final List<MapMarker> thinned = thinMarkers(
      markers: <MapMarker>[
        markerAt('a', 37.5005, 127.0005),
        markerAt('b', 37.5006, 127.0006),
        markerAt('c', 37.5007, 127.0007),
      ],
      viewport: viewport,
      columns: 5,
      maxCount: 20,
    );

    expect(thinned, hasLength(1));
    expect(thinned.single.id, 'a', reason: '먼저 온 것이 칸을 차지한다');
  });

  test('떨어진 마커는 모두 남는다', () {
    final List<MapMarker> thinned = thinMarkers(
      markers: <MapMarker>[
        markerAt('a', 37.502, 127.002),
        markerAt('b', 37.510, 127.010),
        markerAt('c', 37.518, 127.018),
      ],
      viewport: viewport,
      columns: 5,
      maxCount: 20,
    );

    expect(thinned, hasLength(3));
  });

  test('상한을 넘지 않는다', () {
    final List<MapMarker> many = <MapMarker>[
      for (int i = 0; i < 200; i++)
        markerAt('m$i', 37.50 + i * 0.0001, 127.00 + i * 0.0001),
    ];

    final List<MapMarker> thinned = thinMarkers(
      markers: many,
      viewport: viewport,
      columns: 5,
      maxCount: 20,
    );

    expect(thinned.length, lessThanOrEqualTo(20));
  });

  /// 행사는 수가 적어 격자에서 밀리면 레이어가 통째로 없는 것처럼 된다(R21).
  test('문화행사는 같은 칸이어도 솎이지 않는다', () {
    final List<MapMarker> thinned = thinMarkers(
      markers: <MapMarker>[
        markerAt('spot', 37.5005, 127.0005),
        markerAt('event', 37.5006, 127.0006, kind: MapMarkerKind.culturalEvent),
      ],
      viewport: viewport,
      columns: 5,
      maxCount: 20,
    );

    expect(
      thinned.where((MapMarker m) => m.kind == MapMarkerKind.culturalEvent),
      hasLength(1),
    );
  });

  test('빈 입력은 빈 결과다', () {
    expect(
      thinMarkers(
        markers: const <MapMarker>[],
        viewport: viewport,
        columns: 5,
        maxCount: 20,
      ),
      isEmpty,
    );
  });
}
