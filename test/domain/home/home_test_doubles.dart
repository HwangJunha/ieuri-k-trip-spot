import 'package:ieuri_k_trip_spot/domain/home/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/home/model/tour_event.dart';
import 'package:ieuri_k_trip_spot/domain/home/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/home/repository/home_repository.dart';

/// A single configurable fake [HomeRepository]. Each section returns whatever
/// the test supplies (defaults to one item), keeping test setup minimal.
class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({
    List<TouristSpot>? recommended,
    List<TourEvent>? events,
    List<TouristSpot>? popular,
  }) : recommended = recommended ?? const <TouristSpot>[_spot],
       events = events ?? const <TourEvent>[_event],
       popular = popular ?? const <TouristSpot>[_spot];

  final List<TouristSpot> recommended;
  final List<TourEvent> events;
  final List<TouristSpot> popular;

  static const TouristSpot _spot = TouristSpot(
    id: 'spot-1',
    name: 'Gyeongbokgung Palace',
    imageRef: 'gyeongbokgung',
    location: 'Seoul, Jongno-gu',
    congestion: CongestionLevel.low,
    rating: 4.7,
    distanceKm: 1.2,
  );

  static const TourEvent _event = TourEvent(
    id: 'event-1',
    title: 'Myeongdong Food Fest',
    category: EventCategory.festival,
    imageRef: 'myeongdong',
  );

  @override
  Future<List<TouristSpot>> fetchRecommendedSpots() async => recommended;

  @override
  Future<List<TourEvent>> fetchHappeningNowEvents() async => events;

  @override
  Future<List<TouristSpot>> fetchPopularSpots() async => popular;
}
