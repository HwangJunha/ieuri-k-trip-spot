import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../model/community_chip.dart';
import '../model/community_failure.dart';
import '../repository/community_repository.dart';
import '../repository/community_repository_impl.dart';

part 'community_providers.g.dart';

/// 커뮤니티 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
@riverpod
CommunityRepository communityRepository(Ref ref) =>
    CommunityRepositoryImpl(ref.watch(graphqlClientProvider));

/// 자동 재시도 1회 뒤 멈추는 재시도 정책(spot의 `spotRetryPolicy`와 같은 이유).
///
/// Riverpod 3 기본값은 실패한 provider를 지수 백오프로 **최대 10회** 재조회한다.
/// 재시도로 풀리지 않는 실패에서는 그 폭주가 그대로 낭비이고, 사용자에게는 오류
/// 화면이 뜨기까지의 지연으로만 보인다.
///
/// 인증 실패는 **아예 재시도하지 않는다** — SPEC-0005의 갱신·로그아웃 경로가
/// 소관이며 여기서 다시 조회해 봐야 같은 실패가 난다.
Duration? communityRetryPolicy(int retryCount, Object error) {
  if (error is CommunityFailure &&
      error.kind == CommunityFailureKind.unauthenticated) {
    return null;
  }
  if (retryCount >= 1) return null;
  return const Duration(milliseconds: 400);
}

/// 상단 칩 구성(가이드 §2). **빈 목록이 정상**이므로 빈 결과를 오류로 다루지 않는다 —
/// 구성이 없는 앱이면 비어 오고, 칩 영역이 비는 레이아웃을 화면이 허용해야 한다.
///
/// 피드와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다.
/// 칩 조회가 실패해도 피드는 그대로 뜨고, 그 반대도 같다.
@Riverpod(retry: communityRetryPolicy)
Future<List<CommunityChip>> communityChips(Ref ref) =>
    ref.watch(communityRepositoryProvider).fetchCommunityChips();
