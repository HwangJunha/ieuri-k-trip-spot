import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/feed_item.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/feed_list_providers.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/feed_providers.dart';

import '../feed_test_doubles.dart';

ProviderContainer _container(FakeFeedRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [feedRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('페이지네이션 (R4)', () {
    test('커서로 다음 페이지를 이어 붙인다 (AC4-2)', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..feedPages.addAll(<CursorPage<FeedItem>>[
          CursorPage<FeedItem>(
            items: <FeedItem>[feedItem('1')],
            hasNextPage: true,
            endCursor: 'c1',
          ),
          CursorPage<FeedItem>(
            items: <FeedItem>[feedItem('2')],
            hasNextPage: false,
          ),
        ]);
      final ProviderContainer container = _container(repo);

      await container.read(feedListControllerProvider.future);
      await container.read(feedListControllerProvider.notifier).loadMore();

      final FeedListState state = container
          .read(feedListControllerProvider)
          .requireValue;
      expect(state.items.map((FeedItem f) => f.id), <String>['1', '2']);
      // 두 번째 조회는 첫 페이지의 커서를 들고 갔다.
      expect(repo.feedAfterCursors, <String?>[null, 'c1']);
    });

    test('소진되면 더 불러오지 않는다 (AC4-4)', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..feedPages.add(
          CursorPage<FeedItem>(
            items: <FeedItem>[feedItem('1')],
            hasNextPage: false,
          ),
        );
      final ProviderContainer container = _container(repo);

      await container.read(feedListControllerProvider.future);
      await container.read(feedListControllerProvider.notifier).loadMore();

      // 두 번째 요청 자체가 나가지 않는다.
      expect(repo.feedAfterCursors, <String?>[null]);
      expect(
        container.read(feedListControllerProvider).requireValue.hasMore,
        isFalse,
      );
    });

    test('이어읽기가 실패해도 이미 그려진 목록은 남는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..feedPages.add(
          CursorPage<FeedItem>(
            items: <FeedItem>[feedItem('1')],
            hasNextPage: true,
            endCursor: 'c1',
          ),
        );
      final ProviderContainer container = _container(repo);
      await container.read(feedListControllerProvider.future);

      repo.fetchFeedThrows = StateError('network');
      await container.read(feedListControllerProvider.notifier).loadMore();

      final FeedListState state = container
          .read(feedListControllerProvider)
          .requireValue;
      expect(state.items.single.id, '1');
      expect(state.isLoadingMore, isFalse);
    });
  });

  group('좋아요 낙관적 갱신 (R6)', () {
    Future<ProviderContainer> seeded(FakeFeedRepository repo) async {
      repo.feedPages.add(
        CursorPage<FeedItem>(
          items: <FeedItem>[feedItem('1', likeCount: 3)],
          hasNextPage: false,
        ),
      );
      final ProviderContainer container = _container(repo);
      await container.read(feedListControllerProvider.future);
      return container;
    }

    test('좋아요하면 즉시 반영되고 서버 수로 되맞춘다 (AC6-1)', () async {
      final FakeFeedRepository repo = FakeFeedRepository()..likeCountResult = 4;
      final ProviderContainer container = await seeded(repo);

      await container.read(feedListControllerProvider.notifier).toggleLike('1');

      final FeedItem item = container
          .read(feedListControllerProvider)
          .requireValue
          .items
          .single;
      expect(item.likedByViewer, isTrue);
      expect(item.likeCount, 4);
    });

    test('서버가 거부하면 이전 상태로 되돌린다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..likeErrorCode = 'FEED_ITEM_NOT_FOUND';
      final ProviderContainer container = await seeded(repo);

      await container.read(feedListControllerProvider.notifier).toggleLike('1');

      final FeedItem item = container
          .read(feedListControllerProvider)
          .requireValue
          .items
          .single;
      expect(item.likedByViewer, isFalse);
      expect(item.likeCount, 3);
    });

    test('전송이 실패해도 이전 상태로 되돌린다', () async {
      // userErrors가 아니라 예외로 오는 실패도 롤백해야 한다.
      final FakeFeedRepository repo = FakeFeedRepository()
        ..likeThrows = StateError('network');
      final ProviderContainer container = await seeded(repo);

      await container.read(feedListControllerProvider.notifier).toggleLike('1');

      final FeedItem item = container
          .read(feedListControllerProvider)
          .requireValue
          .items
          .single;
      expect(item.likedByViewer, isFalse);
      expect(item.likeCount, 3);
    });

    test('좋아요를 취소하면 수가 줄고 취소 연산이 호출된다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()..likeCountResult = 2;
      repo.feedPages.add(
        CursorPage<FeedItem>(
          items: <FeedItem>[feedItem('1', likeCount: 3, likedByViewer: true)],
          hasNextPage: false,
        ),
      );
      final ProviderContainer container = _container(repo);
      await container.read(feedListControllerProvider.future);

      await container.read(feedListControllerProvider.notifier).toggleLike('1');

      final FeedItem item = container
          .read(feedListControllerProvider)
          .requireValue
          .items
          .single;
      expect(item.likedByViewer, isFalse);
      expect(item.likeCount, 2);
      expect(repo.unlikeCalls, 1);
      expect(repo.likeCalls, 0);
    });

    test('좋아요 수가 0일 때 취소해도 음수가 되지 않는다 (AC6-3)', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      repo.feedPages.add(
        CursorPage<FeedItem>(
          items: <FeedItem>[feedItem('1', likeCount: 0, likedByViewer: true)],
          hasNextPage: false,
        ),
      );
      final ProviderContainer container = _container(repo);
      await container.read(feedListControllerProvider.future);

      await container.read(feedListControllerProvider.notifier).toggleLike('1');

      expect(
        container
            .read(feedListControllerProvider)
            .requireValue
            .items
            .single
            .likeCount,
        0,
      );
    });
  });
}
