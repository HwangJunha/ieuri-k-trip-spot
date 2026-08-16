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

/// 자동 재시도 1회 뒤 멈추는 재시도 정책(커뮤니티·spot과 같은 이유).
///
/// Riverpod 3 기본값은 실패한 provider를 지수 백오프로 **최대 10회** 재조회한다.
/// 재시도로 풀리지 않는 실패에서는 그 폭주가 그대로 낭비이고, 사용자에게는 오류
/// 화면이 뜨기까지의 지연으로만 보인다(POL-040 — 재시도는 횟수로 제한한다).
Duration? dmRetryPolicy(int retryCount, Object error) {
  // **권한·인증 실패는 아예 재시도하지 않는다** — `FORBIDDEN`은 재시도로 풀리지
  // 않고 상한까지 헛돌기만 한다. 인증은 SPEC-0005의 갱신 경로가 소관이다.
  if (error is DmFailure && error.permanent) return null;
  if (retryCount >= 1) return null;
  return const Duration(milliseconds: 400);
}
