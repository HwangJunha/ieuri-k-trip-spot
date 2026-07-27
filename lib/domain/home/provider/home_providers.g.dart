// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [HomeRepository]. Widgets never construct it (CLAUDE.md §5);
/// section providers read it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.

@ProviderFor(homeRepository)
const homeRepositoryProvider = HomeRepositoryProvider._();

/// Exposes the [HomeRepository]. Widgets never construct it (CLAUDE.md §5);
/// section providers read it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  /// Exposes the [HomeRepository]. Widgets never construct it (CLAUDE.md §5);
  /// section providers read it from here, and tests override this one provider to
  /// inject a fake. Swapping the mock impl for a GraphQL one changes only this
  /// line.
  const HomeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRepository create(Ref ref) {
    return homeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRepository>(value),
    );
  }
}

String _$homeRepositoryHash() => r'd263180d9ae864f66ce987bd9ecedbfa79a3cda1';

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

String _$recommendedSpotsHash() => r'e0b4fa6dea15d762c19c6818424591caf682748c';

/// "Happening Now" events as an `AsyncValue` for the UI boundary.

@ProviderFor(happeningNowEvents)
const happeningNowEventsProvider = HappeningNowEventsProvider._();

/// "Happening Now" events as an `AsyncValue` for the UI boundary.

final class HappeningNowEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TourEvent>>,
          List<TourEvent>,
          FutureOr<List<TourEvent>>
        >
    with $FutureModifier<List<TourEvent>>, $FutureProvider<List<TourEvent>> {
  /// "Happening Now" events as an `AsyncValue` for the UI boundary.
  const HappeningNowEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'happeningNowEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$happeningNowEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<TourEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TourEvent>> create(Ref ref) {
    return happeningNowEvents(ref);
  }
}

String _$happeningNowEventsHash() =>
    r'8fc286380e09748b34c0987b651dc039859a50bd';

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

String _$popularSpotsHash() => r'a4096cd5496a357c75b11abe72ffa6703ae3d3e9';
