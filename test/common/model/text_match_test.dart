import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/text_match.dart';

/// 검색 결과 강조가 짚는 구간(SPEC-0013). 순수 함수라 위젯 없이 검증한다.
void main() {
  test('질의가 나타나는 모든 자리를 찾는다', () {
    expect(findTextMatches('공원 옆 공원길', '공원'), <TextMatch>[
      const TextMatch(start: 0, end: 2),
      const TextMatch(start: 5, end: 7),
    ]);
  });

  test('대소문자를 무시한다', () {
    // 영문 제목을 소문자로 검색하는 일이 흔하다.
    expect(findTextMatches('Seoul Forest', 'seoul'), <TextMatch>[
      const TextMatch(start: 0, end: 5),
    ]);
  });

  test('질의를 공백으로 쪼개 조각마다 찾는다', () {
    // "예술 공원"으로 쳐도 붙여 쓴 "예술공원로"가 강조된다 — 서버 BM25도 토큰
    // 단위로 맞추므로 표시가 그쪽에 가깝다.
    expect(findTextMatches('예술공원로', '예술 공원'), <TextMatch>[
      const TextMatch(start: 0, end: 4),
    ]);
  });

  test('겹치거나 붙은 구간은 하나로 합친다', () {
    // 나누어 두면 굵은 글자 사이에 이음매가 보인다.
    expect(findTextMatches('aaa', 'aa'), <TextMatch>[
      const TextMatch(start: 0, end: 3),
    ]);
  });

  test('일치가 없으면 빈 목록이다', () {
    expect(findTextMatches('경복궁', '불국사'), isEmpty);
  });

  test('빈 질의·빈 문자열은 빈 목록이다', () {
    expect(findTextMatches('경복궁', ''), isEmpty);
    expect(findTextMatches('경복궁', '   '), isEmpty);
    expect(findTextMatches('', '경복'), isEmpty);
  });
}
