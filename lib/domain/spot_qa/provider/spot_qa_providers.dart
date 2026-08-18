import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../model/spot_qa_failure.dart';
import '../repository/spot_qa_repository.dart';
import '../repository/spot_qa_repository_impl.dart';

part 'spot_qa_providers.g.dart';

/// 질문/답변 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
@riverpod
SpotQaRepository spotQaRepository(Ref ref) =>
    SpotQaRepositoryImpl(ref.watch(graphqlClientProvider));

/// 자동 재시도 1회 뒤 멈추는 재시도 정책(community·spot과 같은 이유).
///
/// Riverpod 3 기본값은 실패한 provider를 지수 백오프로 **최대 10회** 재조회한다.
/// 재시도로 풀리지 않는 실패에서는 그 폭주가 그대로 낭비이고, 사용자에게는 오류
/// 화면이 뜨기까지의 지연으로만 보인다.
///
/// 인증 실패는 **아예 재시도하지 않는다** — SPEC-0005의 갱신·로그아웃 경로가
/// 소관이며 여기서 다시 조회해 봐야 같은 실패가 난다.
Duration? spotQaRetryPolicy(int retryCount, Object error) {
  if (error is SpotQaFailure &&
      error.kind == SpotQaFailureKind.unauthenticated) {
    return null;
  }
  if (retryCount >= 1) return null;
  return const Duration(milliseconds: 400);
}
