import 'package:flutter/material.dart';

/// 카드 하단의 좋아요·댓글 행(디자인 §1). 두 버튼 모두 터치 영역 ≥48dp다.
///
/// **미인증이어도 버튼을 감추지 않는다** — 감추면 기능이 없는 것처럼 보이므로,
/// 눌렀을 때 로그인으로 유도하는 쪽을 택한다(설계 §3, R17). `likedByViewer`는
/// 미인증일 때 false로 오므로 별도 분기가 필요 없다.
///
/// 좋아요는 낙관적으로 반영되고 실패하면 되돌아간다(R12) — 이 위젯은 그 상태를
/// 표시만 하고, 판단은 컨트롤러가 한다.
class PostActionBar extends StatelessWidget {
  const PostActionBar({
    super.key,
    required this.likeCount,
    required this.likedByViewer,
    required this.commentCount,
    this.onLike,
    this.onComment,
  });

  final int likeCount;
  final bool likedByViewer;

  /// 서버가 준 댓글 수. **목록 길이로 계산하지 않는다** — 차단된 사람의 댓글은
  /// 목록에서 빠지지만 숫자에는 남으므로 둘이 다를 수 있고, 그것은 버그가 아니다
  /// (가이드 §6).
  final int commentCount;

  final VoidCallback? onLike;
  final VoidCallback? onComment;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        _Action(
          icon: likedByViewer ? Icons.favorite : Icons.favorite_border,
          // 눌린 상태만 강조색이다. 나머지는 저강조로 두어 본문을 가리지 않는다.
          color: likedByViewer
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          count: likeCount,
          onTap: onLike,
        ),
        const SizedBox(width: 8),
        _Action(
          icon: Icons.mode_comment_outlined,
          color: theme.colorScheme.onSurfaceVariant,
          count: commentCount,
          onTap: onComment,
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        // 터치 영역 ≥48dp(디자인 §1).
        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: theme.textTheme.labelMedium?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
