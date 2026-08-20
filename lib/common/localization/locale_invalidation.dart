import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/graphql_client.dart';
import '../../domain/community/provider/feed_providers.dart';
import '../../domain/community/provider/nearby_spots_providers.dart';
import '../../domain/community/provider/post_detail_providers.dart';
import '../../domain/map/provider/map_marker_controller.dart';
import '../../domain/map/provider/map_providers.dart';
// 커뮤니티 장소 선택기에도 같은 이름의 provider가 있어 접두사로 가른다.
import '../../domain/spot/provider/liked_spots_providers.dart' as spot_liked;
import '../../domain/spot/provider/retry_budget_providers.dart';
import '../../domain/spot/provider/spot_detail_providers.dart';
import '../../domain/spot/provider/spot_search_providers.dart';
import '../../domain/spot/provider/swipe_providers.dart';
import '../../domain/spot_qa/provider/my_questions_providers.dart';
import '../../domain/spot_qa/provider/spot_answers_providers.dart';
import '../../domain/spot_qa/provider/spot_questions_providers.dart';

/// 언어가 바뀔 때 **spot id를 들고 있는 상태를 전부 비운다**(SPEC-0029 R-18·R-26).
///
/// **왜 개별 구독으로는 부족한가.** 지금까지는 각 provider가 필요하다고 판단할 때만
/// `localeControllerProvider`를 watch 했고, 안 단 곳에서는 낡은 제목이 잠시 보이는
/// 정도가 대가였다. **언어별 분리 이후에는 id 자체가 해소되지 않는다** — 같은 상태가
/// 조용히 틀린 데이터이거나 `SPOT_NOT_FOUND_IN_LOCALE` 오류 화면이 된다. 선택적
/// 구독으로는 빠진 곳이 계속 생긴다(설계 §2.1).
///
/// **그래서 발화 지점을 하나로 두고 대상을 명시적 목록으로 관리한다**(AC-18.4).
/// 새 provider가 spot id를 들면 이 목록에 추가하는 것이 규율이다 — 개별 provider가
/// 구독을 기억해야 하는 방식보다 누락이 드러나기 쉽다.
///
/// **이미 `localeControllerProvider`를 watch 하는 provider는 넣지 않는다.** 그것들은
/// 언어 변경만으로 스스로 다시 빌드된다. 여기서 또 무효화하면 **그 재빌드 도중에
/// 자기 자신을 무효화하는 꼴**이라 Riverpod이 `CircularDependencyError`를 던진다 —
/// 실제로 그렇게 터졌다. 해당 provider:
/// `nearbySpotsSection`·`popularSpotsSection`·`happeningNowEvents`·
/// `availableSpotCategories`·`likedSpotsController`·`SwipeController`.
///
/// 즉 이 함수가 맡는 것은 **구독하지 않는 나머지**다. 새 provider를 만들 때 둘 중
/// 하나를 고르면 되고, 양쪽에 다 넣으면 안 된다.
///
/// **여기 없는 것과 그 이유:**
/// - 최근 검색어 — 비우지 않고 언어별 키로 **가른다**(R-21). 비우면 돌아왔을 때
///   사용자가 지운 적 없는 이력이 사라진다.
/// - 초안 — 사용자가 쓴 글이라 비우면 안 된다. 복원 시 `spotId`만 재검증한다(AC-26.2).
/// - Q&A 열람 카운트 — 질문 id 기준이라 spot id를 담지 않는다.
/// - DM 메시지 캐시 — `spotQaOrigin`을 애초에 캐시하지 않아 안전하다.
void invalidateLocaleScopedState(Ref ref) {
  // **GraphQL 캐시를 먼저 비운다**(AC-26.5). provider를 무효화해도 캐시가 남아 있으면
  // 재조회가 이전 언어의 정규화된 응답을 그대로 돌려준다 — 같은 쿼리·변수라도 언어가
  // 다르면 다른 항목이어야 하는데, 캐시 키에는 언어가 없다. 순서가 뒤바뀌면 방금
  // 무효화한 provider가 낡은 캐시로 다시 채워진다.
  //
  // **이미 만들어져 있을 때만 만진다.** 그냥 `read`하면 언어 변경이 클라이언트를
  // (그리고 `SecureStorage`를) **생성**시킨다 — 아직 아무 쿼리도 나가지 않은 상태,
  // 예컨대 첫 실행의 언어 선택 화면에서도 그렇다. 없는 캐시에는 비울 것도 없다.
  if (ref.exists(graphqlClientProvider)) {
    ref.read(graphqlClientProvider).cache.store.reset();
  }

  // spot 목록·상세 계열.
  ref.invalidate(spotDetailControllerProvider);
  ref.invalidate(spotCategoryCodesProvider);
  ref.invalidate(spotSearchProvider);

  // 카테고리 선택 — 코드 집합은 언어마다 서버가 노출하는 목록이 다르다(§8). 새
  // 언어에 없는 코드를 그대로 보내면 조회가 빈 결과로 돌아오는데, 사용자에겐
  // 필터가 고장난 것으로 보인다. 비워서 "전체"로 되돌린다.
  ref.invalidate(selectedSpotCategoryProvider);
  ref.invalidate(spotSearchCategoryProvider);
  ref.invalidate(spot_liked.selectedLikedCategoryProvider);

  // 지도 — 누적 마커는 provider 무효화만으로는 안 비워진다. keepAlive라 상태가
  // 그대로 살아남기 때문이다(AC-26.3).
  ref.invalidate(mapViewportProvider);
  ref.read(mapMarkerControllerProvider.notifier).clear();

  // 재시도 예산 — 이전 언어에서 소진한 예산이 새 언어의 첫 조회를 막으면 안 된다
  // (AC-26.4). 언어를 바꾼 것은 사용자의 새 시도이므로 상한도 새로 시작한다.
  ref.invalidate(spotRetryBudgetProvider);

  // 커뮤니티 — spot이 붙은 글이 목록에서 빠지므로 다시 받아야 한다(R-23).
  ref.invalidate(feedControllerProvider);
  ref.invalidate(postDetailProvider);
  ref.invalidate(spotPostsProvider);
  ref.invalidate(nearbySpotsControllerProvider);

  // Q&A — 질문에 붙은 spot이 해소되지 않으면 그 질문 자체가 목록에서 빠진다.
  ref.invalidate(spotQuestionsControllerProvider);
  ref.invalidate(myQuestionsControllerProvider);
  ref.invalidate(spotAnswersControllerProvider);
}
