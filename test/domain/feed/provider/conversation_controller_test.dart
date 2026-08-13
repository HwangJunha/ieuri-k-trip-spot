import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/conversation_providers.dart';
import 'package:ieuri_k_trip_spot/domain/feed/provider/feed_providers.dart';

import '../feed_test_doubles.dart';

const String _cid = 'c1';

ProviderContainer _container(
  FakeFeedRepository repo, {
  FakeMessageCacheStore? cache,
}) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      feedRepositoryProvider.overrideWithValue(repo),
      messageCacheStoreProvider.overrideWithValue(
        cache ?? FakeMessageCacheStore(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('로컬 캐시 (R18)', () {
    test('캐시가 있으면 서버를 기다리지 않고 즉시 그린다 (AC18-1)', () async {
      final FakeMessageCacheStore cache = FakeMessageCacheStore(
        <String, List<Message>>{
          _cid: <Message>[message('cached')],
        },
      );
      final FakeFeedRepository repo = FakeFeedRepository();
      final ProviderContainer container = _container(repo, cache: cache);

      // future를 기다리기 전에 이미 캐시된 값이 상태에 올라와 있다.
      container.listen(
        conversationControllerProvider(_cid),
        (_, _) {},
        fireImmediately: true,
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        container
            .read(conversationControllerProvider(_cid))
            .messages
            .map((Message m) => m.id),
        contains('cached'),
      );
    });

    test('서버에서 사라진 메시지도 로컬에 있으면 계속 보인다 (AC18-3)', () async {
      final FakeMessageCacheStore cache = FakeMessageCacheStore(
        <String, List<Message>>{
          _cid: <Message>[message('old', createdAt: DateTime.utc(2026, 1, 1))],
        },
      );
      final FakeFeedRepository repo = FakeFeedRepository()
        ..messagePages.add(
          CursorPage<Message>(
            items: <Message>[
              message('new', createdAt: DateTime.utc(2026, 8, 12)),
            ],
            hasNextPage: false,
          ),
        );
      final ProviderContainer container = _container(repo, cache: cache);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .sync();
      final ConversationState state = container.read(
        conversationControllerProvider(_cid),
      );

      expect(
        state.messages.map((Message m) => m.id),
        containsAll(<String>['old', 'new']),
      );
    });

    test('캐시가 비어 있어도 서버 조회로 정상 동작한다 (AC18-4)', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..messagePages.add(
          CursorPage<Message>(
            items: <Message>[message('m1')],
            hasNextPage: false,
          ),
        );
      final ProviderContainer container = _container(repo);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .sync();
      final ConversationState state = container.read(
        conversationControllerProvider(_cid),
      );

      expect(state.messages.single.id, 'm1');
    });

    test('조회 결과를 캐시에 남긴다 (AC18-2)', () async {
      final FakeMessageCacheStore cache = FakeMessageCacheStore();
      final FakeFeedRepository repo = FakeFeedRepository()
        ..messagePages.add(
          CursorPage<Message>(
            items: <Message>[message('m1')],
            hasNextPage: false,
          ),
        );
      final ProviderContainer container = _container(repo, cache: cache);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .sync();

      expect(cache.read(_cid).single.id, 'm1');
    });
  });

  group('메시지 전송 (R9)', () {
    Future<ProviderContainer> opened(
      FakeFeedRepository repo, {
      FakeMessageCacheStore? cache,
    }) async {
      final ProviderContainer container = _container(repo, cache: cache);
      await container
          .read(conversationControllerProvider(_cid).notifier)
          .sync();
      return container;
    }

    test('전송에 성공하면 서버 id로 확정된다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..sentMessageIds.add('server-1');
      final ProviderContainer container = await opened(repo);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '안녕하세요', me: author('me'));

      final Message sent = container
          .read(conversationControllerProvider(_cid))
          .messages
          .first;
      expect(sent.id, 'server-1');
      expect(sent.status, MessageDeliveryStatus.sent);
      expect(sent.localId, isFalse);
      expect(repo.sentBodies.single, '안녕하세요');
    });

    test('실패하면 말풍선이 실패 상태로 남는다 — 사라지지 않는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..sendMessageThrows = StateError('network');
      final ProviderContainer container = await opened(repo);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '안녕하세요', me: author('me'));

      final Message failed = container
          .read(conversationControllerProvider(_cid))
          .messages
          .single;
      expect(failed.status, MessageDeliveryStatus.failed);
      expect(failed.body, '안녕하세요');
    });

    test('서버가 거부해도 실패 상태로 남는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..sendErrorCode = 'BLOCKED';
      final ProviderContainer container = await opened(repo);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '안녕', me: author('me'));

      expect(
        container
            .read(conversationControllerProvider(_cid))
            .messages
            .single
            .status,
        MessageDeliveryStatus.failed,
      );
    });

    test('공백만 있는 본문은 보내지 않는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final ProviderContainer container = await opened(repo);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '   ', me: author('me'));

      expect(repo.sentBodies, isEmpty);
    });

    test('전송 중·실패한 메시지는 캐시에 남지 않는다', () async {
      final FakeMessageCacheStore cache = FakeMessageCacheStore();
      final FakeFeedRepository repo = FakeFeedRepository()
        ..sendMessageThrows = StateError('network');
      final ProviderContainer container = await opened(repo, cache: cache);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '실패할 메시지', me: author('me'));

      expect(cache.read(_cid), isEmpty);
    });
  });

  group('재시도 횟수 상한 (POL-040)', () {
    Future<ProviderContainer> withFailedMessage(FakeFeedRepository repo) async {
      final ProviderContainer container = _container(repo);
      await container
          .read(conversationControllerProvider(_cid).notifier)
          .sync();
      repo.sendMessageThrows = StateError('network');
      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '본문', me: author('me'));
      return container;
    }

    test('재시도하면 횟수가 올라간다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final ProviderContainer container = await withFailedMessage(repo);
      final String id = container
          .read(conversationControllerProvider(_cid))
          .messages
          .single
          .id;

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .retry(id);

      expect(
        container
            .read(conversationControllerProvider(_cid))
            .messages
            .single
            .retryCount,
        1,
      );
    });

    test('상한을 넘으면 더 보내지 않는다', () async {
      final FakeFeedRepository repo = FakeFeedRepository();
      final ProviderContainer container = await withFailedMessage(repo);
      final int sentBefore = repo.sentBodies.length;

      // 상한까지 재시도한다. id는 실패할 때마다 그대로다.
      for (int i = 0; i < maxMessageRetries + 2; i++) {
        final String id = container
            .read(conversationControllerProvider(_cid))
            .messages
            .single
            .id;
        await container
            .read(conversationControllerProvider(_cid).notifier)
            .retry(id);
      }

      // 상한만큼만 실제로 전송을 시도했다.
      expect(repo.sentBodies.length - sentBefore, maxMessageRetries);
      expect(
        container
            .read(conversationControllerProvider(_cid))
            .messages
            .single
            .retryCount,
        maxMessageRetries,
      );
    });

    test('성공한 메시지는 재시도 대상이 아니다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..sentMessageIds.add('server-1');
      final ProviderContainer container = _container(repo);
      await container
          .read(conversationControllerProvider(_cid).notifier)
          .sync();
      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '본문', me: author('me'));
      final int sentBefore = repo.sentBodies.length;

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .retry('server-1');

      expect(repo.sentBodies.length, sentBefore);
    });
  });

  group('과거 메시지 이어읽기 (AC8-2)', () {
    test('커서로 과거를 더 불러온다', () async {
      final FakeFeedRepository repo = FakeFeedRepository()
        ..messagePages.addAll(<CursorPage<Message>>[
          CursorPage<Message>(
            items: <Message>[
              message('m2', createdAt: DateTime.utc(2026, 8, 12)),
            ],
            hasNextPage: true,
            endCursor: 'c1',
          ),
          CursorPage<Message>(
            items: <Message>[
              message('m1', createdAt: DateTime.utc(2026, 8, 11)),
            ],
            hasNextPage: false,
          ),
        ]);
      final ProviderContainer container = _container(repo);
      await container
          .read(conversationControllerProvider(_cid).notifier)
          .sync();

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .loadMore();

      final ConversationState state = container.read(
        conversationControllerProvider(_cid),
      );
      expect(state.messages.map((Message m) => m.id), <String>['m2', 'm1']);
      expect(repo.messageAfterCursors, <String?>[null, 'c1']);
    });
  });
}
