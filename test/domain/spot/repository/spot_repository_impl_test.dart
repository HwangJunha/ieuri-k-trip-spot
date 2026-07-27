import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/repository/spot_repository_impl.dart';

void main() {
  const SpotRepositoryImpl repo = SpotRepositoryImpl();

  test('fetchRecommendedSpots returns populated spots', () async {
    final List<TouristSpot> spots = await repo.fetchRecommendedSpots();

    expect(spots, isNotEmpty);
    for (final TouristSpot spot in spots) {
      expect(spot.id, isNotEmpty);
      expect(spot.name, isNotEmpty);
      expect(spot.location, isNotEmpty);
    }
  });

  test('fetchPopularSpots returns spots with rating and distance', () async {
    final List<TouristSpot> spots = await repo.fetchPopularSpots();

    expect(spots, isNotEmpty);
    for (final TouristSpot spot in spots) {
      expect(spot.rating, isNotNull);
      expect(spot.distanceKm, isNotNull);
    }
  });
}
