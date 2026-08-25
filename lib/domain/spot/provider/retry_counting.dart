import '../../../common/location/location_service.dart';
import '../model/retry_budget.dart';
import '../model/spot_failure.dart';

/// 이 실패를 재시도 상한에 계상할지 판별한다(SPEC-0006 §2.3의 표).
///
/// 계상하는 것: 네트워크 오류·타임아웃, 서버 오류(`errors[]` 루트), 그 밖의 일반 실패.
///
/// 계상하지 **않는** 것 — 재시도로 해결되지 않거나 다른 경로가 소관인 실패다:
/// - 인증 실패([SpotFailureKind.unauthenticated]) — SPEC-0005 토큰 갱신 경로 소관
///   (R5·AC-14·AC-15). 판별은 repository가 기존 `UNAUTHENTICATED` 코드 경로로 번역한
///   결과를 그대로 쓴다(새 판별 로직을 만들지 않는다).
/// - 위치 권한 거부·서비스 꺼짐([LocationUnavailable]) — 재시도로 풀리지 않는 상태이며
///   SPEC-0001 안내 경로 소관이다.
bool countsTowardRetryBudget(Object error) => switch (error) {
  SpotFailure(kind: SpotFailureKind.unauthenticated) => false,
  LocationUnavailable() => false,
  _ => true,
};

/// 자동 재시도 1회 뒤 멈추는 Riverpod `retry` 정책(SPEC-0006 R1·R2).
///
/// **폭주의 실제 경로가 여기다.** Riverpod 3의 기본 정책은 실패한 provider를 지수
/// 백오프로 **최대 10회** 자동 재조회한다. 상한을 컨트롤러 안에서 사후에 막는 대신
/// 이 함수로 재시도 자체를 끊는 편이 정확하다 — 세지 않은 조회가 아예 발생하지 않는다.
///
/// [retryCount]는 이미 수행한 자동 재시도 횟수다(0 = 최초 실패 직후). 1회만 허용하므로
/// 최초 시도 + 자동 재시도 1회 = 총 2회에서 멈춘다(AC-1·AC-2).
///
/// 계상하지 않는 실패에는 `null`을 돌려 **자동 재시도를 하지 않는다.** 인증 실패는
/// SPEC-0005의 갱신 경로가, 위치 실패는 SPEC-0001의 안내 경로가 처리할 문제이며,
/// 여기서 다시 조회해 봐야 같은 실패가 날 뿐이다(R5·AC-14).
/// **이제 SwipeController와 상세만 쓴다**(2026-08-26). 홈 섹션·좋아요·검색은
/// 공통 정책(`common/network/network_retry_policy.dart`, 5회)으로 옮겼다 — 같은
/// 홈 화면 안에서 spot 섹션은 2회, 이벤트 섹션은 5회로 갈려 오류 화면이 뜨는
/// 시점이 3배 차이 났다(실기기 지적). SPEC-0006 AC-1·AC-2가 총 2회로 못박은
/// 대상은 `SwipeController`이지 그 화면들이 아니다.
Duration? spotRetryPolicy(int retryCount, Object error) {
  if (!countsTowardRetryBudget(error)) return null;
  if (retryCount >= maxAutoRetries) return null;
  return retryDelay;
}

/// 허용하는 자동 재시도 횟수. **여기만 1회로 남는다**(2026-08-26).
///
/// 다른 도메인은 공통 정책(`common/network/network_retry_policy.dart`)을 따라
/// 5회 지수 백오프로 올렸지만, spot은 **SPEC-0006 AC-2가 "최초 1회 + 자동
/// 재시도 1회 = 총 2회"를 수용 기준으로 못박은 영역**이다. 여기를 바꾸면 그
/// 스펙의 기준을 깨는 것이므로 값을 올리려면 SPEC-0006부터 고쳐야 한다.
///
/// [RetryBudget.defaultMaxAttempts]에서 파생한다 —
/// 상한은 "최초 시도 + 자동 재시도"이므로 자동 재시도 허용 횟수는 그보다 1 적다.
/// 두 값을 따로 적으면 한쪽만 고쳤을 때 예산과 재시도 정책이 조용히 어긋난다.
const int maxAutoRetries = RetryBudget.defaultMaxAttempts - 1;

/// 자동 재시도 간격. 수용 기준에 수치가 없어 구현 재량이다.
///
/// 테스트는 [debugRetryDelay]로 이 값을 0에 가깝게 줄인다 — 재시도 **횟수**가 검증
/// 대상이지 간격이 아니라서, 실제로 400ms씩 재우면 테스트가 검증하는 것 없이 느려지기만
/// 한다.
Duration get retryDelay => debugRetryDelay ?? const Duration(milliseconds: 400);

/// 테스트 전용 재시도 간격 오버라이드. 프로덕션에서는 항상 null이다.
Duration? debugRetryDelay;
