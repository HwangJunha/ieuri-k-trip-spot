import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/retry_budget.dart';
import '../../auth/provider/session_scope.dart';

part 'retry_budget_providers.g.dart';

/// 조회 시도 횟수를 담는 provider(SPEC-0006 R4). [scope] 문자열 하나로 패밀리를
/// 이루며, 카운터를 세려는 조회 대상마다 고유한 scope를 쓴다(예:
/// `swipe:touristSpot`, `detail:126508`).
///
/// **`keepAlive`인 이유가 이 스펙의 핵심이다.** 폭주의 경로는 컨트롤러의 재빌드이므로,
/// 카운터가 컨트롤러와 같은 생명주기를 가지면 재빌드마다 0으로 돌아가 상한이 의미를
/// 잃는다(설계문서 §2.2). 이 provider는 재빌드·무효화를 넘어 살아남아야 하고, 따라서
/// autoDispose 기본값을 명시적으로 벗어난다.
///
/// 생명주기가 컨테이너와 같다는 것은 곧 카테고리를 바꿔도 이전 scope의 카운터가 남는다는
/// 뜻이다. 그것이 의도한 동작이다 — 카테고리별로 상한이 독립적으로 시작하고(AC-4),
/// 돌아왔을 때 이미 소진했던 카테고리는 소진 상태 그대로다.
@Riverpod(keepAlive: true)
class SpotRetryBudget extends _$SpotRetryBudget {
  @override
  RetryBudget build(String scope) {
    // 로그아웃하면 예산을 되돌린다 — 이전 사용자가 소진한 한도를 새 사용자가
    // 물려받으면 아무것도 못 한다.
    ref.watchSignedIn();
    return const RetryBudget();
  }

  /// [failure] 1회를 계상한다. 인증 실패·권한 거부처럼 계상하지 않는 실패는 호출부가
  /// 걸러낸 뒤 부른다(설계문서 §2.3). 실패 자체를 함께 보관해, 소진 뒤의 재빌드가
  /// 원인을 지어내지 않고 실제 실패를 그대로 돌려줄 수 있게 한다.
  void countFailure(Object failure) => state = state.countFailure(failure);

  /// 카운터를 0으로 되돌린다. 명시적 재시도가 성공했을 때 호출한다(AC-9).
  ///
  /// `invalidateSelf`로 항목 자체를 버린다 — 0으로 초기화한 예산은 기본값과 같으므로
  /// 붙들고 있을 이유가 없고, keepAlive라 명시적으로 버리지 않으면 조회한 관광지마다
  /// 항목이 하나씩 영구히 쌓인다.
  void reset() => ref.invalidateSelf();
}

/// 스와이프 피드의 카운터 scope. 선택별로 갈라 상한이 독립적으로 시작한다(AC-4).
///
/// [feedKey]는 `SwipeFeedKey.scopeKey`다(예: `recommended/LODGING,TOURIST_SPOT`) —
/// 소스(추천/전체)와 정렬된 코드 문자열을 함께 담아, 같은 필터라도 소스가 다르면
/// 예산이 갈린다(SPEC-0035). 정렬하는 이유는 선택 순서가 예산을 가르면 안 되기
/// 때문이다. 코드가 비어 있어도(전체) 소스 접두 덕에 고유 scope다.
String swipeRetryScope(String feedKey) => 'swipe:$feedKey';

/// 상세 조회의 카운터 scope. contentId별로 갈린다 — 다른 관광지 상세는 자기 상한을
/// 새로 시작한다.
String detailRetryScope(String contentId) => 'detail:$contentId';
