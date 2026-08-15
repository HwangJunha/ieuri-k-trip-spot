import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/comment.dart';
import 'package:ieuri_k_trip_spot/domain/community/model/community_failure.dart';
import 'package:ieuri_k_trip_spot/common/model/target_category.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/comments_providers.dart';
import 'package:ieuri_k_trip_spot/domain/community/provider/community_providers.dart';

import '../community_test_doubles.dart';

ProviderContainer _container(FakeCommunityRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [communityRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('CommentsController', () {
    test('댓글 첫 페이지를 받는다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(comments: <Comment>[fakeComment()]),
      );

      final CommentsState state = await container.read(
        commentsControllerProvider('p1').future,
      );

      expect(state.items, hasLength(1));
      expect(state.hasMore, isFalse);
    });

    // 댓글이 루트 쿼리로 갈리면서 얻은 것: **댓글 조회가 실패해도 글은 살아 있다.**
    // 그 분리를 provider 단위에서 못 박는다 — 상세 화면이 둘을 따로 watch한다.
    test('댓글 조회 실패는 댓글 provider만 오류로 만든다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(
          post: fakePost(),
          commentsError: CommunityFailure.network,
        ),
      );
      container.listen(
        commentsControllerProvider('p1'),
        (_, _) {},
        fireImmediately: true,
      );

      await expectLater(
        container.read(commentsControllerProvider('p1').future),
        throwsA(isA<CommunityFailure>()),
      );
    });

    test('댓글을 달면 서버에 본문이 넘어가고 목록을 다시 받는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        comments: <Comment>[fakeComment()],
      );
      final ProviderContainer container = _container(repo);
      await container.read(commentsControllerProvider('p1').future);

      final CommentSubmission result = await container
          .read(commentsControllerProvider('p1').notifier)
          .submit('  좋은 글이네요  ');

      expect(result, CommentSubmission.success);
      expect(repo.lastCreateComment?.postId, 'p1');
      // 앞뒤 공백은 서버가 제거한 뒤 판정하지만, 보내기 전에 다듬는다.
      expect(repo.lastCreateComment?.body, '좋은 글이네요');
      // 최상위 댓글이면 부모를 보내지 않는다(2차 가이드 §1).
      expect(repo.lastCreateComment?.parentCommentId, isNull);
    });

    // 2차 가이드 §1 — 답글은 parentCommentId를 실어 보낸다.
    test('답글은 parentCommentId를 함께 보낸다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository(
        comments: <Comment>[fakeComment()],
      );
      final ProviderContainer container = _container(repo);
      await container.read(commentsControllerProvider('p1').future);

      final CommentSubmission result = await container
          .read(commentsControllerProvider('p1').notifier)
          .submit('저도요!', parentCommentId: 'c1');

      expect(result, CommentSubmission.success);
      expect(repo.lastCreateComment?.parentCommentId, 'c1');
    });

    // 최상위 목록만 items에 담기고 답글은 각 댓글의 replies에 있다.
    test('최상위 댓글에 답글이 딸려 온다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(
          comments: <Comment>[
            fakeComment(
              id: 'c1',
              replies: <Comment>[
                fakeComment(id: 'c2', parentCommentId: 'c1'),
                fakeComment(id: 'c3', parentCommentId: 'c1'),
              ],
            ),
          ],
        ),
      );

      final CommentsState state = await container.read(
        commentsControllerProvider('p1').future,
      );

      expect(state.items, hasLength(1));
      expect(state.items.single.replies.map((Comment c) => c.id), <String>[
        'c2',
        'c3',
      ]);
    });

    test('공백뿐인 댓글은 서버로 나가지 않는다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository();
      final ProviderContainer container = _container(repo);
      await container.read(commentsControllerProvider('p1').future);

      final CommentSubmission result = await container
          .read(commentsControllerProvider('p1').notifier)
          .submit('   ');

      expect(result, CommentSubmission.rejected);
      expect(repo.lastCreateComment, isNull);
    });

    test('미인증은 전용 결과로 구분된다', () async {
      final FakeCommunityRepository repo = FakeCommunityRepository()
        ..mutationError = CommunityFailure.unauthenticated;
      final ProviderContainer container = _container(repo);
      await container.read(commentsControllerProvider('p1').future);

      final CommentSubmission result = await container
          .read(commentsControllerProvider('p1').notifier)
          .submit('안녕하세요');

      expect(result, CommentSubmission.unauthenticated);
    });
  });

  group('communityChips', () {
    test('서버가 준 칩을 그대로 노출한다', () async {
      final ProviderContainer container = _container(
        FakeCommunityRepository(
          chips: const <TargetCategory>[TargetCategory.restaurant],
        ),
      );

      final List<TargetCategory> chips = await container.read(
        communityChipsProvider.future,
      );

      expect(chips.single, TargetCategory.restaurant);
    });

    // 가이드 §2 — 빈 목록은 오류가 아니다. 화면이 그 경우를 허용해야 한다.
    test('빈 목록도 정상 데이터다', () async {
      final ProviderContainer container = _container(FakeCommunityRepository());

      final List<TargetCategory> chips = await container.read(
        communityChipsProvider.future,
      );

      expect(chips, isEmpty);
      expect(container.read(communityChipsProvider).hasError, isFalse);
    });
  });
}
