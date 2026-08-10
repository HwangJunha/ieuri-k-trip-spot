import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/map/model/map_bounds.dart';

/// 뷰포트 확장과 포함 판정(R20). 순수 계산이라 SDK 없이 그대로 검증된다.
void main() {
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
}
