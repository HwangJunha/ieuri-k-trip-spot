import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/localization/locale_controller.dart';
import '../../../common/location/coordinates.dart';
import '../../../common/location/location_providers.dart';
import '../../../common/pagination/offset_page.dart';
import '../../../common/pagination/page.dart';
import '../../../common/storage/search_radius_controller.dart';
import '../model/popular_spot.dart';
import '../model/tourist_spot.dart';
import 'spot_providers.dart';

part 'home_section_providers.g.dart';

/// 홈 섹션이 한 번에 보여주는 개수. 가로 스크롤·짧은 세로 목록이라 한 페이지면
/// 족하고, 홈에서는 페이지를 더 넘기지 않는다(더 보려면 Discover로 간다).
const int homeSectionSize = 10;

/// 홈 "Near you" 섹션(R16). 설정된 반경 안의 spot을 서버가 계산한 거리순으로 준다.
///
/// **Discover와 같은 `spots` 쿼리를 재사용한다**(설계 §3). 홈 전용 조회 경로를
///따로 두면 같은 데이터에 두 규약이 생긴다.
///
/// 좌표와 반경을 `watch`하는 것이 AC-16.2를 만족시키는 지점이다 — 설정에서 반경을
/// 바꾸면 이 provider가 무효화되어 다음 조회에 새 값이 실린다. `read`로 하면 값은
/// 읽히지만 다시 부를 계기가 없어 옛 반경 결과가 그대로 남는다.
///
/// **세 홈 섹션은 각각 독립된 provider다**(R19). 하나로 묶으면 한 섹션의 실패가
/// 화면 전체를 무너뜨려 AC-19.1을 위반한다. 재시도도 이 provider 하나만
/// 무효화하므로 다른 섹션은 건드리지 않는다(AC-20.2).
@riverpod
Future<List<TouristSpot>> nearbySpotsSection(Ref ref) async {
  // 언어를 바꾸면 다시 받는다. 제목·주소는 **서버가 Accept-Language로 번역해** 주는
  // 문장이라, 다시 받지 않으면 영어로 바꿔도 한국어 이름이 그대로 남는다.
  // 홈은 StatefulShellRoute.indexedStack의 브랜치라 설정 화면에 가 있어도 계속
  // mount된 상태다 — autoDispose가 돌지 않으니 이 구독이 유일한 갱신 계기다.
  // **값은 쓰지 않고 재빌드 트리거로만 구독한다**(swipe_providers와 같은 규약).
  ref.watch(localeControllerProvider);

  final Coordinates coords = await ref.watch(currentCoordinatesProvider.future);
  final double radiusKm = ref.watch(searchRadiusControllerProvider);

  final OffsetPage<TouristSpot> page = await ref
      .watch(spotRepositoryProvider)
      .fetchSpotPage(
        latitude: coords.latitude,
        longitude: coords.longitude,
        radiusMeters: radiusMetersOf(radiusKm),
        page: 0,
        size: homeSectionSize,
      );

  // 정렬은 서버가 보장한다(거리 오름차순) — 클라이언트가 다시 정렬하지 않는다.
  return page.items;
}

/// 홈 "Popular" 섹션(R18). 반경 안의 spot을 누적 좋아요 총합 내림차순으로 준다.
///
/// **좋아요 10개 미만은 서버가 이미 걸러 낸다**(AC-18.2) — 표본이 적으면 순위가
/// 사실상 잡음이기 때문이고, 그 판단은 서버 몫이라 클라이언트가 다시 거르지 않는다.
/// 정렬도 계약이므로 재정렬하지 않는다(POL-019).
///
/// 조건을 만족하는 spot이 0건인 것은 정상 상태다(AC-18.4) — 특히 초기 데이터
/// 상황에서는 대부분 비어 있을 것으로 예상된다(설계 §2).
///
/// Near you와 마찬가지로 좌표·반경을 `watch`하고, 이 provider 하나만 무효화하면
/// 이 섹션만 다시 조회된다(R19·R20).
@riverpod
Future<List<PopularSpot>> popularSpotsSection(Ref ref) async {
  // Near you와 같은 이유로 언어도 watch 한다 — 장소 이름이 서버 번역이다.
  ref.watch(localeControllerProvider);

  final Coordinates coords = await ref.watch(currentCoordinatesProvider.future);
  final double radiusKm = ref.watch(searchRadiusControllerProvider);

  final CursorPage<PopularSpot> page = await ref
      .watch(spotRepositoryProvider)
      .fetchPopularSpots(
        latitude: coords.latitude,
        longitude: coords.longitude,
        radiusMeters: radiusMetersOf(radiusKm),
        first: homeSectionSize,
      );

  return page.items;
}
