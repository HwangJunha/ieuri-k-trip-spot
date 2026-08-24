import 'package:flutter/painting.dart';

/// Brand palette. Detailed tones (surface/on-*) are derived by [AppTheme]
/// from these seeds via Material 3 [ColorScheme.fromSeed], following the
/// Google Stitch design.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFFEA4A3F);

  /// 브랜드색 단일화로 primary와 같은 값이다 — 주황 서브 컬러는 쓰지 않는다.
  static const Color secondary = primary;
  static const Color tertiary = Color(0xFFF5A623);
  static const Color neutral = Color(0xFF88726F);
}
