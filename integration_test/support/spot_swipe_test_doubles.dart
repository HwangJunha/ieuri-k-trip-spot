import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_kind.dart';
import 'package:ieuri_k_trip_spot/common/permission/model/permission_state.dart';
import 'package:ieuri_k_trip_spot/common/permission/service/permission_service.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/congestion_level.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_image.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/repository/spot_repository.dart';

/// 고정 좌표를 돌려주는 [LocationService]. 여정 #2는 위치 권한/GPS 자체를 검증
/// 대상으로 삼지 않는다(그건 여정 #1의 몫) — 이미 허용된 상태에서 시작한다.
class FixedLocationService implements LocationService {
  const FixedLocationService({
    this.coordinates = const Coordinates(latitude: 37.5, longitude: 127.0),
  });

  final Coordinates coordinates;

  @override
  Future<Coordinates> currentCoordinates() async => coordinates;
}

/// 항상 허용 상태를 보고하는 [PermissionService]. `PermissionBootGate`가 OS
/// 다이얼로그를 띄우지 않고 곧장 통과하도록 한다(위치 권한은 이 여정의 전제조건).
class GrantedPermissionService implements PermissionService {
  const GrantedPermissionService();

  @override
  Future<PermissionState> status(PermissionKind kind) async =>
      PermissionState.granted;

  @override
  Future<PermissionState> request(PermissionKind kind) async =>
      PermissionState.granted;

  @override
  Future<bool> openSettings() async => true;
}

/// 설정 가능한 [SpotRepository] 페이크(controlled response). [feed]를 한 페이지로
/// 통째로 돌려준다 — 이 여정은 페이지네이션/선제조회를 검증하지 않는다(그건
/// swipe_controller_test.dart의 몫).
class FakeSpotRepository implements SpotRepository {
  FakeSpotRepository({required this.feed});

  final List<TouristSpot> feed;

  /// 기록된 반응(spotId, reaction) — 낙관적 발사 검증용.
  final List<(String, SpotReaction)> recordedReactions =
      <(String, SpotReaction)>[];

  @override
  Future<OffsetPage<TouristSpot>> fetchSpotPage({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    SpotCategory? category,
    required int page,
    required int size,
  }) async {
    if (page > 0) {
      return OffsetPage<TouristSpot>(
        items: const <TouristSpot>[],
        page: page,
        hasNext: false,
      );
    }
    return OffsetPage<TouristSpot>(items: feed, page: 0, hasNext: false);
  }

  @override
  Future<List<SpotCategory>> fetchAvailableCategories(
    AppLanguage language,
  ) async => const <SpotCategory>[SpotCategory.touristSpot];

  @override
  Future<void> reactToSpot(String spotId, SpotReaction reaction) async {
    recordedReactions.add((spotId, reaction));
  }

  @override
  Future<SpotDetail> fetchSpotDetail(String id, SpotCategory category) async =>
      SpotDetail(
        id: id,
        title: 'Spot $id',
        category: category,
        thumbnailImageUrl: id,
        overview: 'Overview of $id',
        address: '$id-ro, Seoul',
        copyright: CopyrightType.type1,
        attributionText: 'KTO',
        gallery: const <SpotImage>[
          SpotImage(
            imageUrl: 'https://img/g.jpg',
            copyright: CopyrightType.type1,
            attributionText: 'KTO',
          ),
        ],
        likeCount: 0,
      );

  @override
  Future<List<TouristSpot>> fetchRecommendedSpots() async =>
      const <TouristSpot>[];

  @override
  Future<List<TouristSpot>> fetchPopularSpots() async => const <TouristSpot>[];
}

/// 스와이프 카드 하나를 최소 필드로 만든다(id는 e2e 카드 Key와 동일하게 쓰인다).
TouristSpot _swipeSpot(String id) => TouristSpot(
  id: id,
  name: 'Spot $id',
  imageRef: id,
  location: 'Seoul',
  congestion: CongestionLevel.low,
  thumbnailImageUrl: id,
  address: '$id-ro, Seoul',
  distanceMeters: 1200,
  copyright: CopyrightType.type1,
  attributionText: 'KTO',
  category: SpotCategory.touristSpot,
);

/// `s0`, `s1`, ... `s{n-1}` 카드 [n]장을 만든다.
List<TouristSpot> swipeSpots(int n) =>
    List<TouristSpot>.generate(n, (int i) => _swipeSpot('s$i'));
