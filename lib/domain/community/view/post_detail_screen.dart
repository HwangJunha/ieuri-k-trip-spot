import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/comment_tile.dart';
import '../component/post_card.dart';
import '../model/comment.dart';
import '../model/post.dart';
import '../provider/post_detail_providers.dart';

/// 글 상세(R13·R23, 디자인 §4).
///
/// ```
/// AppBar
/// 스크롤 본문
///   ├── PostCard 전체 형태 (본문 미절단, 사진 전체)
///   ├── 구분선 + "Comments · N"   ← 서버 commentCount 그대로
///   └── CommentTile × N           ← 1단계만, 대댓글 없음
/// ```
///
/// **댓글 수와 목록 길이가 달라도 오류가 아니다**(가이드 §6): `commentCount`는
/// 숨겨진 댓글만 제외하고 차단은 반영하지 않으므로, 내가 차단한 사람의 댓글은
/// 목록에서 빠지지만 숫자에는 남는다. 숫자는 모두에게 같아야 하기 때문이며 클라이언트가
/// 목록을 세어 다시 계산하지 않는다.
///
/// 댓글 입력 바는 이번 범위에 넣지 않았다 — 읽기 흐름을 먼저 세우는 것이 목표이고,
/// 쓰기(`createComment`)는 컴포저와 함께 붙는다.
class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({super.key, required this.postId});

  static String get routeName => 'post-detail';

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<Post?> state = ref.watch(postDetailProvider(postId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.communityPostDetailTitle)),
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _Notice(
            title: l10n.communityFeedUnavailable,
            body: l10n.communityFeedUnavailableBody,
            onRetry: () => ref.invalidate(postDetailProvider(postId)),
          ),
          // **null은 오류가 아니다** — 차단·숨김이면 서버가 오류 대신 null을 준다
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

class _Body extends StatelessWidget {
  const _Body({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    // null과 빈 목록은 다른 상태다. null이면 댓글 조회 자체가 실패한 것이고(글 본문은
    // 정상), 빈 목록이면 정말로 댓글이 없는 것이다 — "댓글 없음"으로 뭉뚱그리면
    // 사용자가 오해한다.
    final List<Comment>? comments = post.comments;
    // 모든 항목이 같은 기준으로 상대 시각을 계산하도록 빌드 1회당 한 번만 읽는다.
    final DateTime now = DateTime.now().toUtc();

    return ListView(
      children: <Widget>[
        // expanded — 본문을 자르지 않고 사진을 전부 보여준다(디자인 §4).
        PostCard(post: post, now: now, expanded: true),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            // 서버 commentCount 그대로. 목록 길이로 계산하지 않는다(가이드 §6).
            l10n.communityCommentsHeader(post.commentCount),
            style: theme.textTheme.titleSmall,
          ),
        ),
        if (comments == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                l10n.communityCommentsUnavailable,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else if (comments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text(l10n.communityCommentsEmpty)),
          )
        else
          for (final Comment comment in comments)
            CommentTile(comment: comment, now: now),
        const SizedBox(height: 24),
      ],
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
