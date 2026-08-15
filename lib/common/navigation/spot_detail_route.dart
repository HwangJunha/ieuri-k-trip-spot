import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// 관광지 상세 라우트 이름.
///
/// **왜 `common/`에 있는가.** 상세로 보내는 곳이 여러 기능에 걸쳐 있다 —
/// Discover·좋아요·검색(`domain/spot`)에 더해 홈의 "Happening Now"
/// (`domain/event`)도 축제를 상세로 연다. 이름을 쓰겠다고 서로의 `view/`를
/// import하면 기능 간 의존이 생기므로 이름만 공용으로 올린다(CLAUDE.md §3·§4).
///
/// 화면 자체는 `domain/spot`이 소유하고 `SpotDetailView.routeName`이 이 상수를
/// 돌려준다 — 진실의 출처는 하나다.
const String spotDetailRouteName = 'spotDetail';

/// 검색 화면 라우트 이름.
///
/// 상세와 같은 이유로 여기 둔다 — 홈과 지도가 각각 검색으로 보내는데, 이름을 쓰겠다고
/// `domain/spot`의 화면을 import하면 기능 간 의존이 생긴다(CLAUDE.md §3·§4).
/// 진실의 출처는 `SearchScreen.routeName`이고 이 상수가 그 값을 복사한다.
const String searchRouteName = 'search';

// `festivalEventCategoryName`은 SPEC-0020에서 제거됐다. 축제를 상세로 열 때
// 카테고리를 실어 보내던 상수였는데, 서버가 상세를 spot 자신의 카테고리로 해석하게
// 되면서 라우트에서 카테고리 인자 자체가 사라졌다 — 넘길 곳이 없으니 상수도 없앤다.
// (값이 필요하면 `domain/spot`의 `kFestivalEventCategoryCode`가 진실의 출처다.)

/// 관광지 상세로 이동한다.
///
/// **인자 규약을 한곳에 모은다.** 호출부가 넷이라 각자 만들면 한 곳만 빠뜨려도 그
/// 진입점에서만 상세가 반쪽으로 열린다.
///
/// **카테고리 인자는 사라졌다**(SPEC-0020). 예전에는 서버의 `intro`/`infoItems`가
/// 필수로 요구해 호출부가 이미 가진 값을 실어 보냈으나, 이제 서버가 spot 자신의
/// 카테고리로 해석한다 — 상세를 여는 데 카테고리를 알 필요가 없다.
///
/// [thumbnailUrl]은 본문 조회를 기다리는 동안 같은 이미지를 그려 깜빡임을 없앤다
/// (SPEC-0006 R8·AC-24). 없어도 오류가 아니다(AC-25).
///
/// [feedCategory]는 **어느 피드에서 열렸는지**다(스와이프 세션의 선택 키). 스와이프
/// 피드에서 열 때만 넘긴다 — 반응 후 소비할 카드 스택이 그쪽에만 있다(SPEC-0007 R11).
///
/// `push`이므로 돌아오면 호출한 화면이 그대로 살아 있다.
void openSpotDetail(
  BuildContext context, {
  required String id,
  String? thumbnailUrl,
  String? feedCategory,
}) {
  context.pushNamed(
    spotDetailRouteName,
    pathParameters: <String, String>{'id': id},
    queryParameters: <String, String>{
      if (thumbnailUrl case final String value) 'thumb': value,
      if (feedCategory case final String value) 'feed': value,
    },
  );
}
