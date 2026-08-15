import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/locale_controller.dart';
import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/network/graphql_client.dart';
import '../../../common/pagination/page.dart';
import '../../../common/storage/search_radius_controller.dart';
import '../model/festival.dart';
import '../repository/event_repository.dart';
import '../repository/event_repository_impl.dart';

part 'event_providers.g.dart';

/// 홈 섹션이 한 번에 보여주는 축제 수. 홈에서는 페이지를 더 넘기지 않는다.
const int happeningNowSize = 10;

/// Exposes the [EventRepository]. Widgets never construct it (CLAUDE.md §5); the
/// section provider reads it from here, and tests override this one provider to
/// inject a fake.
@riverpod
EventRepository eventRepository(Ref ref) =>
    EventRepositoryImpl(ref.watch(graphqlClientProvider));

/// 홈 "Happening Now" 섹션(R17). 반경 안에서 오늘 진행 중인 축제만 온다.
///
/// 좌표와 반경을 `watch`하는 것은 Near you와 같은 이유다 — 설정에서 반경을 바꾸면
/// 다음 조회에 반영되어야 한다(AC-16.2와 같은 성질).
///
/// **홈의 세 섹션은 각각 독립된 provider다**(R19). 이 provider의 실패나 빈 결과가
/// 다른 섹션에 번지지 않고, 재시도도 이것 하나만 무효화한다(AC-20.2).
@riverpod
Future<List<Festival>> happeningNowEvents(Ref ref) async {
  // 축제 이름도 서버 번역이라 언어를 바꾸면 다시 받아야 한다(Near you와 같은 이유).
  ref.watch(localeControllerProvider);

  final Coordinates coords = await ref.watch(currentCoordinatesProvider.future);
  final double radiusKm = ref.watch(searchRadiusControllerProvider);

  final CursorPage<Festival> page = await ref
      .watch(eventRepositoryProvider)
      .fetchOngoingFestivals(
        latitude: coords.latitude,
        longitude: coords.longitude,
        radiusMeters: radiusMetersOf(radiusKm),
        first: happeningNowSize,
      );

  return page.items;
}
