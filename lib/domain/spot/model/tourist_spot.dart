import 'congestion_level.dart';
import 'copyright_type.dart';
import 'distance.dart';
import 'spot_category.dart';

/// A tourist spot. Pure domain model — no widgets, no transport types. The
/// repository maps its source (mock now, GraphQL later) into this.
///
/// Two surfaces share it:
/// - Home cards (recommended + popular) use [name], [imageRef], [location],
///   [congestion], [rating], [distanceKm].
/// - The Discover swipe card (SPEC-0002) uses [thumbnailImageUrl], [address],
///   [distanceMeters], [copyright], [attributionText], [category].
///
/// The swipe fields are optional so Home construction is untouched; a spot built
/// for the swipe feed fills them, a Home spot leaves them null.
///
/// [imageRef] is an opaque image reference. Mock data uses it as a stable seed
/// for a color-block placeholder (offline/test stability, spec §4) rather than a
/// network URL; when the real API lands it can carry an asset key or URL without
/// changing the model shape. [thumbnailImageUrl] is the swipe-card variant of the
/// same idea — kept separate so the two surfaces can diverge later.
class TouristSpot {
  const TouristSpot({
    required this.id,
    required this.name,
    required this.imageRef,
    required this.location,
    required this.congestion,
    this.rating,
    this.distanceKm,
    this.thumbnailImageUrl,
    this.address,
    this.distanceMeters,
    this.copyright,
    this.attributionText,
    this.category,
  });

  final String id;
  final String name;
  final String imageRef;

  /// Human-readable location label, e.g. "Seoul, Jongno-gu".
  final String location;
  final CongestionLevel congestion;

  /// Star rating (e.g. 4.8). Null when not applicable (recommended cards).
  final double? rating;

  /// Distance from the user in kilometres (Home popular cards). Null when not
  /// shown. The swipe surface uses [distanceMeters] instead.
  final double? distanceKm;

  /// Swipe-card image reference (opaque; mock uses it as a placeholder seed).
  final String? thumbnailImageUrl;

  /// Full address shown on the swipe card overlay. Null on Home spots.
  final String? address;

  /// Server-computed distance in metres for the swipe card. The client localizes
  /// the display via [distance] (POL-024). Null on Home spots.
  final int? distanceMeters;

  /// Image copyright type — drives the swipe card's BoxFit branch (spec §6).
  final CopyrightType? copyright;

  /// Minimal attribution text rendered on every swipe card (AC-21).
  final String? attributionText;

  /// Category the spot belongs to (Discover category bar).
  final SpotCategory? category;

  /// [distanceMeters] as a [Distance] value the swipe card can localize. Null
  /// when the server did not compute a distance.
  Distance? get distance =>
      distanceMeters == null ? null : Distance(distanceMeters!);

  @override
  bool operator ==(Object other) =>
      other is TouristSpot &&
      other.id == id &&
      other.name == name &&
      other.imageRef == imageRef &&
      other.location == location &&
      other.congestion == congestion &&
      other.rating == rating &&
      other.distanceKm == distanceKm &&
      other.thumbnailImageUrl == thumbnailImageUrl &&
      other.address == address &&
      other.distanceMeters == distanceMeters &&
      other.copyright == copyright &&
      other.attributionText == attributionText &&
      other.category == category;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    imageRef,
    location,
    congestion,
    rating,
    distanceKm,
    thumbnailImageUrl,
    address,
    distanceMeters,
    copyright,
    attributionText,
    category,
  );
}
