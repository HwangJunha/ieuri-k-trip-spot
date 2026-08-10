import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_area.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_overlay.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_tuning.dart';

/// 줌 게이트(R25)와 경계 조인(R26).
void main() {
  CongestionArea areaOf(String id) => CongestionArea(
    id: id,
    name: '구역 $id',
    congestion: CongestionSnapshot(
      level: CongestionLevel.normal,
      populationMin: 3000,
      populationMax: 3500,
      observedAt: DateTime.utc(2026, 8, 10, 3, 30),
    ),
  );

  CongestionAreaBoundary boundaryOf(String id) => CongestionAreaBoundary(
    id: id,
    name: '구역 $id',
    category: '관광특구',
    polygon: const <List<double>>[
      <double>[126.97, 37.55],
      <double>[126.99, 37.55],
      <double>[126.99, 37.57],
      <double>[126.97, 37.55],
    ],
  );

  group('구역 선택 (R27)', () {
    // 서울시청 부근의 정사각형. [lng, lat] 순서이며 닫혀 있다.
    CongestionOverlay squareOverlay(String id) => CongestionOverlay(
      area: areaOf(id),
      boundary: CongestionAreaBoundary(
        id: id,
        name: '구역 $id',
        category: '관광특구',
        polygon: const <List<double>>[
          <double>[126.97, 37.55],
          <double>[126.99, 37.55],
          <double>[126.99, 37.57],
          <double>[126.97, 37.57],
          <double>[126.97, 37.55],
        ],
      ),
    );

    test('폴리곤 안을 누르면 그 구역이 잡힌다', () {
      final CongestionOverlay? hit = overlayAt(
        latitude: 37.56,
        longitude: 126.98,
        overlays: <CongestionOverlay>[squareOverlay('POI014')],
      );

      expect(hit?.area.id, 'POI014');
    });

    test('폴리곤 밖을 누르면 아무것도 잡히지 않는다', () {
      final CongestionOverlay? hit = overlayAt(
        latitude: 37.60,
        longitude: 127.05,
        overlays: <CongestionOverlay>[squareOverlay('POI014')],
      );

      expect(hit, isNull);
    });

    test('겹치면 먼저 오는 구역을 고른다 — 같은 곳을 눌렀을 때 결과가 흔들리지 않는다', () {
      final CongestionOverlay? hit = overlayAt(
        latitude: 37.56,
        longitude: 126.98,
        overlays: <CongestionOverlay>[
          squareOverlay('POI001'),
          squareOverlay('POI002'),
        ],
      );

      expect(hit?.area.id, 'POI001');
    });

    test('그릴 구역이 없으면 아무것도 잡히지 않는다', () {
      expect(
        overlayAt(
          latitude: 37.56,
          longitude: 126.98,
          overlays: const <CongestionOverlay>[],
        ),
        isNull,
      );
    });
  });

  group('줌 게이트 (R25)', () {
    test('임계값 미만에서는 표시하지 않는다', () {
      expect(shouldShowCongestion(MapTuning.polygonMinZoom - 1), isFalse);
    });

    test('임계값에서는 표시한다 — 경계는 포함이다', () {
      expect(shouldShowCongestion(MapTuning.polygonMinZoom), isTrue);
    });

    test('임계값을 넘으면 표시한다', () {
      expect(shouldShowCongestion(MapTuning.polygonMinZoom + 1), isTrue);
    });
  });

  group('경계 조인 (R26)', () {
    test('구역 id가 일치하는 것끼리 묶인다', () {
      final List<CongestionOverlay> overlays = joinCongestionOverlays(
        areas: <CongestionArea>[areaOf('POI014')],
        boundaries: <String, CongestionAreaBoundary>{
          'POI014': boundaryOf('POI014'),
        },
      );

      expect(overlays, hasLength(1));
      expect(overlays.single.area.id, 'POI014');
      expect(overlays.single.boundary.id, 'POI014');
    });

    test('경계 캐시에 없는 구역은 건너뛴다 — 오류가 아니다', () {
      final List<CongestionOverlay> overlays = joinCongestionOverlays(
        areas: <CongestionArea>[areaOf('POI014'), areaOf('POI999')],
        boundaries: <String, CongestionAreaBoundary>{
          'POI014': boundaryOf('POI014'),
        },
      );

      expect(overlays, hasLength(1));
      expect(overlays.single.area.id, 'POI014');
    });

    test('혼잡도가 없는 구역은 채색 대상이 아니다', () {
      final List<CongestionOverlay> overlays = joinCongestionOverlays(
        areas: <CongestionArea>[],
        boundaries: <String, CongestionAreaBoundary>{
          'POI014': boundaryOf('POI014'),
        },
      );

      expect(overlays, isEmpty);
    });

    test('입력 순서를 유지한다 — 그리기 순서가 흔들리면 화면이 깜빡인다', () {
      final List<CongestionOverlay> overlays = joinCongestionOverlays(
        areas: <CongestionArea>[
          areaOf('POI003'),
          areaOf('POI001'),
          areaOf('POI002'),
        ],
        boundaries: <String, CongestionAreaBoundary>{
          'POI001': boundaryOf('POI001'),
          'POI002': boundaryOf('POI002'),
          'POI003': boundaryOf('POI003'),
        },
      );

      expect(overlays.map((CongestionOverlay o) => o.area.id), <String>[
        'POI003',
        'POI001',
        'POI002',
      ]);
    });

    test('표시명은 실시간 응답 쪽을 쓴다 — 경계 캐시는 언어가 뒤처질 수 있다', () {
      final List<CongestionOverlay> overlays = joinCongestionOverlays(
        areas: <CongestionArea>[
          CongestionArea(
            id: 'POI014',
            name: 'Gangnam MICE',
            congestion: CongestionSnapshot(
              level: CongestionLevel.crowded,
              populationMin: 3000,
              populationMax: 3500,
              observedAt: DateTime.utc(2026, 8, 10, 3, 30),
            ),
          ),
        ],
        boundaries: <String, CongestionAreaBoundary>{
          'POI014': const CongestionAreaBoundary(
            id: 'POI014',
            name: '강남 MICE 관광특구',
            category: '관광특구',
            polygon: <List<double>>[],
          ),
        },
      );

      expect(overlays.single.name, 'Gangnam MICE');
    });
  });
}
