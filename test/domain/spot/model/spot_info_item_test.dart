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
