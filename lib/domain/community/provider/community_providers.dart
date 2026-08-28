import '../../../common/location/location_service.dart';
import '../../../common/network/auth_error_codes.dart';
import '../../../common/network/network_retry_policy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/target_category.dart';
import '../../../common/network/graphql_client.dart';
import '../repository/community_repository.dart';
import '../repository/community_repository_impl.dart';

part 'community_providers.g.dart';

/// 커뮤니티 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
@riverpod
CommunityRepository communityRepository(Ref ref) =>
    CommunityRepositoryImpl(ref.watch(graphqlClientProvider));

/// 공통 상한을 쓰는 재시도 정책(간격·횟수는 `network_retry_policy`가 정한다).
///
/// Riverpod 3 기본값은 **최대 10회**라 그대로 두면 한 번의 실패가 11번의 왕복이
/// 된다. 멈추는 조건은 여전히 횟수다(POL-040) — 간격만 지수로 벌린다.
///
/// 인증 실패는 **아예 재시도하지 않는다** — SPEC-0005의 갱신·로그아웃 경로가
/// 소관이며 여기서 다시 조회해 봐야 같은 실패가 난다.
///
/// 위치 실패도 같은 이유로 재시도하지 않는다(2026-08-29) — 주변 글 피드가
/// 좌표를 입력으로 쓰는데, 좌표를 못 얻은 것은 서버가 아니라 기기 사정이라
/// 다시 조회해도 같은 답이다. 화면은 `communityLocationUnavailable`로 안내한다.
Duration? communityRetryPolicy(int retryCount, Object error) {
  // 인증 실패는 갱신 링크 소관이라 재시도하지 않는다. 판별은 공통
  // [AuthAwareFailure] 하나에만 의존한다 — 도메인마다 따로 적어 두면 서버가
  // 코드를 늘렸을 때 한쪽만 고쳐진다(2026-08-29).
  if (error is LocationUnavailable) return null;
  if (error is AuthAwareFailure && error.isUnauthenticated) return null;
  if (retryCount >= defaultMaxAutoRetries) return null;
  return defaultRetryDelayOf(retryCount);
}

/// 상단 칩 구성(가이드 §2). **빈 목록이 정상**이므로 빈 결과를 오류로 다루지 않는다 —
/// 구성이 없는 앱이면 비어 오고, 칩 영역이 비는 레이아웃을 화면이 허용해야 한다.
///
/// **서버가 준 순서를 그대로 쓰지 않는다** — 코드 알파벳순일 뿐이라 언어를 바꾸면
/// 같은 칩이 다른 자리로 간다. 표시 순서는 그리는 쪽이 `kCategoryDisplayOrder`로 잡는다.
///
/// 피드와 **분리된 provider**인 이유는 실패가 서로를 가리지 않게 하기 위해서다.
/// 칩 조회가 실패해도 피드는 그대로 뜨고, 그 반대도 같다.
@Riverpod(retry: communityRetryPolicy)
Future<List<TargetCategory>> communityChips(Ref ref) =>
    ref.watch(communityRepositoryProvider).fetchCommunityChips();
