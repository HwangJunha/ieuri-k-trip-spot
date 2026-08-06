import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/comment.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/post.dart';

import '../community_test_doubles.dart';

void main() {
  test('두 Post가 같은 값이면 동등하다', () {
    expect(fakePost(), equals(fakePost()));
    expect(fakePost().hashCode, equals(fakePost().hashCode));
  });

  test('id가 다르면 동등하지 않다', () {
    expect(fakePost(id: 'a'), isNot(equals(fakePost(id: 'b'))));
  });

  test('태그가 다르면 동등하지 않다', () {
    expect(
      fakePost(tags: const <String>['야경']),
      isNot(equals(fakePost(tags: const <String>['한복']))),
    );
  });

  // 가이드 §5 — 장소 없는 글이 허용된다. 모델이 그것을 오류로 만들지 않는다.
  test('장소 없는 글도 유효한 값이다', () {
    final Post post = fakePost(withoutSpot: true);
    expect(post.spot, isNull);
    expect(post.title, isNotEmpty);
  });

  // 가이드 §7 — 낙관적 반영은 응답의 likeCount로 되맞춘다. copyWith가 그 두 필드만
  // 갈아끼우고 나머지를 보존하는지 확인한다.
  test('copyWith는 좋아요 상태만 바꾸고 나머지는 보존한다', () {
    final Post original = fakePost(likeCount: 3, likedByViewer: false);
    final Post updated = original.copyWith(likedByViewer: true, likeCount: 4);

    expect(updated.likedByViewer, isTrue);
    expect(updated.likeCount, 4);
    expect(updated.title, original.title);
    expect(updated.body, original.body);
    expect(updated.commentCount, original.commentCount);
    expect(updated.spot, original.spot);
    expect(updated.edited, original.edited);
  });

  // 가이드 §6 — commentCount가 미리보기 길이보다 클 수 있고 그것은 버그가 아니다.
  // 모델이 둘을 강제로 맞추지 않는다는 사실을 못 박는다.
  test('commentCount는 미리보기 길이와 달라도 그대로 유지된다', () {
    final Post post = fakePost(
      commentCount: 4,
      commentPreview: <Comment>[
        fakeComment(),
        fakeComment(id: 'c2'),
      ],
    );

    expect(post.commentCount, 4);
    expect(post.commentPreview, hasLength(2));
  });
}
