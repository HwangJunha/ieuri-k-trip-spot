import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/spot_category.dart';
import '../provider/spot_category_toggle.dart';
import '../provider/swipe_providers.dart';

/// 화면이 진입할 때 카테고리 선택의 기본값을 심는다(SPEC-0020 R4).
///
/// **세 화면이 같은 일을 한다**(Discover·좋아요·검색). R12가 선택 provider를 화면별로
/// 나누라고 하므로 provider는 셋이지만, "목록이 오면 기본값을 심는다"는 규칙은 하나라
/// 여기 한 번만 적는다.
///
/// **`ref.listen`인 이유.** 가용 목록은 서버에서 비동기로 오는데, `build` 안에서
/// provider 상태를 바꾸면 Riverpod이 막는다. 목록이 도착하는 순간에 한 번 심어야
/// 하므로 값 변화를 구독한다.
///
/// **이미 로드된 뒤에 화면이 열리는 경우**(탭 전환·재진입)는 `listen`이 발화하지
/// 않으므로 현재 값을 한 번 읽어 함께 처리한다. 심는 쪽이 멱등하므로 두 경로가
/// 겹쳐도 문제가 없다.
///
/// [SpotCategoryToggle.seedDefault]가 "이미 고른 것이 있으면 아무 일도 하지 않는다"를
/// 보장하므로, 언어 전환으로 목록이 다시 와도 사용자의 선택을 덮지 않는다.
/// [readNotifier]로 선택 provider의 notifier를 받는다. provider 참조가 아니라 콜백인
/// 이유는 riverpod_generator가 만드는 `.notifier` 접근자의 타입이 생성 코드의 내부
/// 사정이라(버전마다 이름이 바뀐다) 여기에 못 박으면 codegen 업그레이드가 이 파일을
/// 깨기 때문이다 — 호출부가 `() => ref.read(xProvider.notifier)`를 넘긴다.
void seedSpotCategoryDefault(
  WidgetRef ref,
  SpotCategoryToggle Function() readNotifier,
) {
  void seed(AsyncValue<List<SpotCategory>> value) {
    final List<SpotCategory>? available = value.value;
    if (available == null) return;
    readNotifier().seedDefault(available);
  }

  ref.listen<AsyncValue<List<SpotCategory>>>(
    availableSpotCategoriesProvider,
    (_, AsyncValue<List<SpotCategory>> next) => seed(next),
  );
  seed(ref.read(availableSpotCategoriesProvider));
}
