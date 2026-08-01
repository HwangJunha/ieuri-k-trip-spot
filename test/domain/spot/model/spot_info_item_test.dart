import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_info_item.dart';

void main() {
  test('an item with a name or text has content', () {
    expect(const SpotInfoItem(name: '입장료', text: '3,000원').hasContent, isTrue);
    // 한쪽만 있어도 보여줄 값은 있다.
    expect(const SpotInfoItem(name: '입장료', text: '').hasContent, isTrue);
    expect(const SpotInfoItem(name: '', text: '3,000원').hasContent, isTrue);
  });

  test('an item that is blank on both sides has nothing to show', () {
    // non-null이지만 공백뿐인 항목 — 그리면 빈 줄만 남으므로 제외 대상이다.
    expect(const SpotInfoItem(name: '', text: '').hasContent, isFalse);
    expect(const SpotInfoItem(name: '  ', text: '\n').hasContent, isFalse);
  });

  test('display getters strip the markup TourAPI sends', () {
    const SpotInfoItem item = SpotInfoItem(
      name: '이용시간',
      text: '[평일]<br>09:00~18:00 &amp; 예약제',
    );

    expect(item.displayName, '이용시간');
    expect(item.displayText, '[평일]\n09:00~18:00 & 예약제');
  });

  test('an item that is only markup has nothing to show', () {
    // 태그만 남은 항목은 정리 후 비므로 "값 없음"과 같게 다뤄야 한다.
    expect(const SpotInfoItem(name: '<br>', text: '<br>').hasContent, isFalse);
  });

  test('SpotInfoItem equality is value-based', () {
    expect(
      const SpotInfoItem(name: 'a', text: 'b'),
      const SpotInfoItem(name: 'a', text: 'b'),
    );
    expect(
      const SpotInfoItem(name: 'a', text: 'b'),
      isNot(const SpotInfoItem(name: 'a', text: 'c')),
    );
  });
}
