import 'package:flutter/material.dart';

/// Semantic colors for real-time congestion levels (DESIGN.md §3/§5 "커스텀
/// 시맨틱 색상"). These are *not* Material 3 [ColorScheme] roles, so they live in
/// a dedicated [ThemeExtension] shared by Home cards and the future Map markers.
///
/// Widgets read a level's color via
/// `Theme.of(context).extension<CongestionColors>()`; nothing hardcodes the hex.
@immutable
class CongestionColors extends ThemeExtension<CongestionColors> {
  const CongestionColors({
    required this.low,
    required this.moderate,
    required this.high,
    required this.onCongestion,
  });

  /// "Low" / "Quiet" — token `congestion-low`.
  final Color low;

  /// "Moderate" — token `congestion-medium`.
  final Color moderate;

  /// "High" / "Very Busy" — token `congestion-high`.
  final Color high;

  /// Contrasting text/icon color for content sitting on a congestion color.
  /// All three source colors are mid-dark, so white reads accessibly on each.
  final Color onCongestion;

  /// The single source-of-truth token set (DESIGN.md §2.2). Shared by light and
  /// dark themes — the badge colors are semantic and identical across brightness.
  static const CongestionColors brand = CongestionColors(
    low: Color(0xFF2E9E5B),
    moderate: Color(0xFFF5A623),
    high: Color(0xFFE23B2E),
    onCongestion: Color(0xFFFFFFFF),
  );

  @override
  CongestionColors copyWith({
    Color? low,
    Color? moderate,
    Color? high,
    Color? onCongestion,
  }) => CongestionColors(
    low: low ?? this.low,
    moderate: moderate ?? this.moderate,
    high: high ?? this.high,
    onCongestion: onCongestion ?? this.onCongestion,
  );

  @override
  CongestionColors lerp(ThemeExtension<CongestionColors>? other, double t) {
    if (other is! CongestionColors) return this;
    return CongestionColors(
      low: Color.lerp(low, other.low, t)!,
      moderate: Color.lerp(moderate, other.moderate, t)!,
      high: Color.lerp(high, other.high, t)!,
      onCongestion: Color.lerp(onCongestion, other.onCongestion, t)!,
    );
  }
}
