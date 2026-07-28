// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [SpotRepository]. Widgets never construct it (CLAUDE.md §5);
/// section providers read it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.

@ProviderFor(spotRepository)
const spotRepositoryProvider = SpotRepositoryProvider._();

/// Exposes the [SpotRepository]. Widgets never construct it (CLAUDE.md §5);
/// section providers read it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.

final class SpotRepositoryProvider
    extends $FunctionalProvider<SpotRepository, SpotRepository, SpotRepository>
    with $Provider<SpotRepository> {
  /// Exposes the [SpotRepository]. Widgets never construct it (CLAUDE.md §5);
  /// section providers read it from here, and tests override this one provider to
  /// inject a fake. Swapping the mock impl for a GraphQL one changes only this
  /// line.
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

String _$spotRepositoryHash() => r'9508c1c2e29c0c2ae2a6460de0652572155d7ce7';

/// "Recommended for You" spots as an `AsyncValue` for the UI boundary.

@ProviderFor(recommendedSpots)
const recommendedSpotsProvider = RecommendedSpotsProvider._();

/// "Recommended for You" spots as an `AsyncValue` for the UI boundary.

final class RecommendedSpotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TouristSpot>>,
          List<TouristSpot>,
          FutureOr<List<TouristSpot>>
        >
    with
        $FutureModifier<List<TouristSpot>>,
        $FutureProvider<List<TouristSpot>> {
  /// "Recommended for You" spots as an `AsyncValue` for the UI boundary.
  const RecommendedSpotsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recommendedSpotsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recommendedSpotsHash();

  @$internal
  @override
  $FutureProviderElement<List<TouristSpot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TouristSpot>> create(Ref ref) {
    return recommendedSpots(ref);
  }
}

String _$recommendedSpotsHash() => r'cc7f4b929147d0728c11d4ad5e012520b4c21feb';

/// "Popular Spots" as an `AsyncValue` for the UI boundary.

@ProviderFor(popularSpots)
const popularSpotsProvider = PopularSpotsProvider._();

/// "Popular Spots" as an `AsyncValue` for the UI boundary.

final class PopularSpotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TouristSpot>>,
          List<TouristSpot>,
          FutureOr<List<TouristSpot>>
        >
    with
        $FutureModifier<List<TouristSpot>>,
        $FutureProvider<List<TouristSpot>> {
  /// "Popular Spots" as an `AsyncValue` for the UI boundary.
  const PopularSpotsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularSpotsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularSpotsHash();

  @$internal
  @override
  $FutureProviderElement<List<TouristSpot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TouristSpot>> create(Ref ref) {
    return popularSpots(ref);
  }
}

String _$popularSpotsHash() => r'067de133d98016aaf374dd4ca82c8d35c0333fa7';
