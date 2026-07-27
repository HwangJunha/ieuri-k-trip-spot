/// Real-time crowding of a spot. Pure domain enum — the UI maps each level to a
/// semantic color (via the `CongestionColors` theme extension) and an l10n label
/// (Low / Moderate / High, a.k.a. Quiet / … / Very Busy).
enum CongestionLevel {
  low,
  moderate,
  high;

  /// Maps a server/wire token to a level, defaulting to [moderate] for unknown
  /// values. Kept here so the repository maps once and the model stays the
  /// single source of truth when the real API lands.
  static CongestionLevel fromWire(String? wire) =>
      switch (wire?.toUpperCase()) {
        'LOW' => CongestionLevel.low,
        'MODERATE' => CongestionLevel.moderate,
        'HIGH' => CongestionLevel.high,
        _ => CongestionLevel.moderate,
      };
}
