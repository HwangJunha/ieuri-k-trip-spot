import '../../../common/localization/app_language.dart';
import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
import '../model/liked_spot.dart';
import '../model/popular_spot.dart';
import '../model/spot_category.dart';
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
abstract interface class SpotRepository {
  /// One page of the Discover swipe feed. The server has no cursor support, so
  /// this is offset pagination: [page] is the 0-based page number and [size] the
  /// page length. [latitude]/[longitude] are the user's location (server-required),
  /// [radiusMeters] bounds the search, and [category] filters when set. Returns an
  /// [OffsetPage] carrying items + `page` + `hasNext` (spec §4).
  Future<OffsetPage<TouristSpot>> fetchSpotPage({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    SpotCategory? category,
    required int page,
    required int size,
  });

  /// One tourist spot's full detail by [id] (=contentId, SPEC-0003). The active
  /// language is carried by the client's `Accept-Language` header, not an
  /// argument (spec §2). Maps the GraphQL response to a domain [SpotDetail];
  /// query-level failures surface as a [SpotFailure] the provider translates to a
  /// UI state (SPOT_NOT_FOUND / UPSTREAM_RATE_LIMITED / UPSTREAM_UNAVAILABLE, §6).
  ///
  /// [category] is required by the server's `intro`/`infoItems` fields, which
  /// normalize category-specific TourAPI responses. It cannot be read from the
  /// response being fetched, so the caller supplies the value it already has from
  /// the swipe feed. When it is null (an unmapped server enum) the caller omits
  /// those two sections rather than failing the whole screen.
  Future<SpotDetail> fetchSpotDetail(String id, SpotCategory category);

  /// The categories the server exposes for the active [language] (spec §5). The
  /// server is the single source of availability — the client renders exactly
  /// what this returns and hardcodes nothing.
  Future<List<SpotCategory>> fetchAvailableCategories(AppLanguage language);

  /// Records a swipe [reaction] for spot [spotId] (spec §4, optimistic). Resolves
  /// on success; a failure surfaces as a thrown error the caller can log and
  /// ignore (like-failure is non-critical).
  Future<void> reactToSpot(String spotId, SpotReaction reaction);

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
    SpotCategory? category,
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
  /// 좋아요 총합 내림차순이며 **서버가 정렬한다**(POL-019). 좋아요 10개 미만인
  /// spot은 서버가 제외하므로 클라이언트가 거르지 않는다(AC-18.2). 조건을 만족하는
  /// spot이 0건인 것은 정상 상태다(AC-18.4).
  Future<CursorPage<PopularSpot>> fetchPopularSpots({
    required double latitude,
    required double longitude,
    int? radiusMeters,
    SpotCategory? category,
    int? first,
    String? after,
  });

  /// 좋아요한 관광지 한 페이지(SPEC-0008 R-18). `likedSpots`는 **커서** 페이징이라
  /// 오프셋인 [fetchSpotPage]와 달리 [CursorPage]를 돌려준다 — 둘 다 `common/pagination`의
  /// 공용 타입이고, 기능이 자기 페이지네이션을 새로 만들지 않는다(CLAUDE.md §4).
  ///
  /// [after]는 이전 페이지의 `endCursor`이며 첫 조회에선 null이다. [first]는 페이지 크기.
  /// [category]가 null이면 전체다 — 필터링은 서버가 하고 클라이언트는 받은 페이지를
  /// 그대로 잇는다(Discover의 [fetchSpotPage]와 같은 규약).
  ///
  /// 정렬은 서버가 보장하므로 클라이언트가 재정렬하지 않는다. 미인증이면 최상위
  /// `errors[]`의 `UNAUTHENTICATED`가 [SpotFailure]로 번역되어 SPEC-0005의 세션 갱신
  /// 경로를 탄다 — 이 스펙이 별도 처리를 더하지 않는다(§5.2).
  Future<CursorPage<LikedSpot>> fetchLikedSpots({
    SpotCategory? category,
    int? first,
    String? after,
  });
}
