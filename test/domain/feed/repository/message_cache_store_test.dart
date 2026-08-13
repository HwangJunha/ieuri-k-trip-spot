import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/feed/repository/message_cache_store.dart';

import '../feed_test_doubles.dart';

void main() {
  group('캐시 병합 (R18)', () {
    test('서버에 없는 과거 메시지가 로컬에 남아 있으면 그대로 유지된다 (AC18-3)', () {
      // 서버는 6개월이 지나 지웠지만 기기의 기록은 지우지 않는다.
      final List<Message> merged = mergeCachedMessages(
        cached: <Message>[message('old', createdAt: DateTime.utc(2026, 1, 1))],
        fromServer: <Message>[
          message('new', createdAt: DateTime.utc(2026, 8, 12)),
        ],
      );

      expect(
        merged.map((Message m) => m.id),
        containsAll(<String>['old', 'new']),
      );
    });

    test('같은 id는 서버 값이 이긴다', () {
      final List<Message> merged = mergeCachedMessages(
        cached: <Message>[message('m1', body: '오래된 사본')],
        fromServer: <Message>[message('m1', body: '서버 원본')],
      );

      expect(merged.single.body, '서버 원본');
    });

    test('최신순으로 정렬된다', () {
      final List<Message> merged = mergeCachedMessages(
        cached: <Message>[message('a', createdAt: DateTime.utc(2026, 1, 1))],
        fromServer: <Message>[
          message('c', createdAt: DateTime.utc(2026, 8, 12)),
          message('b', createdAt: DateTime.utc(2026, 5, 1)),
        ],
      );

      expect(merged.map((Message m) => m.id).toList(), <String>['c', 'b', 'a']);
    });

    test('캐시가 비어 있어도 서버 결과만으로 동작한다 (AC18-4)', () {
      final List<Message> merged = mergeCachedMessages(
        cached: const <Message>[],
        fromServer: <Message>[message('m1')],
      );

      expect(merged.single.id, 'm1');
    });

    test('양쪽이 모두 비면 빈 목록이다 — 오류가 아니다', () {
      expect(
        mergeCachedMessages(
          cached: const <Message>[],
          fromServer: const <Message>[],
        ),
        isEmpty,
      );
    });
  });

  group('저장 규칙', () {
    test('전송 중·실패한 메시지는 캐시하지 않는다', () async {
      // 서버가 받았다는 보장이 없어, 다음 실행에서 되살아나면 보낸 적 없는
      // 메시지가 보인다.
      final FakeMessageCacheStore store = FakeMessageCacheStore();
      await store.write('c1', <Message>[
        message('sent'),
        message(
          'pending',
          status: MessageDeliveryStatus.sending,
          localId: true,
        ),
        message('failed', status: MessageDeliveryStatus.failed, localId: true),
      ]);

      expect(store.read('c1').map((Message m) => m.id), <String>['sent']);
    });
  });
}
