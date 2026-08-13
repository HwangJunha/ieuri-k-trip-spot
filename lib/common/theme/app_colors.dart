import 'package:flutter/painting.dart';

/// Brand palette. Detailed tones (surface/on-*) are derived by [AppTheme]
/// from these seeds via Material 3 [ColorScheme.fromSeed], following the
/// Google Stitch design.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFFEA4A3F);
  static const Color secondary = Color(0xFFA56200);
  static const Color tertiary = Color(0xFFF5A623);
  static const Color neutral = Color(0xFF88726F);
}
