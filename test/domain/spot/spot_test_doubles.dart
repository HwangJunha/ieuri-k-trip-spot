import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/repository/spot_repository.dart';

/// A single configurable fake [SpotRepository]. Each method returns whatever the
/// test supplies, keeping test setup minimal. The swipe methods (SPEC-0002) page
/// through [feed] in [pageSize] chunks so prefetch/exhaustion are testable.
class FakeSpotRepository implements SpotRepository {
  FakeSpotRepository({
    List<TouristSpot>? recommended,
    List<TouristSpot>? popular,
    List<TouristSpot>? feed,
    this.categories,
    this.pageSize = 5,
    this.reactShouldFail = false,
  }) : recommended = recommended ?? const <TouristSpot>[_spot],
       popular = popular ?? const <TouristSpot>[_spot],
       feed = feed ?? const <TouristSpot>[];

  final List<TouristSpot> recommended;
  final List<TouristSpot> popular;
  final List<TouristSpot> feed;
  final List<SpotCategory>? categories;
  final int pageSize;
  final bool reactShouldFail;

  /// 마지막으로 기록된 반응 (검증용).
  final List<(String, SpotReaction)> recordedReactions =
      <(String, SpotReaction)>[];

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

  @override
  Future<OffsetPage<TouristSpot>> fetchSpotPage({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    SpotCategory? category,
    required int page,
    required int size,
  }) async {
    final List<TouristSpot> pool = category == null
        ? feed
        : feed.where((TouristSpot s) => s.category == category).toList();
    // 프로바이더는 프로덕션에서 size=100을 보내지만, 페이징/선제조회를 작은 피드로
    // 검증할 수 있게 페이크는 자신의 [pageSize]로 자른다(들어온 size는 무시).
    final int start = page * pageSize;
    final int end = (start + pageSize).clamp(0, pool.length);
    final List<TouristSpot> items = start >= pool.length
        ? const <TouristSpot>[]
        : pool.sublist(start, end);
    final bool hasNext = end < pool.length;
    return OffsetPage<TouristSpot>(
      items: items,
      page: page,
      hasNext: hasNext,
      totalCount: pool.length,
    );
  }

  @override
  Future<List<SpotCategory>> fetchAvailableCategories(
    AppLanguage language,
  ) async {
    if (categories != null) return categories!;
    return language == AppLanguage.korean
        ? const <SpotCategory>[
            SpotCategory.touristSpot,
            SpotCategory.travelCourse,
          ]
        : const <SpotCategory>[
            SpotCategory.touristSpot,
            SpotCategory.transport,
          ];
  }

  @override
  Future<void> reactToSpot(String spotId, SpotReaction reaction) async {
    if (reactShouldFail) throw StateError('react failed');
    recordedReactions.add((spotId, reaction));
  }
}

/// 스와이프 카드 하나를 최소 필드로 만든다(테스트 데이터 생성 편의).
TouristSpot swipeSpot(
  String id, {
  SpotCategory category = SpotCategory.touristSpot,
  CopyrightType copyright = CopyrightType.type1,
  int distanceMeters = 1200,
}) => TouristSpot(
  id: id,
  name: 'Spot $id',
  imageRef: id,
  location: 'Seoul',
  congestion: CongestionLevel.low,
  thumbnailImageUrl: id,
  address: '$id-ro, Seoul',
  distanceMeters: distanceMeters,
  copyright: copyright,
  attributionText: 'KTO',
  category: category,
);

/// 고정 좌표를 돌려주는 페이크 [LocationService]. GPS 없이 SwipeController·뷰
/// 테스트가 위치 조회를 통제할 수 있게 한다.
class FakeLocationService implements LocationService {
  FakeLocationService({
    this.coordinates = const Coordinates(latitude: 37.5, longitude: 127.0),
  });

  final Coordinates coordinates;

  @override
  Future<Coordinates> currentCoordinates() async => coordinates;
}
