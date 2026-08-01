import 'package:flutter/material.dart';

import '../model/spot_info_item.dart';

/// 이용안내 항목들(SPEC-0003). 항목명 + 내용을 위아래로 쌓는다 — 내용이 길고 줄바꿈이
/// 흔해서 운영 정보처럼 라벨/값을 가로로 두지 않는다.
///
/// 표시 대상 판단은 호출부(모델의 `presentInfoItems`)가 하고, 이 위젯은 받은 [items]를
/// 그리기만 한다. 다만 항목명·내용 각각은 한쪽만 비어 있을 수 있어 그때는 그 줄만 뺀다.
class SpotInfoItemList extends StatelessWidget {
  const SpotInfoItemList({super.key, required this.items});

  final List<SpotInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 값이 같은 항목이 두 번 올 수 있어(TourAPI 중복) 값 비교가 아니라 인덱스로
        // 첫 항목을 가른다 — `item != items.first`면 중복 항목의 간격이 사라진다.
        for (int i = 0; i < items.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: 12),
          _InfoItem(item: items[i]),
        ],
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.item});

  final SpotInfoItem item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // 다듬기·빈 값 판단은 모델이 한다 — 위젯은 그리기만.
    final String name = item.displayName;
    final String text = item.displayText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (name.isNotEmpty)
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        if (name.isNotEmpty && text.isNotEmpty) const SizedBox(height: 2),
        if (text.isNotEmpty)
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
