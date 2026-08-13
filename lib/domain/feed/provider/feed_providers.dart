import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/network/graphql_client.dart';
import '../../../common/network/graphql_socket_client.dart';
import '../model/discover_segment.dart';
import '../model/feed_failure.dart';
import '../repository/feed_repository.dart';
import '../repository/feed_repository_impl.dart';

part 'feed_providers.g.dart';

/// 피드 repository 하나의 출처(CLAUDE.md §5 — 위젯이 repository를 직접 만들지
/// 않는다). 테스트는 이 provider 하나만 오버라이드해 페이크를 주입한다.
///
/// **클라이언트를 둘 받는다.** 쿼리·뮤테이션은 HTTP, 구독만 WebSocket이다
/// (SPEC-0017 — 이 앱 최초의 Subscription).
@riverpod
FeedRepository feedRepository(Ref ref) => FeedRepositoryImpl(
  ref.watch(graphqlClientProvider),
  socketClient: ref.watch(graphqlSocketClientProvider),
);

/// 자동 재시도 1회 뒤 멈추는 재시도 정책(커뮤니티·spot과 같은 이유).
///
/// Riverpod 3 기본값은 실패한 provider를 지수 백오프로 **최대 10회** 재조회한다.
/// 재시도로 풀리지 않는 실패에서는 그 폭주가 그대로 낭비이고, 사용자에게는 오류
/// 화면이 뜨기까지의 지연으로만 보인다(POL-040 — 재시도는 횟수로 제한한다).
Duration? feedRetryPolicy(int retryCount, Object error) {
  // **권한·인증 실패는 아예 재시도하지 않는다** — `FORBIDDEN`은 재시도로 풀리지
  // 않고 상한까지 헛돌기만 한다. 인증은 SPEC-0005의 갱신 경로가 소관이다.
  if (error is FeedFailure && error.permanent) return null;
  if (retryCount >= 1) return null;
  return const Duration(milliseconds: 400);
}

/// 둘러보기 탭에서 지금 보고 있는 화면(R5).
///
/// **이 provider는 어느 쪽을 그릴지만 안다.** 두 화면의 데이터는 각자의 provider가
/// 따로 들고 있어서, 전환해도 상태가 유지되고(AC5-1) 한쪽의 실패가 다른 쪽을
/// 막지 않는다(AC5-3). 토글이 두 화면의 상태까지 소유하면 그 격리가 깨진다.
///
/// keepAlive인 이유는 커뮤니티의 카테고리·정렬 선택과 같다 — 사용자가 고른 화면은
/// 위젯이 아니라 세션에 속한다. autoDispose면 spot 상세에 다녀오는 것만으로
/// 추천으로 되돌아간다.
@Riverpod(keepAlive: true)
class SelectedDiscoverSegment extends _$SelectedDiscoverSegment {
  /// 기본은 추천이다 — **피드 도입이 추천을 대체하지 않는다**(AC5-2).
  @override
  DiscoverSegment build() => DiscoverSegment.recommendation;

  void select(DiscoverSegment segment) => state = segment;
}
