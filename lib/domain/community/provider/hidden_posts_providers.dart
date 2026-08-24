
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/log/app_log.dart';
import '../../../common/pagination/page.dart';
import '../../../common/model/post.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'hidden_posts_providers.g.dart';

const int _pageSize = 20;

/// 숨긴 글 목록의 누적 상태. 피드·차단 목록과 같은 커서 페이징이다.
class HiddenPostsState {
  const HiddenPostsState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  final List<Post> items;
  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  bool get isEmpty => items.isEmpty && !hasMore;

  HiddenPostsState copyWith({
    List<Post>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => HiddenPostsState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 내가 숨긴 글 목록(2차 가이드 §2) — 해제 화면이 쓴다.
///
/// **별도 쿼리가 아니라 `posts(hiddenByViewer: true)`다.** 서버가 그렇게 만든 이유는
/// 이 목록에도 카테고리·태그 필터와 정렬이 그대로 걸려야 하기 때문이다. 다만 해제
/// 화면은 필터를 두지 않으므로 여기서는 인자 없이 부른다.
///
/// **숨긴 글은 그 밖의 모든 조회에서 빠진다** — 피드도, `post(id:)` 단건도 null이다.
/// 그래서 이 목록이 유일한 해제 경로다.
///
/// 좌표를 넘기지 않는 이유: 이 화면은 "내가 숨긴 것"의 전체 목록이지 지역 피드가
/// 아니다. 좌표를 걸면 다른 도시에서 숨긴 글을 풀 수 없게 된다.
@Riverpod(retry: communityRetryPolicy)
class HiddenPostsController extends _$HiddenPostsController {
  static const AppLog _log = AppLog('HiddenPostsController');

  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  @override
  Future<HiddenPostsState> build() async {
    final CursorPage<Post> page = await _repository.fetchPosts(
      hiddenByViewer: true,
      first: _pageSize,
    );
    return HiddenPostsState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  Future<void> loadMore() async {
    final HiddenPostsState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<HiddenPostsState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<Post> next = await _repository.fetchPosts(
        hiddenByViewer: true,
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<HiddenPostsState>(
        HiddenPostsState(
          items: <Post>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      // 추가 로딩 실패는 보고 있는 목록을 지우지 않는다 — 인디케이터만 걷는다.
      _log.warn('hiddenPosts loadMore failed: ${error.runtimeType}');
      state = AsyncData<HiddenPostsState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }
}
