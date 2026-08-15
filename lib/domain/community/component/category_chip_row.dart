import 'package:flutter/material.dart';

import '../../../common/category/category_bar.dart';
import '../../../common/category/category_chip_data.dart';
import '../../../common/category/spot_category_icon.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../common/model/target_category.dart';
import 'community_labels.dart';

/// 상단 카테고리 줄(당근 동네생활의 상단 진입 줄을 따른다).
///
/// **모양은 공용 [CategoryBar]가 그린다**(사용자 결정, 2026-08-15). 원래 이 위젯의
/// 디자인이 앱 전체의 기준이 되면서, spot 쪽 바가 여기 모양으로 맞춰졌고 이쪽은
/// 그 공용 위젯을 다시 쓴다 — 같은 모양이 두 벌 남으면 한쪽만 고쳐 갈라진다.
///
/// **항목 구성은 서버가 정한다** — `communityChips`가 어떤 카테고리를 쓸지 내려주고
/// 앱은 표시 문구만 매핑한다(가이드 §2). 다만 **순서는 서버가 정하지 않는다**:
/// 서버는 코드 알파벳순 배열을 줄 뿐이라 언어를 바꾸면 같은 칩이 다른 자리로 간다.
/// 표시 순서는 [CategoryBar]가 `kCategoryDisplayOrder`로 고정한다 — 사용자가 자리로
/// 기억하는 줄이라 spot 쪽 바와 같은 순서여야 한다. 그 목록에 없는 코드도 버리지 않고
/// 줄 끝에 붙는다.
///
/// **[chips]가 비어도 정상이다.** 구성이 없는 앱이면 서버가 빈 목록을 준다 — 그때는
/// "전체" 하나만 남는 것이 아니라 **줄 자체를 그리지 않는다**([CategoryBar]가 빈
/// 목록을 그렇게 접는다): 고를 것이 하나뿐인 필터 줄은 자리만 차지한다.
///
/// **다중 선택이다**(서버 #77, 2026-08-16). 서버 `posts`가 복수 `categories`를 받게
/// 되면서 spot 쪽 바와 동작까지 같아졌다 — 그 전까지는 서버가 하나만 받아 모양만
/// 같고 동작은 단일 선택이었다.
///
/// **빈 선택이 "전체"다.** 마지막 칩을 꺼도 막지 않고 "전체"가 저절로 켜진다. 서버에는
/// 그때 `categories` 인자를 보내지 않는다(빈 배열은 거절된다) — 접는 일은 리포지토리가
/// 맡는다.
class CategoryChipRow extends StatelessWidget {
  const CategoryChipRow({
    super.key,
    required this.chips,
    required this.selected,
    required this.onToggle,
    required this.onSelectAll,
  });

  final List<TargetCategory> chips;

  /// 지금 켜진 카테고리. 비어 있으면 "전체" 항목이 선택 상태다.
  final Set<TargetCategory> selected;

  /// 개별 칩을 누를 때. 켜기·끄기 판단은 호출부(provider)가 한다.
  final ValueChanged<TargetCategory> onToggle;

  /// "전체"를 누를 때. 개별 선택을 전부 푼다.
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return CategoryBar(
      available: <CategoryChipData>[
        for (final TargetCategory chip in chips)
          CategoryChipData(
            id: chip.code,
            label: targetCategoryLabel(l10n, chip),
            // 아이콘은 코드 기준 공용 매핑을 쓴다 — 예전에는 이 파일이 같은 모양의
            // switch를 따로 들고 있었고, 두 벌이 갈리면 같은 카테고리가 화면마다
            // 다른 아이콘으로 보인다.
            icon: spotCategoryIcon(chip.code),
          ),
      ],
      selectedIds: selected.map((TargetCategory c) => c.code).toSet(),
      // **커뮤니티 자기 키를 쓴다.** 공용 `categoryAll`과 문구가 같더라도, 이 키는
      // 커뮤니티가 소유하고 다른 화면에서도 쓰이고 있다.
      allLabel: l10n.communityCategoryAll,
      // 바가 돌려주는 id는 늘 위에서 실어 보낸 값이라 대응이 있다. 그래도 모르는
      // 코드는 조용히 무시한다 — 서버가 enum을 늘렸을 때 탭 한 번에 앱이 죽지 않게.
      onToggle: (String code) {
        final TargetCategory? next = TargetCategory.fromCode(code);
        if (next != null) onToggle(next);
      },
      onSelectAll: onSelectAll,
    );
  }
}
