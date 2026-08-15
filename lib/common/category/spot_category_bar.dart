import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import 'category_bar.dart';
import 'category_chip_data.dart';
import 'spot_category.dart';
import 'spot_category_icon.dart';

/// [SpotCategory]를 다루는 화면용 [CategoryBar] 어댑터.
///
/// 네 화면(Discover·좋아요·검색·지도)이 같은 변환을 반복하지 않도록 여기 한 번만
/// 적는다 — `SpotCategory` 목록을 [CategoryChipData]로 옮기고, 눌린 id를 다시
/// `SpotCategory`로 되돌려 준다.
///
/// **되돌릴 때 [available]에서 찾는 이유**: `SpotCategory.ofCode`로 만들면 라벨이
/// 코드 문자열로 채워진 인스턴스가 선택 집합에 들어간다. 동등성은 코드만 보므로
/// 필터 동작은 같지만, 나중에 선택 집합에서 라벨을 읽는 자리가 생기면 코드가
/// 그대로 화면에 뜬다. 목록에 있는 진짜 인스턴스를 넘기는 편이 안전하다.
///
/// "전체" 문구는 공용 키([AppLocalizations.categoryAll])다 — 커뮤니티가 자기
/// `communityCategoryAll`을 계속 쓰므로 그 키를 빌리지 않는다.
class SpotCategoryBar extends StatelessWidget {
  const SpotCategoryBar({
    super.key,
    required this.available,
    required this.selected,
    required this.onToggle,
    required this.onSelectAll,
  });

  /// 서버가 준 가용 카테고리. 비어 있으면 바를 그리지 않는다.
  final List<SpotCategory> available;

  /// 지금 켜진 카테고리. 비어 있으면 "전체"다.
  final Set<SpotCategory> selected;

  final ValueChanged<SpotCategory> onToggle;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) => CategoryBar(
    available: spotCategoryChips(available),
    selectedIds: selected.map((SpotCategory c) => c.code).toSet(),
    allLabel: AppLocalizations.of(context).categoryAll,
    onToggle: (String code) => onToggle(
      available.firstWhere(
        (SpotCategory c) => c.code == code,
        orElse: () => SpotCategory.ofCode(code),
      ),
    ),
    onSelectAll: onSelectAll,
  );
}
