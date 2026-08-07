import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/pagination/page.dart';
import '../../../common/model/comment.dart';
import '../model/community_failure.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'comments_providers.g.dart';

/// 댓글 한 페이지 크기.
const int _pageSize = 20;

/// 댓글 목록의 누적 상태. 피드와 같은 커서 페이징이다.
class CommentsState {
  const CommentsState({
    required this.items,
    required this.hasMore,
    this.endCursor,
    this.isLoadingMore = false,
  });

  final List<Comment> items;
  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  bool get isEmpty => items.isEmpty && !hasMore;

  CommentsState copyWith({
    List<Comment>? items,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
  }) => CommentsState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// 글 하나의 최상위 댓글과 각 댓글의 답글(가이드 §2, 2차 가이드 §1). [postId]별
/// 패밀리 — id를 인자로 두면 codegen이 family를 만든다(CLAUDE.md §5).
///
/// **[CommentsState.items]는 최상위 댓글만 담는다** — 답글은 각 [Comment.replies]
/// 안에 있다. 그래서 목록 길이는 답글을 세지 않으며, `commentCount`는 답글까지
/// 포함하므로 둘이 다른 것이 정상이다(§6의 차단 불일치와 겹쳐 두 배로 어긋날 수
/// 있다).
///
/// **`comments`가 루트 쿼리라서 provider도 글과 분리돼 있다.** 예전에는 글 상세
/// 응답에 댓글이 중첩돼 있었는데, 그 구조에서는 목록 안의 목록을 페이지네이션해야 해
/// 어느 카드의 커서인지 추적할 수 없었다. 지금은 상세 화면이 글과 댓글을 각각
/// 받으며, **댓글 조회가 실패해도 글 본문은 그대로 뜬다.**
///
/// **`commentCount`와 이 목록의 길이가 달라도 오류가 아니다** — 숫자는 차단을
/// 반영하지 않고 목록은 반영하기 때문이다(가이드 §6).
@Riverpod(retry: communityRetryPolicy)
class CommentsController extends _$CommentsController {
  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  @override
  Future<CommentsState> build(String postId) async {
    final CursorPage<Comment> page = await _repository.fetchComments(
      postId,
      first: _pageSize,
    );
    return CommentsState(
      items: page.items,
      hasMore: page.hasNextPage,
      endCursor: page.endCursor,
    );
  }

  Future<void> loadMore() async {
    final CommentsState? current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData<CommentsState>(current.copyWith(isLoadingMore: true));
    try {
      final CursorPage<Comment> next = await _repository.fetchComments(
        postId,
        first: _pageSize,
        after: current.endCursor,
      );
      state = AsyncData<CommentsState>(
        CommentsState(
          items: <Comment>[...current.items, ...next.items],
          hasMore: next.hasNextPage,
          endCursor: next.endCursor,
        ),
      );
    } on Object catch (error) {
      // 추가 로딩 실패는 보고 있는 목록을 지우지 않는다 — 인디케이터만 걷는다.
      developer.log(
        'comments loadMore failed: ${error.runtimeType}',
        name: 'CommentsController',
      );
      state = AsyncData<CommentsState>(current.copyWith(isLoadingMore: false));
    }
  }

  /// 댓글을 단다. **낙관적으로 처리하지 않는다**(디자인 §6) — 서버가 거부할 사유가
  /// 실재하고(길이·차단), 달린 것처럼 보였다가 사라지는 편이 잠깐 기다리는 것보다
  /// 나쁘다.
  ///
  /// 성공하면 `createComment`가 **commentId만 주므로**(가이드 §5) 응답으로 댓글을
  /// 조립할 수 없다 — 목록을 다시 받는다.
  ///
  /// [parentCommentId]를 주면 그 댓글의 답글이다(2차 가이드 §1). 낙관적 갱신을 하지
  /// 않는 것이 여기서 한 번 더 이득인데, **답글에 답글을 달면 서버가 최상위 부모로
  /// 눕히므로 실제 부모가 보낸 값과 다를 수 있기** 때문이다 — 다시 받으면 그 차이가
  /// 저절로 해소된다.
  Future<CommentSubmission> submit(
    String body, {
    String? parentCommentId,
  }) async {
    final String trimmed = body.trim();
    if (trimmed.isEmpty) return CommentSubmission.rejected;

    try {
      await _repository.createComment(
        postId: postId,
        body: trimmed,
        parentCommentId: parentCommentId,
      );
      ref.invalidateSelf();
      return CommentSubmission.success;
    } on CommunityFailure catch (failure) {
      if (failure.kind == CommunityFailureKind.unauthenticated) {
        return CommentSubmission.unauthenticated;
      }
      return CommentSubmission.rejected;
    } on Object {
      return CommentSubmission.rejected;
    }
  }
}

/// 댓글 작성 결과. 화면이 이 값으로 안내를 고른다.
enum CommentSubmission { success, rejected, unauthenticated }
