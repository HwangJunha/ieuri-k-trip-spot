import '../model/congestion_level.dart';
import '../model/tourist_spot.dart';
import 'spot_repository.dart';

/// Mock implementation of [SpotRepository] (spec §4). The tourism server has no
/// spot/congestion API yet, so each section returns hardcoded domain models. The
/// async signatures are kept so swapping in a GraphQL-backed impl later touches
/// nothing above the repository.
///
/// Location/rating/distance values are illustrative mocks, not measured.
class SpotRepositoryImpl implements SpotRepository {
  const SpotRepositoryImpl();

  @override
  Future<List<TouristSpot>> fetchRecommendedSpots() async =>
      const <TouristSpot>[
        TouristSpot(
          id: 'rec-gyeongbokgung',
          name: 'Gyeongbokgung Palace',
          imageRef: 'gyeongbokgung',
          location: 'Seoul, Jongno-gu',
          congestion: CongestionLevel.low,
        ),
        TouristSpot(
          id: 'rec-seongsu',
          name: 'Seongsu-dong Cafe Street',
          imageRef: 'seongsu',
          location: 'Seoul, Seongdong-gu',
          congestion: CongestionLevel.moderate,
        ),
        TouristSpot(
          id: 'rec-bukhansan',
          name: 'Bukhansan National Park',
          imageRef: 'bukhansan',
          location: 'Seoul, Gangbuk-gu',
          congestion: CongestionLevel.low,
        ),
      ];

  @override
  Future<List<TouristSpot>> fetchPopularSpots() async => const <TouristSpot>[
    TouristSpot(
      id: 'pop-nseoul-tower',
      name: 'N Seoul Tower',
      imageRef: 'nseoul-tower',
      location: 'Seoul, Yongsan-gu',
      congestion: CongestionLevel.high,
      rating: 4.8,
      distanceKm: 2.4,
    ),
    TouristSpot(
      id: 'pop-bukchon',
      name: 'Bukchon Hanok Village',
      imageRef: 'bukchon',
      location: 'Seoul, Jongno-gu',
      congestion: CongestionLevel.low,
      rating: 4.6,
      distanceKm: 3.1,
    ),
    TouristSpot(
      id: 'pop-hongdae',
      name: 'Hongdae Street',
      imageRef: 'hongdae',
      location: 'Seoul, Mapo-gu',
      congestion: CongestionLevel.moderate,
      rating: 4.5,
      distanceKm: 5.2,
    ),
  ];
}
