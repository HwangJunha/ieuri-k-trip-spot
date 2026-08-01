import 'package:flutter/material.dart';

/// 스와이프 카드마다 붙는 최소 저작권 출처 표기(AC-21). 서버가 준 [attributionText]는
/// 이미 "출처: 한국관광공사(...)"처럼 완성된 출처 문구라 그대로 렌더한다(클라이언트가
/// 접두사를 덧붙이면 "출처 · 출처:"로 중복된다). 표준 문구 전문·링크는 별도 저작권
/// 정보 화면 몫이라 여기선 담지 않는다(spec §6).
class CopyrightBadge extends StatelessWidget {
  const CopyrightBadge({super.key, required this.attributionText});

  final String attributionText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.scrim.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          attributionText,
          style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
