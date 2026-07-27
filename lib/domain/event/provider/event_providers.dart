import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/tour_event.dart';
import '../repository/event_repository.dart';
import '../repository/event_repository_impl.dart';

part 'event_providers.g.dart';

/// Exposes the [EventRepository]. Widgets never construct it (CLAUDE.md §5); the
/// section provider reads it from here, and tests override this one provider to
/// inject a fake. Swapping the mock impl for a GraphQL one changes only this
/// line.
@riverpod
EventRepository eventRepository(Ref ref) => const EventRepositoryImpl();

/// "Happening Now" events as an `AsyncValue` for the UI boundary.
@riverpod
Future<List<TourEvent>> happeningNowEvents(Ref ref) =>
    ref.watch(eventRepositoryProvider).fetchHappeningNowEvents();
