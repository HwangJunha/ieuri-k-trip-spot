import '../../../common/network/auth_error_codes.dart';
import '../../../common/network/network_retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../repository/spot_qa_repository.dart';
import '../repository/spot_qa_repository_impl.dart';

part 'spot_qa_providers.g.dart';

/// 질문/답변 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
@riverpod
SpotQaRepository spotQaRepository(Ref ref) =>
    SpotQaRepositoryImpl(ref.watch(graphqlClientProvider));

/// 공통 상한을 쓰는 재시도 정책(간격·횟수는 `network_retry_policy`가 정한다).
///
/// Riverpod 3 기본값은 **최대 10회**라 그대로 두면 한 번의 실패가 11번의 왕복이
/// 된다. 멈추는 조건은 여전히 횟수다(POL-040) — 간격만 지수로 벌린다.
///
/// 인증 실패는 **아예 재시도하지 않는다** — SPEC-0005의 갱신·로그아웃 경로가
/// 소관이며 여기서 다시 조회해 봐야 같은 실패가 난다.
Duration? spotQaRetryPolicy(int retryCount, Object error) {
  // 인증 실패는 갱신 링크 소관이라 재시도하지 않는다. 판별은 공통
  // [AuthAwareFailure] 하나에만 의존한다 — 도메인마다 따로 적어 두면 서버가
  // 코드를 늘렸을 때 한쪽만 고쳐진다(2026-08-29).
  if (error is AuthAwareFailure && error.isUnauthenticated) return null;
  if (retryCount >= defaultMaxAutoRetries) return null;
  return defaultRetryDelayOf(retryCount);
}
