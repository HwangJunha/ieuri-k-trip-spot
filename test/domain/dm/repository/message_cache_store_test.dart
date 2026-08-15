import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/dm/repository/message_cache_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dm_test_doubles.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  // SPEC-0021 AC11.6 — 피드를 걷어내도 **과거 캐시가 그대로 복원되어야 한다.**
  //
  // 이미 성립하는 성질이라(직렬화가 처음부터 인용을 제외했다) 여기 기준을 남기는
  // 이유는 이관 중에 형식을 건드리면 조용히 깨지기 때문이다.
  group('과거 캐시 복원 (SPEC-0021 AC11.6)', () {
    test('피드를 걷어내기 전에 쓴 줄을 그대로 읽는다', () async {
      // 이전 버전이 실제로 남겼을 형태 — 인용은 애초에 직렬화되지 않았다.
      SharedPreferences.setMockInitialValues(<String, Object>{
        'dm_messages_c1': <String>[
          '{"id":"m1","body":"예전 메시지","senderId":"other",'
              '"senderNickname":"상대","senderProfileImageUrl":null,'
              '"createdAt":"2026-01-01T00:00:00.000Z","ownedByViewer":false,'
              '"photoKey":null}',
        ],
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<Message> restored =
          SharedPreferencesMessageCacheStore(prefs).read('c1');

      expect(restored.single.id, 'm1');
      expect(restored.single.body, '예전 메시지');
    });

    test('모르는 키가 섞여 있어도 알려진 키만 읽어 복원한다', () async {
      // 인용이 실려 있던 줄이 있었더라도 역직렬화가 그것을 보지 않으므로 깨지지
      // 않는다 — 이 성질이 깨지면 과거 대화 기록이 통째로 사라진다.
      SharedPreferences.setMockInitialValues(<String, Object>{
        'dm_messages_c1': <String>[
          '{"id":"m2","body":"","senderId":"other","senderNickname":"상대",'
              '"createdAt":"2026-01-01T00:00:00.000Z","ownedByViewer":false,'
              '"photoKey":null,"feedItem":{"id":"f1","body":"지워진 피드"}}',
        ],
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<Message> restored =
          SharedPreferencesMessageCacheStore(prefs).read('c1');

      expect(restored.single.id, 'm2');
      // 본문도 사진도 없으니 R4의 "내용 없음" 표시 대상이다.
      expect(restored.single.isEmpty, isTrue);
    });
  });
}
