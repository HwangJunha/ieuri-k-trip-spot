import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/tour_api_text.dart';

void main() {
  test('converts <br> to line breaks in a real opentimefood value', () {
    // 서버가 실제로 내려준 형태.
    const String raw =
        '[평일]<br>- 11:30~22:00<br>- 준비시간 15:00~17:30<br>'
        '- 점심 마지막 주문 14:00 / 저녁 마지막 주문 21:00<br>'
        '[주말]<br>- 11:30~21:00';

    expect(sanitizeTourApiText(raw), '''
[평일]
- 11:30~22:00
- 준비시간 15:00~17:30
- 점심 마지막 주문 14:00 / 저녁 마지막 주문 21:00
[주말]
- 11:30~21:00''');
  });

  test('handles every <br> spelling', () {
    expect(sanitizeTourApiText('a<br>b<br/>c<br />d<BR>e'), 'a\nb\nc\nd\ne');
  });

  test('strips other tags but keeps their text', () {
    expect(sanitizeTourApiText('<b>굵게</b> 보통'), '굵게 보통');
  });

  test('treats block tag closings as line breaks', () {
    // 문단이 서로 붙어버리지 않게.
    expect(sanitizeTourApiText('<p>첫 줄</p><p>둘째 줄</p>'), '첫 줄\n둘째 줄');
  });

  test('decodes the entities TourAPI actually sends', () {
    expect(
      sanitizeTourApiText('커피&amp;디저트&nbsp;안내 &lt;주의&gt;'),
      '커피&디저트 안내 <주의>',
    );
  });

  test('trims each line and collapses runs of blank lines', () {
    // 원문에 줄 끝 공백과 <br><br><br>이 흔하다.
    expect(sanitizeTourApiText('a  <br>  b<br><br><br>c'), 'a\nb\n\nc');
  });

  test('keeps angle brackets that are not tags', () {
    // 원문에 꺾쇠가 강조 용도로 그냥 쓰인다 — 태그로 오인해 지우면 내용이 사라진다.
    expect(sanitizeTourApiText('5세 미만 <무료> 입장'), '5세 미만 <무료> 입장');
    expect(sanitizeTourApiText('11:00 <-> 22:00'), '11:00 <-> 22:00');
    expect(sanitizeTourApiText('가격 < 10000원'), '가격 < 10000원');
  });

  test('decodes numeric entities too', () {
    // 명명 엔티티만 처리하면 &#40;가 화면에 그대로 남아 뒤섞인다.
    expect(sanitizeTourApiText('&#40;주차 가능&#41;'), '(주차 가능)');
    expect(sanitizeTourApiText('09:00 &#8211; 18:00'), '09:00 – 18:00');
  });

  test('returns null when nothing displayable remains', () {
    // "값 없으면 안 그린다" 판단이 태그만 남은 값에도 적용되도록 null을 돌려준다.
    expect(sanitizeTourApiText(null), isNull);
    expect(sanitizeTourApiText(''), isNull);
    expect(sanitizeTourApiText('   '), isNull);
    expect(sanitizeTourApiText('<br>'), isNull);
    expect(sanitizeTourApiText('<br><br>&nbsp;'), isNull);
  });

  test('leaves plain text untouched apart from trimming', () {
    expect(sanitizeTourApiText('  09:00 ~ 18:00  '), '09:00 ~ 18:00');
  });
}
