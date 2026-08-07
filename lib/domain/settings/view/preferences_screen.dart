import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/localization/app_language.dart';
import '../../../common/localization/locale_controller.dart';
import '../../../common/storage/app_preferences.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/settings_tile.dart';
import '../provider/search_radius_controller.dart';

/// 검색 반경과 언어 설정(SPEC-0011 R13·R14).
///
/// 둘 다 **로컬 설정이다** — 서버를 부르지 않는다. 언어는 이미 [LocaleController]가
/// 저장과 `Accept-Language` 전송을 하고 있어 여기서는 선택 UI만 붙인다(설계 §6).
class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  static String get routeName => 'settings-preferences';

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  /// 드래그 중인 값. 슬라이더를 놓을 때까지 저장하지 않는다 — 매 프레임 저장하면
  /// SharedPreferences 쓰기가 드래그 한 번에 수십 번 일어난다.
  double? _dragging;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final double saved = ref.watch(searchRadiusControllerProvider);
    final double radius = _dragging ?? saved;
    final AppLanguage current = ref.watch(
      localeControllerProvider.select(
        (Locale l) =>
            AppLanguage.fromCode(l.languageCode) ?? AppLanguage.english,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.preferencesTitle)),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            SettingsSectionHeader(l10n.preferencesRadiusSection),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      l10n.preferencesRadiusValue(
                        AppPreferences.formatKm(radius),
                      ),
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  Slider(
                    value: radius,
                    min: AppPreferences.minSearchRadiusKm,
                    max: AppPreferences.maxSearchRadiusKm,
                    onChanged: (double v) => setState(() => _dragging = v),
                    onChangeEnd: (double v) {
                      ref
                          .read(searchRadiusControllerProvider.notifier)
                          .select(v);
                      setState(() => _dragging = null);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        l10n.preferencesRadiusValue(
                          AppPreferences.formatKm(
                            AppPreferences.minSearchRadiusKm,
                          ),
                        ),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        l10n.preferencesRadiusValue(
                          AppPreferences.formatKm(
                            AppPreferences.maxSearchRadiusKm,
                          ),
                        ),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 0km가 유효값이라는 것을 화면에 드러낸다(R13 네 번째 기준) —
                  // 슬라이더만 보면 0이 "설정 안 함"으로 읽힌다.
                  Text(
                    l10n.preferencesRadiusHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            SettingsSectionHeader(l10n.preferencesLanguageSection),
            for (final AppLanguage language in AppLanguage.values)
              ListTile(
                title: Text(language.nativeName),
                trailing: language == current
                    ? Icon(Icons.check, color: theme.colorScheme.primary)
                    : null,
                onTap: () => ref
                    .read(localeControllerProvider.notifier)
                    .select(language),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
