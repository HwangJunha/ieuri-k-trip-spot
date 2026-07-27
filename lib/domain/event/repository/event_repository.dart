import '../model/tour_event.dart';

/// Data access for tourism events. Returns domain models only; the current
/// implementation serves mock data, and when the tourism GraphQL API lands only
/// the implementation changes — providers and UI stay put (spec §4).
///
/// The signature is async on purpose so the eventual network swap needs no
/// provider/UI change.
abstract interface class EventRepository {
  /// "Happening Now" — event cards shown on Home and (later) the Events tab.
  Future<List<TourEvent>> fetchHappeningNowEvents();
}
