import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/pagination/page.dart';
import '../model/blocked_user.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'blocked_users_providers.g.dart';

const int _pageSize = 20;

/// 차단 목록의 누적 상태. 피드와 같은 커서 페이징이다.
class BlockedUsersState {
  const BlockedUsersState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  final List<BlockedUser> items;
  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  bool get isEmpty => items.isEmpty && !hasMore;

  BlockedUsersState copyWith({
    List<BlockedUser>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => BlockedUsersState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 내가 차단한 사람 목록(가이드 §6).
///
/// **나를 차단한 사람은 여기 없다** — 남이 건 차단은 내가 풀 수 없기 때문이다.
/// "글이 안 보이는데 목록에 없다"는 정상이며, 화면이 그 사실을 안내한다.
@Riverpod(retry: communityRetryPolicy)
class BlockedUsersController extends _$BlockedUsersController {
  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  @override
  Future<BlockedUsersState> build() async {
    final CursorPage<BlockedUser> page = await _repository.fetchBlockedUsers(
      first: _pageSize,
    );
    return BlockedUsersState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  Future<void> loadMore() async {
    final BlockedUsersState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<BlockedUsersState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<BlockedUser> next = await _repository.fetchBlockedUsers(
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<BlockedUsersState>(
        BlockedUsersState(
          items: <BlockedUser>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      developer.log(
        'blockedUsers loadMore failed: ${error.runtimeType}',
        name: 'BlockedUsersController',
      );
      state = AsyncData<BlockedUsersState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }
}
