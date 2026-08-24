import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/comment.dart';
import 'package:ieuri_k_trip_spot/common/model/post.dart';

import '../post_fixtures.dart';

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
    final Post original = fakePost(
      likeCount: 3,
      likedByViewer: false,
      viewCount: 330,
    );
    final Post updated = original.copyWith(likedByViewer: true, likeCount: 4);

    expect(updated.likedByViewer, isTrue);
    expect(updated.likeCount, 4);
    expect(updated.title, original.title);
    expect(updated.body, original.body);
    expect(updated.commentCount, original.commentCount);
    // 좋아요를 눌러도 조회수는 그대로다 — 서버가 세는 값이다.
    expect(updated.viewCount, 330);
    expect(updated.spot, original.spot);
    expect(updated.edited, original.edited);
  });

  // 조회수가 다르면 다른 글 상태다 — 목록이 갱신을 놓치지 않으려면 동등성이
  // 이 값을 봐야 한다.
  test('조회수가 다르면 같지 않다', () {
    expect(fakePost(viewCount: 330), isNot(fakePost(viewCount: 331)));
    expect(fakePost(viewCount: 330), fakePost(viewCount: 330));
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
