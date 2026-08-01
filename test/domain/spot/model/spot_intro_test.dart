import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/spot/model/spot_intro.dart';

void main() {
  test('presentEntries keeps only fields that have a value', () {
    const SpotIntro intro = SpotIntro(
      businessHours: '09:00 ~ 18:00',
      closedDays: null,
      fee: '3,000원',
    );

    expect(
      intro.presentEntries.map((SpotIntroEntry e) => e.field),
      <SpotIntroField>[SpotIntroField.businessHours, SpotIntroField.fee],
    );
    expect(intro.hasAny, isTrue);
  });

  test('blank and whitespace-only values count as absent', () {
    // 서버가 null 대신 빈 문자열을 줘도 빈 라벨("주차: ")이 남으면 안 된다(AC-25).
    const SpotIntro intro = SpotIntro(
      businessHours: '',
      parking: '   ',
      fee: '\n',
    );

    expect(intro.presentEntries, isEmpty);
    expect(intro.hasAny, isFalse);
  });

  test('values are trimmed for display', () {
    const SpotIntro intro = SpotIntro(businessHours: '  09:00 ~ 18:00  ');

    expect(intro.presentEntries.single.value, '09:00 ~ 18:00');
  });

  test('an intro with no fields at all reports nothing to show', () {
    // 여행코스처럼 운영 정보 개념이 없는 카테고리 — 섹션을 통째로 숨긴다.
    expect(const SpotIntro().hasAny, isFalse);
    expect(const SpotIntro().presentEntries, isEmpty);
  });

  test('entries follow the display order, not the declaration order', () {
    // 여행자가 확인하는 순서: 언제 여는가 → 닫는가 → 얼마인가 → 부가 조건.
    const SpotIntro intro = SpotIntro(
      businessHours: '09:00',
      closedDays: '월요일',
      parking: '가능',
      inquiryPhone: '02-000',
      fee: '무료',
      petAllowed: '불가',
      creditCardAccepted: '가능',
    );

    expect(
      intro.presentEntries.map((SpotIntroEntry e) => e.field),
      <SpotIntroField>[
        SpotIntroField.businessHours,
        SpotIntroField.closedDays,
        SpotIntroField.fee,
        SpotIntroField.parking,
        SpotIntroField.petAllowed,
        SpotIntroField.creditCardAccepted,
        SpotIntroField.inquiryPhone,
      ],
    );
  });

  test('SpotIntro equality is value-based', () {
    expect(const SpotIntro(fee: '무료'), const SpotIntro(fee: '무료'));
    expect(const SpotIntro(fee: '무료'), isNot(const SpotIntro(fee: '유료')));
  });
}
