import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app_assets.dart';
import '../../localization/app_language.dart';
import '../../localization/locale_controller.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../router/app_router.dart';

/// First-run language picker. Selecting a language switches the app locale
/// immediately (so this very screen re-renders in that language); Confirm
/// proceeds to onboarding.
class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AppLanguage current =
        ref.watch(localeControllerProvider.notifier).current;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16),
              SvgPicture.asset(AppAssets.lockupFor(theme.brightness), height: 44),
              const SizedBox(height: 32),
              Text(
                l10n.languageSelectionSubtitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.languageSelectionInstruction,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    for (final AppLanguage language in AppLanguage.values)
                      _LanguageTile(
                        language: language,
                        selected: language == current,
                        onTap: () => ref
                            .read(localeControllerProvider.notifier)
                            .select(language),
                      ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => context.go(Routes.onboarding),
                child: Text(l10n.confirmSelection),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.changeLaterHint,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outlineVariant,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor:
              selected ? scheme.primary : scheme.surfaceContainerHighest,
          foregroundColor: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
          child: Text(
            language.badge,
            style: theme.textTheme.labelMedium,
          ),
        ),
        title: Text(language.nativeName),
        subtitle: Text(language.englishName),
        trailing: Icon(
          selected ? Icons.check_circle : Icons.circle_outlined,
          color: selected ? scheme.primary : scheme.outline,
        ),
      ),
    );
  }
}
