// 지도 모델 테스트를 한 파일에 모았다.
//
// **파일을 쪼개지 않는 이유는 속도다** — flutter test는 파일마다 격리된 VM을 띄우므로
// 파일 수가 곧 실행 시간이다. 모델별 구분은 group으로 충분하다(CLAUDE.md §8).

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/commercial_activity_level.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/commercial_display_state.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_area.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_display.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_layer_state.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_overlay.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/congestion_palette.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_bounds.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_marker.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_tuning.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/marker_thinning.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_recommendation.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/region_score.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  // ─── commercial_display_state ────────────────────────────────

  CommercialStatus statusOf({
    required bool isDefaulted,
    CommercialActivityLevel level = CommercialActivityLevel.normal,
  }) => CommercialStatus(
    level: level,
    isDefaulted: isDefaulted,
    observedAt: DateTime.utc(2026, 8, 9, 23, 50),
  );

  test('상권 정보가 부재면 정보 없음이다', () {
    expect(commercialDisplayStateOf(null), CommercialDisplayState.unavailable);
  });

  test('기본값 표식이 참이면 실측과 구분되는 상태다', () {
    expect(
      commercialDisplayStateOf(statusOf(isDefaulted: true)),
      CommercialDisplayState.estimated,
    );
  });

  test('기본값 표식이 거짓이면 실측이다', () {
    expect(
      commercialDisplayStateOf(statusOf(isDefaulted: false)),
      CommercialDisplayState.measured,
    );
  });

  /// 이것이 3상태를 두는 이유 그 자체다. 값이 같아도 신뢰도가 다르다.
  test('같은 보통이라도 실측과 기본값은 다른 상태다', () {
    final CommercialDisplayState measured = commercialDisplayStateOf(
      statusOf(isDefaulted: false),
    );
    final CommercialDisplayState defaulted = commercialDisplayStateOf(
      statusOf(isDefaulted: true),
    );

    expect(measured, isNot(defaulted));
  });

  test('부재와 기본값도 서로 다른 상태다 — 하나로 뭉뚱그리지 않는다', () {
    expect(
      commercialDisplayStateOf(null),
      isNot(commercialDisplayStateOf(statusOf(isDefaulted: true))),
    );
  });

  // ─── congestion_display ──────────────────────────────────────

  setUpAll(() async {
    // intl의 로케일별 날짜 심볼을 올린다. 앱에서는 flutter_localizations가 하지만
    // 순수 단위 테스트에는 그 초기화가 없다.
    await initializeDateFormatting();
  });

  final DateTime observedAt = DateTime(2026, 8, 10, 3, 30);

  group('기준 시각 (R27)', () {
    test('기준 시각의 시와 분이 문자열에 담긴다', () {
      final String label = CongestionDisplay.observedAtLabel(observedAt, 'en');

      expect(label, contains('3'));
      expect(label, contains('30'));
    });

    test('"지금"에 해당하는 표현을 쓰지 않는다', () {
      final String en = CongestionDisplay.observedAtLabel(observedAt, 'en');
      final String ko = CongestionDisplay.observedAtLabel(observedAt, 'ko');

      expect(en.toLowerCase(), isNot(contains('now')));
      expect(ko, isNot(contains('지금')));
      expect(ko, isNot(contains('현재')));
    });

    test('로케일에 따라 표기가 달라진다', () {
      expect(
        CongestionDisplay.observedAtLabel(observedAt, 'ko'),
        isNot(CongestionDisplay.observedAtLabel(observedAt, 'en')),
      );
    });

    test('영어 로케일에 한국어가 섞이지 않는다', () {
      final String en = CongestionDisplay.observedAtLabel(observedAt, 'en');

      expect(RegExp(r'[가-힣]').hasMatch(en), isFalse);
    });
  });

  group('인구 범위 (R27)', () {
    test('하한과 상한이 모두 담긴다', () {
      final ({String max, String min}) range =
          CongestionDisplay.populationRange(3000, 3500, 'en');

      expect(range.min, contains('3'));
      expect(range.max, contains('3'));
      expect(range.min, isNot(range.max));
    });

    test('천 단위를 끊어 준다', () {
      final ({String max, String min}) range =
          CongestionDisplay.populationRange(3000, 3500, 'en');

      expect(range.min, '3,000');
      expect(range.max, '3,500');
    });
  });

  // ─── congestion_layer_state ──────────────────────────────────

  CongestionOverlay overlayOf(String id) => CongestionOverlay(
    area: CongestionArea(
      id: id,
      name: '구역 $id',
      congestion: CongestionSnapshot(
        level: CongestionLevel.normal,
        populationMin: 3000,
        populationMax: 3500,
        observedAt: DateTime.utc(2026, 8, 10, 3, 30),
      ),
    ),
    boundary: CongestionAreaBoundary(
      id: id,
      name: '구역 $id',
      category: '관광특구',
      polygon: const <List<double>>[],
    ),
  );

  group('출처 표기 (R30)', () {
    test('폴리곤을 그릴 때 출처를 노출한다', () {
      final CongestionLayerState state = CongestionShown(<CongestionOverlay>[
        overlayOf('POI014'),
      ]);

      expect(state.showsAttribution, isTrue);
    });

    test('줌 게이트로 숨겼으면 출처도 띄우지 않는다', () {
      expect(const CongestionHiddenByZoom().showsAttribution, isFalse);
    });

    test('그릴 구역이 하나도 없으면 출처를 띄우지 않는다 — 서울 밖이 여기 해당한다', () {
      const CongestionLayerState state = CongestionShown(<CongestionOverlay>[]);

      expect(state.showsAttribution, isFalse);
    });

    test('조회 중에는 출처를 띄우지 않는다', () {
      expect(const CongestionLoading().showsAttribution, isFalse);
    });

    test('성능 저하 상태에서는 출처를 띄우지 않는다', () {
      expect(const CongestionDegraded().showsAttribution, isFalse);
    });
  });

  // ─── congestion_overlay ──────────────────────────────────────

  CongestionArea areaOf(
    String id, {
    CongestionLevel level = CongestionLevel.normal,
  }) => CongestionArea(
    id: id,
    name: '구역 $id',
    congestion: CongestionSnapshot(
      level: level,
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

  /// 지도를 옮기면 서버가 「구역 중심점이 bbox 안」으로 거르므로 같은 자리가 보이는데도
  /// 빈 배열이 정상 응답으로 온다. 그걸 그대로 그리면 보이던 폴리곤이 사라진다
  /// (실기기 2026-09-18) — 그래서 지우지 않고 더한다(사용자 결정).
  group('폴리곤 누적', () {
    CongestionOverlay overlayOf(
      String id, {
      CongestionLevel level = CongestionLevel.normal,
    }) => CongestionOverlay(
      area: areaOf(id, level: level),
      boundary: boundaryOf(id),
    );

    test('새 구역을 뒤에 더한다', () {
      final List<CongestionOverlay> merged = mergeCongestionOverlays(
        held: <CongestionOverlay>[overlayOf('A')],
        incoming: <CongestionOverlay>[overlayOf('B')],
      );

      expect(
        merged.map((CongestionOverlay o) => o.area.id),
        <String>['A', 'B'],
      );
    });

    /// 이것이 사용자가 겪은 증상이다 — 이동 한 번에 레이어가 통째로 사라졌다.
    test('빈 응답이 와도 들고 있던 것을 지우지 않는다', () {
      final List<CongestionOverlay> merged = mergeCongestionOverlays(
        held: <CongestionOverlay>[overlayOf('A'), overlayOf('B')],
        incoming: const <CongestionOverlay>[],
      );

      expect(
        merged.map((CongestionOverlay o) => o.area.id),
        <String>['A', 'B'],
      );
    });

    /// 혼잡도는 실시간이라 같은 구역이 다시 오면 색이 갱신되어야 한다.
    test('같은 구역은 새 값으로 바뀐다', () {
      final List<CongestionOverlay> merged = mergeCongestionOverlays(
        held: <CongestionOverlay>[overlayOf('A')],
        incoming: <CongestionOverlay>[
          overlayOf('A', level: CongestionLevel.crowded),
        ],
      );

      expect(merged, hasLength(1));
      expect(merged.single.area.congestion.level, CongestionLevel.crowded);
    });

    /// 겹치는 폴리곤의 그리기 순서가 호출마다 달라지면 화면이 깜빡이고, 구역 선택도
    /// 먼저 오는 것을 고르므로 결과가 흔들린다.
    test('갱신되어도 자리는 그대로다', () {
      final List<CongestionOverlay> merged = mergeCongestionOverlays(
        held: <CongestionOverlay>[
          overlayOf('A'),
          overlayOf('B'),
          overlayOf('C'),
        ],
        incoming: <CongestionOverlay>[
          overlayOf('B', level: CongestionLevel.crowded),
        ],
      );

      expect(
        merged.map((CongestionOverlay o) => o.area.id),
        <String>['A', 'B', 'C'],
      );
      expect(merged[1].area.congestion.level, CongestionLevel.crowded);
    });

    test('같은 구역이 두 번 와도 하나만 남는다', () {
      final List<CongestionOverlay> merged = mergeCongestionOverlays(
        held: const <CongestionOverlay>[],
        incoming: <CongestionOverlay>[overlayOf('A'), overlayOf('A')],
      );

      expect(merged, hasLength(1));
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

  // ─── congestion_palette ──────────────────────────────────────

  test('네 단계의 채우기 색이 서로 다르다', () {
    final Set<int> fills = CongestionLevel.values
        .map(CongestionPalette.fillOf)
        .toSet();

    expect(fills, hasLength(CongestionLevel.values.length));
  });

  test('붐빔과 여유는 다른 색이다', () {
    expect(
      CongestionPalette.fillOf(CongestionLevel.crowded),
      isNot(CongestionPalette.fillOf(CongestionLevel.relaxed)),
    );
  });

  test('채우기는 반투명이라 아래 지도가 비친다', () {
    for (final CongestionLevel level in CongestionLevel.values) {
      final int alpha = CongestionPalette.fillOf(level) >>> 24;

      expect(alpha, lessThan(0xFF), reason: '$level의 채우기가 불투명하다');
      expect(alpha, greaterThan(0), reason: '$level의 채우기가 완전 투명하다');
    }
  });

  test('테두리는 불투명해 인접 구역의 경계가 뭉개지지 않는다', () {
    for (final CongestionLevel level in CongestionLevel.values) {
      expect(CongestionPalette.strokeOf(level) >>> 24, 0xFF, reason: '$level');
    }
  });

  /// 적록 대비에만 의존하지 않는다는 요구(R24)를 검증한다. 색상을 못 봐도 밝기만으로
  /// 순서를 읽을 수 있어야 하므로, 단계가 올라갈수록 명도가 낮아져야 한다.
  test('단계가 올라갈수록 어두워진다 — 색각과 무관하게 순서를 읽을 수 있다', () {
    double luminanceOf(CongestionLevel level) {
      final int argb = CongestionPalette.strokeOf(level);
      final int r = (argb >> 16) & 0xFF;
      final int g = (argb >> 8) & 0xFF;
      final int b = argb & 0xFF;
      // ITU-R BT.601 가중치. 정확한 지각 명도가 아니라 단조성만 보면 된다.
      return 0.299 * r + 0.587 * g + 0.114 * b;
    }

    final List<double> luminances = CongestionLevel.values
        .map(luminanceOf)
        .toList();

    for (int i = 1; i < luminances.length; i++) {
      expect(
        luminances[i],
        lessThan(luminances[i - 1]),
        reason: '${CongestionLevel.values[i]}가 앞 단계보다 어둡지 않다',
      );
    }
  });

  // ─── map_bounds ──────────────────────────────────────────────

  // 서울시청 부근의 작은 사각형. 위도 0.02도 × 경도 0.02도.
  const MapBounds seoul = MapBounds(
    minLat: 37.55,
    minLng: 126.97,
    maxLat: 37.57,
    maxLng: 126.99,
  );

  group('확장 조회 (R20)', () {
    test('확장한 영역은 화면보다 넓다', () {
      final MapBounds expanded = seoul.expanded();

      expect(expanded.latSpan, greaterThan(seoul.latSpan));
      expect(expanded.lngSpan, greaterThan(seoul.lngSpan));
    });

    test('중심을 유지한 채 넓힌다', () {
      final MapBounds expanded = seoul.expanded(2);

      // 1.5배가 아니라 2배로 넓히면 각 변이 원래 폭의 절반씩 상하좌우로 늘어난다.
      expect(expanded.minLat, closeTo(37.54, 1e-9));
      expect(expanded.maxLat, closeTo(37.58, 1e-9));
      expect(expanded.minLng, closeTo(126.96, 1e-9));
      expect(expanded.maxLng, closeTo(127.00, 1e-9));
    });

    test('원래 영역은 확장된 영역 안에 들어간다', () {
      expect(seoul.expanded().contains(seoul), isTrue);
    });

    test('극점을 넘지 않도록 잘라낸다', () {
      const MapBounds nearPole = MapBounds(
        minLat: 89,
        minLng: 0,
        maxLat: 89.9,
        maxLng: 1,
      );

      expect(nearPole.expanded(10).maxLat, lessThanOrEqualTo(90));
    });
  });

  group('최소 반경 보장', () {
    /// 실기기에서 폴리곤이 사라지던 뷰포트(2026-08-25). 강남 한복판인데 폭이
    /// 1.3km라 구역 중심점이 하나도 안 걸려 서버가 `areas: []`를 돌려줬다.
    const MapBounds zoomedIn = MapBounds(
      minLat: 37.49775659520474,
      minLng: 127.01339958857577,
      maxLat: 37.50929903170785,
      maxLng: 127.02011479335178,
    );

    test('좁은 화면은 최소 반경만큼 넓어진다', () {
      final MapBounds widened = zoomedIn.withMinRadius(3);

      // 반경 3km면 위도 폭은 지름 6km — 위도 1도가 약 111km이므로 0.054도다.
      expect(widened.latSpan, closeTo(6 / 111.0, 1e-6));
      expect(widened.latSpan, greaterThan(zoomedIn.latSpan));
      expect(widened.lngSpan, greaterThan(zoomedIn.lngSpan));
    });

    test('중심은 그대로 둔다 — 보던 곳이 밀리면 안 된다', () {
      final MapBounds widened = zoomedIn.withMinRadius(3);

      expect(
        (widened.minLat + widened.maxLat) / 2,
        closeTo((zoomedIn.minLat + zoomedIn.maxLat) / 2, 1e-9),
      );
      expect(
        (widened.minLng + widened.maxLng) / 2,
        closeTo((zoomedIn.minLng + zoomedIn.maxLng) / 2, 1e-9),
      );
    });

    test('원래 화면은 넓힌 영역 안에 들어간다', () {
      expect(zoomedIn.withMinRadius(3).contains(zoomedIn), isTrue);
    });

    test('이미 넓으면 줄이지 않는다', () {
      // 서울 전역을 담을 만큼 넓은 화면에 3km를 요구해도 그대로다.
      expect(seoul.withMinRadius(0.1), same(seoul));
    });
  });

  group('격자 스냅 (캐시 키)', () {
    test('격자 배수로 떨어진다', () {
      final MapBounds snapped = seoul.snappedToGrid(0.05);

      for (final double v in <double>[
        snapped.minLat,
        snapped.minLng,
        snapped.maxLat,
        snapped.maxLng,
      ]) {
        expect((v / 0.05) - (v / 0.05).roundToDouble(), closeTo(0, 1e-9));
      }
    });

    test('원래 화면은 스냅 결과 안에 들어간다 — 잘리면 그만큼 데이터가 안 온다', () {
      expect(seoul.snappedToGrid(0.05).contains(seoul), isTrue);
    });

    test('같은 칸 안에서 움직이면 키가 같다 — 재조회하지 않는다', () {
      const MapBounds a = MapBounds(
        minLat: 37.5123,
        minLng: 127.0111,
        maxLat: 37.5188,
        maxLng: 127.0177,
      );
      // 지도를 조금 민 상태. 같은 0.05도 칸 안이다.
      const MapBounds b = MapBounds(
        minLat: 37.5126,
        minLng: 127.0114,
        maxLat: 37.5191,
        maxLng: 127.0180,
      );

      expect(a.snappedToGrid(0.05), b.snappedToGrid(0.05));
    });

    test('칸을 넘어가면 키가 달라진다 — 새로 받는다', () {
      const MapBounds inCell = MapBounds(
        minLat: 37.51,
        minLng: 127.01,
        maxLat: 37.54,
        maxLng: 127.04,
      );
      // 위로 한 칸(0.05도) 옮긴 화면.
      const MapBounds nextCell = MapBounds(
        minLat: 37.56,
        minLng: 127.01,
        maxLat: 37.59,
        maxLng: 127.04,
      );

      expect(
        inCell.snappedToGrid(0.05),
        isNot(nextCell.snappedToGrid(0.05)),
      );
    });

    test('격자가 0 이하면 손대지 않는다', () {
      expect(seoul.snappedToGrid(0), same(seoul));
    });
  });

  /// 「조금 벗어난 정도로는 데이터를 안 끌고 온다」는 실기기 지적에서 나온 판정
  /// (사용자 결정 2026-09-18). 중심이 화면 크기의 일정 비율 이상 움직여야 새 영역이다.
  group('이동 판정', () {
    // 폭·높이가 0.02도인 정사각 화면.
    const MapBounds screen = MapBounds(
      minLat: 37.50,
      minLng: 127.00,
      maxLat: 37.52,
      maxLng: 127.02,
    );

    /// [screen]을 위도로 [dLat], 경도로 [dLng]만큼 옮긴 화면.
    MapBounds shifted({double dLat = 0, double dLng = 0}) => MapBounds(
      minLat: screen.minLat + dLat,
      minLng: screen.minLng + dLng,
      maxLat: screen.maxLat + dLat,
      maxLng: screen.maxLng + dLng,
    );

    test('제자리면 새 영역이 아니다', () {
      expect(screen.movedBeyond(screen, 0.25), isFalse);
    });

    test('기준보다 덜 움직이면 새 영역이 아니다', () {
      // 화면 높이의 20% — 기준 25% 미만이다.
      expect(screen.movedBeyond(shifted(dLat: 0.004), 0.25), isFalse);
    });

    /// 실제로 쓰는 값으로도 한 번 본다 — 상수가 바뀌면 여기서 걸린다.
    test('설정값으로 화면 절반을 밀면 새 영역이다', () {
      expect(
        screen.movedBeyond(shifted(dLat: 0.01), MapTuning.areaChangeFraction),
        isTrue,
      );
    });

    // 정확히 기준값(화면의 25%)은 시험하지 않는다 — `0.52 - 0.50`이 `0.02`가 아닌
    // 부동소수점 세계에서 그 한 점의 판정은 마이크로미터 단위 오차가 가르고, 지도
    // 동작에는 아무 의미가 없다.
    test('기준을 넘으면 새 영역이다', () {
      expect(screen.movedBeyond(shifted(dLat: 0.006), 0.25), isTrue);
    });

    test('경도로 움직여도 판정한다', () {
      expect(screen.movedBeyond(shifted(dLng: 0.006), 0.25), isTrue);
    });

    /// 예전 기준(영역 포함)이 놓치던 지점이다 — 조회 영역이 화면의 1.2배라 각 변에
    /// 10% 여백이 있어, 화면의 15%를 밀어도 「안 움직였다」로 읽혔다.
    test('조회 영역 안에 있어도 중심이 충분히 움직였으면 새 영역이다', () {
      final MapBounds queried = screen.expanded();
      // 화면 높이의 30% — 조회 영역(각 변 10% 여백)은 아직 벗어나지 않았지만
      // 중심은 기준을 넘었다.
      final MapBounds moved = shifted(dLat: 0.006);

      expect(queried.contains(moved), isFalse);
      expect(screen.movedBeyond(moved, 0.25), isTrue);
    });

    test('면적이 0이면 새 영역으로 본다 — 비교할 기준이 없다', () {
      const MapBounds degenerate = MapBounds(
        minLat: 37.5,
        minLng: 127.0,
        maxLat: 37.5,
        maxLng: 127.0,
      );

      expect(degenerate.movedBeyond(screen, 0.25), isTrue);
    });
  });

  group('포함 판정 (R20)', () {
    test('안쪽 영역은 포함으로 본다 — 재조회하지 않는다', () {
      const MapBounds inner = MapBounds(
        minLat: 37.555,
        minLng: 126.975,
        maxLat: 37.565,
        maxLng: 126.985,
      );

      expect(seoul.contains(inner), isTrue);
    });

    test('한 변이라도 벗어나면 포함이 아니다 — 재조회한다', () {
      const MapBounds shifted = MapBounds(
        minLat: 37.55,
        minLng: 126.97,
        maxLat: 37.57,
        maxLng: 127.10,
      );

      expect(seoul.contains(shifted), isFalse);
    });

    test('경계가 정확히 겹쳐도 포함이다 — 가진 데이터로 그릴 수 있다', () {
      expect(seoul.contains(seoul), isTrue);
    });
  });

  group('유효성', () {
    test('뒤집힌 bbox는 유효하지 않다', () {
      const MapBounds flipped = MapBounds(
        minLat: 37.57,
        minLng: 126.97,
        maxLat: 37.55,
        maxLng: 126.99,
      );

      expect(flipped.isValid, isFalse);
    });

    test('면적이 0이면 유효하지 않다 — 걸치는 것이 없다', () {
      const MapBounds empty = MapBounds(
        minLat: 37.55,
        minLng: 126.97,
        maxLat: 37.55,
        maxLng: 126.99,
      );

      expect(empty.isValid, isFalse);
    });

    test('위도 범위를 벗어나면 유효하지 않다', () {
      const MapBounds outOfRange = MapBounds(
        minLat: 37.55,
        minLng: 126.97,
        maxLat: 91,
        maxLng: 126.99,
      );

      expect(outOfRange.isValid, isFalse);
    });

    test('정상 bbox는 유효하다', () {
      expect(seoul.isValid, isTrue);
    });
  });

  // ─── marker_thinning ─────────────────────────────────────────

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

  /// 예전에는 문화행사를 격자 밖으로 통과시키는 예외가 있었다. 그 마커를 더 이상
  /// 만들지 않으므로(사용자 결정 2026-09-18) 격자는 종류를 보지 않는다.
  test('같은 칸이면 종류와 무관하게 하나만 남는다', () {
    final List<MapMarker> thinned = thinMarkers(
      markers: <MapMarker>[
        markerAt('a', 37.5005, 127.0005),
        markerAt('b', 37.5006, 127.0006, kind: MapMarkerKind.culturalEvent),
      ],
      viewport: viewport,
      columns: 5,
      maxCount: 20,
    );

    expect(thinned, hasLength(1));
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

  // ─── region_recommendation ───────────────────────────────────

  RegionRecommendation regionWith(List<RegionScore> scores) =>
      RegionRecommendation(
        code: '11110',
        name: 'Jongno-gu',
        provinceName: 'Seoul',
        scores: scores,
        scoreFactorCount: scores.length,
        centerLat: 37.5735,
        centerLng: 126.9790,
      );

  group('결측 항목', () {
    test('빠진 항목을 0점으로 채우지 않는다', () {
      // 서버가 산출 불가 항목을 빼서 준다(§2.2). 0으로 채우면 서버가 피한 왜곡을
      // 클라이언트가 되살린다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.congestion, value: 90, rank: 2),
      ]);

      expect(region.scores, hasLength(1));
      expect(region.lacks(RegionScoreFactor.visitorVolume), isTrue);
    });

    test('거리 항목이 없으면 위치 없이 받은 결과다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.congestion, value: 90, rank: 1),
      ]);

      expect(region.lacksDistance, isTrue);
    });

    test('거리 항목이 있으면 위치를 반영한 결과다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.distance, value: 70, rank: 3),
      ]);

      expect(region.lacksDistance, isFalse);
    });
  });

  group('점수 막대 비율', () {
    test('0~100을 0.0~1.0으로 옮긴다', () {
      const RegionScore score = RegionScore(
        factor: RegionScoreFactor.stayIntensity,
        value: 75,
        rank: 4,
      );

      expect(score.fraction, closeTo(0.75, 1e-9));
    });

    test('범위를 벗어난 값이 와도 막대가 넘치지 않는다', () {
      const RegionScore over = RegionScore(
        factor: RegionScoreFactor.congestion,
        value: 140,
        rank: 1,
      );
      const RegionScore under = RegionScore(
        factor: RegionScoreFactor.congestion,
        value: -20,
        rank: 30,
      );

      expect(over.fraction, 1.0);
      expect(under.fraction, 0.0);
    });
  });

  group('강점 라벨 (시·도 3위 이내)', () {
    test('3위 안에 든 항목만 고른다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.distance, value: 90, rank: 1),
        RegionScore(factor: RegionScoreFactor.congestion, value: 80, rank: 3),
        // 4위는 라벨을 붙이지 않는다.
        RegionScore(
          factor: RegionScoreFactor.stayIntensity,
          value: 70,
          rank: 4,
        ),
      ]);

      expect(
        region.topRankedScores.map((RegionScore s) => s.factor).toList(),
        <RegionScoreFactor>[
          RegionScoreFactor.distance,
          RegionScoreFactor.congestion,
        ],
      );
    });

    test('순위가 좋은 것부터 나온다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.congestion, value: 50, rank: 3),
        RegionScore(factor: RegionScoreFactor.distance, value: 40, rank: 1),
      ]);

      expect(region.topRankedScores.first.factor, RegionScoreFactor.distance);
    });

    test('3위 안에 든 항목이 없으면 라벨도 없다', () {
      // 실측상 10곳 중 2곳이 이렇다. 없는 강점을 지어내지 않는다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.congestion, value: 90, rank: 4),
        RegionScore(factor: RegionScoreFactor.distance, value: 80, rank: 12),
      ]);

      expect(region.topRankedScores, isEmpty);
    });

    test('모르는 항목은 라벨이 되지 않는다', () {
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(factor: RegionScoreFactor.unknown, value: 100, rank: 1),
        RegionScore(factor: RegionScoreFactor.distance, value: 40, rank: 2),
      ]);

      expect(
        region.topRankedScores.map((RegionScore s) => s.factor).toList(),
        <RegionScoreFactor>[RegionScoreFactor.distance],
      );
    });

    test('동순위는 항목 선언 순서로 가른다', () {
      // 서버가 준 배열 순서에 따라 라벨 순서가 흔들리면 안 된다.
      final RegionRecommendation region = regionWith(const <RegionScore>[
        RegionScore(
          factor: RegionScoreFactor.spendingIntensity,
          value: 100,
          rank: 1,
        ),
        RegionScore(
          factor: RegionScoreFactor.stayIntensity,
          value: 100,
          rank: 1,
        ),
      ]);

      expect(
        region.topRankedScores.first.factor,
        RegionScoreFactor.stayIntensity,
      );
    });
  });

  group('빈 결과(§5.1)', () {
    test('목록이 비면 빈 결과다', () {
      // 바다·해외 좌표, 시군구 3개 미만인 시도(세종·제주), 후보 없음이 모두 이렇게
      // 온다. 어느 경우에도 오류가 아니다.
      const RegionRecommendationResult result = RegionRecommendationResult(
        regions: <RegionRecommendation>[],
      );

      expect(result.isEmpty, isTrue);
    });

    test('목록이 차 있으면 빈 결과가 아니다', () {
      final RegionRecommendationResult result = RegionRecommendationResult(
        regions: <RegionRecommendation>[regionWith(const <RegionScore>[])],
      );

      expect(result.isEmpty, isFalse);
    });
  });

}
