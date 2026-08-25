/// 자동 재시도의 **전역 기본 상한**(SPEC-0032 R17).
///
/// ## 왜 이것이 필요한가
///
/// Riverpod 3의 기본 재시도는 **최대 10회 지수 백오프**다. `retry:`를 지정하지 않은
/// provider는 전부 그 기본값을 쓴다 — 한 번의 조회 실패가 조용히 11번의 왕복이 된다.
///
/// **서버에 WAF도 rate limit도 없다**(사용자, 2026-08-25). 정책이 빠진 provider가
/// 40개쯤 남아 있으면 그것이 곧 의도치 않은 DoS 경로다. 라이브러리 기본값은 우리
/// 정책이 아니다.
///
/// ## 왜 도메인마다 복붙하지 않는가
///
/// 이 저장소는 이미 도메인별로 같은 정책을 여섯 번 복제했고(`spot`·`community`·
/// `dm`·`spot_qa`·`settings`·`alarm`), 그러는 동안 `map`·`national_map`·`event`가
/// 통째로 빠졌다. 하나를 두고 쓰면 빠뜨릴 자리가 없다.
///
/// 도메인 고유의 면제 조건이 있으면(예: spot의 `SpotFailureKind.unauthenticated`)
/// 그 도메인이 자기 판별 함수를 쓰되 **간격과 횟수는 여기서 가져간다**.
library;

import '../location/location_service.dart';

/// 허용하는 자동 재시도 횟수. 최초 시도 + 이 횟수만큼 재시도한다(총 6회).
///
/// **1회는 너무 적다**(사용자 결정, 2026-08-26). 일시적인 네트워크 끊김은 한 번
/// 더 시도해서 안 되면 대개 두세 번째에 붙는데, 1회로 끊으면 사용자가 직접 다시
/// 누르게 된다. 아래 백오프 덕에 5회를 다 써도 서버를 몰아치지 않는다.
const int defaultMaxAutoRetries = 5;

/// 첫 재시도까지 기다리는 시간. 이후 [defaultRetryDelayOf]가 두 배씩 늘린다.
const Duration defaultRetryDelay = Duration(milliseconds: 500);

/// [retryCount]번째 재시도(0부터)까지 기다릴 시간. **두 배씩 늘어난다.**
///
/// ```
/// 0.5s -> 1s -> 2s -> 4s -> 8s   (5회를 다 쓰면 약 15.5초)
/// ```
///
/// ## 왜 고정 간격이 아닌가 — POL-040의 예외다
///
/// POL-040은 "재시도는 시간이 아니라 **횟수로** 제한한다, 시간 기반 백오프 수치는
/// 근거가 없다"고 정한다. 이 정책은 그 취지를 따르되 **간격만** 지수로 둔다 —
/// 멈추는 조건은 여전히 [defaultMaxAutoRetries]라는 횟수이며, 시간은 상한이
/// 아니라 왕복 사이의 간격일 뿐이다.
///
/// 근거는 **서버에 WAF도 rate limit도 없다는 것**(사용자, 2026-08-25)이다.
/// 400ms 고정으로 5회를 돌리면 2초 안에 6번을 두드리고, 화면이 여러 개면 그
/// 파도가 겹친다 — 서버가 잠깐 밀렸을 때 그것을 더 밀어붙이는 모양이 된다.
/// 간격을 벌리면 같은 횟수로도 서버에 회복할 틈을 준다(사용자 결정, 2026-08-26).
///
/// 수치의 근거: 첫 간격은 사용자가 기다림을 느끼기 전에 한 번 더 시도할 수 있는
/// 0.5초, 배수는 이 방식의 통상값인 2다. 상한을 따로 두지 않는 이유는 5회에서
/// 어차피 멈추기 때문이다 — 마지막 간격 8초가 실질 상한이다.
Duration defaultRetryDelayOf(int retryCount) =>
    defaultRetryDelay * (1 << retryCount);

/// 정책이 따로 없는 provider가 쓰는 재시도 정책.
///
/// ```dart
/// @Riverpod(retry: defaultNetworkRetry)
/// ```
///
/// **위치 실패는 재시도하지 않는다.** 권한 거부나 GPS 꺼짐은 다시 물어도 같은
/// 답이 오고, 그 안내는 SPEC-0001 경로가 맡는다.
///
/// **인증 실패는 여기서 거르지 않는다.** 도메인마다 실패 타입이 달라 공통 코드가
/// 알 수 없기 때문이다 — 인증 갈래를 가진 도메인은 자기 정책을 쓰는 편이 정확하다.
Duration? defaultNetworkRetry(int retryCount, Object error) {
  if (error is LocationUnavailable) return null;
  if (retryCount >= defaultMaxAutoRetries) return null;
  return defaultRetryDelayOf(retryCount);
}
