import 'package:flutter/material.dart';

/// Light [ThemeData] for the app.
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

  /// CJK 폴백. 라틴 폰트에 없는 글리프를 이 순서로 찾는다.
  ///
  /// **중국어는 TC(번체)다**(사용자 지적 2026-08-26). 앱이 스스로 번체라 표시하고
  /// 서버에도 `TW`를 보내는데(`app_language.dart`) 폰트만 SC(간체)였다.
  /// TC 폰트에는 간체 글리프가 없으므로 문자열도 번체로 통일해야 한다.
  static const List<String> _fontFamilyFallback = <String>[
    'NotoSansKR',
    'NotoSansJP',
    'NotoSansTC',
  ];

  static final ThemeData light = _build(_lightScheme);

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
    // secondary 계열은 primary(브랜드 레드)와 같은 톤으로 통일한다 — 주황 계열
    // 서브 컬러를 화면마다 섞어 쓰면 브랜드색이 흐려진다. 역할은 남겨 두되
    // 값만 primary와 맞춰, 개별 위젯이 secondary를 참조해도 레드로 그려진다.
    secondary: Color(0xFFB2211D),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDAD5),
    onSecondaryContainer: Color(0xFF93020A),
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
    secondaryFixed: Color(0xFFFFDAD5),
    secondaryFixedDim: Color(0xFFFFB4AA),
    onSecondaryFixed: Color(0xFF410002),
    onSecondaryFixedVariant: Color(0xFF93020A),
    tertiaryFixed: Color(0xFFFFDDB4),
    tertiaryFixedDim: Color(0xFFFFB955),
    onTertiaryFixed: Color(0xFF291800),
    onTertiaryFixedVariant: Color(0xFF633F00),
  );
}
