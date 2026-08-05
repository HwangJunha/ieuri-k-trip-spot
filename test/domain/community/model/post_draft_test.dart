import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_draft.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post_topic.dart';

PostDraft _full({String body = '경복궁 다녀왔어요.'}) => PostDraft(
  targetId: '11094',
  targetTitle: '경복궁',
  topic: PostTopic.review,
  body: body,
);

void main() {
  group('등록 가능 조건 (R1-1)', () {
    test('대상·태그·본문이 모두 갖춰지면 등록할 수 있다', () {
      expect(_full().canSubmit, isTrue);
    });

    test('대상이 없으면 등록할 수 없다', () {
      const PostDraft draft = PostDraft(
        topic: PostTopic.review,
        body: '본문이 있다.',
      );

      expect(draft.canSubmit, isFalse);
    });

    test('태그가 없으면 등록할 수 없다', () {
      const PostDraft draft = PostDraft(targetId: '11094', body: '본문이 있다.');

      expect(draft.canSubmit, isFalse);
    });

    // 서버도 공백뿐인 본문을 POST_BODY_REQUIRED로 거부한다.
    test('공백뿐인 본문은 비어 있는 것으로 본다', () {
      expect(_full(body: '   \n  ').canSubmit, isFalse);
    });
  });

  group('본문 길이 (가이드 §12)', () {
    // 서버는 **코드포인트**로 센다. String.length(UTF-16)로 세면 이모지에서
    // "499자인데 거부됨"이 난다.
    test('길이를 코드포인트로 센다', () {
      // ZWJ 결합 가족 이모지: 사용자 눈에는 1글자, 코드포인트로는 7.
      const PostDraft draft = PostDraft(body: '👨‍👩‍👧‍👦');

      expect(draft.bodyRunes, 7);
      expect(draft.remainingRunes, maxPostBodyRunes - 7);
    });

    test('500자를 넘으면 등록이 막히고 초과분이 드러난다', () {
      final PostDraft draft = _full(body: '가' * 501);

      expect(draft.isBodyTooLong, isTrue);
      expect(draft.canSubmit, isFalse);
      // 음수 잔여 = 초과분. 화면이 이 값을 뒤집어 "1자 초과"로 보여준다.
      expect(draft.remainingRunes, -1);
    });

    test('정확히 500자는 등록할 수 있다', () {
      final PostDraft draft = _full(body: '가' * 500);

      expect(draft.isBodyTooLong, isFalse);
      expect(draft.canSubmit, isTrue);
    });
  });

  // 지금은 SPOT 하나뿐이지만 값으로 다룬다(가이드 §1) — 하드코딩하지 않는다.
  test('대상 종류의 기본값은 SPOT이며 값으로 바꿀 수 있다', () {
    expect(const PostDraft().targetType, 'SPOT');
    expect(const PostDraft(targetType: 'PRODUCT').targetType, 'PRODUCT');
  });
}
