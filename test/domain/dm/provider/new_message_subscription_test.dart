import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/dm/provider/conversation_providers.dart';
import 'package:ieuri_k_trip_spot/domain/dm/provider/dm_providers.dart';

import '../dm_test_doubles.dart';

const String _cid = 'c1';

ProviderContainer _container(FakeDmRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      dmRepositoryProvider.overrideWithValue(repo),
      messageCacheStoreProvider.overrideWithValue(FakeMessageCacheStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// 구독을 연 대화 화면 하나.
Future<ProviderContainer> _opened(FakeDmRepository repo) async {
  final ProviderContainer container = _container(repo);
  final ConversationController notifier = container.read(
    conversationControllerProvider(_cid).notifier,
  );
  container.listen(conversationControllerProvider(_cid), (_, _) {});
  await notifier.sync();
  notifier.listenForNewMessages();
  return container;
}

List<Message> _messages(ProviderContainer c) =>
    c.read(conversationControllerProvider(_cid)).messages;

void main() {
  group('새 메시지 구독', () {
    test('상대 메시지가 도착하면 목록에 얹힌다', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer container = await _opened(repo);

      repo.newMessages.add(message('m1', body: '안녕하세요'));
      await Future<void>.delayed(Duration.zero);

      expect(_messages(container).single.body, '안녕하세요');
    });

    test('같은 id가 다시 오면 두 번 뜨지 않는다', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer container = await _opened(repo);

      repo.newMessages
        ..add(message('m1'))
        ..add(message('m1'));
      await Future<void>.delayed(Duration.zero);

      expect(_messages(container).length, 1);
    });

    test('내가 보낸 메시지의 에코는 낙관적 말풍선과 합쳐진다', () async {
      // 다른 기기에서 보낸 경우가 있어 자기 메시지도 에코된다. dedupe하지 않으면
      // 내 메시지가 두 번 뜬다.
      final FakeDmRepository repo = FakeDmRepository()
        ..sentMessageIds.add('server-1');
      final ProviderContainer container = await _opened(repo);
      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '내 메시지', me: author('me'));

      repo.newMessages.add(
        message('server-1', body: '내 메시지', ownedByViewer: true),
      );
      await Future<void>.delayed(Duration.zero);

      expect(_messages(container).length, 1);
      expect(_messages(container).single.id, 'server-1');
    });

    test('전송 응답보다 에코가 먼저 와도 두 번 뜨지 않는다', () async {
      // 서버는 에코와 응답에 **같은 id**를 준다. 에코가 먼저 도착하면 구독이 이미
      // 그 id로 넣어 두므로, 응답이 늦게 와도 다시 넣지 않고 낙관적 말풍선만 걷는다.
      final FakeDmRepository repo = FakeDmRepository()
        ..sentMessageIds.add('server-9');
      final ProviderContainer container = await _opened(repo);

      // 전송을 시작만 하고 응답을 기다리지 않는다.
      final Future<void> sending = container
          .read(conversationControllerProvider(_cid).notifier)
          .send(body: '경합', me: author('me'));
      repo.newMessages.add(
        message('server-9', body: '경합', ownedByViewer: true),
      );
      await Future<void>.delayed(Duration.zero);
      await sending;

      expect(
        _messages(container).where((Message m) => m.body == '경합').length,
        1,
      );
      expect(_messages(container).single.id, 'server-9');
    });
  });

  group('읽음 처리', () {
    test('조회만으로는 읽음이 되지 않는다', () async {
      final FakeDmRepository repo = FakeDmRepository()
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

      expect(repo.markReadCalls, isEmpty);
    });

    test('markRead는 upToMessageId 없이 모두 읽음으로 보낸다', () async {
      final FakeDmRepository repo = FakeDmRepository()..markReadResult = 0;
      final ProviderContainer container = _container(repo);

      final int? remaining = await container
          .read(conversationControllerProvider(_cid).notifier)
          .markRead();

      expect(repo.markReadCalls.single.conversationId, _cid);
      // 생략이 "모두 읽음"이다 — 마지막 메시지 id를 몰라도 부를 수 있다.
      expect(repo.markReadCalls.single.upTo, isNull);
      // 잔여 수를 돌려주므로 재조회가 필요 없다.
      expect(remaining, 0);
    });
  });

  group('사진·인용 전송', () {
    test('사진만 보내도 본문이 빈 문자열로 실린다', () async {
      // body는 non-null이라 생략하면 GraphQL 검증에서 실패한다.
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer container = await _opened(repo);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(me: author('me'), photoKey: 'images/a');

      expect(repo.sentBodies.single, '');
      expect(repo.sentPhotoKeys.single, 'images/a');
    });

    test('본문·사진·인용이 모두 비면 보내지 않는다', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer container = await _opened(repo);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(me: author('me'), body: '   ');

      expect(repo.sentBodies, isEmpty);
    });

    test('사진만 보내면 본문은 빈 문자열로 실린다', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer container = await _opened(repo);

      await container
          .read(conversationControllerProvider(_cid).notifier)
          .send(me: author('me'), photoKey: 'images/p1');

      expect(repo.sentBodies.single, '');
      expect(repo.sentPhotoKeys.single, 'images/p1');
    });
  });
}
