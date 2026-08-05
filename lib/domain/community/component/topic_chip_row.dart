import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/post_topic.dart';
import 'post_topic_label.dart';

/// 상단 카테고리 행(당근 동네생활의 상단 진입 줄을 따른다).
///
/// **당근은 여기를 얇은 아웃라인 pill이 아니라 아이콘+라벨의 부드러운 원형 항목
/// 한 줄로 둔다.** 그래서 이 위젯도 `ChoiceChip` 대신 원형 아이콘 위에 라벨을 붙인
/// 항목을 가로로 늘어놓는다 — 눌러야 할 곳이 크고, 아이콘이 태그를 글자 없이도
/// 구분해 준다.
///
/// **지금은 [PostTopic]으로 채운다.** 사용자가 원한 것은 `SpotCategory` 줄이지만
/// 서버 피드는 `topic: PostTopic`만 받고 `nearbyPosts`/`targetPosts`에 category 인자도,
/// `Post`에 category 필드도 없다. 서버가 그 인자를 열면 **이 파일 하나만** 데이터
/// 출처를 바꾸면 되도록 항목 생성을 여기에 가둬 두었다([_entries]).
/// 서버 작업이 필요한 사항이며 [AMEND] 대상이다.
///
/// 단일 선택이다. 선택된 항목을 다시 누르면 전체([selected]가 null)로 돌아간다.
/// 언어별 길이 차이에 대비해 고정 폭을 두지 않는다(디자인 §8).
class TopicChipRow extends StatelessWidget {
  const TopicChipRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  /// 지금 선택된 태그. null이면 "전체" 항목이 선택 상태다.
  final PostTopic? selected;

  final ValueChanged<PostTopic?> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 88,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: <Widget>[
          _Entry(
            icon: Icons.grid_view_rounded,
            label: l10n.communityTopicAll,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final PostTopic topic in PostTopic.values)
            _Entry(
              icon: _iconFor(topic),
              label: postTopicLabel(l10n, topic),
              selected: selected == topic,
              // 같은 항목을 다시 누르면 해제 — 전체로 돌아간다.
              onTap: () => onSelected(selected == topic ? null : topic),
            ),
        ],
      ),
    );
  }

  /// 태그별 아이콘. 라벨이 번역돼도 모양은 그대로라 언어를 바꿔도 같은 자리를
  /// 찾을 수 있다.
  IconData _iconFor(PostTopic topic) => switch (topic) {
    PostTopic.question => Icons.help_outline_rounded,
    PostTopic.tip => Icons.lightbulb_outline_rounded,
    PostTopic.review => Icons.rate_review_outlined,
    PostTopic.companion => Icons.groups_outlined,
    PostTopic.photo => Icons.photo_camera_outlined,
  };
}

/// 항목 하나 — 원형 아이콘 + 그 아래 라벨.
///
/// 선택 상태는 원의 채움색과 라벨 굵기로만 나타낸다. 테두리를 두르면 당근의
/// 납작한 느낌이 사라진다.
class _Entry extends StatelessWidget {
  const _Entry({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color background = selected
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    final Color foreground = selected
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: SizedBox(
          // 라벨이 길어도 항목 폭이 흔들리지 않도록 상한만 둔다. 고정 폭이 아니라
          // 상한이라 짧은 언어에서는 좁게 붙는다.
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: foreground),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
