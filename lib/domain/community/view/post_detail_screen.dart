import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/auth_route.dart';
import '../../../common/navigation/settings_routes.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/comment_tile.dart';
import '../component/post_card.dart';
import '../component/post_photo.dart';
import '../../../common/model/comment.dart';
import '../../../common/model/post.dart';
import '../model/post_draft.dart';
import '../provider/comments_providers.dart';
import '../provider/post_detail_providers.dart';
import 'post_moderation_flow.dart';

/// 글 상세.
///
/// ```
/// AppBar
/// 스크롤 본문 (PaginationListView)
///   ├── [0] PostCard 전체 형태 (본문 미절단, 사진 전체)
///   ├── [1] 구분선 + "댓글 · N"   ← 서버 commentCount 그대로
///   └── [2..] CommentTile × N     ← 최상위 + 답글(들여쓰기), 커서 페이징
/// 하단 고정 CommentComposerBar   ← 답글 대상이 있으면 그 표시가 함께 뜬다
/// ```
///
/// **글과 댓글이 서로 다른 provider다.** `comments`가 루트 쿼리가 되면서 갈렸고,
/// 덕분에 **댓글 조회가 실패해도 글 본문은 그대로 뜬다**(가이드 §2).
///
/// **댓글 수와 목록 길이가 달라도 오류가 아니다**(가이드 §6, 2차 가이드 §1):
/// `commentCount`는 차단을 반영하지 않는데 목록은 반영하고, 게다가 그 수는 **답글까지
/// 포함한다.** 두 사유가 겹쳐 어긋나므로 클라이언트가 목록을 세어 다시 계산하지 않는다.
class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({super.key, required this.postId});

  static String get routeName => postDetailRouteName;

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<Post?> state = ref.watch(postDetailProvider(postId));

    // 볼 수 없는 글이거나 조회에 실패했으면 ⋮ 를 둘 이유가 없다 — 신고·차단 대상이
    // 화면에 없기 때문이다. `AsyncValue<Post?>`라 데이터가 온 것과 글이 null인 것이
    // 겹치므로 둘 다 걸러 낸다.
    final Post? post = state is AsyncData<Post?> ? state.value : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.communityPostDetailTitle),
        actions: <Widget>[
          if (post != null)
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: l10n.communityPostOptions,
              onPressed: () => runPostModerationFlow(
                context,
                ref,
                post: post,
                // 차단·삭제에 성공하면 이 글은 더 이상 볼 수 없다 — 상세에 남겨
                // 두는 것이 어색하므로 화면을 닫는다. 수정도 같은 콜백을 쓰지만
                // 그때는 다시 조회하는 편이 맞아 provider를 함께 무효화한다.
                onChanged: () {
                  ref.invalidate(postDetailProvider(postId));
                  Navigator.of(context).maybePop();
                },
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _Notice(
            title: l10n.communityFeedUnavailable,
            body: l10n.communityFeedUnavailableBody,
            onRetry: () => ref.invalidate(postDetailProvider(postId)),
          ),
          // **null은 오류가 아니다** — 차단·숨김·삭제면 서버가 오류 대신 null을 준다
          // (가이드 §6). 딥링크로 들어온 경우이므로 안내만 하고 재시도를 권하지
          // 않는다: 다시 조회해도 같은 null이다.
          data: (Post? post) => post == null
              ? _Notice(
                  title: l10n.communityPostUnavailableTitle,
                  body: l10n.communityPostUnavailable,
                )
              : _Body(post: post),
        ),
      ),
    );
  }
}

/// 상세 본문. 글·헤더·댓글을 **한 목록**으로 엮어 공용 [PaginationListView]에
/// 넘긴다(CLAUDE.md §4 — 기능이 자기 페이지네이션을 만들지 않는다).
///
/// 스크롤을 중첩하지 않는 이유이기도 하다 — 목록 안에 목록을 넣으면 어느 쪽이
/// 움직이는지 사용자가 알 수 없다.
/// 화면이 그리는 댓글 한 줄 — 최상위이거나 답글이다.
///
/// **서버가 준 트리를 평탄화한 결과다.** 목록 안에 목록을 넣으면 스크롤이 중첩되고
/// 어느 쪽이 움직이는지 알 수 없으므로, 한 목록에 순서대로 눕히고 [isReply]로
/// 들여쓰기만 다르게 준다.
typedef _CommentRow = ({Comment comment, bool isReply});

/// 최상위 댓글 목록을 화면 순서로 평탄화한다.
///
/// **답글 순서를 건드리지 않는다** — 서버가 오래된 순으로 주고 대화 흐름이라
/// 뒤집으면 문맥이 끊긴다(2차 가이드 §1). 최상위 목록만 최신순이다.
///
/// **부모가 삭제돼도 답글은 남는다** — 그 경우 서버가 부모 자리를 여전히 내려주므로
/// 여기서 특별히 걸러 낼 것이 없다. 답글만 남은 부분 트리를 숨기지 않는다.
List<_CommentRow> _flatten(List<Comment> topLevel) => <_CommentRow>[
  for (final Comment parent in topLevel) ...<_CommentRow>[
    (comment: parent, isReply: false),
    for (final Comment reply in parent.replies) (comment: reply, isReply: true),
  ],
];

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.post});

  final Post post;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  /// 글 카드와 댓글 헤더가 목록 앞에 차지하는 칸 수.
  static const int _headerCount = 2;

  /// 지금 답글을 달고 있는 최상위 댓글. null이면 일반 댓글이다.
  ///
  /// **화면 상태이지 서버 상태가 아니라서 provider로 올리지 않는다** — 다른 화면이
  /// 알 필요가 없고, 상세를 떠나면 사라지는 것이 맞다.
  Comment? _replyTarget;

  @override
  Widget build(BuildContext context) {
    final Post post = widget.post;
    // 모든 항목이 같은 기준으로 상대 시각을 계산하도록 빌드 1회당 한 번만 읽는다.
    final DateTime now = DateTime.now().toUtc();
    final AsyncValue<CommentsState> comments = ref.watch(
      commentsControllerProvider(post.id),
    );
    final CommentsState? data = comments.value;
    // 댓글이 아직 없거나(로딩·실패·빈 목록) 하나도 안 온 경우에는 헤더 뒤 한 칸이
    // 상태 표시 자리다 — 로딩·실패·"댓글 없음"이 서로 다른 문구로 그 자리에 뜬다.
    //
    // **추가 로딩은 최상위 댓글 단위다.** `replies`에는 페이지네이션이 없으므로
    // (2차 가이드 §1) 커서는 `data.items`(최상위)에만 걸리고, 평탄화된 줄 수는
    // 그보다 많을 수 있다.
    final List<_CommentRow> items = _flatten(data?.items ?? const <Comment>[]);

    return Column(
      children: <Widget>[
        Expanded(
          child: PaginationListView(
            itemCount: _headerCount + (items.isEmpty ? 1 : items.length),
            hasMore: data?.hasMore ?? false,
            isLoadingMore: data?.isLoadingMore ?? false,
            onLoadMore: () => ref
                .read(commentsControllerProvider(post.id).notifier)
                .loadMore(),
            // 당겨서 새로고침 — 공용 `common/pagination`의 선택 인자다(CLAUDE.md §4).
            //
            // **글과 댓글을 함께 다시 받는다.** 이 목록은 둘을 한 스크롤로 엮은
            // 것이라 한쪽만 갱신하면 좋아요 수와 댓글 목록이 서로 다른 시점을
            // 가리킨다. 둘 다 await해야 데이터가 올 때까지 스피너가 돈다.
            onRefresh: () async {
              ref
                ..invalidate(postDetailProvider(post.id))
                ..invalidate(commentsControllerProvider(post.id));
              await (
                ref
                    .read(postDetailProvider(post.id).future)
                    .catchError((Object _) => post),
                ref
                    .read(commentsControllerProvider(post.id).future)
                    .catchError(
                      (Object _) => const CommentsState(
                        items: <Comment>[],
                        hasMore: false,
                      ),
                    ),
              ).wait;
            },
            itemBuilder: (BuildContext context, int index) => switch (index) {
              0 => PostCard(
                post: post,
                now: now,
                expanded: true,
                onPhotoTap: (int at) => showPostPhotoViewer(
                  context,
                  photoKeys: post.photoKeys,
                  initialIndex: at,
                ),
              ),
              1 => _CommentsHeader(count: post.commentCount),
              _ when items.isEmpty => _CommentsStatus(
                state: comments,
                post: post,
              ),
              _ => _Tile(
                row: items[index - _headerCount],
                postId: post.id,
                now: now,
                // **최상위에만 답글 버튼을 준다**(2차 가이드 §1). 답글에 답글을
                // 달면 서버가 최상위 부모로 눕히므로, 버튼을 두면 사용자가 믿은
                // 부모와 실제 부모가 어긋난다.
                onReply: _replyTo,
              ),
            },
          ),
        ),
        _CommentComposerBar(
          postId: post.id,
          replyTo: _replyTarget,
          onCancelReply: () => setState(() => _replyTarget = null),
          onSubmitted: () => setState(() => _replyTarget = null),
        ),
      ],
    );
  }

  void _replyTo(Comment parent) => setState(() => _replyTarget = parent);
}

/// 댓글 목록의 로딩·실패·빈 상태 한 칸.
///
/// **글 본문과 분리돼 있다** — 댓글 조회가 실패해도 위의 글은 그대로 보인다.
class _CommentsStatus extends ConsumerWidget {
  const _CommentsStatus({required this.state, required this.post});

  final AsyncValue<CommentsState> state;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final bool failed = state.hasError;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              failed
                  ? l10n.communityCommentsUnavailable
                  : l10n.communityCommentsEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (failed) ...<Widget>[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(commentsControllerProvider(post.id)),
                child: Text(l10n.communityRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommentsHeader extends StatelessWidget {
  const _CommentsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            // 서버 commentCount 그대로. 목록 길이로 계산하지 않는다(가이드 §6).
            l10n.communityCommentsHeader(count),
            style: theme.textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _Tile extends ConsumerWidget {
  const _Tile({
    required this.row,
    required this.postId,
    required this.now,
    required this.onReply,
  });

  final _CommentRow row;
  final String postId;
  final DateTime now;

  /// 답글 대상을 고르는 콜백. **최상위 줄에만 넘긴다.**
  final ValueChanged<Comment> onReply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Comment comment = row.comment;
    return CommentTile(
      comment: comment,
      now: now,
      isReply: row.isReply,
      // 답글에는 답글 버튼을 두지 않는다 — 눌러도 최상위에 달리기 때문이다.
      onReply: row.isReply ? null : () => onReply(comment),
      onOptions: () => runCommentModerationFlow(
        context,
        ref,
        comment: comment,
        onChanged: () {
          ref.invalidate(commentsControllerProvider(postId));
          // 댓글 수는 글에 있으므로 함께 다시 받는다.
          ref.invalidate(postDetailProvider(postId));
        },
      ),
    );
  }
}

/// 하단 고정 댓글 입력. **낙관적으로 처리하지 않는다** — 서버가 거부할 사유가
/// 실재하고, 달린 것처럼 보였다가 사라지는 편이 잠깐 기다리는 것보다 나쁘다.
///
/// [replyTo]가 있으면 그 댓글의 **답글**로 보낸다(2차 가이드 §1). 누구에게 다는지를
/// 입력줄 위에 밝히고 취소 수단을 함께 둔다 — 답글 모드에 갇히면 일반 댓글을 달 수
/// 없다.
class _CommentComposerBar extends ConsumerStatefulWidget {
  const _CommentComposerBar({
    required this.postId,
    required this.replyTo,
    required this.onCancelReply,
    required this.onSubmitted,
  });

  final String postId;

  /// 답글 대상(최상위 댓글). null이면 일반 댓글이다.
  final Comment? replyTo;

  final VoidCallback onCancelReply;

  /// 전송에 성공했을 때 — 호출부가 답글 대상을 푼다.
  final VoidCallback onSubmitted;

  @override
  ConsumerState<_CommentComposerBar> createState() =>
      _CommentComposerBarState();
}

class _CommentComposerBarState extends ConsumerState<_CommentComposerBar> {
  final TextEditingController _controller = TextEditingController();

  /// 입력줄 전체의 높이를 재기 위한 키. 안내 스낵바를 이 높이만큼 띄워 겹침을
  /// 피한다([_toast]).
  final GlobalKey _barKey = GlobalKey();

  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 본문 길이는 **코드포인트**로 센다(가이드 §8) — `String.length`(UTF-16)로 세면
  /// 이모지가 든 댓글에서 서버와 숫자가 어긋난다.
  bool get _canSend {
    final String text = _controller.text.trim();
    return text.isNotEmpty && text.runes.length <= maxPostBodyRunes;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final Comment? replyTo = widget.replyTo;
    return Material(
      key: _barKey,
      color: theme.colorScheme.surface,
      elevation: 2,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // **누구에게 다는지 밝힌다.** 답글 모드는 눈에 보이지 않으면 일반
            // 댓글을 달려던 사용자가 엉뚱한 곳에 달게 된다.
            if (replyTo != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.communityReplyComposerHint(
                          replyTo.author.nickname,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onCancelReply,
                      tooltip: l10n.communityReplyCancel,
                      visualDensity: VisualDensity.compact,
                      iconSize: 18,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      // **maxLength를 두지 않는다** — 두면 입력이 잘려 초과분이
                      // 사라진다.
                      decoration: InputDecoration(
                        hintText: replyTo == null
                            ? l10n.communityCommentComposerHint
                            : l10n.communityReplyComposerHint(
                                replyTo.author.nickname,
                              ),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  _sending
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          onPressed: _canSend ? _send : null,
                          tooltip: l10n.communityCommentSend,
                          icon: const Icon(Icons.send),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    final CommentSubmission result = await ref
        .read(commentsControllerProvider(widget.postId).notifier)
        // null이면 최상위 댓글이다(2차 가이드 §1).
        .submit(_controller.text, parentCommentId: widget.replyTo?.id);
    if (!mounted) return;
    setState(() => _sending = false);

    switch (result) {
      case CommentSubmission.success:
        _controller.clear();
        // 답글 모드를 푼다 — 한 번 답글을 달면 다음 입력은 일반 댓글이 기본이다.
        widget.onSubmitted();
        // 목록은 컨트롤러가 다시 받는다(`createComment`는 commentId만 준다).
        // 댓글 수는 글에 있으므로 상세도 함께 무효화한다.
        ref.invalidate(postDetailProvider(widget.postId));
        _toast(l10n.communityCommentDone);
      case CommentSubmission.unauthenticated:
        _toast(l10n.communitySignInRequired);
        context.pushNamed(loginRouteName);
      case CommentSubmission.rejected:
        _toast(l10n.communityActionFailed);
    }
  }

  /// 안내를 띄운다.
  ///
  /// **[SnackBarBehavior.floating]이어야 한다.** 기본값(fixed)은 Scaffold 바닥에
  /// 붙는데, 이 화면은 바로 그 자리에 댓글 입력줄이 있어 스낵바가 입력창을 덮는다.
  /// 떠 있는 형태로 두고 입력줄 높이만큼 띄워 둘이 겹치지 않게 한다.
  void _toast(String message) {
    final double barHeight = _barKey.currentContext?.size?.height ?? 0;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          // 입력줄 위로 올린다. 높이를 못 재면(레이아웃 전) 기본 여백으로 떨어진다.
          bottom: barHeight + 12,
        ),
      ),
    );
  }
}

/// 볼 수 없는 글·조회 실패 안내. [onRetry]가 null이면 재시도 버튼을 두지 않는다 —
/// 차단·숨김은 다시 조회해도 결과가 같다.
class _Notice extends StatelessWidget {
  const _Notice({required this.title, required this.body, this.onRetry});

  final String title;
  final String body;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.communityRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
