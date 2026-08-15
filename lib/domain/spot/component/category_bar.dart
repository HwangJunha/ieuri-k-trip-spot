import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/spot_category.dart';
import '../provider/swipe_providers.dart';

/// 상단 카테고리 바(spec §5). `availableSpotCategories` 결과만 렌더한다 — 서버가
/// 가용성의 단일 출처라 클라이언트는 없는 카테고리를 하드코딩하지 않는다.
///
/// **아직 단일 선택이다.** SPEC-0020 2단계에서 다중 선택으로 바뀌며, 지금은 1단계
/// (모델 전환)만 반영해 새 타입에 맞춰 두었다. "전체 보기" 칩은 이미 제거됐다 —
/// 선택 집합이 비어 있을 수 없게 되어(R2) `null`이 뜻할 것이 없다.
///
/// 라벨은 **서버가 준 [SpotCategory.label]**이다(R11). `spotCategoryLabel()`과
/// `discoverCategory*` arb 키는 제거됐다 — 서버가 카테고리를 추가해도 앱 업데이트
/// 없이 라벨이 따라와야 하기 때문이다(AC1.3).
///
/// **선택 상태는 화면이 준다**([selected]·[onSelected]). Discover 스와이프·좋아요
/// 목록·검색이 같은 바를 쓰지만 선택은 서로 독립이어야 하기 때문이다(R12) — 하나의
/// provider에 묶으면 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치운다.
class CategoryBar extends ConsumerWidget {
  const CategoryBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  /// 현재 선택된 카테고리 집합. 지금은 원소가 최대 하나다(단일 선택).
  final Set<SpotCategory> selected;

  /// 칩을 고를 때 호출된다. 고른 카테고리를 그대로 넘긴다.
  final ValueChanged<SpotCategory> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SpotCategory>> categories = ref.watch(
      availableSpotCategoriesProvider,
    );

    // 카테고리 목록 자체가 로딩/실패면 바를 접는다(카드 흐름을 막지 않음).
    final List<SpotCategory> available = categories.value ?? const [];
    if (available.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: available.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          final SpotCategory category = available[index];
          return _CategoryChip(
            label: category.label,
            selected: selected.contains(category),
            onTap: () => onSelected(category),
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
