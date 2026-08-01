import 'package:flutter/material.dart';

/// 저작권 표준 문구 전문 블록(AC-28, SPEC-0002가 이 스펙에 넘긴 의무). 서버가 언어별로
/// 내려준 [attributionText] 전문을 그대로 노출한다 — 클라이언트는 문구를 만들지 않는다
/// (POL-024). 카드의 [CopyrightBadge]가 한 줄 요약이라면 이건 전문 노출용이다.
///
/// 갤러리 이미지가 항목과 **다른** 출처를 가지면 그 문구도 여기에 덧붙인다
/// ([imageAttributions]). 이미지 위에 배지를 얹지 않고도 이미지별 저작권이 반영되게
/// 하는 자리다(AC-28). 항목 문구와 같은 값은 중복이라 호출부에서 걸러 넘긴다.
class AttributionBlock extends StatelessWidget {
  const AttributionBlock({
    super.key,
    required this.attributionText,
    this.imageAttributions = const <String>[],
  });

  final String attributionText;

  /// 항목 문구와 다른 이미지별 출처 문구(중복 제거된 목록). 비면 렌더하지 않는다.
  final List<String> imageAttributions;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    attributionText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  // 이미지별 출처가 항목과 다르면 이어서 노출한다(AC-28).
                  for (final String text in imageAttributions) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
