import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_language.dart';

part 'app_preferences.g.dart';

/// The [SharedPreferences] instance, loaded once in `main()` and injected via
/// an override on this provider.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
  'sharedPreferencesProvider must be overridden in main()',
);

@Riverpod(keepAlive: true)
AppPreferences appPreferences(Ref ref) =>
    AppPreferences(ref.watch(sharedPreferencesProvider));

/// Thin wrapper over [SharedPreferences] for non-sensitive app preferences —
/// the chosen locale and the search radius. Per-account onboarding state moved
/// to the secure wrapper (spec §4.3), so nothing sensitive is stored here.
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const String _localeKey = 'locale';
  static const String _searchRadiusKey = 'search_radius_km';

  /// 반경 설정의 경계와 기본값(SPEC-0011 R13).
  ///
  /// **최소 1km다**(사용자 지적 2026-09-19). 예전에는 0을 "현재 위치만"으로 두었으나,
  /// 슬라이더에서 0km가 고를 수 있는 값으로 보이는 것 자체가 잘못이었다 — 반경 0인
  /// 검색은 뜻이 서지 않고, 실제로는 `radiusMetersOf`가 null로 바꿔 서버 기본값
  /// (20km)으로 조회되고 있었다. 고른 값과 실제 동작이 달랐다.
  static const double minSearchRadiusKm = 1;
  static const double maxSearchRadiusKm = 100;
  static const double defaultSearchRadiusKm = 20;

  AppLanguage? get savedLanguage =>
      AppLanguage.fromCode(_prefs.getString(_localeKey));

  Future<void> saveLanguage(AppLanguage language) =>
      _prefs.setString(_localeKey, language.code);

  /// 저장된 검색 반경(km). 저장된 적이 없으면 기본 20km다.
  ///
  /// 범위를 벗어난 값은 경계로 잘라 낸다 — 이전 버전이 다른 범위로 저장했거나
  /// 저장소가 손상된 경우에도 슬라이더가 `value out of range`로 죽지 않게 한다.
  double get searchRadiusKm {
    final double? saved = _prefs.getDouble(_searchRadiusKey);
    if (saved == null) return defaultSearchRadiusKm;
    return saved.clamp(minSearchRadiusKm, maxSearchRadiusKm);
  }

  Future<void> saveSearchRadiusKm(double km) => _prefs.setDouble(
    _searchRadiusKey,
    km.clamp(minSearchRadiusKm, maxSearchRadiusKm),
  );

  /// 반경을 표시 문자열로 만든다. 정수면 소수점을 떼서 "20"으로 보이게 한다 —
  /// 슬라이더가 연속값이라 그대로 두면 "20.0"이 된다.
  ///
  /// 서식이 범위 상수 옆에 있어야 [maxSearchRadiusKm]가 바뀔 때 표시 규칙을 같이
  /// 보게 된다.
  static String formatKm(double km) =>
      km == km.roundToDouble() ? km.toInt().toString() : km.toStringAsFixed(1);
}
