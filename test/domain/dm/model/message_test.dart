import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message.dart';

import '../dm_test_doubles.dart';

void main() {
  // SPEC-0021 R4 — 피드 인용만 있던 과거 메시지는 서버가 인용을 걷어낸 뒤로 **본문도
  // 사진도 없이** 내려온다. 그대로 그리면 빈 말풍선이 되므로, 모델이 그 상태를
  // 구분해 표시 계층에 알려야 한다.
  group('내용 없는 메시지 (R4)', () {
    test('본문도 사진도 없으면 비어 있다고 판정한다', () {
      expect(message('m1', body: '').isEmpty, isTrue);
    });

    test('본문이 있으면 비어 있지 않다', () {
      expect(message('m1', body: '안녕').isEmpty, isFalse);
    });

    test('본문이 없어도 사진이 있으면 비어 있지 않다', () {
      // 사진만 보낸 메시지는 정상이며 "내용 없음"으로 표시하면 안 된다.
      final Message photoOnly = Message(
        id: 'm1',
        body: '',
        sender: author('other'),
        createdAt: DateTime.utc(2026, 8, 12),
        ownedByViewer: false,
        photoKey: 'images/p1',
      );

      expect(photoOnly.isEmpty, isFalse);
    });

    test('본문이 비어도 말풍선을 숨기지 않도록 hasBody와 구분된다', () {
      // hasBody는 본문 줄을 그릴지, isEmpty는 "내용 없음"을 그릴지를 가른다 —
      // 하나로 합치면 사진만 보낸 메시지가 "내용 없음"으로 뜬다.
      final Message photoOnly = Message(
        id: 'm1',
        body: '',
        sender: author('other'),
        createdAt: DateTime.utc(2026, 8, 12),
        ownedByViewer: false,
        photoKey: 'images/p1',
      );

      expect(photoOnly.hasBody, isFalse);
      expect(photoOnly.isEmpty, isFalse);
    });
  });
}
