import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';

void main() {
  test('TouristSpot equality is value-based', () {
    const TouristSpot a = TouristSpot(
      id: '1',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      distanceMeters: 2400,
    );
    const TouristSpot b = TouristSpot(
      id: '1',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      distanceMeters: 2400,
    );
    const TouristSpot different = TouristSpot(
      id: '2',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      distanceMeters: 2400,
    );

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(different));
  });

  // AC-15.2·AC-15.3 — 홈 화면 모델에 별점·혼잡도 필드가 **없다**.
  //
  // 없어진 필드는 런타임 단언으로 잡을 수 없다. 그 이름을 쓰는 코드는 애초에
  // 컴파일되지 않기 때문이다 — **이 테스트 파일이 컴파일된다는 사실 자체가
  // 필드가 없다는 증거**이고, 누군가 rating을 되살리면 아래 목록이 어긋나 깨진다.
  //
  // 리플렉션(dart:mirrors)은 Flutter에서 못 쓰므로, 모델이 노출하는 값 집합을
  // 여기에 고정하는 것이 실질적인 방어선이다.
  test('TouristSpot carries only server-backed values', () {
    const TouristSpot spot = TouristSpot(
      id: '1',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      thumbnailImageUrl: 'https://example.test/n.jpg',
      address: '105 Namsangongwon-gil',
      distanceMeters: 2400,
      attributionText: 'KTO',
    );

    // 서버가 실제로 주는 값들.
    expect(spot.id, '1');
    expect(spot.name, 'N Seoul Tower');
    expect(spot.location, 'Seoul, Yongsan-gu');
    expect(spot.thumbnailImageUrl, 'https://example.test/n.jpg');
    expect(spot.address, '105 Namsangongwon-gil');
    expect(spot.attributionText, 'KTO');
    // 거리는 서버 계산값이라 남는다 — 미터 단위이며 표시 포맷은 위젯이 붙인다.
    expect(spot.distance?.meters, 2400);
  });
}
