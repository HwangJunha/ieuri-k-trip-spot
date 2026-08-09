// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [SpotRepository]. Widgets never construct it (CLAUDE.md §5);
/// section providers read it from here, and tests override this one provider to
/// inject a fake. The swipe feed is GraphQL-backed, so the impl takes the shared
/// client from `common/network`.

@ProviderFor(spotRepository)
const spotRepositoryProvider = SpotRepositoryProvider._();

/// Exposes the [SpotRepository]. Widgets never construct it (CLAUDE.md §5);
/// section providers read it from here, and tests override this one provider to
/// inject a fake. The swipe feed is GraphQL-backed, so the impl takes the shared
/// client from `common/network`.

final class SpotRepositoryProvider
    extends $FunctionalProvider<SpotRepository, SpotRepository, SpotRepository>
    with $Provider<SpotRepository> {
  /// Exposes the [SpotRepository]. Widgets never construct it (CLAUDE.md §5);
  /// section providers read it from here, and tests override this one provider to
  /// inject a fake. The swipe feed is GraphQL-backed, so the impl takes the shared
  /// client from `common/network`.
  const SpotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spotRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spotRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpotRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SpotRepository create(Ref ref) {
    return spotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpotRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpotRepository>(value),
    );
  }
}

String _$spotRepositoryHash() => r'a9401d0c75abe45212cbfe66c2914d54ce5e7083';
