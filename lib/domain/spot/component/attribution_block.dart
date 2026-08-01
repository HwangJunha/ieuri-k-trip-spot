import 'package:flutter/material.dart';

/// 저작권 표준 문구 전문 블록(AC-28, SPEC-0002가 이 스펙에 넘긴 의무). 서버가 언어별로
/// 내려준 [attributionText] 전문을 그대로 노출한다 — 클라이언트는 문구를 만들지 않는다
/// (POL-024). 카드의 [CopyrightBadge]가 한 줄 요약이라면 이건 전문 노출용이다.
class AttributionBlock extends StatelessWidget {
  const AttributionBlock({super.key, required this.attributionText});

  final String attributionText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.copyright_outlined,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                attributionText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
