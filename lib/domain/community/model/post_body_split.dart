/// 본문을 "제목 줄 + 나머지"로 가르는 순수 함수(SPEC-0010 당근 동네생활 레이아웃).
///
/// **이것은 서버 `Post.title`이 생길 때까지의 대역이다.** 지금 서버 `Post`에는
/// `body: String!`만 있고 제목 필드가 없는데, 당근 동네생활 카드는 굵은 제목 한 줄과
/// 그 아래 본문이라는 위계를 갖는다. 그 위계를 오늘 만들기 위해 본문에서 첫 문장을
/// 떼어내 제목 자리에 놓는다.
///
/// **`Post.title`이 서버에 추가되면 이 파일을 통째로 지운다** — 호출부는 카드
/// 컴포넌트 한 곳뿐이라 `post.title` / `post.body`로 바꾸면 끝난다. 모델 계층에 둔
/// 이유가 그것이다: 위젯에 흩어져 있으면 지울 때 찾아다녀야 한다.
///
/// 서버 작업이 필요한 사항이며 [AMEND] 대상이다(설계 문서의 갭 절 참조).
class PostBodySplit {
  const PostBodySplit({required this.title, required this.rest});

  /// 카드에서 굵게 그릴 첫 줄. 항상 비어 있지 않다(본문이 공백뿐이면 원문 그대로).
  final String title;

  /// 제목 아래에 이어 그릴 나머지. 없으면 빈 문자열이라 호출부가 영역을 미렌더한다.
  final String rest;

  @override
  bool operator ==(Object other) =>
      other is PostBodySplit && other.title == title && other.rest == rest;

  @override
  int get hashCode => Object.hash(title, rest);

  @override
  String toString() => 'PostBodySplit($title | $rest)';
}

/// 제목으로 떼어낼 첫 조각의 최대 길이(코드포인트). 이보다 길면 자르지 않고 **본문
/// 전체를 제목으로 두지도 않는다** — 한 줄짜리 긴 글에서 제목만 세 줄이 되는 것을
/// 막기 위해, 그런 글은 제목 없이 본문으로만 그린다.
const int _maxTitleRunes = 40;

/// 문장 끝으로 인정하는 문자들. 한국어·영어·중국어·일본어 종결부호를 모두 본다.
const String _sentenceEnders = '.!?。！？';

/// [body]를 제목 줄과 나머지로 가른다.
///
/// 가르는 순서는 넷이며, **첫 성공에서 멈춘다**:
///
/// 1. **개행이 있으면 첫 줄이 제목이다.** 사용자가 스스로 나눈 경계라 가장 믿을 만하다.
/// 2. **개행이 없으면 첫 문장이 제목이다** (종결부호 기준).
///    "경복궁은 매주 화요일 휴무예요. 헛걸음하지 마세요" → 앞 문장이 제목.
/// 3. **종결부호가 없으면 첫 이모지가 경계다.** 실제 데이터가 이 모양이 많다 —
///    "청계천 야경 🌃 여름 밤에 발 담그고…" 처럼 이모지가 마침표 노릇을 한다.
///    라이브 시드 9건 중 4건이 여기서만 갈린다.
/// 4. **어느 쪽도 안 되면 제목을 두지 않는다.** 제목이 [_maxTitleRunes]를 넘거나
///    나머지가 비면 위계가 오히려 어색해지므로, 그때는 본문만 그린다.
///
/// 길이 판정은 **코드포인트**로 한다(가이드 §12) — `String.length`(UTF-16)로 세면
/// 이모지가 든 본문에서 서버와 다른 숫자가 나온다.
PostBodySplit splitPostBody(String body) {
  final String trimmed = body.trim();
  if (trimmed.isEmpty) return PostBodySplit(title: body, rest: '');

  // 1) 사용자가 직접 나눈 경계가 있으면 그것을 따른다.
  final int newline = trimmed.indexOf('\n');
  if (newline > 0) {
    final String head = trimmed.substring(0, newline).trim();
    final String tail = trimmed.substring(newline + 1).trim();
    if (head.isNotEmpty && head.runes.length <= _maxTitleRunes) {
      return PostBodySplit(title: head, rest: tail);
    }
    // 첫 줄이 너무 길면 제목으로 쓰지 않는다 — 본문만 그린다.
    return PostBodySplit(title: '', rest: trimmed);
  }

  // 2) 종결부호 기준. 3) 안 되면 이모지 기준. 둘 다 "경계 인덱스"를 돌려준다.
  for (final int end in <int>[
    _firstSentenceEnd(trimmed),
    _firstEmojiBoundary(trimmed),
  ]) {
    if (end <= 0) continue;
    final String head = trimmed.substring(0, end).trim();
    final String tail = trimmed.substring(end).trim();
    // 나머지가 비면 가르는 의미가 없다 — 한 문장짜리 글은 본문으로만 그린다.
    if (head.isNotEmpty &&
        tail.isNotEmpty &&
        head.runes.length <= _maxTitleRunes) {
      return PostBodySplit(title: head, rest: tail);
    }
  }

  // 4) 가를 수 없다. 제목 없이 본문만.
  return PostBodySplit(title: '', rest: trimmed);
}

/// 첫 문장이 끝나는 인덱스(종결부호 **포함**). 없으면 -1.
///
/// 종결부호 뒤에 공백이나 문자열 끝이 와야 문장 경계로 본다 — "3.5km" 같은 소수점이
/// 문장을 가르지 않게 하기 위해서다.
int _firstSentenceEnd(String text) {
  for (int i = 0; i < text.length; i++) {
    if (!_sentenceEnders.contains(text[i])) continue;
    // 종결부호가 연달아 오면(!!, ?!) 마지막까지 삼킨다.
    int j = i;
    while (j + 1 < text.length && _sentenceEnders.contains(text[j + 1])) {
      j++;
    }
    final int next = j + 1;
    if (next >= text.length) return -1; // 문장이 하나뿐 — 가를 것이 없다.
    if (text[next] == ' ' || text[next] == '\n') return next;
  }
  return -1;
}

/// 첫 이모지 뒤의 경계 인덱스(이모지 **포함**). 없으면 -1.
///
/// 캐주얼한 한국어 글에서 이모지는 마침표 자리를 대신한다 — "청계천 야경 🌃 여름
/// 밤에…" 에서 사용자가 읽는 경계는 이모지다. 앞뒤가 공백(또는 문자열 경계)이어야
/// 경계로 보므로, 문장 중간에 박힌 이모지는 가르지 않는다.
///
/// 코드포인트로 순회한다 — UTF-16 코드유닛으로 보면 서로게이트 쌍이 반으로 갈린다.
int _firstEmojiBoundary(String text) {
  final List<int> runes = text.runes.toList(growable: false);
  int index = 0; // 지금까지 지나온 코드유닛 수(= substring 인덱스)
  for (int i = 0; i < runes.length; i++) {
    final int rune = runes[i];
    final int width = rune > 0xFFFF ? 2 : 1;
    if (_isEmoji(rune)) {
      // 이모지가 연달아 오면(🌊🚗) 마지막까지 삼킨다. 변이 선택자·ZWJ도 함께.
      int j = i;
      int end = index + width;
      while (j + 1 < runes.length &&
          (_isEmoji(runes[j + 1]) || _isEmojiJoiner(runes[j + 1]))) {
        j++;
        end += runes[j] > 0xFFFF ? 2 : 1;
      }
      final bool spaceBefore = index == 0 || text[index - 1] == ' ';
      final bool spaceAfter = end >= text.length || text[end] == ' ';
      // 맨 앞의 이모지는 경계가 아니다 — 제목이 비어 버린다.
      if (index > 0 && spaceBefore && spaceAfter) return end;
      i = j;
      index = end;
      continue;
    }
    index += width;
  }
  return -1;
}

/// 표시용 이모지로 볼 코드포인트인지. 정확한 유니코드 분류가 아니라 **본문에서
/// 마침표 노릇을 하는 그림문자**를 잡는 것이 목적이라 주요 블록만 본다.
bool _isEmoji(int rune) =>
    (rune >= 0x1F300 && rune <= 0x1FAFF) || // 그림문자 전반(😀 🌙 🧺 …)
    (rune >= 0x2600 && rune <= 0x27BF) || // 기타 기호·딩벳(✨ ☀ ➡)
    (rune >= 0x1F1E6 && rune <= 0x1F1FF); // 국기용 지역 표시자

/// 이모지에 붙어 하나를 이루는 결합 문자(ZWJ, 변이 선택자, 스킨톤).
bool _isEmojiJoiner(int rune) =>
    rune == 0x200D || // ZWJ
    rune == 0xFE0F ||
    rune == 0xFE0E || // 변이 선택자
    (rune >= 0x1F3FB && rune <= 0x1F3FF); // 스킨톤
