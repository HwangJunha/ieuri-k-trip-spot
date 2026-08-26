import 'package:flutter/widgets.dart';

/// Static paths to bundled logo/icon assets (see `asset/icon/`).
class AppAssets {
  const AppAssets._();

  static const String _icon = 'asset/icon';

  static const String appIcon = '$_icon/app-icon.svg';

  /// Large white card + coral logo — the prominent splash icon (big size).
  static const String appIconSplash = '$_icon/app-icon-splash.svg';
  static const String markCoral = '$_icon/mark-coral.svg';
  static const String markWhite = '$_icon/mark-white.svg';
  static const String lockupLight = '$_icon/lockup-light.svg';
  static const String lockupDark = '$_icon/lockup-dark.svg';

  /// Brand mark tinted for the given [brightness]: coral on light surfaces,
  /// white on dark surfaces.
  static String markFor(Brightness brightness) =>
      brightness == Brightness.dark ? markWhite : markCoral;

  /// Wordmark lockup for the given [brightness]. `lockup-light` is the
  /// light-theme variant; `lockup-dark` is the dark-theme variant.
  static String lockupFor(Brightness brightness) =>
      brightness == Brightness.dark ? lockupDark : lockupLight;

  static const String _onboarding = 'asset/onboarding';

  /// 온보딩 다섯 장의 일러스트. **하단 탭과 같은 순서다**(2026-08-25).
  ///
  /// 한 세트로 보여야 하므로 다섯이 같은 결(플랫 벡터·얇은 외곽선·따뜻한 배경)로
  /// 그려져 있다 — 한 장만 다른 스타일로 갈아 끼우면 그 장이 튄다.
  static const List<String> onboarding = <String>[
    '$_onboarding/home.png',
    '$_onboarding/national_map.png',
    '$_onboarding/discover.png',
    '$_onboarding/activity.png',
    '$_onboarding/map.png',
  ];
}
