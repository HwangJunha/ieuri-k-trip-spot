import '../../../common/network/network_retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../../../common/network/graphql_socket_client.dart';
import '../model/dm_failure.dart';
import '../repository/dm_repository.dart';
import '../repository/dm_repository_impl.dart';

part 'dm_providers.g.dart';

/// DM repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// **클라이언트를 둘 받는다.** 쿼리·뮤테이션은 HTTP, 구독만 WebSocket이다
/// (SPEC-0017 — 이 앱 최초의 Subscription).
@riverpod
DmRepository dmRepository(Ref ref) => DmRepositoryImpl(
  ref.watch(graphqlClientProvider),
  socketClient: ref.watch(graphqlSocketClientProvider),
);

/// 공통 상한을 쓰는 재시도 정책(간격·횟수는 `network_retry_policy`가 정한다).
///
/// Riverpod 3 기본값은 **최대 10회**라 그대로 두면 한 번의 실패가 11번의 왕복이
/// 된다. 멈추는 조건은 여전히 횟수다(POL-040) — 간격만 지수로 벌린다.
Duration? dmRetryPolicy(int retryCount, Object error) {
  // **권한·인증 실패는 아예 재시도하지 않는다** — `FORBIDDEN`은 재시도로 풀리지
  // 않고 상한까지 헛돌기만 한다. 인증은 SPEC-0005의 갱신 경로가 소관이다.
  if (error is DmFailure && error.permanent) return null;
  if (retryCount >= defaultMaxAutoRetries) return null;
  return defaultRetryDelayOf(retryCount);
}
