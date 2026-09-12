import 'package:ieuri_k_trip_spot/common/localization/app_language.dart';
import 'package:ieuri_k_trip_spot/common/location/coordinates.dart';
import 'package:ieuri_k_trip_spot/common/location/location_service.dart';
import 'package:ieuri_k_trip_spot/common/pagination/offset_page.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/copyright_type.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spot.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/liked_spots_query.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/popular_spot.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category.dart';
import 'package:ieuri_k_trip_spot/common/category/spot_category_selection.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_detail.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_image.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_info_item.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_intro.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_reaction.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_search_result.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_suggestion.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/swipe_feed_key.dart';
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

  /// 조회가 돌려줄 장소. **활성 언어의 장소만 담는다**(SPEC-0029) — 서버가 언어 축으로
  /// 이미 갈라 주므로 페이크도 원문/번역을 구분하지 않는다.
  ///
  /// `fetchSpotPage`와 `fetchRecommendedSpots`가 함께 쓴다. 바꿀 수 있다 — 추천 묶음을
  /// 다시 불렀을 때 서버가 다른 묶음을 주는 상황(SPEC-0035 AC-10.2)을 테스트가
  /// 도중에 갈아끼워 만든다.
  List<TouristSpot> feed;

  /// `fetchRecommendedSpots` 호출 횟수(검증용, SPEC-0035). 홈이 1회만 부르는지, 큐
  /// 보충이 같은 인자로 다시 부르는지 본다.
  int recommendedCallCount = 0;

  /// 호출마다 실린 인자(검증용, SPEC-0035). 커서·페이지가 없어 세 값뿐이다.
  final List<RecommendedRequest> recommendedRequests = <RecommendedRequest>[];

  /// `fetchRecommendedSpots`가 던질 실패(설정 시). [pageFailure]와 별개다 — 홈은 추천을,
  /// 전체 스와이프는 페이지를 부르므로 둘을 따로 실패시킬 수 있어야 한다.
  Object? recommendedFailure;

  /// [recommendedFailure]를 던질 횟수. 0이면 설정된 동안 계속 던진다.
  int failRecommendedTimes = 0;

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

  /// 마지막 조회에 실린 카테고리 코드(검증용) — 필터가 서버까지 전달되는지 본다.
  List<String>? lastLikedCategoryCodes;

  /// 마지막 조회에 실린 검색어(검증용, SPEC-0033). **null과 빈 문자열이 다르다** —
  /// null은 인자를 보내지 않았다는 뜻이고, 빈 문자열은 서버가 `EMPTY_QUERY`로
  /// 거절할 값이다(AC8.2).
  String? lastLikedQuery;

  /// 좋아요 목록 커서 페이징(SPEC-0008 R-18). [likedPageSize]씩 잘라 돌려주며,
  /// 커서는 다음 항목의 인덱스 문자열이다 — 실제 서버의 불투명 커서를 흉내내되
  /// 테스트가 페이지 경계를 예측할 수 있게 한다.
  ///
  /// [categoryCodes]가 있으면 실제 서버처럼 **자르기 전에** 거른다 — 페이지 크기가
  /// 필터링 이후 기준이어야 커서 경계가 서버와 같아진다. 여러 코드는 OR다.
  /// [query]도 같은 자리에서 제목 부분일치로 거른다(대소문자 무시) — 카테고리와
  /// **함께**(AND) 적용되는 것이 서버 규약이다.
  @override
  Future<CursorPage<LikedSpot>> fetchLikedSpots({
    List<String>? categoryCodes,
    String? query,
    int? first,
    String? after,
  }) async {
    likedSpotsCallCount++;
    lastLikedCategoryCodes = categoryCodes;
    lastLikedQuery = query;
    if (likedSpotsFailure != null && likedSpotsCallCount > failLikedAfter) {
      throw likedSpotsFailure!;
    }

    final String? needle = query?.toLowerCase();
    final List<LikedSpot> pool = liked
        .where(
          (LikedSpot s) =>
              (categoryCodes == null ||
                  categoryCodes.contains(s.category.code)) &&
              (needle == null || s.title.toLowerCase().contains(needle)),
        )
        .toList();
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
  List<String>? lastSearchCategoryCodes;

  /// `searchSpots` 호출 횟수(검증용) — 재시도가 실제로 다시 조회하는지 본다.
  int searchCallCount = 0;

  /// `fetchPopularSpots`가 돌려줄 항목(설정 시).
  List<PopularSpot> popular = const <PopularSpot>[];

  /// `fetchPopularSpots` 호출 횟수(검증용). 홈 섹션이 조회를 한 번만 하는지 본다
  /// (SPEC-0029 AC-19.1).
  int popularCallCount = 0;

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
    List<String>? categoryCodes,
    int? first,
    String? after,
  }) async {
    popularCallCount++;
    popularRadiiMeters.add(radiusMeters);
    if (popularFailure != null) throw popularFailure!;
    final List<PopularSpot> pool = popular;
    return CursorPage<PopularSpot>(
      items: first == null ? pool : pool.take(first).toList(growable: false),
      hasNextPage: false,
    );
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
    List<String>? categoryCodes,
    int? page,
    int? size,
  }) async {
    searchCallCount++;
    lastSearchQuery = query;
    lastSearchPage = page;
    lastSearchCategoryCodes = categoryCodes;
    if (searchFailure != null) throw searchFailure!;
    return searchResult;
  }

  @override
  Future<OffsetPage<TouristSpot>> fetchSpotPage({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categoryCodes,
    required int page,
    required int size,
  }) async {
    spotPageCallCount++;
    requestedRadiiMeters.add(radiusMeters);
    if (pageFailure != null &&
        (failPageTimes == 0 || spotPageCallCount <= failPageTimes)) {
      throw pageFailure!;
    }
    final List<TouristSpot> source = feed;
    final List<TouristSpot> pool = categoryCodes == null
        ? source
        : source
              .where(
                (TouristSpot s) => categoryCodes.contains(s.category?.code),
              )
              .toList();
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

  /// 추천 묶음(SPEC-0035). **페이지가 없다** — 카테고리로 거른 [feed]의 앞 [first]건을
  /// 그대로 준다. 서버가 반응한 장소를 빼는 동작은 흉내내지 않는다(그 판정은
  /// 서버 테스트 몫이고, 클라이언트는 받은 묶음에서 겹침만 걷어낸다).
  @override
  Future<List<TouristSpot>> fetchRecommendedSpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categoryCodes,
    int? first,
  }) async {
    recommendedCallCount++;
    requestedRadiiMeters.add(radiusMeters);
    recommendedRequests.add((
      first: first,
      radiusMeters: radiusMeters,
      categoryCodes: categoryCodes,
    ));
    if (recommendedFailure != null &&
        (failRecommendedTimes == 0 ||
            recommendedCallCount <= failRecommendedTimes)) {
      throw recommendedFailure!;
    }
    final List<TouristSpot> pool = categoryCodes == null
        ? feed
        : feed
              .where(
                (TouristSpot s) => categoryCodes.contains(s.category?.code),
              )
              .toList();
    return first == null ? pool : pool.take(first).toList(growable: false);
  }

  @override
  Future<List<SpotCategory>> fetchAvailableCategories(
    AppLanguage language,
  ) async {
    if (categories != null) return categories!;
    // 라이브 서버와 같은 모양이다: 언어마다 목록이 갈린다(KO는 TRAVEL_COURSE,
    // 비KO는 그 자리에 TRANSPORT). 라벨은 서버가 활성 언어로 준 값을 흉내낸다.
    return language == AppLanguage.korean
        ? const <SpotCategory>[
            SpotCategory(code: 'TOURIST_SPOT', label: '관광지'),
            SpotCategory(code: 'TRAVEL_COURSE', label: '여행코스'),
          ]
        : const <SpotCategory>[
            SpotCategory(code: 'TOURIST_SPOT', label: 'Tourist Spots'),
            SpotCategory(code: 'TRANSPORT', label: 'Transport'),
          ];
  }

  /// `fetchSpotDetail` 호출 횟수(검증용). 상한 소진 후 호출이 늘지 않는지 확인한다.
  int detailCallCount = 0;

  /// [detailFailure]를 던질 횟수. 0이면 설정된 동안 계속 던진다 — 앞의 N회만 실패하고
  /// 이후 성공시켜 명시적 재시도 성공 경로를 검증할 때 쓴다(SPEC-0006 AC-9).
  int failDetailTimes = 0;

  @override
  Future<SpotDetail> fetchSpotDetail(String id, {String? categoryCode}) async {
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

/// 테스트가 쓰는 카테고리 값들(SPEC-0020). 서버가 주는 것과 같은 모양의 값 객체이며
/// 동등성은 `code`만 본다 — 라벨이 달라도 같은 카테고리다.
const SpotCategory catTouristSpot = SpotCategory(
  code: 'TOURIST_SPOT',
  label: 'Tourist Spots',
);
const SpotCategory catRestaurant = SpotCategory(
  code: 'RESTAURANT',
  label: 'Restaurants',
);
const SpotCategory catLodging = SpotCategory(code: 'LODGING', label: 'Lodging');
const SpotCategory catTravelCourse = SpotCategory(
  code: 'TRAVEL_COURSE',
  label: 'Travel Courses',
);
const SpotCategory catTransport = SpotCategory(
  code: 'TRANSPORT',
  label: 'Transport',
);
const SpotCategory catFestivalEvent = SpotCategory(
  code: 'FESTIVAL_EVENT',
  label: 'Festivals & Events',
);
const SpotCategory catCulturalFacility = SpotCategory(
  code: 'CULTURAL_FACILITY',
  label: 'Cultural Facilities',
);

/// 선택 없음 — 예전 `null`("전체")이 있던 자리다. 서버로는 인자가 생략되어 전체가
/// 온다(빈 배열은 보내지 않는다, AC5.1). 프로덕션 화면은 기본값을 심어 이 상태를
/// 만들지 않지만, 필터와 무관한 동작을 검증하는 테스트에는 이 자리가 맞다.
final SpotCategorySelection noCategories = SpotCategorySelection(
  const <SpotCategory>[],
);

/// [categories]를 담은 선택. family 인자로 그대로 쓴다.
SpotCategorySelection selectionOf(List<SpotCategory> categories) =>
    SpotCategorySelection(categories);

/// `fetchRecommendedSpots`에 실린 인자 한 벌(검증용, SPEC-0035).
typedef RecommendedRequest = ({
  int? first,
  int? radiusMeters,
  List<String>? categoryCodes,
});

/// 전체(`spots`) 소스 + 선택 없음 — 예전 `swipeControllerProvider(noCategories)`가
/// 가리키던 세션이다. 추천이 기본이 된 뒤(SPEC-0035)에도 오프셋 경로를 검증하는
/// 테스트는 이 키를 쓴다.
final SwipeFeedKey allFeed = SwipeFeedKey(
  recommended: false,
  selection: noCategories,
);

/// 추천 소스 + [categories] 필터. 비우면 필터 없는 추천 묶음이다.
SwipeFeedKey recommendedFeed([
  List<SpotCategory> categories = const <SpotCategory>[],
]) => SwipeFeedKey(recommended: true, selection: selectionOf(categories));

/// 좋아요 목록 컨트롤러의 family 키(SPEC-0033). 카테고리와 검색어를 함께 담는다 —
/// 검색어를 생략하면 필터 없는 전체 조회다.
LikedSpotsQuery likedQuery({
  List<SpotCategory> categories = const <SpotCategory>[],
  String query = '',
}) => LikedSpotsQuery(
  selection: SpotCategorySelection(categories),
  query: query,
);

/// 상세 하나를 최소 필드로 만든다(테스트 데이터 생성 편의). null 인자를 넘겨 값 없는
/// 섹션(overview/address/homepage/tel)이나 빈 갤러리를 검증할 수 있다.
SpotDetail detailSpot(
  String id, {
  String title = 'Detail Spot',
  SpotCategory? category = catTouristSpot,
  String? overview = 'A famous place.',
  String? address = 'Seoul',
  String? homepage = 'https://example.com',
  String? tel = '02-000-0000',
  int likeCount = 10,
  List<SpotImage>? gallery,
  // 기본은 "운영 정보·이용안내 없음" — 이 섹션들을 검증하는 테스트만 값을 넘긴다.
  SpotIntro? intro,
  List<SpotInfoItem> infoItems = const <SpotInfoItem>[],
  // 미니 지도(SPEC-0027)용 좌표. 서버가 non-null로 주므로 기본값을 둔다 —
  // 지도를 검증하는 테스트만 값을 넘긴다.
  Coordinates coordinates = const Coordinates(
    latitude: 37.5665,
    longitude: 126.9780,
  ),
}) => SpotDetail(
  id: id,
  title: title,
  thumbnailImageUrl: 'https://img/$id.jpg',
  overview: overview,
  address: address,
  homepage: homepage,
  tel: tel,
  copyright: CopyrightType.type1,
  attributionText: 'Source: KTO',
  coordinates: coordinates,
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
  SpotCategory category = catTouristSpot,
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
///
/// [failure]를 주면 좌표 대신 그것을 던진다 — 위치를 끈 기기를 흉내 낸다.
class FakeLocationService implements LocationService {
  FakeLocationService({
    this.coordinates = const Coordinates(latitude: 37.5, longitude: 127.0),
    this.failure,
  });

  /// 위치를 얻지 못하는 기기(권한 거부·위치 서비스 꺼짐).
  factory FakeLocationService.unavailable([
    LocationUnavailableReason reason = LocationUnavailableReason.serviceDisabled,
  ]) => FakeLocationService(failure: LocationUnavailable(reason));

  final Coordinates coordinates;

  /// 설정하면 [currentCoordinates]와 [watchCoordinates]가 이것을 던진다.
  final LocationUnavailable? failure;

  @override
  Future<Coordinates> currentCoordinates() async {
    final LocationUnavailable? error = failure;
    if (error != null) throw error;
    return coordinates;
  }

  /// 한 번 흘리고 닫는다 — 이 페이크를 쓰는 테스트는 지도 화면이 아니라 위치를
  /// 입력으로 받는 조회들이라, 좌표가 계속 바뀔 필요가 없다.
  @override
  Stream<Coordinates> watchCoordinates() {
    final LocationUnavailable? error = failure;
    if (error != null) return Stream<Coordinates>.error(error);
    return Stream<Coordinates>.value(coordinates);
  }
}
