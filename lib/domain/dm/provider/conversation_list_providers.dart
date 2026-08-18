import 'dart:developer' as developer;

import '../../auth/model/auth_state.dart';
import '../../auth/provider/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/list_equality.dart';
import '../../../common/model/spot_qa_origin.dart';
import '../../../common/pagination/page.dart';
import '../model/conversation.dart';
import '../repository/dm_repository.dart';
import 'dm_providers.dart';

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
/// 다른 목록 상태와 모양이 같아 보여도 **합치지 않는다** — 항목 타입이 다르고,
/// 한쪽에 필요한 필드가 다른 쪽에 생기면 둘 다 흐려진다.
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

/// 대화 하나의 질문/답변 출처(SPEC-0026 R14). 없으면 null이다.
///
/// **서버에 대화 단건 조회가 없어** 목록에서 되짚는다(계약 §Query — `conversations`
/// 뿐이다). 대화 화면은 `conversationId`만 들고 있으므로(CLAUDE.md §6) 이 provider가
/// 그 id로 목록에서 찾아 준다.
///
/// **null이 정상값이다.** 기존 DM은 전부 출처가 없고, 목록이 아직 오지 않았거나 조회에
/// 실패했을 때도 null이다 — 그때 맥락 카드만 안 그리고 대화는 지금과 똑같이 동작한다.
/// 출처가 없다고 대화를 오류로 만들지 않는다.
@riverpod
SpotQaOrigin? conversationSpotQaOrigin(Ref ref, String conversationId) => ref
    .watch(conversationListControllerProvider)
    .value
    ?.items
    .where((Conversation c) => c.id == conversationId)
    .firstOrNull
    ?.spotQaOrigin;

/// 홈의 메시지 배지가 보는 값. **로그인했을 때만 목록을 한 번 받아 플래그를 채운다.**
///
/// [UnreadConversationsFlag]만으로는 부족했다 — 그건 대화 목록 화면이 갱신해 주는
/// 값이라 **한 번도 안 들어갔으면 영원히 false**다. DM이 와도 사용자가 모른다는 문제가
/// 정확히 거기서 나왔다. 홈은 앱을 열면 늘 지나는 화면이라 여기서 한 번 받아 둔다.
///
/// **비로그인이면 조회하지 않는다.** 대화 조회는 인증이 필요해 반드시 실패하는데,
/// 홈에서 매번 그 왕복이 나가면 낭비이고 로그 노이즈다.
///
/// 실패해도 false다 — 배지는 부가 정보라 오류를 끌고 다니지 않는다.
@riverpod
bool hasUnreadConversations(Ref ref) {
  final AuthState? auth = ref.watch(authControllerProvider).value;
  if (auth == null || !auth.isAuthenticated) return false;

  // 이미 목록을 받아 둔 상태면 그 값이 가장 정확하다.
  final ConversationListState? list = ref
      .watch(conversationListControllerProvider)
      .value;
  if (list != null) return list.hasUnread;

  // 아직 안 받았으면 대화 목록 화면이 남긴 플래그를 쓴다(조회가 끝나면 위로 넘어간다).
  return ref.watch(unreadConversationsFlagProvider);
}

/// 내가 참여한 대화 목록(R8).
///
/// **keepAlive가 아니다.** 대화 목록은 열 때마다 최신이어야 하고, 읽음 처리·새
/// 메시지로 배지가 수시로 바뀐다 — 세션에 붙들어 두면 낡은 미읽음 수가 남는다.
@Riverpod(retry: dmRetryPolicy)
class ConversationListController extends _$ConversationListController {
  DmRepository get _repository => ref.read(dmRepositoryProvider);

  @override
  Future<ConversationListState> build() async {
    final CursorPage<Conversation> page = await ref
        .watch(dmRepositoryProvider)
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
