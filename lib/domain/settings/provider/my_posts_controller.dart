
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

import '../../../common/log/app_log.dart';
import '../../../common/model/post.dart';
import '../../../common/pagination/page.dart';
import '../repository/profile_repository.dart';
import 'agreements_controller.dart' show settingsRetryPolicy;
import 'profile_providers.dart';

part 'my_posts_controller.g.dart';

const int _pageSize = 20;

/// 내가 쓴 글 목록의 누적 상태(SPEC-0011 R3). 커뮤니티 피드·차단 목록과 같은 커서
/// 페이징이다.
class MyPostsState {
  const MyPostsState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  final List<Post> items;
  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  /// 빈 상태(디자인 §7). **다음 페이지가 없어야 빈 것이다** — 첫 페이지가 비었는데
  /// `hasNextPage`가 true면 아직 더 받을 것이 있다.
  bool get isEmpty => items.isEmpty && !hasMore;

  MyPostsState copyWith({
    List<Post>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => MyPostsState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 내가 쓴 글(R3).
///
/// **페이지네이션은 `common/pagination/`을 쓴다**(CLAUDE.md §4) — 화면은
/// `PaginationListView`가 그리고, 여기서는 누적·커서·중복 호출 억제만 한다.
@Riverpod(retry: settingsRetryPolicy)
class MyPostsController extends _$MyPostsController {
  static final Logger _log = appLogger('MyPostsController');

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  Future<MyPostsState> build() async {
    final CursorPage<Post> page = await _repository.fetchMyPosts(
      first: _pageSize,
    );
    return MyPostsState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  /// 다음 페이지를 이어 붙인다. **이미 받는 중이면 무시한다** —
  /// [PaginationListView]는 바닥 근처에서 여러 번 발화하므로 중복 억제는 여기 몫이다.
  Future<void> loadMore() async {
    final MyPostsState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<MyPostsState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<Post> next = await _repository.fetchMyPosts(
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<MyPostsState>(
        MyPostsState(
          items: <Post>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      // **이미 받아 둔 목록을 오류로 날리지 않는다** — 다음 장 실패로 첫 장까지
      // 사라지면 사용자는 글이 없어진 줄 안다. 인디케이터만 걷고 그대로 둔다.
      _log.w('myPosts loadMore failed: ${error.runtimeType}');
      state = AsyncData<MyPostsState>(current.copyWith(isLoadingMore: false));
    }
  }

  /// 당겨서 새로고침. 첫 페이지부터 다시 받는다.
  Future<void> refresh() async {
    state = await AsyncValue.guard(build);
  }
}
