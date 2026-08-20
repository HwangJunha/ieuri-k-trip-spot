// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the active [Locale] for the whole app. Initialised from the saved
/// choice, or the device locale matched to a supported language (English
/// otherwise). Changing it re-renders every screen in the new language.

@ProviderFor(LocaleController)
const localeControllerProvider = LocaleControllerProvider._();

/// Holds the active [Locale] for the whole app. Initialised from the saved
/// choice, or the device locale matched to a supported language (English
/// otherwise). Changing it re-renders every screen in the new language.
final class LocaleControllerProvider
    extends $NotifierProvider<LocaleController, Locale> {
  /// Holds the active [Locale] for the whole app. Initialised from the saved
  /// choice, or the device locale matched to a supported language (English
  /// otherwise). Changing it re-renders every screen in the new language.
  const LocaleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeControllerHash();

  @$internal
  @override
  LocaleController create() => LocaleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$localeControllerHash() => r'78d7bd7fb385fb1e80b808d48c4442eb64350784';

/// Holds the active [Locale] for the whole app. Initialised from the saved
/// choice, or the device locale matched to a supported language (English
/// otherwise). Changing it re-renders every screen in the new language.

abstract class _$LocaleController extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
