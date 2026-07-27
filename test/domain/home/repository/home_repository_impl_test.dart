import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/home/model/tour_event.dart';
import 'package:ieuri_k_trip_spot/domain/home/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/home/repository/home_repository_impl.dart';

void main() {
  const HomeRepositoryImpl repo = HomeRepositoryImpl();

  test('fetchRecommendedSpots returns populated spots', () async {
    final List<TouristSpot> spots = await repo.fetchRecommendedSpots();

    expect(spots, isNotEmpty);
    for (final TouristSpot spot in spots) {
      expect(spot.id, isNotEmpty);
      expect(spot.name, isNotEmpty);
      expect(spot.location, isNotEmpty);
    }
  });

  test('fetchHappeningNowEvents returns populated events', () async {
    final List<TourEvent> events = await repo.fetchHappeningNowEvents();

    expect(events, isNotEmpty);
    for (final TourEvent event in events) {
      expect(event.id, isNotEmpty);
      expect(event.title, isNotEmpty);
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
