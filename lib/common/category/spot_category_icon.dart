import 'package:flutter/material.dart';

import 'category_chip_data.dart';
import 'spot_category.dart';

/// 카테고리 코드 → Material 아이콘(SPEC-0020 R11).
///
/// 서버 `iconUrl`이 현재 전 카테고리 null이라 **이 매핑이 실제로 쓰이는 경로**다.
/// `iconUrl`이 생기면 그쪽이 우선하고, 로딩에 실패해도 여기로 떨어진다(AC11.6).
///
/// **exhaustive switch가 아니다.** 기본값이 있는 조회로 두어야 서버가 카테고리를
/// 추가해도 앱이 깨지지 않는다(AC1.3·AC11.5) — 이 매핑은 유효성 검사가 아니라
/// "아는 것을 예쁘게 그리는" 최적화다.
///
/// 9종은 전체 집합이며 한 언어에 다 나오지 않는다 — 언어당 8종(공통 7 + KO
/// `TRAVEL_COURSE` / 비KO `TRANSPORT`). 언어 전환 시 양쪽이 나타나므로 모두 둔다.
const Map<String, IconData> _iconByCode = <String, IconData>{
  'TOURIST_SPOT': Icons.photo_camera_outlined,
  'CULTURAL_FACILITY': Icons.museum_outlined,
  'FESTIVAL_EVENT': Icons.celebration_outlined,
  'TRAVEL_COURSE': Icons.route_outlined,
  'LEISURE_SPORTS': Icons.hiking_outlined,
  'LODGING': Icons.hotel_outlined,
  'SHOPPING': Icons.shopping_bag_outlined,
  'RESTAURANT': Icons.restaurant_outlined,
  'TRANSPORT': Icons.directions_subway_outlined,
};

/// 모르는 코드가 떨어지는 중립 아이콘(AC11.5).
const IconData _fallbackIcon = Icons.place_outlined;

/// [code]에 대응하는 아이콘. 매핑에 없으면 중립 기본값이다.
IconData spotCategoryIcon(String code) => _iconByCode[code] ?? _fallbackIcon;

/// [SpotCategory]를 [CategoryBar]의 표시 모델로 옮긴다.
///
/// 라벨은 **서버가 준 [SpotCategory.label]**이다(R11) — 서버가 카테고리를 추가해도
/// 앱 업데이트 없이 라벨이 따라와야 하기 때문이다(AC1.3).
List<CategoryChipData> spotCategoryChips(List<SpotCategory> categories) =>
    <CategoryChipData>[
      for (final SpotCategory c in categories)
        CategoryChipData(
          id: c.code,
          label: c.label,
          icon: spotCategoryIcon(c.code),
        ),
    ];
