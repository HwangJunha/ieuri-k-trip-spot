import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_refresh_policy.dart';

void main() {
  group('LocationRefreshPolicy.distanceMeters', () {
    // 서울시청. 기준점으로 쓴다.
    const Coordinates cityHall = Coordinates(
      latitude: 37.5663,
      longitude: 126.9779,
    );

    test('같은 자리는 0이다', () {
      expect(
        LocationRefreshPolicy.distanceMeters(cityHall, cityHall),
        closeTo(0, 0.001),
      );
    });

    /// 위도 1도는 어디서나 약 111km다 — 경도와 달리 위도에 따라 변하지 않는다.
    test('위도 0.01도는 약 1.1km다', () {
      const Coordinates north = Coordinates(
        latitude: 37.5763,
        longitude: 126.9779,
      );
      expect(
        LocationRefreshPolicy.distanceMeters(cityHall, north),
        closeTo(1112, 5),
      );
    });

    test('방향을 바꿔도 같은 거리다', () {
      const Coordinates other = Coordinates(
        latitude: 37.5800,
        longitude: 127.0000,
      );
      expect(
        LocationRefreshPolicy.distanceMeters(cityHall, other),
        closeTo(LocationRefreshPolicy.distanceMeters(other, cityHall), 0.001),
      );
    });
  });

  group('LocationRefreshPolicy.shouldRefresh', () {
    const Coordinates origin = Coordinates(
      latitude: 37.5663,
      longitude: 126.9779,
    );

    /// 같은 동네 안에서 걸어 다닌 정도. 갱신하면 목록이 제멋대로 바뀐다.
    test('가까이 움직였으면 갱신하지 않는다', () {
      // 위도 0.001도 ≈ 111m.
      const Coordinates nearby = Coordinates(
        latitude: 37.5673,
        longitude: 126.9779,
      );
      expect(LocationRefreshPolicy.shouldRefresh(origin, nearby), isFalse);
    });

    /// 지하철 한 정거장 정도. 이 경우까지 붙잡으면 예전 동네가 계속 보인다.
    test('멀리 움직였으면 갱신한다', () {
      // 위도 0.01도 ≈ 1.1km.
      const Coordinates far = Coordinates(
        latitude: 37.5763,
        longitude: 126.9779,
      );
      expect(LocationRefreshPolicy.shouldRefresh(origin, far), isTrue);
    });

    /// 경계에서 갈리는 지점을 고정해 둔다 — 임계를 바꾸면 이 테스트가 알려준다.
    test('임계와 같으면 갱신한다', () {
      // 위도 0.0045도 ≈ 500m.
      const Coordinates atThreshold = Coordinates(
        latitude: 37.570797,
        longitude: 126.9779,
      );
      final double d = LocationRefreshPolicy.distanceMeters(
        origin,
        atThreshold,
      );
      expect(d, greaterThanOrEqualTo(LocationRefreshPolicy.thresholdMeters));
      expect(LocationRefreshPolicy.shouldRefresh(origin, atThreshold), isTrue);
    });

    /// 비교할 것이 없으면 기존 좌표를 그대로 둔다 — 좌표를 못 받은 상황에서
    /// 화면을 흔들 이유가 없다.
    test('한쪽이 없으면 갱신하지 않는다', () {
      expect(LocationRefreshPolicy.shouldRefresh(null, origin), isFalse);
      expect(LocationRefreshPolicy.shouldRefresh(origin, null), isFalse);
      expect(LocationRefreshPolicy.shouldRefresh(null, null), isFalse);
    });
  });
}
