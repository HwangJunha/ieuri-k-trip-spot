import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/distance_format.dart';

/// 두 좌표 사이 거리. **서버가 추천 지역의 거리를 주지 않아 클라이언트가 계산한다** —
/// 거리 점수(0~100)는 정규화된 값이라 km로 되돌릴 수 없다.
void main() {
  test('같은 지점은 0이다', () {
    expect(
      distanceMetersBetween(
        lat1: 37.5665,
        lng1: 126.9780,
        lat2: 37.5665,
        lng2: 126.9780,
      ),
      closeTo(0, 0.001),
    );
  });

  test('서울시청에서 강남구청까지 실제 거리에 가깝다', () {
    // 실측 약 8.3km. 하버사인은 직선(대권) 거리라 도로 거리보다 짧다.
    final double meters = distanceMetersBetween(
      lat1: 37.5665,
      lng1: 126.9780,
      lat2: 37.5172,
      lng2: 127.0473,
    );

    expect(meters, closeTo(8300, 500));
  });

  test('서울에서 부산까지 대략 325km다', () {
    final double meters = distanceMetersBetween(
      lat1: 37.5665,
      lng1: 126.9780,
      lat2: 35.1796,
      lng2: 129.0756,
    );

    expect(meters / 1000, closeTo(325, 10));
  });

  test('방향이 바뀌어도 거리는 같다', () {
    final double forward = distanceMetersBetween(
      lat1: 37.5665,
      lng1: 126.9780,
      lat2: 35.1796,
      lng2: 129.0756,
    );
    final double backward = distanceMetersBetween(
      lat1: 35.1796,
      lng1: 129.0756,
      lat2: 37.5665,
      lng2: 126.9780,
    );

    expect(forward, closeTo(backward, 0.001));
  });
}
