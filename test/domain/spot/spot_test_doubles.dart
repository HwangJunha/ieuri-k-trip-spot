import 'package:ieuri_k_trip_spot/domain/spot/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/repository/spot_repository.dart';

/// A single configurable fake [SpotRepository]. Each section returns whatever
/// the test supplies (defaults to one item), keeping test setup minimal.
class FakeSpotRepository implements SpotRepository {
  FakeSpotRepository({
    List<TouristSpot>? recommended,
    List<TouristSpot>? popular,
  }) : recommended = recommended ?? const <TouristSpot>[_spot],
       popular = popular ?? const <TouristSpot>[_spot];

  final List<TouristSpot> recommended;
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

  @override
  Future<List<TouristSpot>> fetchRecommendedSpots() async => recommended;

  @override
  Future<List<TouristSpot>> fetchPopularSpots() async => popular;
}
