/// Category of a "Happening Now" event. Pure domain enum; the UI maps each to an
/// `Icons.*` glyph and an l10n label (Festival / Live / Art).
enum EventCategory {
  festival,
  live,
  art;

  static EventCategory fromWire(String? wire) => switch (wire?.toUpperCase()) {
    'FESTIVAL' => EventCategory.festival,
    'LIVE' => EventCategory.live,
    'ART' => EventCategory.art,
    _ => EventCategory.festival,
  };
}

/// An event shown in the Home "Happening Now" section. Pure domain model, kept
/// minimal per spec §4 (only title + category are specified; no time/subtitle).
///
/// [imageRef] is an opaque reference used as a color-block placeholder seed for
/// mock data (spec §4), not a network URL.
class TourEvent {
  const TourEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.imageRef,
  });

  final String id;
  final String title;
  final EventCategory category;
  final String imageRef;

  @override
  bool operator ==(Object other) =>
      other is TourEvent &&
      other.id == id &&
      other.title == title &&
      other.category == category &&
      other.imageRef == imageRef;

  @override
  int get hashCode => Object.hash(id, title, category, imageRef);
}
