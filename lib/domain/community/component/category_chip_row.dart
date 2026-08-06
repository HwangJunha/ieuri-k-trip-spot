import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/community_chip.dart';
import '../model/target_category.dart';
import 'community_labels.dart';

/// 상단 카테고리 줄(당근 동네생활의 상단 진입 줄을 따른다).
///
/// **항목 구성은 서버가 정한다** — `communityChips`가 카테고리와 순서를 내려주고
/// (이미 `position` 오름차순으로 정렬돼 있다) 앱은 표시 문구만 매핑한다(가이드 §2).
/// 언어마다 가용 카테고리가 다르므로 클라이언트가 전체 목록을 하드코딩하면 안 된다.
///
/// **[chips]가 비어도 정상이다.** 구성이 없는 앱이면 서버가 빈 목록을 준다 — 그때는
/// "전체" 하나만 남는 것이 아니라 **줄 자체를 그리지 않는다**: 고를 것이 하나뿐인
/// 필터 줄은 자리만 차지한다.
///
/// 단일 선택이다. 선택된 항목을 다시 누르면 전체([selected]가 null)로 돌아간다.
/// 언어별 길이 차이에 대비해 고정 폭을 두지 않는다(폭 상한 + ellipsis).
class CategoryChipRow extends StatelessWidget {
  const CategoryChipRow({
    super.key,
    required this.chips,
    required this.selected,
    required this.onSelected,
  });

  final List<CommunityChip> chips;

  /// 지금 선택된 카테고리. null이면 "전체" 항목이 선택 상태다.
  final TargetCategory? selected;

  final ValueChanged<TargetCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    final AppLocalizations l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 88,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: <Widget>[
          _Entry(
            icon: Icons.grid_view_rounded,
            label: l10n.communityCategoryAll,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final CommunityChip chip in chips)
            _Entry(
              icon: _iconFor(chip.category),
              label: targetCategoryLabel(l10n, chip.category),
              selected: selected == chip.category,
              // 같은 항목을 다시 누르면 해제 — 전체로 돌아간다.
              onTap: () =>
                  onSelected(selected == chip.category ? null : chip.category),
            ),
        ],
      ),
    );
  }

  /// 카테고리별 아이콘. 라벨이 번역돼도 모양은 그대로라 언어를 바꿔도 같은 자리를
  /// 찾을 수 있다.
  IconData _iconFor(TargetCategory category) => switch (category) {
    TargetCategory.touristSpot => Icons.photo_camera_outlined,
    TargetCategory.culturalFacility => Icons.museum_outlined,
    TargetCategory.festivalEvent => Icons.celebration_outlined,
    TargetCategory.travelCourse => Icons.route_outlined,
    TargetCategory.leisureSports => Icons.hiking_outlined,
    TargetCategory.lodging => Icons.hotel_outlined,
    TargetCategory.shopping => Icons.shopping_bag_outlined,
    TargetCategory.restaurant => Icons.restaurant_outlined,
    TargetCategory.transport => Icons.directions_subway_outlined,
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
