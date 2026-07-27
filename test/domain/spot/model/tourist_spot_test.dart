import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';

void main() {
  test('TouristSpot equality is value-based', () {
    const TouristSpot a = TouristSpot(
      id: '1',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      congestion: CongestionLevel.high,
      rating: 4.8,
      distanceKm: 2.4,
    );
    const TouristSpot b = TouristSpot(
      id: '1',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      congestion: CongestionLevel.high,
      rating: 4.8,
      distanceKm: 2.4,
    );
    const TouristSpot different = TouristSpot(
      id: '2',
      name: 'N Seoul Tower',
      imageRef: 'nseoul',
      location: 'Seoul, Yongsan-gu',
      congestion: CongestionLevel.high,
    );

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(different));
  });
}
