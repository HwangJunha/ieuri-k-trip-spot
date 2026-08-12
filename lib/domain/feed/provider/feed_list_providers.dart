import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/list_equality.dart';
import '../../../common/pagination/page.dart';
import '../model/feed_item.dart';
import '../repository/feed_repository.dart';
import 'feed_providers.dart';

part 'feed_list_providers.g.dart';

/// 한 번에 받아오는 피드 수. 서버 기본값 20 / 상한 50이며, 초과해도 오류가 아니라
/// 50으로 잘린다(계약 §페이지네이션).
const int _pageSize = 20;

/// 피드 화면의 상태.
///
/// **총 개수를 담지 않는다** — 서버가 주지 않으므로 "N개 중 M번째" 같은 표현을
/// 만들지 않는다(설계 §2). 소진 판정은 [hasMore] 하나로 한다.
class FeedListState {
  const FeedListState({
    this.items = const <FeedItem>[],
    this.hasMore = false,
    this.endCursor,
    this.isLoadingMore = false,
  });

  final List<FeedItem> items;

  /// 다음 페이지가 있는지. 서버 `pageInfo.hasNextPage` 그대로다(AC4-4).
  final bool hasMore;

  /// 이어읽기 커서. 서버 `pageInfo.endCursor`다.
  final String? endCursor;

  final bool isLoadingMore;

  bool get isEmpty => items.isEmpty;

  FeedListState copyWith({
    List<FeedItem>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => FeedListState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );

  @override
  bool operator ==(Object other) =>
      other is FeedListState &&
      listEquals(other.items, items) &&
      other.hasMore == hasMore &&
      other.endCursor == endCursor &&
      other.isLoadingMore == isLoadingMore;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), hasMore, endCursor, isLoadingMore);
}

/// 피드 목록(R4). 최신순 고정이라 정렬 인자가 없다.
///
/// **이 provider의 실패는 추천 화면을 막지 않는다**(AC5-3) — 두 화면이 서로 다른
/// provider를 보기 때문이며, 세그먼트 토글은 어느 쪽을 그릴지만 정한다.
@Riverpod(retry: feedRetryPolicy)
class FeedListController extends _$FeedListController {
  FeedRepository get _repository => ref.read(feedRepositoryProvider);

  @override
  Future<FeedListState> build() async {
    final CursorPage<FeedItem> page = await ref
        .watch(feedRepositoryProvider)
        .fetchFeed(first: _pageSize);
    return FeedListState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  /// 다음 페이지를 이어 붙인다(AC4-2).
  ///
  /// 소진됐거나 이미 불러오는 중이면 **아무것도 하지 않는다** — 전면 스크롤은
  /// 경계에서 여러 번 호출되기 쉬워서, 중복 요청을 여기서 막지 않으면 같은 페이지를
  /// 두 번 붙인다.
  Future<void> loadMore() async {
    final FeedListState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<FeedListState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<FeedItem> page = await _repository.fetchFeed(
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<FeedListState>(
        current.copyWith(
          items: <FeedItem>[...current.items, ...page.items],
          hasMore: page.hasNextPage,
          endCursor: page.endCursor,
          isLoadingMore: false,
        ),
      );
    } on Object catch (error) {
      // 이어읽기 실패는 **이미 그려진 목록을 지우지 않는다** — 화면을 통째로 오류로
      // 바꾸면 사용자가 보던 피드가 사라진다. 로딩 표시만 걷고 목록은 남긴다.
      developer.log(
        'loadMore failed: ${error.runtimeType}',
        name: 'FeedListController',
      );
      state = AsyncData<FeedListState>(current.copyWith(isLoadingMore: false));
    }
  }

  /// 좋아요를 토글한다(R6).
  ///
  /// **즉시 반영하고 실패하면 되돌린다**(설계 §3, AC6-1). 서버 연산이 멱등이므로
  /// 중복 탭이 수를 어긋내지 않으며(AC6-2), 성공하면 서버가 준 수로 되맞춘다 —
  /// 서버 값이 정본이다.
  Future<void> toggleLike(String feedItemId) async {
    final FeedListState? current = state.value;
    if (current == null) return;
    final int at = current.items.indexWhere((FeedItem f) => f.id == feedItemId);
    if (at < 0) return;

    final FeedItem original = current.items[at];
    final bool liking = !original.likedByViewer;

    void replace(FeedItem item) {
      final FeedListState? latest = state.value;
      if (latest == null) return;
      final List<FeedItem> items = <FeedItem>[...latest.items];
      final int index = items.indexWhere((FeedItem f) => f.id == feedItemId);
      if (index < 0) return;
      items[index] = item;
      state = AsyncData<FeedListState>(latest.copyWith(items: items));
    }

    replace(
      original.copyWith(
        likedByViewer: liking,
        // 취소가 음수로 내려가지 않게 막는다(AC6-3).
        likeCount: (original.likeCount + (liking ? 1 : -1)).clamp(0, 1 << 31),
      ),
    );

    // 실패는 두 갈래이고 **둘 다 롤백해야 한다** — 도메인 규칙 위반은 값으로,
    // 전송·인증 실패는 예외로 온다. 한쪽만 처리하면 나머지 경로에서 화면이 좋아요된
    // 채로 굳는다.
    try {
      final FeedMutationResult<int> result = liking
          ? await _repository.likeFeedItem(feedItemId)
          : await _repository.unlikeFeedItem(feedItemId);

      if (!result.succeeded) {
        developer.log(
          'toggleLike rejected: ${result.errorCode}',
          name: 'FeedListController',
        );
        replace(original);
        return;
      }
      final int? serverCount = result.value;
      if (serverCount != null) {
        replace(
          original.copyWith(likedByViewer: liking, likeCount: serverCount),
        );
      }
    } on Object catch (error) {
      developer.log(
        'toggleLike failed: ${error.runtimeType}',
        name: 'FeedListController',
      );
      replace(original);
    }
  }
}
