import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../../../common/pagination/offset_page.dart';
import '../model/congestion_level.dart';
import '../model/copyright_type.dart';
import '../model/spot_category.dart';
import '../model/spot_detail.dart';
import '../model/spot_failure.dart';
import '../model/spot_image.dart';
import '../model/spot_reaction.dart';
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
  Future<SpotDetail> fetchSpotDetail(String id) async {
    // 언어는 인자로 보내지 않는다 — Accept-Language 헤더로 전달된다(spec §2).
    final Map<String, dynamic> data = await _queryDetail(
      documentNodeQuerySpotDetail,
      Variables$Query$SpotDetail(id: id).toJson(),
      'spotDetail',
    );
    final Query$SpotDetail$spotDetail result = Query$SpotDetail.fromJson(
      data,
    ).spotDetail;
    return _detailFromResult(result);
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
  TouristSpot _spotFromItem(Query$Spots$spots$items item) => TouristSpot(
    id: item.id,
    name: item.title,
    imageRef: item.thumbnailImageUrl,
    location: item.address ?? '',
    congestion: CongestionLevel.low,
    thumbnailImageUrl: item.thumbnailImageUrl,
    address: item.address,
    distanceMeters: item.distanceMeters.round(),
    copyright: _copyright(item.copyright),
    attributionText: item.attributionText,
    category: _categoryFromEnum(item.category),
  );

  /// 상세 생성 타입 → 도메인 [SpotDetail]. nullable 필드는 그대로 넘기고(UI가 숨김 판단),
  /// 갤러리 아이템은 [SpotImage]로 매핑한다(POL-020, AC-32).
  SpotDetail _detailFromResult(Query$SpotDetail$spotDetail r) => SpotDetail(
    id: r.id,
    title: r.title,
    category: _categoryFromEnum(r.category),
    thumbnailImageUrl: r.thumbnailImageUrl,
    overview: r.overview,
    address: r.address,
    homepage: r.homepage,
    tel: r.tel,
    copyright: _copyright(r.copyright),
    attributionText: r.attributionText,
    gallery: r.gallery.map(_imageFromGallery).toList(growable: false),
    likeCount: r.likeCount,
  );

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

  /// 상세 조회 실행. `_run`과 달리 최상위 `errors[]`를 정체불명 네트워크 실패로
  /// 뭉개지 않고, 첫 오류의 코드를 뽑아 [SpotFailure.fromQueryErrorCode]로 번역한다
  /// (SPOT_NOT_FOUND/UPSTREAM_*를 UI가 구분하려면 코드가 필요하다, spec §6·AC-26).
  /// 링크 예외(도달 불가)나 코드 없는 오류는 그대로 네트워크 실패로 떨어진다.
  Future<Map<String, dynamic>> _queryDetail(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await _client.query(
        QueryOptions(document: document, variables: variables),
      );
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      throw SpotFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    if (hasTransportFailure(result)) {
      GraphqlDebugLog.transportFailure(operation, result);
      final String? code = _firstErrorCode(result);
      // 코드가 있으면 유형별 실패로(SPOT_NOT_FOUND 등), 없으면(링크 예외 등) 네트워크로.
      throw code == null
          ? SpotFailure.network
          : SpotFailure.fromQueryErrorCode(code);
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw SpotFailure.unknown;
    return data;
  }

  /// 최상위 `errors[]` 첫 항목의 코드 문자열. 서버가 `extensions.code`에 싣는 것이
  /// 관례이나 최종 포맷은 미확정(`[TBD-2]`)이라, extensions에 없으면 코드처럼 보이는
  /// 메시지(SCREAMING_SNAKE)를 폴백으로 본다. 아무 코드도 못 찾으면 null.
  String? _firstErrorCode(QueryResult<Object?> result) {
    final List<GraphQLError> errors =
        result.exception?.graphqlErrors ?? const <GraphQLError>[];
    if (errors.isEmpty) return null;
    final GraphQLError error = errors.first;
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

    if (hasTransportFailure(result)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw SpotFailure.network;
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
