import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
import '../model/congestion_level.dart';
import '../model/copyright_type.dart';
import '../model/liked_spot.dart';
import '../model/spot_category.dart';
import '../model/spot_detail.dart';
import '../model/spot_failure.dart';
import '../model/spot_image.dart';
import '../model/spot_info_item.dart';
import '../model/spot_intro.dart';
import '../model/spot_reaction.dart';
import '../model/tour_api_text.dart';
import '../model/tourist_spot.dart';
import 'spot_operations.graphql.dart';
import 'spot_repository.dart';
import 'spot_schema.graphql.dart';

/// GraphQL-backed [SpotRepository] (SPEC-0002). Runs the graphql_codegen-generated
/// typed operations through the shared client and maps each response to a domain
/// model. The generated `*.graphql.dart` types never leave this file (CLAUDE.md §3).
///
/// The Discover swipe feed is server-backed: `spots` (offset page/size — the
/// server has no cursor support), `availableSpotCategories`, and the `reactToSpot`
/// mutation. Home's recommended/popular sections have no server API yet, so those
/// two methods still return illustrative mock data; only they change when a Home
/// API lands.
class SpotRepositoryImpl implements SpotRepository {
  SpotRepositoryImpl(this._client);

  final GraphQLClient _client;

  // --- Discover 스와이프 피드 (서버) -----------------------------------------

  @override
  Future<OffsetPage<TouristSpot>> fetchSpotPage({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    SpotCategory? category,
    required int page,
    required int size,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySpots,
      Variables$Query$Spots(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        category: category == null ? null : _category(category),
        page: page,
        size: size,
      ).toJson(),
      'spots',
    );
    final Query$Spots$spots result = Query$Spots.fromJson(data).spots;
    return OffsetPage<TouristSpot>(
      items: result.items.map(_spotFromItem).toList(growable: false),
      page: result.page,
      hasNext: result.hasNext,
      totalCount: result.totalCount,
    );
  }

  @override
  Future<List<SpotCategory>> fetchAvailableCategories(
    AppLanguage language,
  ) async {
    // 언어는 인자로 보내지 않는다 — GraphQL 클라이언트의 Accept-Language 헤더로
    // 전달된다(spec §2). [language]는 인터페이스 계약 유지를 위해 받되 무시한다.
    final Map<String, dynamic> data = await _query(
      documentNodeQueryAvailableSpotCategories,
      const <String, dynamic>{},
      'availableSpotCategories',
    );
    final Query$AvailableSpotCategories result =
        Query$AvailableSpotCategories.fromJson(data);
    // 알 수 없는 값은 매핑이 null → 걸러낸다(서버가 새 값을 추가해도 크래시 없음).
    return result.availableSpotCategories
        .map(_categoryFromEnum)
        .whereType<SpotCategory>()
        .toList(growable: false);
  }

  @override
  Future<SpotDetail> fetchSpotDetail(String id, SpotCategory category) async {
    // 언어는 인자로 보내지 않는다 — Accept-Language 헤더로 전달된다(spec §2).
    // category는 intro/infoItems가 요구하는 필수 인자다(같은 응답의 필드를 인자로
    // 참조할 수 없어 호출부가 넘긴다).
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySpotDetail,
      Variables$Query$SpotDetail(
        id: id,
        category: _category(category),
      ).toJson(),
      'spotDetail',
    );
    final Query$SpotDetail$spotDetail result = Query$SpotDetail.fromJson(
      data,
    ).spotDetail;
    return _detailFromResult(result);
  }

  @override
  Future<CursorPage<LikedSpot>> fetchLikedSpots({
    int? first,
    String? after,
  }) async {
    // 언어는 인자로 보내지 않는다 — Accept-Language 헤더로 전달된다(spec §2).
    final Map<String, dynamic> data = await _query(
      documentNodeQueryLikedSpots,
      Variables$Query$LikedSpots(first: first, after: after).toJson(),
      'likedSpots',
    );
    final Query$LikedSpots$likedSpots result = Query$LikedSpots.fromJson(
      data,
    ).likedSpots;
    return CursorPage<LikedSpot>(
      items: result.edges
          .map((Query$LikedSpots$likedSpots$edges e) => _likedFromNode(e.node))
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<void> reactToSpot(String spotId, SpotReaction reaction) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationReactToSpot,
      Variables$Mutation$ReactToSpot(
        input: Input$ReactToSpotInput(
          spotId: spotId,
          reaction: _reaction(reaction),
        ),
      ).toJson(),
      'reactToSpot',
    );
    final Mutation$ReactToSpot$reactToSpot payload =
        Mutation$ReactToSpot.fromJson(data).reactToSpot;
    _check('reactToSpot', payload.success, payload.userErrors);
  }

  // --- Home 섹션 (서버 API 부재 → 목) ----------------------------------------

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

  // --- 매핑 (생성 타입 → 도메인) ---------------------------------------------

  /// 서버 `Spot` 아이템을 도메인 [TouristSpot]으로 매핑한다. 스와이프 카드가 쓰는
  /// 필드만 채우고(Home 전용 필드는 null), 거리는 미터 정수로 반올림한다.
  /// 제목·주소는 TourAPI 원문이라 `&amp;` 같은 엔티티가 섞여 온다. 여기서 정리해
  /// 두면 같은 값을 스와이프 카드와 상세가 똑같이 보여준다(한쪽만 정리하면 탭 한 번에
  /// 표기가 달라진다).
  TouristSpot _spotFromItem(Query$Spots$spots$items item) => TouristSpot(
    id: item.id,
    name: sanitizeTourApiText(item.title) ?? item.title,
    imageRef: item.thumbnailImageUrl,
    location: sanitizeTourApiText(item.address) ?? '',
    congestion: CongestionLevel.low,
    thumbnailImageUrl: item.thumbnailImageUrl,
    address: sanitizeTourApiText(item.address),
    distanceMeters: item.distanceMeters.round(),
    copyright: _copyright(item.copyright),
    attributionText: item.attributionText,
    category: _categoryFromEnum(item.category),
  );

  /// 좋아요 목록 노드 → 도메인 [LikedSpot](POL-020, §5.2).
  ///
  /// 카테고리가 아직 매핑되지 않은 서버 enum이면 [SpotCategory.touristSpot]으로
  /// 떨어뜨린다 — 항목을 목록에서 빼는 것보다 낫고, 라우터가 같은 이유로 이미 쓰는
  /// 폴백이다. 상세 진입 시 카테고리가 실제와 다르면 서버가 빈 값을 주므로 해당
  /// 섹션이 렌더되지 않는다.
  LikedSpot _likedFromNode(Query$LikedSpots$likedSpots$edges$node n) =>
      LikedSpot(
        id: n.id,
        // TourAPI 원문이라 엔티티가 섞여 온다(다른 표면과 동일하게 정리).
        title: sanitizeTourApiText(n.title) ?? n.title,
        thumbnailImageUrl: n.thumbnailImageUrl,
        address: sanitizeTourApiText(n.address),
        category: _categoryFromEnum(n.category) ?? SpotCategory.touristSpot,
        copyright: _copyright(n.copyright),
        attributionText: n.attributionText,
      );

  /// 상세 생성 타입 → 도메인 [SpotDetail]. nullable 필드는 그대로 넘기고(UI가 숨김 판단),
  /// 갤러리 아이템은 [SpotImage]로 매핑한다(POL-020, AC-32).
  ///
  /// `gallery`·`infoItems`의 **null(조회 실패)과 빈 배열(정상적으로 없음)을 여기서 하나로
  /// 접는다**(SPEC-0008 §2.1, AC-28). 화면 결과가 "섹션을 숨긴다"로 같으므로 도메인
  /// 모델은 둘을 구분하지 않는다 — 구분이 필요해 보이면 그것은 스펙과의 불일치다.
  SpotDetail _detailFromResult(Query$SpotDetail$spotDetail r) => SpotDetail(
    id: r.id,
    // 제목도 TourAPI 원문이라 엔티티가 섞여 온다(스와이프 카드와 동일하게 정리).
    title: sanitizeTourApiText(r.title) ?? r.title,
    category: _categoryFromEnum(r.category),
    thumbnailImageUrl: r.thumbnailImageUrl,
    overview: r.overview,
    address: r.address,
    homepage: r.homepage,
    tel: r.tel,
    copyright: _copyright(r.copyright),
    attributionText: r.attributionText,
    // null이면 빈 배열 — UI는 썸네일 1장으로 폴백한다(AC-26·AC-27).
    gallery:
        r.gallery?.map(_imageFromGallery).toList(growable: false) ??
        const <SpotImage>[],
    likeCount: r.likeCount,
    intro: r.intro == null ? null : _introFromResult(r.intro!),
    // null이면 빈 배열 — 이용안내 섹션을 숨기고 오류 문구는 띄우지 않는다(AC-29).
    infoItems:
        r.infoItems?.map(_infoItemFrom).toList(growable: false) ??
        const <SpotInfoItem>[],
  );

  /// 운영 정보 매핑. 서버가 카테고리별 필드를 공통 이름으로 정규화해 주므로
  /// 카테고리 분기 없이 그대로 옮긴다 — 값 없는 항목의 숨김 판단은 모델이 한다.
  SpotIntro _introFromResult(Query$SpotDetail$spotDetail$intro i) => SpotIntro(
    businessHours: i.businessHours,
    closedDays: i.closedDays,
    parking: i.parking,
    inquiryPhone: i.inquiryPhone,
    fee: i.fee,
    petAllowed: i.petAllowed,
    creditCardAccepted: i.creditCardAccepted,
  );

  SpotInfoItem _infoItemFrom(Query$SpotDetail$spotDetail$infoItems item) =>
      SpotInfoItem(name: item.name, text: item.text);

  SpotImage _imageFromGallery(Query$SpotDetail$spotDetail$gallery g) =>
      SpotImage(
        imageUrl: g.imageUrl,
        thumbnailUrl: g.thumbnailUrl,
        caption: g.caption,
        copyright: _copyright(g.copyright),
        attributionText: g.attributionText,
      );

  /// 생성 enum → 도메인 enum. 미래 서버가 새 값을 추가하면 `$unknown`이 되어 null.
  SpotCategory? _categoryFromEnum(Enum$SpotCategory value) => switch (value) {
    Enum$SpotCategory.TOURIST_SPOT => SpotCategory.touristSpot,
    Enum$SpotCategory.CULTURAL_FACILITY => SpotCategory.culturalFacility,
    Enum$SpotCategory.FESTIVAL_EVENT => SpotCategory.festivalEvent,
    Enum$SpotCategory.TRAVEL_COURSE => SpotCategory.travelCourse,
    Enum$SpotCategory.LEISURE_SPORTS => SpotCategory.leisureSports,
    Enum$SpotCategory.LODGING => SpotCategory.lodging,
    Enum$SpotCategory.SHOPPING => SpotCategory.shopping,
    Enum$SpotCategory.RESTAURANT => SpotCategory.restaurant,
    Enum$SpotCategory.TRANSPORT => SpotCategory.transport,
    Enum$SpotCategory.$unknown => null,
  };

  Enum$SpotCategory _category(SpotCategory category) => switch (category) {
    SpotCategory.touristSpot => Enum$SpotCategory.TOURIST_SPOT,
    SpotCategory.culturalFacility => Enum$SpotCategory.CULTURAL_FACILITY,
    SpotCategory.festivalEvent => Enum$SpotCategory.FESTIVAL_EVENT,
    SpotCategory.travelCourse => Enum$SpotCategory.TRAVEL_COURSE,
    SpotCategory.leisureSports => Enum$SpotCategory.LEISURE_SPORTS,
    SpotCategory.lodging => Enum$SpotCategory.LODGING,
    SpotCategory.shopping => Enum$SpotCategory.SHOPPING,
    SpotCategory.restaurant => Enum$SpotCategory.RESTAURANT,
    SpotCategory.transport => Enum$SpotCategory.TRANSPORT,
  };

  CopyrightType _copyright(Enum$CopyrightType value) => switch (value) {
    Enum$CopyrightType.TYPE1 => CopyrightType.type1,
    Enum$CopyrightType.TYPE3 => CopyrightType.type3,
    Enum$CopyrightType.UNSPECIFIED => CopyrightType.unspecified,
    Enum$CopyrightType.$unknown => CopyrightType.unspecified,
  };

  Enum$SpotReaction _reaction(SpotReaction reaction) => switch (reaction) {
    SpotReaction.like => Enum$SpotReaction.LIKE,
    SpotReaction.dislike => Enum$SpotReaction.DISLIKE,
  };

  // --- 전송/실행 (auth repo와 동일한 2단계 실패 검사) -------------------------

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.query(QueryOptions(document: document, variables: variables)),
    operation,
    variables,
  );

  /// **전체 실패로 판정된** 오류의 코드 문자열. 서버가 `extensions.code`에 싣는 것이
  /// 관례이나 최종 포맷은 미확정(`[TBD-2]`)이라, extensions에 없으면 코드처럼 보이는
  /// 메시지(SCREAMING_SNAKE)를 폴백으로 본다. 아무 코드도 못 찾으면 null.
  ///
  /// `errors.first`가 아니라 [firstRootError]를 쓴다 — `ErrorPolicy.all` 이후로는
  /// 부분 실패와 전체 실패가 같은 배열에 함께 실려 오므로, 앞자리에 갤러리 부분 실패가
  /// 오면 뒤의 UNAUTHENTICATED를 놓쳐 인증 실패가 네트워크 실패로 둔갑한다. 그러면
  /// 재시도 상한에 계상되고 세션 갱신 경로로도 못 간다(SPEC-0006 R5·AC-14).
  String? _rootErrorCode(QueryResult<Object?> result, String rootField) {
    final GraphQLError? error = firstRootError(result, rootField);
    if (error == null) return null;
    final Object? code = error.extensions?['code'];
    if (code is String && code.isNotEmpty) return code;
    // 폴백: 메시지가 코드 토큰(예: "SPOT_NOT_FOUND")과 정확히 일치할 때만 취한다.
    final String message = error.message;
    return RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(message) ? message : null;
  }

  Future<Map<String, dynamic>> _mutate(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.mutate(
      MutationOptions(document: document, variables: variables),
    ),
    operation,
    variables,
  );

  Future<Map<String, dynamic>> _run(
    Future<QueryResult<Object?>> Function() call,
    String operation,
    Map<String, dynamic> variables,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await call();
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      throw SpotFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    // 범위 판별은 `path`로 한다(SPEC-0008 §2.1, AC-25). errors[]가 비어있지 않다는
    // 사실만으로 전체 실패를 단정하면 `["spotDetail","gallery"]` 같은 부분 실패가
    // 오류 화면이 되어 R-7이 무너진다 — 하위 필드 실패는 여기서 통과시키고, 값이
    // null로 내려온 것을 매핑이 빈 값으로 접는다.
    //
    // `operation`이 곧 최상위 필드 이름이라 별도 인자가 필요 없다.
    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      // 코드를 뽑아 번역한다. 인증 실패(UNAUTHENTICATED)를 네트워크 실패로 뭉개면
      // 재시도 상한이 그것까지 계상해 버려 AC-14를 만족할 수 없다(SPEC-0006 §2.3).
      // 코드가 없으면 기존대로 네트워크 실패로 떨어진다.
      throw SpotFailure.fromQueryErrorCode(_rootErrorCode(result, operation));
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw SpotFailure.unknown;
    return data;
  }

  /// 뮤테이션 도메인 실패 검사(spec §2): `userErrors`가 비어 있지 않거나
  /// `success == false`면 실패. 코드만 로깅하고(메시지는 PII 가능) 첫 코드를 던진다.
  void _check(
    String operation,
    bool success,
    List<Mutation$ReactToSpot$reactToSpot$userErrors> userErrors,
  ) {
    if (userErrors.isNotEmpty) {
      final List<({String code, String? field})> parsed = userErrors
          .map((e) => (code: e.code, field: e.field))
          .toList();
      GraphqlDebugLog.userErrors(operation, parsed);
      throw SpotFailure(SpotFailureKind.userError, code: parsed.first.code);
    }
    if (!success) throw SpotFailure.unknown;
  }
}
