import 'copyright_type.dart';
import 'distance.dart';
import 'spot_category.dart';

/// A tourist spot. Pure domain model — no widgets, no transport types. The
/// repository maps the GraphQL response into this.
///
/// Two surfaces share it:
/// - Home cards (Near you + Popular) use [name], [imageRef], [location],
///   [distanceMeters].
/// - The Discover swipe card (SPEC-0002) uses [thumbnailImageUrl], [address],
///   [distanceMeters], [copyright], [attributionText], [category].
///
/// 별점과 혼잡도 필드는 SPEC-0013에서 **제거**했다. 서버에 rating 컬럼도
/// 혼잡도 소스도 없어 클라이언트가 지어낸 값이었고, AC-15.2·AC-15.3이 이
/// 모델에 두 필드가 **없을 것**을 요구한다. 화면에서 감추는 것으로는 부족해
/// 모델에서 지운다 — 남겨 두면 다음 사람이 다시 채운다.
///
/// [imageRef] is an opaque image reference: a network URL when the server
/// provides one, otherwise a stable seed for a color-block placeholder.
/// [thumbnailImageUrl] is the swipe-card variant of the same idea — kept
/// separate so the two surfaces can diverge later.
class TouristSpot {
  const TouristSpot({
    required this.id,
    required this.name,
    required this.imageRef,
    required this.location,
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

  /// Swipe-card image reference (opaque; a non-URL value renders as a placeholder).
  final String? thumbnailImageUrl;

  /// Full address shown on the swipe card overlay.
  final String? address;

  /// Server-computed distance in metres. The client localizes the display via
  /// [distance] (POL-024). Null when the server did not compute one.
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
    thumbnailImageUrl,
    address,
    distanceMeters,
    copyright,
    attributionText,
    category,
  );
}
