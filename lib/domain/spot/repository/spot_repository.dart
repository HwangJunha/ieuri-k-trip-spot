import '../../../common/localization/app_language.dart';
import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
import '../model/liked_spot.dart';
import '../model/spot_category.dart';
import '../model/spot_detail.dart';
import '../model/spot_reaction.dart';
import '../model/tourist_spot.dart';

/// Data access for tourist spots. Returns domain models only; the current
/// implementation serves mock data, and when the tourism GraphQL API lands only
/// the implementation changes — providers and UI stay put (spec §4).
///
/// Signatures are async on purpose so the eventual network swap needs no
/// provider/UI change. The Discover swipe methods (SPEC-0002) return domain
/// values built on `common/pagination` so no feature rolls its own pagination.
abstract interface class SpotRepository {
  /// "Recommended for You" — horizontal spot cards.
  Future<List<TouristSpot>> fetchRecommendedSpots();

  /// "Popular Spots" — vertical spot cards with rating + distance.
  Future<List<TouristSpot>> fetchPopularSpots();

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

  /// 좋아요한 관광지 한 페이지(SPEC-0008 R-18). `likedSpots`는 **커서** 페이징이라
  /// 오프셋인 [fetchSpotPage]와 달리 [CursorPage]를 돌려준다 — 둘 다 `common/pagination`의
  /// 공용 타입이고, 기능이 자기 페이지네이션을 새로 만들지 않는다(CLAUDE.md §4).
  ///
  /// [after]는 이전 페이지의 `endCursor`이며 첫 조회에선 null이다. [first]는 페이지 크기.
  ///
  /// 정렬은 서버가 보장하므로 클라이언트가 재정렬하지 않는다. 미인증이면 최상위
  /// `errors[]`의 `UNAUTHENTICATED`가 [SpotFailure]로 번역되어 SPEC-0005의 세션 갱신
  /// 경로를 탄다 — 이 스펙이 별도 처리를 더하지 않는다(§5.2).
  Future<CursorPage<LikedSpot>> fetchLikedSpots({int? first, String? after});
}
