import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/list_equality.dart';
import '../../../common/pagination/page.dart';
import '../model/conversation.dart';
import '../repository/feed_repository.dart';
import 'feed_providers.dart';

part 'conversation_list_providers.g.dart';

/// 한 번에 받아오는 대화 수. 서버 기본값 20이다(계약 §페이지네이션).
const int _pageSize = 20;

/// 헤더의 미읽음 점 배지가 보는 값.
///
/// **대화 목록 provider를 직접 watch하지 않기 위해 존재한다.** 배지가 목록을 구독하면
/// 둘러보기 탭에 들어서는 것만으로 대화 20건 조회가 나간다 — 점 하나 그리자고 낼
/// 비용이 아니다. 목록을 실제로 불러온 화면이 이 값을 갱신하고, 배지는 값만 읽는다.
///
/// 그래서 **앱을 켜고 대화 목록에 한 번도 안 들어갔으면 점이 뜨지 않는다.** 서버가
/// 전체 미읽음 합계를 주지 않는 이상(계약에 없다) 이보다 정확하게 만들 수 없다.
@Riverpod(keepAlive: true)
class UnreadConversationsFlag extends _$UnreadConversationsFlag {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

/// 대화 목록 화면의 상태.
///
/// [FeedListState]와 같은 모양이지만 **합치지 않는다** — 항목 타입이 다르고, 한쪽에
/// 필요한 필드가 다른 쪽에 생기면 둘 다 흐려진다.
class ConversationListState {
  const ConversationListState({
    this.items = const <Conversation>[],
    this.hasMore = false,
    this.endCursor,
    this.isLoadingMore = false,
  });

  /// 최근 활동순 대화. **클라이언트가 다시 정렬하지 않는다** — 서버가 `updatedAt`
  /// 내림차순으로 내려준다.
  final List<Conversation> items;

  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  bool get isEmpty => items.isEmpty;

  /// 첫 페이지 안에 읽지 않은 대화가 있는지.
  ///
  /// **합계가 아니라 유무만 본다.** 서버가 전체 미읽음 합계를 주지 않아 첫 페이지로
  /// 합을 내면 20건을 넘는 순간 조용히 틀린 값이 된다(디자인 §1.5) — 헤더 배지를
  /// 숫자 없는 점으로 두는 근거다.
  bool get hasUnread => items.any((Conversation c) => c.unreadCount > 0);

  ConversationListState copyWith({
    List<Conversation>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => ConversationListState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );

  @override
  bool operator ==(Object other) =>
      other is ConversationListState &&
      listEquals(other.items, items) &&
      other.hasMore == hasMore &&
      other.endCursor == endCursor &&
      other.isLoadingMore == isLoadingMore;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(items), hasMore, endCursor, isLoadingMore);
}

/// 내가 참여한 대화 목록(R8).
///
/// **keepAlive가 아니다.** 대화 목록은 열 때마다 최신이어야 하고, 읽음 처리·새
/// 메시지로 배지가 수시로 바뀐다 — 세션에 붙들어 두면 낡은 미읽음 수가 남는다.
@Riverpod(retry: feedRetryPolicy)
class ConversationListController extends _$ConversationListController {
  FeedRepository get _repository => ref.read(feedRepositoryProvider);

  @override
  Future<ConversationListState> build() async {
    final CursorPage<Conversation> page = await ref
        .watch(feedRepositoryProvider)
        .fetchConversations(first: _pageSize);
    final ConversationListState next = ConversationListState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
    // 헤더 배지에 알린다 — 배지는 이 목록을 구독하지 않는다(위 주석 참고).
    ref.read(unreadConversationsFlagProvider.notifier).set(next.hasUnread);
    return next;
  }

  /// 다음 페이지를 이어 붙인다. 소진됐거나 이미 받는 중이면 아무것도 하지 않는다 —
  /// 목록 끝에서는 스크롤 알림이 여러 번 오므로 여기서 막지 않으면 같은 페이지를
  /// 두 번 붙인다.
  Future<void> loadMore() async {
    final ConversationListState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<ConversationListState>(
      current.copyWith(isLoadingMore: true),
    );
    try {
      final CursorPage<Conversation> page = await _repository
          .fetchConversations(first: _pageSize, after: current.endCursor);
      state = AsyncData<ConversationListState>(
        current.copyWith(
          items: <Conversation>[...current.items, ...page.items],
          hasMore: page.hasNextPage,
          endCursor: page.endCursor,
          isLoadingMore: false,
        ),
      );
    } on Object catch (error) {
      // 이어읽기 실패는 이미 그려진 목록을 지우지 않는다 — 로딩 표시만 걷는다.
      developer.log(
        'loadMore failed: ${error.runtimeType}',
        name: 'ConversationListController',
      );
      state = AsyncData<ConversationListState>(
        current.copyWith(isLoadingMore: false),
      );
    }
  }
}
