import 'package:flutter/material.dart';

import 'spot_category.dart';
import 'spot_category_icon.dart';

/// 상단 카테고리 바(spec §5). 서버가 준 [available] 목록만 렌더한다 — 서버가
/// 가용성의 단일 출처라 클라이언트는 없는 카테고리를 하드코딩하지 않는다.
///
/// **목록을 provider에서 직접 읽지 않고 인자로 받는다.** 이 위젯은 spot과 지도가
/// 함께 쓰므로 `common/`에 있는데(CLAUDE.md §4), 여기서 `availableSpotCategories`를
/// watch하면 common이 도메인 provider(→ `SpotRepository`)에 의존하게 되어 의존
/// 방향이 뒤집힌다. 목록을 읽는 일은 화면이 맡고, 이 위젯은 그리기만 한다.
///
/// **다중 선택이다**(R1·R2). 여러 칩을 동시에 켤 수 있고, 켜진 칩을 다시 누르면
/// 꺼진다. "전체 보기" 칩은 제거됐다 — 선택 집합이 비어 있을 수 없게 되어(R2)
/// `null`이 뜻할 것이 없다.
///
/// **마지막 하나는 꺼지지 않는다**(AC3.1). 그 규칙은 위젯이 아니라 provider의
/// `toggle`에 있다 — 아무것도 선택되지 않은 화면은 사용자가 되돌릴 방법이 없는
/// 막다른 상태이고, 서버도 빈 배열을 거절한다. 위젯은 눌린 사실만 전달한다.
///
/// 라벨은 **서버가 준 [SpotCategory.label]**이다(R11). `spotCategoryLabel()`과
/// `discoverCategory*` arb 키는 제거됐다 — 서버가 카테고리를 추가해도 앱 업데이트
/// 없이 라벨이 따라와야 하기 때문이다(AC1.3).
///
/// **선택 상태는 화면이 준다**([selected]·[onToggle]). Discover 스와이프·좋아요
/// 목록·검색·지도가 같은 바를 쓰지만 선택은 서로 독립이어야 하기 때문이다(R12) —
/// 하나의 provider에 묶으면 좋아요 목록에서 고른 필터가 스와이프 스택까지 갈아치운다.
class CategoryBar extends StatelessWidget {
  const CategoryBar({
    super.key,
    required this.available,
    required this.selected,
    required this.onToggle,
  });

  /// 서버가 준 가용 카테고리. 비어 있으면 바 자체를 그리지 않는다 — 목록이 아직
  /// 오지 않았거나 조회에 실패한 상태이며, 그때 빈 바를 그리면 자리만 차지한다.
  final List<SpotCategory> available;

  /// 현재 선택된 카테고리 집합. 비어 있지 않다(목록이 오기 전 첫 프레임 제외).
  final Set<SpotCategory> selected;

  /// 칩을 누를 때 호출된다. 켜기·끄기 판단은 provider의 `toggle`이 한다.
  final ValueChanged<SpotCategory> onToggle;

  /// 표시 순서. **기본 카테고리(관광지)를 맨 앞에 두고** 나머지는 서버 순서를
  /// 유지한다(사용자 결정, 2026-08-15).
  ///
  /// 서버는 `code` 알파벳순으로 주는데, 그러면 한글 라벨에서는 순서가 무작위로
  /// 보이고 무엇보다 **기본 선택된 칩이 목록 한가운데** 놓인다(맛집·쇼핑·관광지·
  /// 여행코스). 처음 보는 칩이 기본 선택과 일치해야 화면이 설명된다.
  ///
  /// **선택 여부로 정렬하지 않는다.** 고른 것을 앞으로 모으면 누를 때마다 칩이
  /// 자리를 옮겨, 연달아 고르는 동안 방금 누른 칩이 손가락 아래에서 사라진다.
  /// 순서는 선택과 무관하게 고정이다.
  List<SpotCategory> get _ordered {
    final int i = available.indexWhere(
      (SpotCategory c) => c.code == kDefaultSpotCategoryCode,
    );
    if (i <= 0) return available; // 없거나 이미 첫 번째면 그대로.
    return <SpotCategory>[
      available[i],
      ...available.where((SpotCategory c) => c.code != kDefaultSpotCategoryCode),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 카테고리 목록 자체가 로딩/실패면 바를 접는다(카드 흐름을 막지 않음).
    if (available.isEmpty) return const SizedBox.shrink();

    final List<SpotCategory> ordered = _ordered;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ordered.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) {
          final SpotCategory category = ordered[index];
          return _CategoryChip(
            label: category.label,
            icon: spotCategoryIcon(category.code),
            selected: selected.contains(category),
            onTap: () => onToggle(category),
          );
        },
      ),
    );
  }
}

/// 칩 하나.
///
/// **`ChoiceChip`이 아니라 `FilterChip`이다.** M3에서 `ChoiceChip`은 "여럿 중 하나"를,
/// `FilterChip`은 "여러 개를 걸러낸다"를 뜻한다 — 다중 선택이 된 이상 의미가 맞는
/// 쪽을 쓴다. 접근성 트리에도 그대로 반영돼, 스크린 리더가 단일 선택으로 읽지 않는다.
///
/// 선택 시 아이콘 자리에 체크가 들어간다(`showCheckmark` 기본값) — 색만으로 상태를
/// 알리지 않아야 색각 이상에서도 구분된다.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilterChip(
        label: Text(label),
        // 선택되면 체크가 아이콘 자리를 차지하므로 아이콘은 비선택일 때만 그린다 —
        // 둘을 함께 두면 칩이 언어에 따라 과하게 길어진다.
        avatar: selected ? null : Icon(icon, size: 18),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
