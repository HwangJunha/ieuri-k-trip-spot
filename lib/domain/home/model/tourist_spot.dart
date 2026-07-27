import 'congestion_level.dart';

/// A tourist spot shown on Home cards (recommended + popular sections). Pure
/// domain model — no widgets, no transport types. Only the fields the cards
/// render; the repository maps its source (mock now, GraphQL later) into this.
///
/// [imageRef] is an opaque image reference. Mock data uses it as a stable seed
/// for a color-block placeholder (offline/test stability, spec §4) rather than a
/// network URL; when the real API lands it can carry an asset key or URL without
/// changing the model shape.
class TouristSpot {
  const TouristSpot({
    required this.id,
    required this.name,
    required this.imageRef,
    required this.location,
    required this.congestion,
    this.rating,
    this.distanceKm,
  });

  final String id;
  final String name;
  final String imageRef;

  /// Human-readable location label, e.g. "Seoul, Jongno-gu".
  final String location;
  final CongestionLevel congestion;

  /// Star rating (e.g. 4.8). Null when not applicable (recommended cards).
  final double? rating;

  /// Distance from the user in kilometres (mock value this step). Null when not
  /// shown (recommended cards).
  final double? distanceKm;

  @override
  bool operator ==(Object other) =>
      other is TouristSpot &&
      other.id == id &&
      other.name == name &&
      other.imageRef == imageRef &&
      other.location == location &&
      other.congestion == congestion &&
      other.rating == rating &&
      other.distanceKm == distanceKm;

  @override
  int get hashCode =>
      Object.hash(id, name, imageRef, location, congestion, rating, distanceKm);
}
