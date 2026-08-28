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
import 'auth_error_codes.dart';

/// 허용하는 자동 재시도 횟수. 최초 시도 + 이 횟수만큼 재시도한다(총 6회).
///
/// **1회는 너무 적다**(사용자 결정, 2026-08-26). 일시적인 네트워크 끊김은 한 번
/// 더 시도해서 안 되면 대개 두세 번째에 붙는데, 1회로 끊으면 사용자가 직접 다시
/// 누르게 된다. 아래 백오프 덕에 5회를 다 써도 서버를 몰아치지 않는다.
const int defaultMaxAutoRetries = 5;

/// 첫 재시도까지 기다리는 시간. 이후 [defaultRetryDelayOf]가 두 배씩 늘린다.
const Duration defaultRetryDelay = Duration(milliseconds: 500);

/// 간격의 상한. 이 값에 닿으면 더 늘리지 않는다.
///
/// **상한이 없으면 마지막 간격이 8초가 되어 총 15.5초가 걸린다**(2026-08-26).
/// 그동안 화면은 로딩만 보여주므로 사용자는 "멈춘 것"으로 겪는다 — 실기기에서
/// 그 지적이 나왔다. 3초로 자르면 같은 5회를 약 9.5초에 끝낸다.
const Duration maxRetryDelay = Duration(seconds: 3);

/// [retryCount]번째 재시도(0부터)까지 기다릴 시간. **두 배씩 늘어나되 잘린다.**
///
/// ```
/// 0.5s -> 1s -> 2s -> 3s -> 3s   (5회를 다 쓰면 약 9.5초)
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
/// 0.5초, 배수는 이 방식의 통상값인 2, 상한은 [maxRetryDelay]다.
Duration defaultRetryDelayOf(int retryCount) {
  final Duration delay = defaultRetryDelay * (1 << retryCount);
  return delay > maxRetryDelay ? maxRetryDelay : delay;
}

/// 정책이 따로 없는 provider가 쓰는 재시도 정책.
///
/// ```dart
/// @Riverpod(retry: defaultNetworkRetry)
/// ```
///
/// **위치 실패는 재시도하지 않는다.** 권한 거부나 GPS 꺼짐은 다시 물어도 같은
/// 답이 오고, 그 안내는 SPEC-0001 경로가 맡는다.
///
/// **인증 실패도 재시도하지 않는다**(2026-08-29). 예전에는 "도메인마다 실패 타입이
/// 달라 공통 코드가 알 수 없다"며 걸러 내지 않았는데, 그 결과 이 정책을 쓰는 7개
/// 도메인 37곳이 전부 인증 실패에 재시도를 반복했다 — 액세스 토큰이 거부된 상태에서
/// 홈 화면의 세 쿼리가 **0.5초 간격으로 끝없이** 서버를 두드렸다(실기기).
///
/// 상한(5회)이 있는데도 무한이 된 이유는 두 가지가 겹쳐서다.
///
/// 1. **재시도해도 회복되지 않는다.** 같은 토큰으로 같은 요청을 보내니 결과가 같다.
///    회복은 갱신 링크(`graphql_client.dart`)가 하는 일이지 재시도가 할 일이 아니다.
/// 2. **상한이 리셋된다.** 홈 섹션은 `currentCoordinatesProvider`를 watch하는데,
///    Riverpod은 의존성이 바뀌면 재시도 카운터를 0으로 되돌린다
///    (`element.dart`의 `if (_didChangeDependency) _retryCount = 0`). 위치가 갱신될
///    때마다 5회가 새로 시작되니 사실상 상한이 없다.
///
/// 판별은 [AuthAwareFailure] 하나에만 의존한다 — 도메인 타입을 알 필요가 없고,
/// 새 도메인이 그 인터페이스만 구현하면 저절로 포함된다.
Duration? defaultNetworkRetry(int retryCount, Object error) {
  if (error is LocationUnavailable) return null;
  if (error is AuthAwareFailure && error.isUnauthenticated) return null;
  if (retryCount >= defaultMaxAutoRetries) return null;
  return defaultRetryDelayOf(retryCount);
}

/// **재시도하지 않는다.** 파생(derived) provider가 쓴다.
///
/// ## 왜 파생 provider는 재시도하면 안 되는가
///
/// `cellGeometries`처럼 다른 provider를 `await ref.watch(X.future)` 하기만 하는
/// provider는 **자기가 서버를 부르지 않는다.** 그런데 상위 X가 실패하면 그 오류가
/// 그대로 전파되고, 여기에 재시도 정책이 있으면(없으면 Riverpod 기본 10회다)
/// 이미 6회를 쓰고 실패한 X를 다시 깨운다 — **왕복이 더해지는 게 아니라 곱해진다.**
///
/// 게다가 `element.dart:651`의 `if (_didChangeDependency) _retryCount = 0`
/// 때문에 상위가 상태를 바꿀 때마다 하위 카운터가 리셋되어, 실제 횟수는 예측조차
/// 어렵다. 전국 지도에서 화면에 오류가 떠 있는 동안에도 뒤에서 요청이 계속 나가던
/// 것이 이 경로였다(2026-08-26).
///
/// **재시도는 실제로 I/O를 하는 계층 한 곳에서만 한다.** 파생 계층은 상위가 낸
/// 결론을 그대로 전달한다.
Duration? neverRetry(int retryCount, Object error) => null;
