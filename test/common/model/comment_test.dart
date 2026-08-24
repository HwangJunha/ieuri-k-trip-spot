import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/comment.dart';
import 'package:ieuri_k_trip_spot/common/model/post_author.dart';

Comment _comment({
  String id = 'c1',
  String? parentCommentId,
  List<Comment> replies = const <Comment>[],
}) => Comment(
  id: id,
  body: '좋네요',
  author: const PostAuthor(id: '12', nickname: '민지'),
  createdAt: DateTime.utc(2026, 8, 5, 10),
  parentCommentId: parentCommentId,
  replies: replies,
);

void main() {
  // 2차 가이드 §1 — parentCommentId가 들여쓰기 판정 기준이다.
  group('isTopLevel', () {
    test('parentCommentId가 없으면 최상위다', () {
      expect(_comment().isTopLevel, isTrue);
    });

    test('parentCommentId가 있으면 답글이다', () {
      expect(_comment(parentCommentId: 'c1').isTopLevel, isFalse);
    });
  });

  group('동등성', () {
    test('답글까지 같아야 같다', () {
      final Comment a = _comment(replies: <Comment>[_comment(id: 'c2')]);
      final Comment b = _comment(replies: <Comment>[_comment(id: 'c2')]);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('답글이 다르면 다르다', () {
      expect(
        _comment(replies: <Comment>[_comment(id: 'c2')]),
        isNot(_comment(replies: <Comment>[_comment(id: 'c3')])),
      );
    });

    test('부모가 다르면 다르다', () {
      expect(_comment(), isNot(_comment(parentCommentId: 'c9')));
    });
  });

  // 깊이 2단계라 답글의 답글은 없다 — 요청조차 하지 않으므로 기본값이 빈 목록이다.
  test('답글은 기본으로 비어 있다', () {
    expect(_comment().replies, isEmpty);
  });
}
