import 'package:flutter/material.dart';

import '../../../common/category/category_bar.dart';
import '../../../common/category/category_chip_data.dart';
import '../../../common/category/spot_category_icon.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/community_chip.dart';
import '../../../common/model/target_category.dart';
import 'community_labels.dart';

/// 상단 카테고리 줄(당근 동네생활의 상단 진입 줄을 따른다).
///
/// **모양은 공용 [CategoryBar]가 그린다**(사용자 결정, 2026-08-15). 원래 이 위젯의
/// 디자인이 앱 전체의 기준이 되면서, spot 쪽 바가 여기 모양으로 맞춰졌고 이쪽은
/// 그 공용 위젯을 다시 쓴다 — 같은 모양이 두 벌 남으면 한쪽만 고쳐 갈라진다.
///
/// **항목 구성은 서버가 정한다** — `communityChips`가 카테고리와 순서를 내려주고
/// 앱은 표시 문구만 매핑한다(가이드 §2). 다만 **표시 순서는 앱이 고정한다**
/// (`kCategoryDisplayOrder`): 사용자가 자리로 기억하는 줄이라 spot 쪽 바와 같은
/// 순서여야 하고, 서버 `position`을 따르면 두 화면의 순서가 갈린다.
///
/// **[chips]가 비어도 정상이다.** 구성이 없는 앱이면 서버가 빈 목록을 준다 — 그때는
/// "전체" 하나만 남는 것이 아니라 **줄 자체를 그리지 않는다**([CategoryBar]가 빈
/// 목록을 그렇게 접는다): 고를 것이 하나뿐인 필터 줄은 자리만 차지한다.
///
/// **단일 선택이다.** spot 쪽 바는 다중 선택이지만 커뮤니티 피드는 카테고리 하나만
/// 받는다 — 서버 계약이 그렇고, 이 통일은 모양에 관한 것이지 동작에 관한 것이 아니다.
/// 선택된 항목을 다시 누르면 "전체"([selected]가 null)로 돌아간다.
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
    final AppLocalizations l10n = AppLocalizations.of(context);
    return CategoryBar(
      available: <CategoryChipData>[
        for (final CommunityChip chip in chips)
          CategoryChipData(
            id: _codeOf(chip.category),
            label: targetCategoryLabel(l10n, chip.category),
            // 아이콘은 코드 기준 공용 매핑을 쓴다 — 예전에는 이 파일이 같은 모양의
            // switch를 따로 들고 있었고, 두 벌이 갈리면 같은 카테고리가 화면마다
            // 다른 아이콘으로 보인다.
            icon: spotCategoryIcon(_codeOf(chip.category)),
          ),
      ],
      selectedIds: selected == null
          ? const <String>{}
          : <String>{_codeOf(selected!)},
      // **커뮤니티 자기 키를 쓴다.** 공용 `categoryAll`과 문구가 같더라도, 이 키는
      // 커뮤니티가 소유하고 다른 화면에서도 쓰이고 있다.
      allLabel: l10n.communityCategoryAll,
      // 단일 선택이라 누른 것 하나만 남기고, 같은 것을 다시 누르면 해제한다.
      onToggle: (String code) {
        final TargetCategory next = _categoryOf(code);
        onSelected(selected == next ? null : next);
      },
      onSelectAll: () => onSelected(null),
    );
  }

  /// [TargetCategory] → 서버 코드. [CategoryChipData.id]와 표시 순서가 이 값을 쓴다.
  ///
  /// spot의 `SpotCategory.code`와 같은 문자열이다 — 서버가 두 도메인에 같은 코드
  /// 체계를 쓰기 때문이며, 그래서 아이콘 매핑과 표시 순서를 함께 쓸 수 있다.
  /// 타입을 합치지는 않는다(두 도메인의 계약이 다르다, `target_category.dart`).
  static String _codeOf(TargetCategory category) => switch (category) {
    TargetCategory.touristSpot => 'TOURIST_SPOT',
    TargetCategory.culturalFacility => 'CULTURAL_FACILITY',
    TargetCategory.festivalEvent => 'FESTIVAL_EVENT',
    TargetCategory.travelCourse => 'TRAVEL_COURSE',
    TargetCategory.leisureSports => 'LEISURE_SPORTS',
    TargetCategory.lodging => 'LODGING',
    TargetCategory.shopping => 'SHOPPING',
    TargetCategory.restaurant => 'RESTAURANT',
    TargetCategory.transport => 'TRANSPORT',
  };

  /// [_codeOf]의 역방향. 바가 돌려주는 id는 늘 위에서 실어 보낸 값이라 대응이 있다.
  static TargetCategory _categoryOf(String code) => TargetCategory.values
      .firstWhere((TargetCategory c) => _codeOf(c) == code);
}
