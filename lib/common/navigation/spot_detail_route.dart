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

/// 축제의 상세 카테고리 인자 값(`SpotCategory.festivalEvent.name`).
///
/// `domain/event`가 축제를 상세로 열 때 쓴다 — 그쪽은 `SpotCategory`를 import할 수
/// 없으므로(기능 간 의존) 문자열이 필요하다. **enum 이름과 어긋나면 라우트가 기본값
/// 으로 폴백해 조용히 다른 카테고리로 열리므로**, 값을 바꾸려면 `SpotCategory`와
/// 함께 봐야 한다 — 그래서 라우트 인자 규약을 아는 이 파일에 둔다.
const String festivalEventCategoryName = 'festivalEvent';

/// 관광지 상세로 이동한다.
///
/// **인자 규약을 한곳에 모은다.** 호출부가 넷이고 규약이 두 가지라, 각자 만들면
/// 한 곳만 빠뜨려도 그 진입점에서만 상세가 반쪽으로 열린다:
///
/// - [category]는 서버의 `intro`/`infoItems`가 **필수로 요구하는 인자**다. 조회 중인
///   응답의 필드를 인자로 쓸 수 없어 호출부가 이미 가진 값을 넘긴다. 없으면(매핑되지
///   않은 서버 enum) 파라미터를 빼고 라우트가 기본값으로 폴백한다.
/// - [thumbnailUrl]은 본문 조회를 기다리는 동안 같은 이미지를 그려 깜빡임을 없앤다
///   (SPEC-0006 R8·AC-24). 없어도 오류가 아니다(AC-25).
///
/// [feedCategory]는 **어느 피드에서 열렸는지**이며 [category]와 다른 값이다. 스와이프
/// 피드에서 열 때만 넘긴다 — 반응 후 소비할 카드 스택이 그쪽에만 있다(SPEC-0007 R11).
///
/// `push`이므로 돌아오면 호출한 화면이 그대로 살아 있다.
void openSpotDetail(
  BuildContext context, {
  required String id,
  String? category,
  String? thumbnailUrl,
  String? feedCategory,
}) {
  context.pushNamed(
    spotDetailRouteName,
    pathParameters: <String, String>{'id': id},
    queryParameters: <String, String>{
      if (category case final String value) 'category': value,
      if (thumbnailUrl case final String value) 'thumb': value,
      if (feedCategory case final String value) 'feed': value,
    },
  );
}
