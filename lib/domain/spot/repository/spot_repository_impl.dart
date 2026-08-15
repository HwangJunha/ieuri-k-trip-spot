import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/location/coordinates.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
import '../model/copyright_type.dart';
import '../model/liked_spot.dart';
import '../model/popular_spot.dart';
import '../../../common/category/spot_category.dart';
import '../model/spot_detail.dart';
import '../model/spot_failure.dart';
import '../model/spot_image.dart';
import '../model/spot_info_item.dart';
import '../model/spot_intro.dart';
import '../model/spot_reaction.dart';
import '../model/spot_search_result.dart';
import '../model/spot_suggestion.dart';
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
    List<String>? categoryCodes,
    bool? hasOrigin,
    required int page,
    required int size,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySpots,
      Variables$Query$Spots(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        categories: _categories(categoryCodes),
        // null이면 변수를 보내지 않아 서버가 원문·번역을 모두 준다(SPEC-0019).
        hasOrigin: hasOrigin,
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
    // **한 건도 버리지 않는다**(SPEC-0020 AC1.3). 예전에는 생성 enum을 로컬 enum으로
    // 매핑하며 모르는 값을 null → whereType으로 걸렀는데, 그러면 서버가 카테고리를
    // 추가해도 클라이언트에서 조용히 사라졌다. 이제 code가 문자열이라 매핑 자체가
    // 없고, 모르는 코드는 아이콘만 기본값으로 떨어진다(AC11.5).
    return result.availableSpotCategories
        .map(_categoryFrom)
        .toList(growable: false);
  }

  @override
  Future<SpotDetail> fetchSpotDetail(String id) async {
    // 언어는 인자로 보내지 않는다 — Accept-Language 헤더로 전달된다(spec §2).
    // **카테고리 인자는 사라졌다**(SPEC-0020) — intro/infoItems를 서버가 spot 자신의
    // 카테고리로 해석하므로 호출부가 넘길 값이 없다.
    final Map<String, dynamic> data = await _query(
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
  Future<CursorPage<LikedSpot>> fetchLikedSpots({
    List<String>? categoryCodes,
    int? first,
    String? after,
  }) async {
    // 언어는 인자로 보내지 않는다 — Accept-Language 헤더로 전달된다(spec §2).
    // categoryCodes가 null/빈 목록이면 인자를 비워 전체를 받는다(서버 규약).
    final Map<String, dynamic> data = await _query(
      documentNodeQueryLikedSpots,
      Variables$Query$LikedSpots(
        categories: _categories(categoryCodes),
        first: first,
        after: after,
      ).toJson(),
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

  /// 반경 내 spot 검색(SPEC-0013 R1–R8).
  ///
  /// **입력 검증 실패는 최상위 `errors[]`가 아니라 payload의 `userErrors`로 온다**
  /// (POL-015 — HTTP는 항상 200). 조회에 `userErrors`가 붙는 첫 사례라, 뮤테이션과
  /// 같은 방식으로 코드만 로깅하고(메시지는 PII 가능) [SpotFailure]로 번역한다.
  ///
  /// 결과 0건은 오류가 아니다 — 빈 [SpotSearchResult]로 돌아가고 화면이 정상 상태로
  /// 표현한다(AC-11.2). 정렬은 서버가 보장하므로 재정렬하지 않는다(POL-019).
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
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySearchSpots,
      Variables$Query$SearchSpots(
        query: query,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        categories: _categories(categoryCodes),
        page: page,
        size: size,
      ).toJson(),
      'searchSpots',
    );
    final Query$SearchSpots$searchSpots payload = Query$SearchSpots.fromJson(
      data,
    ).searchSpots;

    if (payload.userErrors.isNotEmpty) {
      final List<({String code, String? field})> parsed = payload.userErrors
          .map(
            (Query$SearchSpots$searchSpots$userErrors e) =>
                (code: e.code, field: e.field),
          )
          .toList();
      // 질의 원문은 사용자 입력이라 로깅하지 않는다(POL-013) — 코드만 남긴다.
      GraphqlDebugLog.userErrors('searchSpots', parsed);
      throw SpotFailure(SpotFailureKind.userError, code: parsed.first.code);
    }
    if (!payload.success) throw SpotFailure.unknown;

    final Query$SearchSpots$searchSpots$connection c = payload.connection;
    return SpotSearchResult(
      page: OffsetPage<TouristSpot>(
        items: c.items
            .map(
              (Query$SearchSpots$searchSpots$connection$items i) =>
                  _spotFromSearchNode(i),
            )
            .toList(growable: false),
        page: c.page,
        hasNext: c.hasNext,
        totalCount: c.totalCount,
      ),
      totalCount: c.totalCount,
    );
  }

  /// 반경 내 제목 접두 자동완성(SPEC-0013 R9).
  ///
  /// 빈 질의는 서버가 오류가 아니라 빈 목록으로 답한다(AC-9.4) — 클라이언트가
  /// 미리 거르지 않고 그대로 보낸다.
  @override
  Future<List<SpotSuggestion>> spotSearchSuggestions({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    int? limit,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySpotSearchSuggestions,
      Variables$Query$SpotSearchSuggestions(
        query: query,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        limit: limit,
      ).toJson(),
      'spotSearchSuggestions',
    );
    return Query$SpotSearchSuggestions.fromJson(data).spotSearchSuggestions
        .map(
          (Query$SpotSearchSuggestions$spotSearchSuggestions s) =>
              SpotSuggestion(
                id: s.id,
                // TourAPI 원문이라 엔티티가 섞여 온다(다른 표면과 동일하게 정리).
                title: sanitizeTourApiText(s.title) ?? s.title,
                category: _categoryOf(
                  s.category.code,
                  s.category.label,
                  s.category.iconUrl,
                ),
              ),
        )
        .toList(growable: false);
  }

  /// 반경 내 인기 spot(SPEC-0013 R18). 좋아요 총합 내림차순이며 서버가 정렬한다.
  @override
  Future<CursorPage<PopularSpot>> fetchPopularSpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categoryCodes,
    bool? hasOrigin,
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryPopularSpots,
      Variables$Query$PopularSpots(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        categories: _categories(categoryCodes),
        hasOrigin: hasOrigin,
        first: first,
        after: after,
      ).toJson(),
      'popularSpots',
    );
    final Query$PopularSpots$popularSpots result = Query$PopularSpots.fromJson(
      data,
    ).popularSpots;
    return CursorPage<PopularSpot>(
      items: result.edges
          .map(
            (Query$PopularSpots$popularSpots$edges e) => PopularSpot(
              spot: _spotFromPopularNode(e.node),
              likeCount: e.likeCount,
            ),
          )
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<void> reactToSpot(String catalogId, SpotReaction reaction) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationReactToSpot,
      Variables$Mutation$ReactToSpot(
        input: Input$ReactToSpotInput(
          catalogId: catalogId,
          reaction: _reaction(reaction),
        ),
      ).toJson(),
      'reactToSpot',
    );
    final Mutation$ReactToSpot$reactToSpot payload =
        Mutation$ReactToSpot.fromJson(data).reactToSpot;
    _check('reactToSpot', payload.success, payload.userErrors);
  }

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
    thumbnailImageUrl: item.thumbnailImageUrl,
    address: sanitizeTourApiText(item.address),
    distanceMeters: item.distanceMeters.round(),
    copyright: _copyright(item.copyright),
    attributionText: item.attributionText,
    category: _categoryOf(
      item.category.code,
      item.category.label,
      item.category.iconUrl,
    ),
  );

  /// 검색 결과 노드 → 도메인 [TouristSpot](SPEC-0013).
  ///
  /// `spots`와 같은 `Spot` 타입이지만 생성 타입이 오퍼레이션별로 갈리므로 매핑도
  /// 따로 둔다 — 규칙은 [_spotFromItem]과 같다(엔티티 정리, 거리 미터 반올림).
  TouristSpot _spotFromSearchNode(
    Query$SearchSpots$searchSpots$connection$items n,
  ) => TouristSpot(
    id: n.id,
    name: sanitizeTourApiText(n.title) ?? n.title,
    imageRef: n.thumbnailImageUrl,
    location: sanitizeTourApiText(n.address) ?? '',
    thumbnailImageUrl: n.thumbnailImageUrl,
    address: sanitizeTourApiText(n.address),
    distanceMeters: n.distanceMeters.round(),
    copyright: _copyright(n.copyright),
    attributionText: n.attributionText,
    category: _categoryOf(
      n.category.code,
      n.category.label,
      n.category.iconUrl,
    ),
    // **`mapX`가 경도, `mapY`가 위도다** — 이름이 직관과 반대라 뒤집기 쉽다.
    // 지도(SPEC-0014)가 검색 결과로 지도를 옮기는 데 쓴다.
    coordinates: Coordinates(latitude: n.mapY, longitude: n.mapX),
  );

  /// 인기 spot 노드 → 도메인 [TouristSpot]. 랭킹 근거(`likeCount`)는 edge에 있어
  /// 호출부가 [PopularSpot]으로 감싼다.
  TouristSpot _spotFromPopularNode(
    Query$PopularSpots$popularSpots$edges$node n,
  ) => TouristSpot(
    id: n.id,
    name: sanitizeTourApiText(n.title) ?? n.title,
    imageRef: n.thumbnailImageUrl,
    location: sanitizeTourApiText(n.address) ?? '',
    thumbnailImageUrl: n.thumbnailImageUrl,
    address: sanitizeTourApiText(n.address),
    distanceMeters: n.distanceMeters.round(),
    copyright: _copyright(n.copyright),
    attributionText: n.attributionText,
    category: _categoryOf(
      n.category.code,
      n.category.label,
      n.category.iconUrl,
    ),
  );

  /// 좋아요 목록 노드 → 도메인 [LikedSpot](POL-020, §5.2).
  ///
  /// **폴백이 없다**(SPEC-0020). 예전에는 매핑되지 않은 서버 enum을 touristSpot으로
  /// 떨어뜨렸는데, 이제 카테고리가 코드/라벨을 실은 객체라 서버가 보낸 값을 그대로
  /// 담으면 된다 — 지어낼 것이 없다.
  LikedSpot _likedFromNode(Query$LikedSpots$likedSpots$edges$node n) =>
      LikedSpot(
        id: n.id,
        // TourAPI 원문이라 엔티티가 섞여 온다(다른 표면과 동일하게 정리).
        title: sanitizeTourApiText(n.title) ?? n.title,
        thumbnailImageUrl: n.thumbnailImageUrl,
        address: sanitizeTourApiText(n.address),
        category: _categoryOf(
          n.category.code,
          n.category.label,
          n.category.iconUrl,
        ),
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
    category: _categoryOf(
      r.category.code,
      r.category.label,
      r.category.iconUrl,
    ),
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

  /// 생성 카테고리 객체 → 도메인 [SpotCategory](SPEC-0020 R11).
  ///
  /// **판정도 걸러내기도 하지 않는다**(AC1.3). 서버 값을 그대로 담을 뿐이라 서버가
  /// 카테고리를 추가해도 클라이언트는 아무것도 잃지 않는다 — 모르는 코드는 아이콘만
  /// 중립 기본값으로 떨어진다(AC11.5).
  ///
  /// 오퍼레이션마다 생성 타입이 갈리므로([Query$Spots$spots$items$category] 등) 인자를
  /// 구조적으로 받는다. 필드 이름이 같아 호출부가 그대로 넘긴다.
  SpotCategory _categoryOf(String code, String label, String? iconUrl) =>
      SpotCategory(code: code, label: label, iconUrl: iconUrl);

  /// `availableSpotCategories` 항목 매핑(칩 목록).
  SpotCategory _categoryFrom(
    Query$AvailableSpotCategories$availableSpotCategories c,
  ) => _categoryOf(c.code, c.label, c.iconUrl);

  /// 선택 집합 → `categories` 변수. **빈 목록은 보내지 않는다** — 서버가
  /// `EMPTY_CATEGORY_SET`으로 거절하므로 null로 접어 전체를 받는다(AC5.1).
  List<String>? _categories(List<String>? codes) =>
      (codes == null || codes.isEmpty) ? null : codes;

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
