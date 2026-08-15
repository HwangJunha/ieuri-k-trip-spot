import 'package:flutter/material.dart';

/// [CategoryBar]가 칩 하나를 그리는 데 필요한 것 전부(SPEC-0020 후속, 2026-08-15).
///
/// **바가 도메인 타입을 알지 않게 하는 장치다.** 같은 바를 spot(`SpotCategory` —
/// 라벨을 서버가 준다)과 커뮤니티(`TargetCategory` — 라벨을 l10n이 준다)가 함께
/// 쓰는데, `common/`은 어느 쪽 타입도 import할 수 없다(CLAUDE.md §3·§4). 그래서
/// 호출부가 자기 타입을 이 표시 모델로 옮겨 넘긴다.
///
/// [id]는 안정 식별자다. 선택 판정과 표시 순서가 전부 이 값으로 이뤄지며, spot은
/// `SpotCategory.code`를, 커뮤니티는 `TargetCategory`의 서버 코드를 싣는다 —
/// 두 도메인이 같은 문자열을 쓰는 것은 우연이 아니라 서버가 같은 코드 체계를
/// 쓰기 때문이고, 그래서 [kCategoryDisplayOrder] 하나로 양쪽이 정렬된다.
@immutable
class CategoryChipData {
  const CategoryChipData({
    required this.id,
    required this.label,
    required this.icon,
  });

  /// 안정 식별자(`TOURIST_SPOT` 등).
  final String id;

  /// 표시 문구. 어디서 왔는지는 호출부의 사정이다.
  final String label;

  /// 원형 아이콘.
  final IconData icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryChipData &&
          other.id == id &&
          other.label == label &&
          other.icon == icon);

  @override
  int get hashCode => Object.hash(id, label, icon);
}

/// 칩의 고정 표시 순서(사용자 결정, 2026-08-15).
///
/// 전체 → 관광지 → 문화시설 → 축제·공연 → 맛집 → 쇼핑 → 여행코스 → 레포츠 → 숙박.
/// ("전체"는 목록이 아니라 바가 늘 맨 앞에 직접 그린다.)
///
/// **서버 순서를 쓰지 않는 이유.** 서버는 `code` 알파벳순으로 주는데, 그러면 한글
/// 라벨에서 순서가 무작위로 보이고 언어를 바꿀 때마다 같은 칩이 다른 자리로 간다.
/// 사용자가 자리로 기억하는 줄이라 순서는 언어와 무관하게 고정이어야 한다.
///
/// **여기에 없는 코드도 그린다.** 서버는 앱 업데이트 없이 카테고리를 늘릴 수 있으므로
/// (AC1.3) 모르는 코드는 버리지 않고 목록 끝에 서버가 준 순서 그대로 덧붙인다 —
/// 이 목록은 유효성 검사가 아니라 "아는 것을 보기 좋게 놓는" 정렬 규칙이다.
/// `TRANSPORT`는 사용자가 지정한 순서에 없어(비KO 언어에만 나온다) 아는 것 중 맨
/// 뒤에 둔다.
///
/// **선택 여부로 정렬하지 않는다.** 고른 것을 앞으로 모으면 누를 때마다 칩이 자리를
/// 옮겨, 연달아 고르는 동안 방금 누른 칩이 손가락 아래에서 사라진다.
const List<String> kCategoryDisplayOrder = <String>[
  'TOURIST_SPOT',
  'CULTURAL_FACILITY',
  'FESTIVAL_EVENT',
  'RESTAURANT',
  'SHOPPING',
  'TRAVEL_COURSE',
  'LEISURE_SPORTS',
  'LODGING',
  'TRANSPORT',
];

/// [chips]를 [kCategoryDisplayOrder]대로 재배열한다. 목록에 없는 id는 서로의 상대
/// 순서를 유지한 채 뒤에 붙는다.
///
/// `sort`가 아니라 **훑어 담기**로 구현한다 — Dart의 `List.sort`는 안정 정렬이
/// 아니라서 모르는 코드끼리의 순서가 보장되지 않고, 그러면 같은 목록을 다시 그릴
/// 때 칩이 이유 없이 자리를 바꿀 수 있다.
List<CategoryChipData> orderedCategoryChips(List<CategoryChipData> chips) {
  final List<CategoryChipData> known = <CategoryChipData>[
    for (final String id in kCategoryDisplayOrder)
      ...chips.where((CategoryChipData c) => c.id == id),
  ];
  final Set<String> placed = known.map((CategoryChipData c) => c.id).toSet();
  return <CategoryChipData>[
    ...known,
    ...chips.where((CategoryChipData c) => !placed.contains(c.id)),
  ];
}
