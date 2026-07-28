// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Exposes the [EventRepository]. Widgets never construct it (CLAUDE.md §5); the
/// section provider reads it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.

@ProviderFor(eventRepository)
const eventRepositoryProvider = EventRepositoryProvider._();

/// Exposes the [EventRepository]. Widgets never construct it (CLAUDE.md §5); the
/// section provider reads it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.

final class EventRepositoryProvider
    extends
        $FunctionalProvider<EventRepository, EventRepository, EventRepository>
    with $Provider<EventRepository> {
  /// Exposes the [EventRepository]. Widgets never construct it (CLAUDE.md §5); the
  /// section provider reads it from here, and tests override this one provider to
  /// inject a fake. Swapping the mock impl for a GraphQL one changes only this
  /// line.
  const EventRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventRepositoryHash();

  @$internal
  @override
  $ProviderElement<EventRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventRepository create(Ref ref) {
    return eventRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventRepository>(value),
    );
  }
}

String _$eventRepositoryHash() => r'70b207c304539f9fc385e11308e3a069711f863c';

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
    r'368f41f0608c74c245e8721a0ceb1def30c98937';
