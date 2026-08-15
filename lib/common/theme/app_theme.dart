import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light and dark [ThemeData] for the app.
///
/// The light scheme is the exact Material 3 role set exported from the Google
/// Stitch design system. The dark scheme is seeded from the brand key color
/// (Stitch currently ships light only — dark tones are a follow-up).
///
/// Noto Sans is the single multilingual family, with CJK fallbacks so
/// EN/KO/JA/ZH glyphs never break. (Stitch names Plus Jakarta Sans / Be Vietnam
/// Pro, but those don't cover JA/ZH; per the approved spec the app unifies on
/// Noto Sans while keeping the M3 type scale, which matches Stitch's sizes.)
class AppTheme {
  const AppTheme._();

  static const String _fontFamily = 'NotoSans';
  static const List<String> _fontFamilyFallback = <String>[
    'NotoSansKR',
    'NotoSansJP',
    'NotoSansSC',
  ];

  static final ThemeData light = _build(_lightScheme);
  static final ThemeData dark = _build(_darkScheme);

  static ThemeData _build(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    fontFamily: _fontFamily,
    fontFamilyFallback: _fontFamilyFallback,
  );

  /// Exact Stitch light color roles.
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB2211D),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD53B32),
    onPrimaryContainer: Color(0xFFFFFBFF),
    secondary: Color(0xFFB4501E),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDBCC),
    onSecondaryContainer: Color(0xFF7A3210),
    tertiary: Color(0xFF805200),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFA16900),
    onTertiaryContainer: Color(0xFFFFFBFF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFFFF8F7),
    onSurface: Color(0xFF271816),
    onSurfaceVariant: Color(0xFF5A403D),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFFF0EE),
    surfaceContainer: Color(0xFFFFE9E6),
    surfaceContainerHigh: Color(0xFFFEE2DE),
    surfaceContainerHighest: Color(0xFFF8DCD9),
    surfaceDim: Color(0xFFEFD4D0),
    surfaceBright: Color(0xFFFFF8F7),
    outline: Color(0xFF8E706C),
    outlineVariant: Color(0xFFE3BEB9),
    inverseSurface: Color(0xFF3D2C2A),
    onInverseSurface: Color(0xFFFFEDEA),
    inversePrimary: Color(0xFFFFB4AA),
    surfaceTint: Color(0xFFB6241F),
    primaryFixed: Color(0xFFFFDAD5),
    primaryFixedDim: Color(0xFFFFB4AA),
    onPrimaryFixed: Color(0xFF410002),
    onPrimaryFixedVariant: Color(0xFF93020A),
    secondaryFixed: Color(0xFFFFDBCC),
    secondaryFixedDim: Color(0xFFE5A183),
    onSecondaryFixed: Color(0xFF33150A),
    onSecondaryFixedVariant: Color(0xFF7A3210),
    tertiaryFixed: Color(0xFFFFDDB4),
    tertiaryFixedDim: Color(0xFFFFB955),
    onTertiaryFixed: Color(0xFF291800),
    onTertiaryFixedVariant: Color(0xFF633F00),
  );

  /// Dark scheme seeded from the brand key color, with secondary/tertiary
  /// nudged to the brand values. Replace with Stitch dark tones when available.
  ///
  /// **secondary 계열은 파생 톤까지 함께 덮는다**(SPEC-0020 R10). `copyWith`로
  /// `secondary` 하나만 바꾸면 `onSecondary`·`secondaryContainer`는 시드(primary)
  /// 기준으로 남아 서브 컬러와 어긋난다 — 어두운 배경에서 밝은 secondary를 쓰므로
  /// `onSecondary`는 흰색이 아니라 어두운 톤이어야 대비가 선다.
  static final ColorScheme _darkScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ).copyWith(
        secondary: const Color(0xFFFFB59B),
        onSecondary: const Color(0xFF5A2100),
        secondaryContainer: const Color(0xFF7A3210),
        onSecondaryContainer: const Color(0xFFFFDBCC),
        tertiary: AppColors.tertiary,
      );
}
