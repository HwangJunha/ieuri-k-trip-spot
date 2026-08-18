import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/spot_qa_origin.dart';
import 'package:ieuri_k_trip_spot/domain/dm/component/message_bubble.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/dm/provider/conversation_providers.dart';
import 'package:ieuri_k_trip_spot/domain/dm/provider/dm_providers.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import 'dm_test_doubles.dart';

/// 질문/답변 인용(SPEC-0026).
///
/// 2026-08-18 서버가 인용을 대화에서 **메시지로** 옮겼다. 예전에는 대화당 하나뿐이라
/// 두 번째 질문에서 말을 걸면 첫 인용이 계속 남아 화면이 거짓말을 했다.
const SpotQaOrigin _origin = SpotQaOrigin(
  catalogId: 'c1',
  spotTitle: '무브살롱 : 살롱그라운드',
  questionId: 'q1',
  questionBodySnapshot: '지금 붐비나요?',
  answerId: 'a1',
  answerBodySnapshot: '오후엔 한산해요',
);

Message _msg({SpotQaOrigin? origin, String body = '안녕하세요'}) => Message(
  id: 'm1',
  body: body,
  sender: author('other'),
  createdAt: DateTime.utc(2026, 8, 18),
  ownedByViewer: false,
  spotQaOrigin: origin,
);

Future<void> _pump(WidgetTester tester, Message message) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: MessageBubble(message: message, onRetry: () {}),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('인용 말풍선', () {
    testWidgets('인용이 있으면 장소와 질문을 그린다', (WidgetTester tester) async {
      await _pump(tester, _msg(origin: _origin));

      expect(find.text('무브살롱 : 살롱그라운드'), findsOneWidget);
      expect(find.text('지금 붐비나요?'), findsOneWidget);
      expect(find.text('안녕하세요'), findsOneWidget);
    });

    // 서버가 인용을 만들지 못해도 메시지는 온다 — 거절이 아니라 null이다.
    testWidgets('인용이 없으면 본문만 그린다', (WidgetTester tester) async {
      await _pump(tester, _msg());

      expect(find.text('무브살롱 : 살롱그라운드'), findsNothing);
      expect(find.text('안녕하세요'), findsOneWidget);
    });

    // 본문 없이 인용만 보낼 수 있다(body: ""). "내용 없음"으로 그려지면 안 된다.
    testWidgets('본문 없이 인용만 있어도 내용 없음이 아니다', (WidgetTester tester) async {
      final Message quoteOnly = _msg(origin: _origin, body: '');

      expect(quoteOnly.isEmpty, isFalse, reason: '인용도 내용이다');

      await _pump(tester, quoteOnly);
      expect(find.text('무브살롱 : 살롱그라운드'), findsOneWidget);
    });
  });

  group('인용 전송', () {
    /// 컨트롤러를 깨우고 첫 로드가 끝나기를 기다린다 — 동기 notifier라 `.future`가
    /// 없어 listen으로 살려 둔다.
    Future<ProviderContainer> primed(FakeDmRepository repo) async {
      final ProviderContainer c = ProviderContainer(
        overrides: [
          dmRepositoryProvider.overrideWithValue(repo),
          messageCacheStoreProvider.overrideWithValue(FakeMessageCacheStore()),
        ],
      );
      addTearDown(c.dispose);
      c.listen(conversationControllerProvider('c1'), (_, _) {},
          fireImmediately: true);
      await Future<void>.delayed(Duration.zero);
      return c;
    }

    test('본문 없이 인용만 보낼 수 있다', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer c = await primed(repo);

      await c
          .read(conversationControllerProvider('c1').notifier)
          .send(me: author('me'), sourceAnswerId: 'a1');

      expect(repo.sentSourceAnswerIds, <String?>['a1']);
      expect(repo.sentBodies, <String>[''], reason: 'body는 non-null이라 빈 문자열');
    });

    test('본문·사진·인용이 모두 비면 보내지 않는다', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer c = await primed(repo);

      await c.read(conversationControllerProvider('c1').notifier).send(
            me: author('me'),
          );

      expect(repo.sentBodies, isEmpty);
    });

    test('인용 없이 보내면 null이 실린다', () async {
      final FakeDmRepository repo = FakeDmRepository();
      final ProviderContainer c = await primed(repo);

      await c
          .read(conversationControllerProvider('c1').notifier)
          .send(me: author('me'), body: '그냥 메시지');

      expect(repo.sentSourceAnswerIds, <String?>[null]);
    });
  });
}
