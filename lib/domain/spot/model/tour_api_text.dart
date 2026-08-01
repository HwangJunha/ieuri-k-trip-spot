/// TourAPI가 내려주는 텍스트 필드의 정리 규칙.
///
/// TourAPI 원문에는 HTML 조각이 섞여 온다 — 줄바꿈을 `<br>`로 주고(`<br/>`, `<BR>`
/// 표기가 뒤섞인다), `&amp;`·`&nbsp;` 같은 엔티티가 그대로 실려 온다. 그대로 그리면
/// 태그가 리터럴로 노출되고 줄바꿈도 먹지 않는다:
///
/// ```
/// [평일]<br>- 11:30~22:00<br>- 준비시간 15:00~17:30
/// ```
///
/// 이 규칙은 overview·intro·infoItems 등 여러 필드가 함께 쓰므로 한 곳에 모은다.
/// 표시 규칙은 클라이언트 몫이라(POL-024) 모델 계층에 둔다 — 위젯마다 반복하지 않는다.
library;

// 정규식은 최상위에 두어 한 번만 컴파일한다 — 상세 화면이 다시 그려질 때마다
// 필드마다 새로 만들지 않도록.

/// `<br>`, `<br/>`, `<br />`, 대소문자 혼용 모두.
final RegExp _brTag = RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false);

/// 블록 태그 닫힘 — 문단이 서로 붙지 않게 줄바꿈으로 본다.
final RegExp _blockTagClose = RegExp(
  r'<\s*/\s*(p|div|li|tr)\s*>',
  caseSensitive: false,
);

/// 실제 태그처럼 생긴 것만 지운다. `<`로 시작해 **영문자**가 오는 경우로 좁히는 게
/// 핵심이다 — `<[^>]*>`로 넓게 잡으면 원문에 강조로 쓰인 꺾쇠(`5세 미만 <무료>`,
/// `11:00 <-> 22:00`)까지 통째로 삼켜 내용이 조용히 사라진다.
final RegExp _htmlTag = RegExp(r'</?[a-zA-Z][^>]*>');

/// `&#40;` 같은 숫자 엔티티.
final RegExp _numericEntity = RegExp(r'&#(\d+);');

/// [raw]에서 HTML 조각을 걷어내고 표시용 평문으로 바꾼다.
///
/// - `<br>` 계열은 줄바꿈으로 바꾼다(줄 구분이 의미를 갖는 데이터라 보존한다).
/// - 나머지 태그는 제거한다(`<b>` 등 강조가 간혹 섞인다).
/// - 자주 오는 HTML 엔티티를 문자로 되돌린다.
/// - 줄 끝 공백을 정리하고, 연속된 빈 줄은 하나로 접는다.
///
/// 값이 없거나 정리 후 비면 null을 돌려준다 — 호출부의 "값 없으면 안 그린다" 판단이
/// 태그만 남은 문자열(`"<br>"`)에도 그대로 적용되도록.
String? sanitizeTourApiText(String? raw) {
  if (raw == null) return null;

  String text = raw;
  text = text.replaceAll(_brTag, '\n');
  text = text.replaceAll(_blockTagClose, '\n');
  text = text.replaceAll(_htmlTag, '');
  // 숫자 엔티티(&#40; 등)를 먼저 되돌린다 — 명명 엔티티만 처리하면 화면에 원문이
  // 그대로 남아 뒤섞인다.
  text = text.replaceAllMapped(_numericEntity, (Match m) {
    final int? code = int.tryParse(m.group(1)!);
    return code == null ? m.group(0)! : String.fromCharCode(code);
  });
  // 자주 나오는 명명 엔티티만 되돌린다(범용 파서를 들이지 않는다).
  //
  // `&amp;`는 마지막에 가깝게 둔다 — 먼저 풀면 `&amp;lt;`가 `<`까지 이중 해제된다.
  text = text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&amp;', '&');

  // 줄 단위로 공백을 정리한다 — 원문에 줄 끝 공백이 흔하다.
  final List<String> lines = text
      .split('\n')
      .map((String line) => line.trim())
      .toList();

  // 연속된 빈 줄은 하나로 접는다(원문의 <br><br><br>).
  final List<String> collapsed = <String>[];
  for (final String line in lines) {
    if (line.isEmpty && collapsed.isNotEmpty && collapsed.last.isEmpty) {
      continue;
    }
    collapsed.add(line);
  }

  final String result = collapsed.join('\n').trim();
  return result.isEmpty ? null : result;
}
