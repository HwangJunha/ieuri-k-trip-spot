import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/popular_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_category.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_image.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_info_item.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_intro.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_search_result.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_suggestion.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tourist_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/repository/spot_repository.dart';

/// A single configurable fake [SpotRepository]. Each method returns whatever the
/// test supplies, keeping test setup minimal. The swipe methods (SPEC-0002) page
/// through [feed] in [pageSize] chunks so prefetch/exhaustion are testable.
class FakeSpotRepository implements SpotRepository {
  FakeSpotRepository({
    List<TouristSpot>? feed,
    this.categories,
    this.pageSize = 5,
    this.reactShouldFail = false,
    this.reactFailure,
    this.detail,
    this.detailFailure,
    this.pageFailure,
    this.failPageTimes = 0,
    List<LikedSpot>? liked,
    this.likedPageSize = 2,
    this.likedSpotsFailure,
    this.failLikedAfter = 0,
  }) : feed = feed ?? const <TouristSpot>[],
       liked = liked ?? const <LikedSpot>[];

  /// `fetchSpotPage`가 던질 실패(설정 시). [failPageTimes]와 함께 쓰면 앞의 N회만
  /// 실패하고 이후 성공한다 — 재시도 상한 검증용(SPEC-0006).
  final Object? pageFailure;

  /// [pageFailure]를 던질 횟수. 0이면 설정된 동안 계속 던진다.
  final int failPageTimes;

  /// `fetchSpotPage` 호출 횟수(검증용). 상한 소진 후 호출이 늘지 않는지 확인한다.
  int spotPageCallCount = 0;

  /// 호출마다 실린 `radiusMeters`(설정 반경이 실제로 조회에 실리는지 확인용,
  /// SPEC-0011 R13). null은 인자를 보내지 않은 것 — 0km가 그 경우다.
  final List<int?> requestedRadiiMeters = <int?>[];

  final List<TouristSpot> feed;
  final List<SpotCategory>? categories;
  final int pageSize;
  final bool reactShouldFail;

  /// `reactToSpot`이 던질 도메인 실패(설정 시). [reactShouldFail]보다 우선한다 —
  /// SPOT_NOT_FOUND처럼 유형별 분기가 있는 경로를 검증할 때 쓴다.
  final SpotFailure? reactFailure;

  /// `fetchSpotDetail`이 돌려줄 상세(설정 시). [detailFailure]가 있으면 그게 우선한다.
  final SpotDetail? detail;

  /// `fetchSpotDetail`이 던질 실패(설정 시) — SPOT_NOT_FOUND 등 오류 경로 검증용.
  /// 첫 조회는 성공시키고 재조회만 실패시키려면 도중에 바꾼다(상세를 연 사이에
  /// 축제가 삭제된 상황).
  SpotFailure? detailFailure;

  /// 마지막으로 기록된 반응 (검증용).
  final List<(String, SpotReaction)> recordedReactions =
      <(String, SpotReaction)>[];

  // --- 좋아요 목록 (SPEC-0008 R-18) -------------------------------------------

  /// `fetchLikedSpots`가 페이징해 돌려줄 전체 항목.
  final List<LikedSpot> liked;

  /// 페이크가 한 번에 돌려줄 항목 수. 프로바이더가 보내는 `first`는 무시하고 이
  /// 값으로 자른다 — 작은 목록으로 페이지 경계를 검증하기 위해서다.
  final int likedPageSize;

  /// `fetchLikedSpots`가 던질 실패(설정 시). 미인증(UNAUTHENTICATED) 경로 검증용.
  /// [failLikedAfter]와 함께 쓰면 앞의 N회는 성공하고 그 다음부터 실패한다 — 첫 장은
  /// 받았는데 추가 로딩만 실패하는 상황을 만든다.
  final Object? likedSpotsFailure;

  /// [likedSpotsFailure]를 던지기 전에 성공시킬 호출 수. 0이면 첫 호출부터 던진다.
  final int failLikedAfter;

  /// `fetchLikedSpots` 호출 횟수(검증용) — 중복 loadMore가 조회를 늘리지 않는지 본다.
  int likedSpotsCallCount = 0;

  /// 마지막 조회에 실린 카테고리(검증용) — 필터가 서버까지 전달되는지 본다.
  SpotCategory? lastLikedCategory;

  /// 좋아요 목록 커서 페이징(SPEC-0008 R-18). [likedPageSize]씩 잘라 돌려주며,
  /// 커서는 다음 항목의 인덱스 문자열이다 — 실제 서버의 불투명 커서를 흉내내되
  /// 테스트가 페이지 경계를 예측할 수 있게 한다.
  ///
  /// [category]가 있으면 실제 서버처럼 **자르기 전에** 거른다 — 페이지 크기가 필터링
  /// 이후 기준이어야 커서 경계가 서버와 같아진다.
  @override
  Future<CursorPage<LikedSpot>> fetchLikedSpots({
    SpotCategory? category,
    int? first,
    String? after,
  }) async {
    likedSpotsCallCount++;
    lastLikedCategory = category;
    if (likedSpotsFailure != null && likedSpotsCallCount > failLikedAfter) {
      throw likedSpotsFailure!;
    }

    final List<LikedSpot> pool = category == null
        ? liked
        : liked.where((LikedSpot s) => s.category == category).toList();
    final int start = after == null ? 0 : (int.tryParse(after) ?? 0);
    final int end = (start + likedPageSize).clamp(0, pool.length);
    final List<LikedSpot> items = start >= pool.length
        ? const <LikedSpot>[]
        : pool.sublist(start, end);
    final bool hasNext = end < pool.length;
    return CursorPage<LikedSpot>(
      items: items,
      hasNextPage: hasNext,
      endCursor: hasNext ? '$end' : null,
    );
  }

  /// `searchSpots`가 돌려줄 결과(설정 시). [searchFailure]가 있으면 그게 우선한다.
  SpotSearchResult searchResult = SpotSearchResult.empty;

  /// `searchSpots`가 던질 실패(설정 시) — 검색 실패 상태(AC-11.3) 검증용.
  Object? searchFailure;

  /// 마지막 조회에 실린 질의·페이지·카테고리(검증용).
  String? lastSearchQuery;
  int? lastSearchPage;
  SpotCategory? lastSearchCategory;

  /// `searchSpots` 호출 횟수(검증용) — 재시도가 실제로 다시 조회하는지 본다.
  int searchCallCount = 0;

  /// `fetchPopularSpots`가 돌려줄 항목(설정 시).
  List<PopularSpot> popular = const <PopularSpot>[];

  /// 인기 조회에 실린 반경(검증용). **`requestedRadiiMeters`와 분리한다** — 두
  /// 조회가 한 리스트를 공유하면 "몇 번째 값이 누구 것인지"가 섞여 단언이 흔들린다.
  final List<int?> popularRadiiMeters = <int?>[];

  /// `fetchPopularSpots`가 던질 실패(설정 시) — 섹션 실패 경로 검증용.
  Object? popularFailure;

  /// `spotSearchSuggestions`가 돌려줄 제안(설정 시).
  List<SpotSuggestion> suggestions = const <SpotSuggestion>[];

  /// 마지막 자동완성 조회에 실린 질의(검증용).
  String? lastSuggestionQuery;

  @override
  Future<CursorPage<PopularSpot>> fetchPopularSpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    SpotCategory? category,
    int? first,
    String? after,
  }) async {
    popularRadiiMeters.add(radiusMeters);
    if (popularFailure != null) throw popularFailure!;
    return CursorPage<PopularSpot>(items: popular, hasNextPage: false);
  }

  @override
  Future<List<SpotSuggestion>> spotSearchSuggestions({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    int? limit,
  }) async {
    lastSuggestionQuery = query;
    return suggestions;
  }

  @override
  Future<SpotSearchResult> searchSpots({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    SpotCategory? category,
    int? page,
    int? size,
  }) async {
    searchCallCount++;
    lastSearchQuery = query;
    lastSearchPage = page;
    lastSearchCategory = category;
    if (searchFailure != null) throw searchFailure!;
    return searchResult;
  }

  @override
  Future<OffsetPage<TouristSpot>> fetchSpotPage({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    SpotCategory? category,
    required int page,
    required int size,
  }) async {
    spotPageCallCount++;
    requestedRadiiMeters.add(radiusMeters);
    if (pageFailure != null &&
        (failPageTimes == 0 || spotPageCallCount <= failPageTimes)) {
      throw pageFailure!;
    }
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

  /// `fetchSpotDetail`이 받은 카테고리(마지막 호출 기준). 서버 필수 인자가 실제로
  /// 전달되는지 검증할 때 쓴다.
  SpotCategory? requestedDetailCategory;

  /// `fetchSpotDetail` 호출 횟수(검증용). 상한 소진 후 호출이 늘지 않는지 확인한다.
  int detailCallCount = 0;

  /// [detailFailure]를 던질 횟수. 0이면 설정된 동안 계속 던진다 — 앞의 N회만 실패하고
  /// 이후 성공시켜 명시적 재시도 성공 경로를 검증할 때 쓴다(SPEC-0006 AC-9).
  int failDetailTimes = 0;

  @override
  Future<SpotDetail> fetchSpotDetail(String id, SpotCategory category) async {
    requestedDetailCategory = category;
    detailCallCount++;
    if (detailFailure != null &&
        (failDetailTimes == 0 || detailCallCount <= failDetailTimes)) {
      throw detailFailure!;
    }
    return detail ?? detailSpot(id);
  }

  @override
  Future<void> reactToSpot(String spotId, SpotReaction reaction) async {
    if (reactFailure != null) throw reactFailure!;
    if (reactShouldFail) throw StateError('react failed');
    recordedReactions.add((spotId, reaction));
  }
}

/// 상세 하나를 최소 필드로 만든다(테스트 데이터 생성 편의). null 인자를 넘겨 값 없는
/// 섹션(overview/address/homepage/tel)이나 빈 갤러리를 검증할 수 있다.
SpotDetail detailSpot(
  String id, {
  String title = 'Detail Spot',
  SpotCategory? category = SpotCategory.touristSpot,
  String? overview = 'A famous place.',
  String? address = 'Seoul',
  String? homepage = 'https://example.com',
  String? tel = '02-000-0000',
  int likeCount = 10,
  List<SpotImage>? gallery,
  // 기본은 "운영 정보·이용안내 없음" — 이 섹션들을 검증하는 테스트만 값을 넘긴다.
  SpotIntro? intro,
  List<SpotInfoItem> infoItems = const <SpotInfoItem>[],
}) => SpotDetail(
  id: id,
  title: title,
  category: category,
  thumbnailImageUrl: 'https://img/$id.jpg',
  overview: overview,
  address: address,
  homepage: homepage,
  tel: tel,
  copyright: CopyrightType.type1,
  attributionText: 'Source: KTO',
  gallery:
      gallery ??
      const <SpotImage>[
        SpotImage(
          imageUrl: 'https://img/g1.jpg',
          copyright: CopyrightType.type1,
          attributionText: 'Source: KTO',
        ),
      ],
  likeCount: likeCount,
  intro: intro,
  infoItems: infoItems,
);

/// 홈 카드 하나를 최소 필드로 만든다(SPEC-0013). 서버가 주는 값만 채운다 —
/// 별점·혼잡도는 모델에서 제거됐다(AC-15.2·AC-15.3).
TouristSpot homeSpot(String id, {int? distanceMeters = 1200}) => TouristSpot(
  id: id,
  name: 'Spot $id',
  imageRef: id,
  location: 'Seoul',
  thumbnailImageUrl: 'https://example.test/$id.jpg',
  distanceMeters: distanceMeters,
);

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

  /// 한 번 흘리고 닫는다 — 이 페이크를 쓰는 테스트는 지도 화면이 아니라 위치를
  /// 입력으로 받는 조회들이라, 좌표가 계속 바뀔 필요가 없다.
  @override
  Stream<Coordinates> watchCoordinates() =>
      Stream<Coordinates>.value(coordinates);
}
