import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_category.dart';
import '../provider/swipe_providers.dart';
import 'spot_display.dart';

/// 상단 카테고리 바(spec §5). `availableSpotCategories` 결과만 렌더한다 — 서버가
/// 가용성의 단일 출처라 클라이언트는 없는 카테고리를 하드코딩하지 않는다. 첫 칩은
/// "전체"(선택 없음).
class CategoryBar extends ConsumerWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<SpotCategory>> categories = ref.watch(
      availableSpotCategoriesProvider,
    );
    final SpotCategory? selected = ref.watch(selectedSpotCategoryProvider);

    // 카테고리 목록 자체가 로딩/실패면 바를 접는다(카드 흐름을 막지 않음).
    final List<SpotCategory> available = categories.value ?? const [];
    if (available.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: available.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _CategoryChip(
              label: l10n.viewAll,
              selected: selected == null,
              onTap: () =>
                  ref.read(selectedSpotCategoryProvider.notifier).select(null),
            );
          }
          final SpotCategory category = available[index - 1];
          return _CategoryChip(
            label: spotCategoryLabel(l10n, category),
            selected: selected == category,
            onTap: () => ref
                .read(selectedSpotCategoryProvider.notifier)
                .select(category),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
