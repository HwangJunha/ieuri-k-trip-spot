import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_geometry.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_hit_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_image.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_projection.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/coordinate_reduction.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/map_cell.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/map_screen_view_state.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/national_map_config.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/photo_scan_progress.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/province_progress.dart';

/// 정사각형 링 하나짜리 칸 도형을 만든다.
CellGeometry _square(
  String cellId, {
  required double lng,
  required double lat,
  double size = 1,
}) {
  final List<GeoPoint> ring = <GeoPoint>[
    GeoPoint(lng, lat),
    GeoPoint(lng + size, lat),
    GeoPoint(lng + size, lat + size),
    GeoPoint(lng, lat + size),
  ];
  return CellGeometry(
    cellId: cellId,
    provinceCode: '41',
    polygons: <List<GeoPoint>>[ring],
    center: GeoPoint(lng + size / 2, lat + size / 2),
    bounds: GeoBounds.of(ring),
  );
}

MapCell _cell(String code, String province, {bool visited = false}) => MapCell(
  id: code,
  districtCodes: <String>[code],
  name: code,
  provinceName: province,
  provinceCode: province,
  visited: visited,
  center: const GeoPoint(127, 37),
);

void main() {
  group('좌표 축약 (R26)', () {
    test('같은 격자 안의 좌표 100건이 1건으로 줄어든다', () {
      // 0.01도 격자 하나 안에 흩어진 100건.
      final List<GeoPoint> points = <GeoPoint>[
        for (int i = 0; i < 100; i++)
          GeoPoint(127.0001 + i * 0.00001, 37.0001 + i * 0.00001),
      ];

      final List<GeoPoint> reduced = CoordinateReduction.dedupeByGrid(points);

      expect(reduced, hasLength(1));
      expect(reduced.first, points.first, reason: '살아남는 것은 처음 좌표다');
    });

    test('격자가 다르면 살아남는다', () {
      final List<GeoPoint> reduced = CoordinateReduction.dedupeByGrid(
        <GeoPoint>[
          const GeoPoint(127.001, 37.001),
          const GeoPoint(127.015, 37.001), // 경도 격자가 다르다
          const GeoPoint(127.001, 37.025), // 위도 격자가 다르다
        ],
      );

      expect(reduced, hasLength(3));
    });

    test('입력 순서를 지킨다', () {
      final List<GeoPoint> reduced = CoordinateReduction.dedupeByGrid(
        <GeoPoint>[
          const GeoPoint(129.0, 35.0),
          const GeoPoint(127.0, 37.0),
          const GeoPoint(128.0, 36.0),
        ],
      );

      expect(
        reduced.map((GeoPoint p) => p.lng),
        <double>[129.0, 127.0, 128.0],
      );
    });
  });

  group('전송 대상 필터 (R25·R27)', () {
    test('한국 밖 좌표는 빠진다', () {
      final List<GeoPoint> kept = CoordinateReduction.withinKorea(<GeoPoint>[
        const GeoPoint(127.0, 37.5), // 서울
        const GeoPoint(139.7, 35.6), // 도쿄
        const GeoPoint(-74.0, 40.7), // 뉴욕
        const GeoPoint(126.5, 33.5), // 제주
      ]);

      expect(kept, hasLength(2));
      expect(kept.map((GeoPoint p) => p.lng), <double>[127.0, 126.5]);
    });

    test('이미 방문한 칸의 bbox 안 좌표는 전송 목록에서 빠진다', () {
      final CellGeometry visited = _square('A', lng: 127.0, lat: 37.0);

      final List<GeoPoint> kept = CoordinateReduction.excludingVisited(
        <GeoPoint>[
          const GeoPoint(127.5, 37.5), // 방문 칸 안
          const GeoPoint(129.0, 35.0), // 밖
        ],
        <GeoBounds>[visited.bounds],
      );

      expect(kept, hasLength(1));
      expect(kept.single.lng, 129.0);
    });

    test('방문한 칸이 없으면 아무것도 버리지 않는다', () {
      final List<GeoPoint> points = <GeoPoint>[
        const GeoPoint(127.5, 37.5),
      ];

      expect(
        CoordinateReduction.excludingVisited(points, const <GeoBounds>[]),
        hasLength(1),
      );
    });

    test('세 단계가 순서대로 적용된다', () {
      final CellGeometry visited = _square('A', lng: 127.0, lat: 37.0);

      final List<GeoPoint> out = CoordinateReduction.reduce(
        <GeoPoint>[
          const GeoPoint(139.7, 35.6), // 해외 -> 1단계에서 탈락
          const GeoPoint(127.5, 37.5), // 방문 칸 -> 3단계에서 탈락
          const GeoPoint(127.5001, 37.5001), // 같은 격자 -> 2단계에서 탈락
          const GeoPoint(129.0, 35.2), // 살아남는다
        ],
        visitedBounds: <GeoBounds>[visited.bounds],
      );

      expect(out, hasLength(1));
      expect(out.single.lng, 129.0);
    });
  });

  group('한국 영역 (R25)', () {
    test('국내 주요 좌표가 영역 안이다', () {
      const List<GeoPoint> inside = <GeoPoint>[
        GeoPoint(126.9780, 37.5665), // 서울
        GeoPoint(129.0756, 35.1796), // 부산
        GeoPoint(126.5312, 33.4996), // 제주
        GeoPoint(130.9058, 37.4844), // 울릉도
      ];

      for (final GeoPoint p in inside) {
        expect(
          NationalMapConfig.koreaBounds.contains(p),
          isTrue,
          reason: '$p',
        );
      }
    });

    test('해외 좌표는 영역 밖이다', () {
      const List<GeoPoint> outside = <GeoPoint>[
        GeoPoint(139.7, 35.68), // 도쿄
        GeoPoint(-74.0, 40.7), // 뉴욕
        GeoPoint(121.5, 25.0), // 타이베이
      ];

      for (final GeoPoint p in outside) {
        expect(
          NationalMapConfig.koreaBounds.contains(p),
          isFalse,
          reason: '$p',
        );
      }
    });
  });

  group('시도 진척 계산 (R21)', () {
    test('경기도 31칸 중 12칸을 방문하면 12/31이다', () {
      final List<MapCell> cells = <MapCell>[
        for (int i = 0; i < 31; i++) _cell('41$i', '41', visited: i < 12),
      ];

      final ProvinceProgress gyeonggi = provinceProgressOf(cells).single;

      expect(gyeonggi.visited, 12);
      expect(gyeonggi.total, 31);
      expect(gyeonggi.ratio, closeTo(12 / 31, 1e-9));
      expect(gyeonggi.isComplete, isFalse);
    });

    test('서울 1칸을 방문하면 1/1이고 완료다', () {
      final ProvinceProgress seoul =
          provinceProgressOf(<MapCell>[_cell('11', '11', visited: true)])
              .single;

      expect(seoul.visited, 1);
      expect(seoul.total, 1);
      expect(seoul.isComplete, isTrue);
    });

    test('시도별로 나뉘고 시도 코드 오름차순이다', () {
      final List<ProvinceProgress> progress = provinceProgressOf(<MapCell>[
        _cell('41a', '41', visited: true),
        _cell('11', '11'),
        _cell('41b', '41'),
      ]);

      expect(progress.map((ProvinceProgress p) => p.provinceCode), <String>[
        '11',
        '41',
      ]);
      expect(progress.last.visited, 1);
      expect(progress.last.total, 2);
    });

    test('빈 목록은 빈 진척이다', () {
      expect(provinceProgressOf(const <MapCell>[]), isEmpty);
    });

    test('전국 진척은 칸 전체를 센다', () {
      final ProvinceProgress all = nationwideProgressOf(<MapCell>[
        _cell('11', '11', visited: true),
        _cell('41a', '41'),
      ], label: '전국');

      expect(all.visited, 1);
      expect(all.total, 2);
    });
  });

  group('저작권 유형 -> 크롭 허용 (R23)', () {
    CellImage image(CellCopyrightType type) => CellImage(
      imageUrl: 'https://example.test/a.jpg',
      caption: '경복궁',
      kind: CellImageKind.landmark,
      copyright: type,
      attributionText: '한국관광공사',
    );

    test('TYPE1은 크롭할 수 있다', () {
      expect(image(CellCopyrightType.type1).allowsCrop, isTrue);
    });

    test('TYPE3은 원본 비율을 지킨다', () {
      expect(image(CellCopyrightType.type3).allowsCrop, isFalse);
    });

    test('UNSPECIFIED는 TYPE3와 같게 다룬다', () {
      expect(
        image(CellCopyrightType.unspecified).allowsCrop,
        image(CellCopyrightType.type3).allowsCrop,
      );
    });
  });

  group('스캔 재개 상태 (R28·R29·R32)', () {
    test('400장 처리 후 중단하면 다음 시작점이 401이다', () {
      const PhotoScanProgress stopped = PhotoScanProgress(
        stage: PhotoScanStage.idle,
        processed: 400,
        total: 1000,
      );

      expect(stopped.isResumable, isTrue);
      // 401번째부터 = 이미 처리한 400장 다음.
      expect(stopped.processed, 400);
    });

    test('1000장 중 300장을 처리하면 진행률이 300/1000이다', () {
      const PhotoScanProgress p = PhotoScanProgress(
        stage: PhotoScanStage.scanning,
        processed: 300,
        total: 1000,
      );

      expect(p.processed, 300);
      expect(p.total, 1000);
      expect(p.ratio, closeTo(0.3, 1e-9));
    });

    test('다 읽었으면 재개 대상이 아니다', () {
      const PhotoScanProgress done = PhotoScanProgress(
        stage: PhotoScanStage.completed,
        processed: 1000,
        total: 1000,
      );

      expect(done.isResumable, isFalse);
    });

    test('좌표가 하나도 없이 끝난 것은 오류가 아니라 안내 대상이다', () {
      const PhotoScanProgress empty = PhotoScanProgress(
        stage: PhotoScanStage.completed,
        processed: 500,
        total: 500,
      );

      expect(empty.finishedWithoutCoordinates, isTrue);
      expect(empty.stage, isNot(PhotoScanStage.failed));
    });

    test('전체를 모르면 진행률은 0이다', () {
      const PhotoScanProgress p = PhotoScanProgress(processed: 10);

      expect(p.ratio, 0);
    });
  });

  group('칸 히트 테스트 (R22)', () {
    final CellGeometry a = _square('A', lng: 127.0, lat: 37.0);
    final CellGeometry b = _square('B', lng: 129.0, lat: 35.0);

    test('칸 안의 점은 그 칸을 찾는다', () {
      expect(
        CellHitTest.cellAt(<CellGeometry>[a, b], const GeoPoint(127.5, 37.5))
            ?.cellId,
        'A',
      );
      expect(
        CellHitTest.cellAt(<CellGeometry>[a, b], const GeoPoint(129.5, 35.5))
            ?.cellId,
        'B',
      );
    });

    test('어느 칸에도 없는 점은 null이다', () {
      expect(
        CellHitTest.cellAt(<CellGeometry>[a, b], const GeoPoint(120.0, 30.0)),
        isNull,
      );
    });

    test('bbox 안이지만 폴리곤 밖이면 찾지 않는다', () {
      // ㄴ 모양: 오른쪽 위가 파인 도형.
      final List<GeoPoint> ring = <GeoPoint>[
        const GeoPoint(0, 0),
        const GeoPoint(2, 0),
        const GeoPoint(2, 1),
        const GeoPoint(1, 1),
        const GeoPoint(1, 2),
        const GeoPoint(0, 2),
      ];

      expect(CellHitTest.containsPoint(ring, const GeoPoint(0.5, 0.5)), isTrue);
      expect(
        CellHitTest.containsPoint(ring, const GeoPoint(1.5, 1.5)),
        isFalse,
        reason: '파인 부분은 도형 밖이다',
      );
    });
  });

  group('투영 (설계 §3)', () {
    const GeoBounds bounds = GeoBounds(
      minLng: 126,
      minLat: 33,
      maxLng: 130,
      maxLat: 38,
    );

    test('화면 좌표와 경위도가 서로의 역이다', () {
      final CellProjection p = CellProjection.fit(
        bounds: bounds,
        width: 400,
        height: 800,
      );

      const GeoPoint origin = GeoPoint(128, 36);
      final ({double dx, double dy}) screen = p.toScreen(origin);
      final GeoPoint back = p.toGeo(screen.dx, screen.dy);

      expect(back.lng, closeTo(origin.lng, 1e-9));
      expect(back.lat, closeTo(origin.lat, 1e-9));
    });

    test('북쪽이 화면 위다', () {
      final CellProjection p = CellProjection.fit(
        bounds: bounds,
        width: 400,
        height: 800,
      );

      expect(
        p.toScreen(const GeoPoint(128, 38)).dy,
        lessThan(p.toScreen(const GeoPoint(128, 33)).dy),
      );
    });

    test('경도를 위도로 보정해 가로로 늘어나지 않는다', () {
      final CellProjection p = CellProjection.fit(
        bounds: bounds,
        width: 400,
        height: 800,
      );

      // 36°N에서 경도 1도는 위도 1도보다 짧다.
      expect(p.lngScale, lessThan(1));
      expect(p.lngScale, closeTo(0.81, 0.02));
    });

    test('폭이 0이어도 계산이 깨지지 않는다', () {
      final CellProjection p = CellProjection.fit(
        bounds: bounds,
        width: 0,
        height: 0,
      );

      expect(p.scale.isFinite, isTrue);
    });
  });

  // "위치 정보가 있는 사진을 찾지 못했어요" 화면에 닫기 하나만 남아 막다른
  // 길이 됐다(사용자 지적 2026-08-26).
  group('완료 화면의 다시 채우기 (canRescan)', () {
    test('좌표를 못 찾고 끝나도 다시 채울 수 있다', () {
      const PhotoScanProgress p = PhotoScanProgress(
        stage: PhotoScanStage.completed,
        total: 100,
        processed: 100,
      );

      // 이 화면이 막다른 길이었다 — 그 사이 사진을 새로 찍었을 수 있다.
      expect(p.finishedWithoutCoordinates, isTrue);
      expect(p.canRescan, isTrue);
    });

    test('지역을 채우고 끝나면 다시 채울 수 있다', () {
      const PhotoScanProgress p = PhotoScanProgress(
        stage: PhotoScanStage.completed,
        total: 100,
        processed: 100,
        foundCoordinates: 10,
      );

      expect(p.canRescan, isTrue);
    });

    test('"일부만 허용"에서는 감춘다', () {
      const PhotoScanProgress p = PhotoScanProgress(
        stage: PhotoScanStage.completed,
        total: 3,
        processed: 3,
        limitedAccess: true,
      );

      // 해법은 사진 재선택·전체 허용이고, 끝나면 스캔이 자동으로 다시 돈다.
      expect(p.canRescan, isFalse);
    });
  });

  // 사진 스캔 중 지역이 칠해질 때마다 지도가 사라지고 스피너가 떴다(사용자 지적
  // 2026-08-26). 갱신 중 잠깐 로딩이 되는 것과 보여 줄 값이 아직 없는 것을
  // 화면이 구분하지 못한 탓이다.
  group('지도 화면이 무엇을 그릴지 (MapScreenViewState)', () {
    test('값이 둘 다 있으면 지도를 그린다', () {
      expect(
        MapScreenViewState.of(
          hasCells: true,
          hasGeometries: true,
          failed: false,
        ),
        MapScreenViewState.map,
      );
    });

    test('갱신이 실패해도 값을 들고 있으면 지도를 그린다', () {
      // 이미 그려 둔 지도를 치울 이유가 없다.
      expect(
        MapScreenViewState.of(
          hasCells: true,
          hasGeometries: true,
          failed: true,
        ),
        MapScreenViewState.map,
      );
    });

    test('아무것도 못 받았으면 로딩이다', () {
      expect(
        MapScreenViewState.of(
          hasCells: false,
          hasGeometries: false,
          failed: false,
        ),
        MapScreenViewState.loading,
      );
    });

    test('한쪽만 있으면 아직 로딩이다', () {
      expect(
        MapScreenViewState.of(
          hasCells: true,
          hasGeometries: false,
          failed: false,
        ),
        MapScreenViewState.loading,
      );
    });

    test('아무것도 못 받은 채 실패했으면 오류다', () {
      expect(
        MapScreenViewState.of(
          hasCells: false,
          hasGeometries: false,
          failed: true,
        ),
        MapScreenViewState.error,
      );
    });
  });
}
