import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/post_topic.dart';
import 'post_topic_label.dart';

/// 주제 태그 칩 한 줄(설계 §3, 디자인 §1).
///
/// **필터 UI는 이 한 줄이 전부다** — 정렬 선택도, 추가 필터도, 상단 탭도, 검색창도
/// 두지 않는다. 상태는 "선택된 topic (없을 수 있음)" 하나뿐이며, 탐색 타일에서
/// 진입해도 같은 상태에 반영되어 여기 칩이 선택된 것처럼 보인다(R11-3).
///
/// 단일 선택이다. 선택된 칩을 다시 누르면 전체([selected]가 null)로 돌아간다.
/// 언어별 길이 차이에 대비해 고정 폭을 두지 않는다(디자인 §8).
class TopicChipRow extends StatelessWidget {
  const TopicChipRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  /// 지금 선택된 태그. null이면 "전체" 칩이 선택 상태다.
  final PostTopic? selected;

  final ValueChanged<PostTopic?> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          _Chip(
            label: l10n.communityTopicAll,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final PostTopic topic in PostTopic.values)
            _Chip(
              label: postTopicLabel(l10n, topic),
              selected: selected == topic,
              // 같은 칩을 다시 누르면 해제 — 전체로 돌아간다.
              onTap: () => onSelected(selected == topic ? null : topic),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Center(
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    ),
  );
}
