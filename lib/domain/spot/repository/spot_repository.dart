import '../../../common/localization/app_language.dart';
import '../../../common/pagination/offset_page.dart';
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
  Future<SpotDetail> fetchSpotDetail(String id);

  /// The categories the server exposes for the active [language] (spec §5). The
  /// server is the single source of availability — the client renders exactly
  /// what this returns and hardcodes nothing.
  Future<List<SpotCategory>> fetchAvailableCategories(AppLanguage language);

  /// Records a swipe [reaction] for spot [spotId] (spec §4, optimistic). Resolves
  /// on success; a failure surfaces as a thrown error the caller can log and
  /// ignore (like-failure is non-critical).
  Future<void> reactToSpot(String spotId, SpotReaction reaction);
}
