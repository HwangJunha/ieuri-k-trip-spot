import 'package:flutter/material.dart';

import '../model/text_match.dart';

/// 질의와 일치한 글자를 굵게 그리는 텍스트.
///
/// 검색 결과에서 **왜 이것이 걸렸는지** 보이게 한다 — 제목에 질의가 없고 주소에만
/// 있는 결과가 흔한데, 강조가 없으면 무관해 보인다.
///
/// **강조는 서버가 주는 것이 아니라 클라이언트가 근사한 것이다.** 보이는 글자가 같은
/// 곳만 굵어지므로, 오타 허용이나 형태소 분석으로 걸린 결과는 강조가 없을 수 있다 —
/// 틀린 것이 아니라 한계다(그래서 강조가 없다고 결과를 의심할 필요는 없다).
///
/// 질의가 비었거나 일치가 없으면 그냥 평범한 [Text]와 같다.
class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.maxLines,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final List<TextMatch> matches = findTextMatches(text, query);
    if (matches.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
      );
    }

    final TextStyle bold = (style ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w700,
    );

    final List<InlineSpan> spans = <InlineSpan>[];
    int cursor = 0;
    for (final TextMatch m in matches) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, m.start)));
      }
      spans.add(TextSpan(text: text.substring(m.start, m.end), style: bold));
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: style,
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
    );
  }
}
