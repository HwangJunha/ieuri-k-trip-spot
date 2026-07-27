import '../model/tour_event.dart';
import 'event_repository.dart';

/// Mock implementation of [EventRepository] (spec §4). The tourism server has no
/// event API yet, so it returns hardcoded domain models. The async signature is
/// kept so swapping in a GraphQL-backed impl later touches nothing above the
/// repository.
class EventRepositoryImpl implements EventRepository {
  const EventRepositoryImpl();

  @override
  Future<List<TourEvent>> fetchHappeningNowEvents() async => const <TourEvent>[
    TourEvent(
      id: 'evt-myeongdong-food',
      title: 'Myeongdong Food Fest',
      category: EventCategory.festival,
      imageRef: 'myeongdong-food',
    ),
    TourEvent(
      id: 'evt-kpop-busking',
      title: 'K-Pop Dance Busking',
      category: EventCategory.live,
      imageRef: 'kpop-busking',
    ),
    TourEvent(
      id: 'evt-media-art',
      title: 'Media Art Expo',
      category: EventCategory.art,
      imageRef: 'media-art',
    ),
  ];
}
