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
/// 그 도메인이 자기 정책을 계속 쓰면 된다 — 이것은 **정책이 없던 자리**를 위한 것이다.
library;

import '../location/location_service.dart';

/// 허용하는 자동 재시도 횟수. 최초 시도 + 이 횟수만큼 재시도한다.
///
/// 도메인 정책들이 이미 1회로 정해 두었으므로 그에 맞춘다 — 전역만 다르게 두면
/// 같은 실패가 화면에 따라 다른 횟수로 재시도된다.
const int defaultMaxAutoRetries = 1;

/// 자동 재시도 간격.
///
/// **지수 백오프를 쓰지 않는다**(POL-040 — 재시도는 횟수로 제한한다). 기존 도메인
/// 정책이 쓰는 400ms 고정을 따르며, 이 수치를 늘리거나 지수화하지 않는다 — 근거가
/// 없는 수치를 새로 만들지 않기 위해서다.
const Duration defaultRetryDelay = Duration(milliseconds: 400);

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
/// 다만 상한이 1회이므로 걸러지지 않아도 최악이 2회다.
Duration? defaultNetworkRetry(int retryCount, Object error) {
  if (error is LocationUnavailable) return null;
  if (retryCount >= defaultMaxAutoRetries) return null;
  return defaultRetryDelay;
}
