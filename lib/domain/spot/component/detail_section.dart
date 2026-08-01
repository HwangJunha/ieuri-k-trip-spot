import 'package:flutter/material.dart';

/// 상세 화면의 제목 있는 섹션(SPEC-0003 §3). 제목 + 임의의 [child]를 세로로 쌓는다.
///
/// 이 위젯 자체는 "값 없으면 숨김"을 알지 못한다 — 호출부가 값이 있을 때만 렌더한다
/// (AC-25: 빈 라벨/placeholder 금지). 섹션 껍데기만 일관되게 제공한다.
class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
