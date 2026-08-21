import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_geometry.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/cell_shape_builder.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/district_boundary.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/district_boundary_source.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/district_resolver.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/map_cell.dart';
import 'package:ieuri_k_trip_spot/domain/national_map/model/shared_map.dart';

/// 3.8MB 자산을 테스트마다 다시 읽으면 느리므로 한 번만 읽는다.
late final List<DistrictBoundary> _boundaries;
late final DistrictResolver _resolver;

MapCell _cell(String id, List<String> districts) => MapCell(
  id: id,
  districtCodes: districts,
  name: id,
  provinceName: '',
  provinceCode: districts.first.substring(0, 2),
  visited: false,
  center: const GeoPoint(127, 37),
);

void main() {
  setUpAll(() {
    _boundaries = DistrictBoundarySource.parse(
      File('asset/geo/district-boundaries.geojson').readAsStringSync(),
    );
    _resolver = DistrictResolver(_boundaries);
  });

  group('경계 자산 (v1.2 §0)', () {
    test('252개 시군구가 파싱된다', () {
      expect(_boundaries, hasLength(252));
    });

    test('모든 시군구가 5자리 코드와 2자리 시도 코드를 갖는다', () {
      for (final DistrictBoundary d in _boundaries) {
        expect(d.code, hasLength(5), reason: d.nameKo);
        expect(d.provinceCode, hasLength(2), reason: d.nameKo);
        expect(d.polygons, isNotEmpty, reason: d.nameKo);
      }
    });

    test('코드가 겹치지 않는다', () {
      expect(
        _boundaries.map((DistrictBoundary d) => d.code).toSet(),
        hasLength(252),
      );
    });

    test('구멍이 실제로 담긴다', () {
      // 전국에 몇 개뿐이지만 파서가 버리면 그 안 좌표가 잘못 판정된다.
      final int holes = _boundaries
          .expand((DistrictBoundary d) => d.polygons)
          .fold(0, (int sum, DistrictPolygon p) => sum + p.holes.length);

      expect(holes, greaterThan(0));
    });
  });

  group('좌표 판정 (서버 PostGIS와 일치해야 한다)', () {
    test('서울시청은 중구(11140)다', () {
      final DistrictBoundary? d = _resolver.districtAt(
        const GeoPoint(126.9780, 37.5665),
      );

      expect(d?.code, '11140');
      expect(d?.nameKo, '중구');
    });

    test('수원 장안구는 41111이다', () {
      expect(
        _resolver.districtAt(const GeoPoint(127.0104, 37.3050))?.code,
        '41111',
      );
    });

    test('동해 한가운데는 판정되지 않는다', () {
      expect(_resolver.districtAt(const GeoPoint(131.0, 37.5)), isNull);
    });

    test('도쿄는 판정되지 않는다', () {
      expect(_resolver.districtAt(const GeoPoint(139.7, 35.68)), isNull);
    });

    test('제주시청은 제주시(50110)다', () {
      expect(
        _resolver.districtAt(const GeoPoint(126.5312, 33.4996))?.code,
        '50110',
      );
    });
  });

  group('판정 결과 축약 (recordVisits 1회의 근거)', () {
    test('같은 시군구의 좌표 여러 건이 코드 1개가 된다', () {
      final DistrictResolution r = _resolver.resolve(<GeoPoint>[
        const GeoPoint(126.9780, 37.5665),
        const GeoPoint(126.9770, 37.5660),
        const GeoPoint(126.9760, 37.5670),
      ]);

      expect(r.districtCodes, <String>['11140']);
      expect(r.unresolvedCount, 0);
    });

    test('판정 실패는 오류가 아니라 개수로 센다', () {
      final DistrictResolution r = _resolver.resolve(<GeoPoint>[
        const GeoPoint(126.9780, 37.5665), // 서울
        const GeoPoint(139.7, 35.68), // 도쿄
        const GeoPoint(131.0, 37.5), // 동해
      ]);

      expect(r.districtCodes, <String>['11140']);
      expect(r.unresolvedCount, 2);
    });

    test('결과는 오름차순이고 중복이 없다', () {
      final DistrictResolution r = _resolver.resolve(<GeoPoint>[
        const GeoPoint(129.0756, 35.1796), // 부산
        const GeoPoint(126.9780, 37.5665), // 서울
        const GeoPoint(126.9780, 37.5665), // 서울 again
      ]);

      expect(r.districtCodes, hasLength(2));
      expect(
        r.districtCodes,
        orderedEquals(<String>[...r.districtCodes]..sort()),
      );
    });

    test('빈 입력은 빈 결과다', () {
      final DistrictResolution r = _resolver.resolve(const <GeoPoint>[]);

      expect(r.isEmpty, isTrue);
      expect(r.unresolvedCount, 0);
    });
  });

  group('칸 도형 조립 (CellShapeBuilder)', () {
    test('서울 25개 구가 폴리곤 1개로 합쳐진다', () {
      // 칸 안의 시군구 경계가 남으면 칸을 칠했을 때 내부에 선이 보인다.
      final List<String> seoulDistricts = _boundaries
          .where((DistrictBoundary d) => d.provinceCode == '11')
          .map((DistrictBoundary d) => d.code)
          .toList();
      expect(seoulDistricts, hasLength(25));

      final List<CellGeometry> shapes = CellShapeBuilder.build(
        cells: <MapCell>[_cell('2', seoulDistricts)],
        boundaries: _boundaries,
      );

      expect(shapes, hasLength(1));
      expect(shapes.single.polygons, hasLength(1), reason: '서울은 섬이 없다');
      expect(shapes.single.cellId, '2');
    });

    test('합쳐도 면적이 보존된다', () {
      // dissolve가 조각을 잃으면 면적이 줄어든다.
      final List<DistrictBoundary> seoul = _boundaries
          .where((DistrictBoundary d) => d.provinceCode == '11')
          .toList();
      final double sum = seoul
          .expand((DistrictBoundary d) => d.polygons)
          .fold(0, (double a, DistrictPolygon p) => a + _area(p.outer));

      final List<CellGeometry> shapes = CellShapeBuilder.build(
        cells: <MapCell>[
          _cell('2', seoul.map((DistrictBoundary d) => d.code).toList()),
        ],
        boundaries: _boundaries,
        // 단순화를 끄고 순수 병합만 본다.
        tolerance: 0,
        minArea: 0,
      );
      final double merged = shapes.single.polygons.fold(
        0,
        (double a, List<GeoPoint> p) => a + _area(p),
      );

      expect(merged, closeTo(sum, sum * 0.001));
    });

    test('섬이 있는 칸은 폴리곤이 여러 개다', () {
      // 인천은 강화·옹진의 섬을 갖는다.
      final List<String> incheon = _boundaries
          .where((DistrictBoundary d) => d.provinceCode == '28')
          .map((DistrictBoundary d) => d.code)
          .toList();

      final List<CellGeometry> shapes = CellShapeBuilder.build(
        cells: <MapCell>[_cell('5', incheon)],
        boundaries: _boundaries,
      );

      expect(shapes.single.polygons.length, greaterThan(1));
    });

    test('시군구 하나짜리 칸도 만들어진다', () {
      final List<CellGeometry> shapes = CellShapeBuilder.build(
        cells: <MapCell>[_cell('99', <String>['50110'])],
        boundaries: _boundaries,
      );

      expect(shapes, hasLength(1));
      expect(shapes.single.polygons, isNotEmpty);
    });

    test('대응하는 경계가 없는 칸은 빠진다', () {
      final List<CellGeometry> shapes = CellShapeBuilder.build(
        cells: <MapCell>[_cell('99', <String>['99999'])],
        boundaries: _boundaries,
      );

      expect(shapes, isEmpty);
    });

    test('중심이 칸의 bounds 안이다', () {
      final List<CellGeometry> shapes = CellShapeBuilder.build(
        cells: <MapCell>[_cell('2', <String>['11110', '11140'])],
        boundaries: _boundaries,
      );

      expect(shapes.single.bounds.contains(shapes.single.center), isTrue);
    });

    test('단순화가 정점을 크게 줄인다', () {
      final List<String> gangwon = _boundaries
          .where((DistrictBoundary d) => d.provinceCode == '51')
          .map((DistrictBoundary d) => d.code)
          .toList();

      final int raw = _boundaries
          .where((DistrictBoundary d) => gangwon.contains(d.code))
          .expand((DistrictBoundary d) => d.polygons)
          .fold(0, (int a, DistrictPolygon p) => a + p.outer.length);

      final List<CellGeometry> shapes = CellShapeBuilder.build(
        cells: <MapCell>[_cell('80', gangwon)],
        boundaries: _boundaries,
      );
      final int simplified = shapes.single.polygons.fold(
        0,
        (int a, List<GeoPoint> p) => a + p.length,
      );

      expect(simplified, lessThan(raw ~/ 2));
    });
  });

  group('공유 링크 토큰 (v1.2 §5)', () {
    test('커스텀 스킴에서 마지막 조각을 꺼낸다', () {
      expect(
        MapShareLink.tokenOf('ieuri://shared/kJ3xQ9mR7wZ2pL8vN4tY6cH1sB5dF0gA'),
        'kJ3xQ9mR7wZ2pL8vN4tY6cH1sB5dF0gA',
      );
    });

    test('https로 바뀌어도 같은 코드가 동작한다', () {
      // 2단계 전환(Universal Link) 후에도 앱 배포가 필요 없어야 한다.
      expect(MapShareLink.tokenOf('https://ieuri.app/shared/abc123'), 'abc123');
    });

    test('쿼리와 프래그먼트를 떼어 낸다', () {
      expect(MapShareLink.tokenOf('ieuri://shared/tok?from=kakao'), 'tok');
      expect(MapShareLink.tokenOf('https://x/shared/tok#top'), 'tok');
    });

    test('토큰이 없으면 null이다', () {
      expect(MapShareLink.tokenOf(''), isNull);
    });
  });

  group('겹침 표시 (null과 빈 배열이 다르다)', () {
    SharedMap map(List<String>? overlapping) => SharedMap(
      ownerNickname: 'nick',
      visitedCellIds: const <String>['1', '2'],
      overlappingCellIds: overlapping,
      visitedCount: 2,
    );

    test('null이면 비교할 수 없는 상태다', () {
      expect(map(null).canCompare, isFalse);
      expect(map(null).hasNoOverlap, isFalse);
    });

    test('빈 배열이면 비교했는데 겹침이 없는 상태다', () {
      expect(map(const <String>[]).canCompare, isTrue);
      expect(map(const <String>[]).hasNoOverlap, isTrue);
    });

    test('겹치는 칸이 있으면 둘 다 아니다', () {
      expect(map(const <String>['1']).canCompare, isTrue);
      expect(map(const <String>['1']).hasNoOverlap, isFalse);
    });
  });
}

double _area(List<GeoPoint> ring) {
  double s = 0;
  for (int i = 0; i < ring.length; i++) {
    final GeoPoint a = ring[i];
    final GeoPoint b = ring[(i + 1) % ring.length];
    s += a.lng * b.lat - b.lng * a.lat;
  }
  return s.abs() / 2;
}
