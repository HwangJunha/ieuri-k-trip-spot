import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_marker.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/marker_appearance.dart';

/// 마커 등장 판정과 연출 배율(SPEC-0025 R9·R10).
///
/// **연출의 실제 재생은 여기서 보지 않는다** — 네이티브 SDK가 그리는 화면이라 단위
/// 테스트 범위 밖이다(설계 §4.6). 테스트가 붙는 것은 "무엇이 새로 나타났는가"와
/// "진행도가 얼마면 크기가 얼마인가" 두 순수 계산이다.
void main() {
  MapMarker marker(
    String id, {
    MapMarkerKind kind = MapMarkerKind.spot,
    double lat = 37.5,
    double lng = 127.0,
  }) => MapMarker(
    id: id,
    name: id,
    latitude: lat,
    longitude: lng,
    kind: kind,
  );

  group('신규 등장 판정', () {
    /// AC R9-1: 갱신 전에 없던 마커가 신규다.
    test('이전에 없던 마커만 신규로 잡는다', () {
      final List<MapMarker> newcomers = MarkerAppearance.newcomers(
        previous: <MapMarker>[marker('a'), marker('b')],
        next: <MapMarker>[marker('a'), marker('b'), marker('c')],
      );

      expect(newcomers.map((MapMarker m) => m.id), <String>['c']);
    });

    /// AC R10-1: 이미 있던 마커는 다시 연출하지 않는다 — 지도를 옮길 때마다 화면의
    /// 모든 마커가 다시 커지면 산만하다.
    test('그대로 남아 있는 마커는 신규가 아니다', () {
      final List<MapMarker> newcomers = MarkerAppearance.newcomers(
        previous: <MapMarker>[marker('a'), marker('b')],
        next: <MapMarker>[marker('a'), marker('b')],
      );

      expect(newcomers, isEmpty);
    });

    /// AC R10-2: 숨겼다 다시 보이는 것도 등장이다. 풀 인덱스로 판정하면 "같은
    /// 슬롯이니 기존 마커"로 오판하는 지점이다(설계 §4.2).
    test('숨겼다 다시 나타난 마커는 신규다', () {
      // 이전 상태에 없다는 것이 곧 "그때 보이지 않았다"는 뜻이다.
      final List<MapMarker> newcomers = MarkerAppearance.newcomers(
        previous: <MapMarker>[marker('a')],
        next: <MapMarker>[marker('a'), marker('b')],
      );

      expect(newcomers.map((MapMarker m) => m.id), <String>['b']);
    });

    /// AC R10-3: 좌표만 바뀐 같은 장소는 등장이 아니다 — 식별자가 같으면 같은
    /// 마커이고, 움직인 것을 새로 나타난 것으로 읽으면 안 된다.
    test('같은 식별자면 좌표가 달라도 신규가 아니다', () {
      final List<MapMarker> newcomers = MarkerAppearance.newcomers(
        previous: <MapMarker>[marker('a', lat: 37.5, lng: 127.0)],
        next: <MapMarker>[marker('a', lat: 37.6, lng: 127.1)],
      );

      expect(newcomers, isEmpty);
    });

    /// 종류가 다르면 같은 id라도 다른 마커다 — 관광지와 행사가 같은 id를 쓸 수 있다.
    test('id가 같아도 종류가 다르면 신규다', () {
      final List<MapMarker> newcomers = MarkerAppearance.newcomers(
        previous: <MapMarker>[marker('a')],
        next: <MapMarker>[
          marker('a'),
          marker('a', kind: MapMarkerKind.culturalEvent),
        ],
      );

      expect(newcomers, hasLength(1));
      expect(newcomers.single.kind, MapMarkerKind.culturalEvent);
    });

    /// 첫 조회는 이전 상태가 비어 있으므로 전부 새로 나타난 것이다.
    test('이전이 비어 있으면 전부 신규다', () {
      final List<MapMarker> newcomers = MarkerAppearance.newcomers(
        previous: const <MapMarker>[],
        next: <MapMarker>[marker('a'), marker('b')],
      );

      expect(newcomers, hasLength(2));
    });

    /// 그려지는 차례대로 연출이 걸려야 자연스럽다.
    test('신규 목록은 새 목록의 순서를 지킨다', () {
      final List<MapMarker> newcomers = MarkerAppearance.newcomers(
        previous: <MapMarker>[marker('b')],
        next: <MapMarker>[marker('c'), marker('b'), marker('a')],
      );

      expect(newcomers.map((MapMarker m) => m.id), <String>['c', 'a']);
    });
  });

  group('진행도 → 크기 배율', () {
    /// AC R9-2: 작게 시작한다.
    test('시작에서는 최종 크기보다 작다', () {
      expect(MarkerAppearance.scaleAt(0), MarkerAppearance.startScale);
      expect(MarkerAppearance.scaleAt(0), lessThan(1));
    });

    /// AC R9-3: **끝은 정확히 1.0이다.** 여기가 어긋나면 연출이 끝난 마커만 크기가
    /// 달라져 R11(최종 상태 일관성)이 깨진다.
    test('끝에서는 정확히 최종 크기다', () {
      expect(MarkerAppearance.scaleAt(1), 1.0);
    });

    /// AC R9-4: 중간은 시작과 끝 사이이고, 진행할수록 커지기만 한다(줄어드는 구간이
    /// 있으면 마커가 꿈틀거린다).
    test('진행할수록 커지기만 한다', () {
      double previous = MarkerAppearance.scaleAt(0);
      for (int step = 1; step <= 10; step++) {
        final double current = MarkerAppearance.scaleAt(step / 10);
        expect(current, greaterThan(previous));
        previous = current;
      }
      expect(previous, 1.0);
    });

    /// 범위를 벗어난 진행도가 들어와도 크기가 튀지 않는다 — 프레임이 밀려 t가 1을
    /// 넘는 경우가 실제로 생긴다.
    test('범위 밖 진행도는 양 끝으로 잘린다', () {
      expect(MarkerAppearance.scaleAt(-1), MarkerAppearance.startScale);
      expect(MarkerAppearance.scaleAt(2), 1.0);
    });
  });
}
