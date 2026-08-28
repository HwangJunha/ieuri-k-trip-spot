import '../../../common/localization/app_language.dart';
import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
import '../model/liked_spot.dart';
import '../model/popular_spot.dart';
import '../../../common/category/spot_category.dart';
import '../model/spot_detail.dart';
import '../model/spot_reaction.dart';
import '../model/spot_search_result.dart';
import '../model/spot_suggestion.dart';
import '../model/tourist_spot.dart';

/// Data access for tourist spots. Returns domain models only — the generated
/// GraphQL types never cross this boundary (CLAUDE.md §3).
///
/// 홈의 목 데이터 메서드(`fetchRecommendedSpots`/`fetchPopularSpots`)는
/// SPEC-0013에서 제거했다. 홈 "Near you"는 Discover와 같은 [fetchSpotPage]를
/// 재사용한다 — 같은 `spots` 쿼리이므로 조회 경로를 둘로 두지 않는다.
///
/// Methods return domain values built on `common/pagination` so no feature
/// rolls its own pagination.
///
/// **카테고리 필터는 `List<String>? categoryCodes`로 받는다**(SPEC-0020 R5). 도메인
/// 값 객체([SpotCategory])가 아니라 코드 목록인 이유는 그것이 곧 전송 형태이기
/// 때문이다 — `categories: [String!]` 인자에 변환 없이 그대로 실린다(AC5.2). 라벨과
/// 아이콘은 필터링에 아무 역할도 하지 않으므로 경계를 넘길 이유가 없다.
///
/// **빈 목록은 넘기지 않는다.** 서버가 `EMPTY_CATEGORY_SET`으로 거절하므로, 선택이
/// 비면 호출부가 null을 주고 서버는 전체를 돌려준다(AC5.1). 그 접기는
/// `SpotCategorySelection.codesOrNull`이 한다.
abstract interface class SpotRepository {
  /// One page of the Discover swipe feed. The server has no cursor support, so
  /// this is offset pagination: [page] is the 0-based page number and [size] the
  /// page length. [latitude]/[longitude] are the user's location (server-required),
  /// [radiusMeters] bounds the search, and [categoryCodes] filters when set. Returns
  /// an [OffsetPage] carrying items + `page` + `hasNext` (spec §4).
  ///
  /// **결과는 활성 언어에 원문이 있는 장소뿐이다**(SPEC-0029). 기계번역이 사라져
  /// 서버가 언어 축으로 장소를 가르므로, 원문/번역을 고르던 `hasOrigin`도 함께
  /// 없어졌다 — 고를 대상이 없다. 다른 언어에만 있는 장소는 오류가 아니라 그냥
  /// 결과에 들어오지 않는다.
  Future<OffsetPage<TouristSpot>> fetchSpotPage({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categoryCodes,
    required int page,
    required int size,
  });

  /// One tourist spot's full detail by [id] (=contentId, SPEC-0003). The active
  /// language is carried by the client's `Accept-Language` header, not an
  /// argument (spec §2). Maps the GraphQL response to a domain [SpotDetail];
  /// query-level failures surface as a [SpotFailure] the provider translates to a
  /// UI state (SPOT_NOT_FOUND / UPSTREAM_RATE_LIMITED / UPSTREAM_UNAVAILABLE, §6).
  ///
  /// **[categoryCode]는 서버가 요구한다.** `intro`/`infoItems`가 카테고리마다 다른
  /// TourAPI 응답을 정규화하므로 어떤 카테고리로 읽을지 알아야 한다. SPEC-0020이 이
  /// 인자가 사라진 것으로 보고 걷어냈으나 실제로는 이름과 타입만 바뀌었고
  /// (`category: SpotCategory!` → `categoryCode: String!`), 빠뜨린 동안 상세 화면이
  /// 검증 오류로 통째로 막혀 있었다.
  ///
  /// **응답의 `category.code`로는 채울 수 없다** — 서버가 전 spot에서 null을 준다.
  /// 그래서 목록에서 코드를 받은 호출부가 넘긴다.
  ///
  /// 모르면 null을 넘긴다. 그때는 운영정보 섹션만 비고 상세 본문은 정상이다 —
  /// 틀린 코드에 서버가 `intro: null`·`infoItems: []`로 답하기 때문이며, 빈 문자열은
  /// 서버가 예외로 거부하므로 구현이 대신 기본 코드를 채운다.
  Future<SpotDetail> fetchSpotDetail(String id, {String? categoryCode});

  /// The categories the server exposes for the active [language] (spec §5). The
  /// server is the single source of availability — the client renders exactly
  /// what this returns and hardcodes nothing.
  Future<List<SpotCategory>> fetchAvailableCategories(AppLanguage language);

  /// Records a swipe [reaction] for spot [catalogId] (spec §4, optimistic).
  /// Resolves on success; a failure surfaces as a thrown error the caller can
  /// log and ignore (like-failure is non-critical).
  Future<void> reactToSpot(String catalogId, SpotReaction reaction);

  /// 반경 안의 spot을 제목·주소 대상으로 검색한다(SPEC-0013 R1–R8, R14).
  ///
  /// 서버가 BM25 관련도를 거리로 가중해 정렬하며, **클라이언트는 재정렬하지
  /// 않는다**(POL-019 — 정렬은 계약이다).
  ///
  /// **오프셋 페이징이다**([page]는 0-based, [size]는 페이지 크기). 초안은 커서를
  /// 요구했으나 서버가 커서 방식에서 정확히 동작하지 않아 전환됐다.
  ///
  /// 결과 0건은 오류가 아니라 빈 [SpotSearchResult]다(AC-11.2). 질의가 공백뿐이거나
  /// 100자를 넘으면 서버가 `userErrors`로 거절하며, 그것은 [SpotFailure]로 번역된다.
  Future<SpotSearchResult> searchSpots({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categoryCodes,
    int? page,
    int? size,
  });

  /// 반경 내 spot 제목의 접두 자동완성(SPEC-0013 R9).
  ///
  /// 페이지네이션하지 않는다 — 지연에 민감한 입력 보조 수단이라 서버가 최대
  /// 10건만 준다. **빈 질의는 오류가 아니라 빈 목록이다**(AC-9.4).
  Future<List<SpotSuggestion>> spotSearchSuggestions({
    required String query,
    required double latitude,
    required double longitude,
    int? radiusMeters,
    int? limit,
  });

  /// 반경 내 인기 spot 한 페이지(SPEC-0013 R18).
  ///
  /// 좋아요 총합 내림차순이며 **서버가 정렬한다**(POL-019). 최소 좋아요 수 미만인
  /// spot은 서버가 제외하므로 클라이언트가 거르지 않는다(AC-18.2) — 그 기준은
  /// SPEC-0029에서 10에서 5로 낮아졌고, 이 역시 서버가 정한다. 조건을 만족하는
  /// spot이 0건인 것은 정상 상태다(AC-18.4).
  ///
  /// 활성 언어 한정은 [fetchSpotPage]와 같다(SPEC-0029).
  Future<CursorPage<PopularSpot>> fetchPopularSpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    List<String>? categoryCodes,
    int? first,
    String? after,
  });

  /// 좋아요한 관광지 한 페이지(SPEC-0008 R-18). `likedSpots`는 **커서** 페이징이라
  /// 오프셋인 [fetchSpotPage]와 달리 [CursorPage]를 돌려준다 — 둘 다 `common/pagination`의
  /// 공용 타입이고, 기능이 자기 페이지네이션을 새로 만들지 않는다(CLAUDE.md §4).
  ///
  /// [after]는 이전 페이지의 `endCursor`이며 첫 조회에선 null이다. [first]는 페이지 크기.
  /// [categoryCodes]가 null이면 전체다 — 필터링은 서버가 하고 클라이언트는 받은
  /// 페이지를 그대로 잇는다(Discover의 [fetchSpotPage]와 같은 규약).
  ///
  /// 정렬은 서버가 보장하므로 클라이언트가 재정렬하지 않는다. 미인증이면 최상위
  /// `errors[]`의 `UNAUTHENTICATED`가 [SpotFailure]로 번역되어 SPEC-0005의 세션 갱신
  /// 경로를 탄다 — 이 스펙이 별도 처리를 더하지 않는다(§5.2).
  ///
  /// [query]는 목록 내 검색어다(SPEC-0033). **null·빈 문자열이면 검색하지 않는다** —
  /// 서버가 `likedSpots`에 인자를 더한 것이 아니라 `searchLikedSpots`를 따로 냈고
  /// 그쪽 `query`는 non-null 필수라, 구현이 검색어 유무로 두 오퍼레이션을 가른다.
  /// 호출부는 그 갈림을 알 필요가 없다 — 여기서는 인자 하나로 보인다.
  ///
  /// 카테고리와 **함께**(AND) 적용되고, 정렬은 검색이어도 `likedAt DESC`다 —
  /// [searchSpots]의 관련도 정렬과 다르다.
  Future<CursorPage<LikedSpot>> fetchLikedSpots({
    List<String>? categoryCodes,
    String? query,
    int? first,
    String? after,
  });
}
