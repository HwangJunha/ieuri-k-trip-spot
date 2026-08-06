import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/auth_route.dart';
import '../../../common/pagination/pagination_list_view.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/comment_tile.dart';
import '../component/post_card.dart';
import '../component/post_photo.dart';
import '../model/comment.dart';
import '../model/post.dart';
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
///   └── [2..] CommentTile × N     ← 1단계만, 커서 페이징
/// 하단 고정 CommentComposerBar
/// ```
///
/// **글과 댓글이 서로 다른 provider다.** `comments`가 루트 쿼리가 되면서 갈렸고,
/// 덕분에 **댓글 조회가 실패해도 글 본문은 그대로 뜬다**(가이드 §2).
///
/// **댓글 수와 목록 길이가 달라도 오류가 아니다**(가이드 §6): `commentCount`는
/// 숨겨진 댓글만 제외하고 차단은 반영하지 않으므로, 내가 차단한 사람의 댓글은
/// 목록에서 빠지지만 숫자에는 남는다. 클라이언트가 목록을 세어 다시 계산하지 않는다.
class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({super.key, required this.postId});

  static String get routeName => 'post-detail';

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
class _Body extends ConsumerWidget {
  const _Body({required this.post});

  /// 글 카드와 댓글 헤더가 목록 앞에 차지하는 칸 수.
  static const int _headerCount = 2;

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 모든 항목이 같은 기준으로 상대 시각을 계산하도록 빌드 1회당 한 번만 읽는다.
    final DateTime now = DateTime.now().toUtc();
    final AsyncValue<CommentsState> comments = ref.watch(
      commentsControllerProvider(post.id),
    );
    final CommentsState? data = comments.value;
    // 댓글이 아직 없거나(로딩·실패·빈 목록) 하나도 안 온 경우에는 헤더 뒤 한 칸이
    // 상태 표시 자리다 — 로딩·실패·"댓글 없음"이 서로 다른 문구로 그 자리에 뜬다.
    final List<Comment> items = data?.items ?? const <Comment>[];

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
                comment: items[index - _headerCount],
                postId: post.id,
                now: now,
              ),
            },
          ),
        ),
        _CommentComposerBar(postId: post.id),
      ],
    );
  }
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
  const _Tile({required this.comment, required this.postId, required this.now});

  final Comment comment;
  final String postId;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) => CommentTile(
    comment: comment,
    now: now,
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

/// 하단 고정 댓글 입력. **낙관적으로 처리하지 않는다** — 서버가 거부할 사유가
/// 실재하고, 달린 것처럼 보였다가 사라지는 편이 잠깐 기다리는 것보다 나쁘다.
class _CommentComposerBar extends ConsumerStatefulWidget {
  const _CommentComposerBar({required this.postId});

  final String postId;

  @override
  ConsumerState<_CommentComposerBar> createState() =>
      _CommentComposerBarState();
}

class _CommentComposerBarState extends ConsumerState<_CommentComposerBar> {
  final TextEditingController _controller = TextEditingController();
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
    return Material(
      color: theme.colorScheme.surface,
      elevation: 2,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  // **maxLength를 두지 않는다** — 두면 입력이 잘려 초과분이 사라진다.
                  decoration: InputDecoration(
                    hintText: l10n.communityCommentComposerHint,
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
      ),
    );
  }

  Future<void> _send() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    final CommentSubmission result = await ref
        .read(commentsControllerProvider(widget.postId).notifier)
        .submit(_controller.text);
    if (!mounted) return;
    setState(() => _sending = false);

    switch (result) {
      case CommentSubmission.success:
        _controller.clear();
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

  void _toast(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
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
