/// 문자열 안에서 질의와 일치한 구간 하나.
///
/// `common/`에 있는 이유는 검색 결과(`domain/spot`)와 장소 선택 시트
/// (`domain/community`)가 같은 강조를 쓰기 때문이다(CLAUDE.md §4).
///
/// 순수 도메인 값이다 — 어느 부분을 강조할지만 정하고, 굵게 그릴지 색을 줄지는
/// 위젯이 정한다(다른 표시 규칙과 같은 분담).
class TextMatch {
  const TextMatch({required this.start, required this.end});

  /// 시작 인덱스(포함).
  final int start;

  /// 끝 인덱스(제외).
  final int end;

  @override
  bool operator ==(Object other) =>
      other is TextMatch && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// [text]에서 [query]와 일치하는 구간을 찾는다(검색 결과 강조용).
///
/// **대소문자를 무시한다.** 한글은 영향이 없지만 영문 제목("Seoul Forest")을
/// 소문자로 검색하는 일이 흔하다.
///
/// **질의를 공백으로 쪼개 각 조각을 따로 찾는다.** "예술 공원"처럼 띄어 친 질의가
/// 붙여 쓴 제목("예술공원로")과 만나면 통째로는 안 걸리는데, 조각으로 보면 둘 다
/// 걸린다. 서버 BM25도 토큰 단위로 맞추므로 표시도 그쪽에 가깝다.
///
/// **서버가 강조 위치를 주지 않으므로 클라이언트가 근사한다.** 그래서 이것은 실제
/// 매칭 근거가 아니라 *보이는 글자가 같은 곳*이다 — 오타 허용이나 형태소 분석으로
/// 걸린 결과는 강조가 안 될 수 있고, 그건 틀린 것이 아니라 한계다.
///
/// 겹치거나 인접한 구간은 하나로 합쳐 돌려준다 — 나누어 두면 굵은 글자 사이에
/// 이음매가 보인다.
List<TextMatch> findTextMatches(String text, String query) {
  final List<String> needles = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((String s) => s.isNotEmpty)
      .toList(growable: false);
  if (needles.isEmpty || text.isEmpty) return const <TextMatch>[];

  final String haystack = text.toLowerCase();
  final List<TextMatch> found = <TextMatch>[];
  for (final String needle in needles) {
    int from = 0;
    while (true) {
      final int at = haystack.indexOf(needle, from);
      if (at < 0) break;
      found.add(TextMatch(start: at, end: at + needle.length));
      // 겹치는 위치까지 훑는다 — "aa"를 "aaa"에서 찾으면 0과 1 둘 다 후보다.
      from = at + 1;
    }
  }
  if (found.isEmpty) return const <TextMatch>[];

  found.sort((TextMatch a, TextMatch b) => a.start.compareTo(b.start));
  final List<TextMatch> merged = <TextMatch>[found.first];
  for (final TextMatch m in found.skip(1)) {
    final TextMatch last = merged.last;
    if (m.start <= last.end) {
      if (m.end > last.end) {
        merged[merged.length - 1] = TextMatch(start: last.start, end: m.end);
      }
    } else {
      merged.add(m);
    }
  }
  return merged;
}
