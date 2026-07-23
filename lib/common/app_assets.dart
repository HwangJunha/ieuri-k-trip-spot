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
}
