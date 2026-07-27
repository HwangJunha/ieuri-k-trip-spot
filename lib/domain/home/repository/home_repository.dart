import '../model/tour_event.dart';
import '../model/tourist_spot.dart';

/// Data access for the Home screen sections. Returns domain models only; the
/// current implementation serves mock data, and when the tourism GraphQL API
/// lands only the implementation changes — providers and UI stay put (spec §4).
///
/// Signatures are async on purpose so the eventual network swap needs no
/// provider/UI change.
abstract interface class HomeRepository {
  /// "Recommended for You" — horizontal spot cards.
  Future<List<TouristSpot>> fetchRecommendedSpots();

  /// "Happening Now" — event cards.
  Future<List<TourEvent>> fetchHappeningNowEvents();

  /// "Popular Spots" — vertical spot cards with rating + distance.
  Future<List<TouristSpot>> fetchPopularSpots();
}
