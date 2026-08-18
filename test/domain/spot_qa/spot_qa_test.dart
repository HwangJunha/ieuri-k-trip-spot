import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/spot_qa_origin.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/my_question_ref.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer_reply.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_qa_eligibility.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_qa_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_question.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/my_questions_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_answers_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_composer_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_questions_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/repository/my_questions_store.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/view/my_questions_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import 'spot_qa_test_doubles.dart';

ProviderContainer _container(FakeSpotQaRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [spotQaRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// 「내 질문」 컨트롤러용 컨테이너. 로컬 저장소도 함께 갈아 끼운다 —
/// SharedPreferences를 세우지 않기 위해서다.
ProviderContainer _myQuestionsContainer(
  FakeSpotQaRepository repo,
  MyQuestionsStore store,
) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      spotQaRepositoryProvider.overrideWithValue(repo),
      myQuestionsStoreProvider.overrideWithValue(store),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// 「내 질문」 화면을 영어 로케일로 띄운다 — 화면에 보이는 문구로 검증한다.
Future<void> _pumpMyQuestions(
  WidgetTester tester,
  ProviderContainer container,
) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: MyQuestionsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('SpotQuestionsController', () {
    test('첫 페이지를 받는다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(
          questionPages: <CursorPage<SpotQuestion>>[
            CursorPage<SpotQuestion>(
              items: <SpotQuestion>[fakeQuestion()],
              hasNextPage: false,
            ),
          ],
        ),
      );

      final SpotQuestionsState state = await container.read(
        spotQuestionsControllerProvider('c1').future,
      );

      expect(state.items, hasLength(1));
      expect(state.hasMore, isFalse);
      expect(state.isEmpty, isFalse);
    });

    test('질문이 없으면 빈 목록이다', () async {
      final ProviderContainer container = _container(FakeSpotQaRepository());

      final SpotQuestionsState state = await container.read(
        spotQuestionsControllerProvider('c1').future,
      );

      expect(state.items, isEmpty);
      // 진입점이 "질문 있음/없음"으로 갈리므로 이 구분이 화면 흐름을 바꾼다.
      expect(state.isEmpty, isTrue);
    });

    test('loadMore가 커서를 넘기고 페이지를 누적한다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository(
        questionPages: <CursorPage<SpotQuestion>>[
          CursorPage<SpotQuestion>(
            items: <SpotQuestion>[fakeQuestion(id: 'q1')],
            hasNextPage: true,
            endCursor: 'cur1',
          ),
          CursorPage<SpotQuestion>(
            items: <SpotQuestion>[fakeQuestion(id: 'q2')],
            hasNextPage: false,
          ),
        ],
      );
      final ProviderContainer container = _container(repo);
      await container.read(spotQuestionsControllerProvider('c1').future);

      await container
          .read(spotQuestionsControllerProvider('c1').notifier)
          .loadMore();

      final SpotQuestionsState state = container
          .read(spotQuestionsControllerProvider('c1'))
          .value!;
      expect(state.items.map((SpotQuestion q) => q.id), <String>[
        'q1',
        'q2',
      ], reason: '앞 페이지를 덮어쓰지 않고 이어 붙인다');
      expect(state.hasMore, isFalse);
      expect(repo.questionCursors, <String?>[null, 'cur1']);
    });

    test('더 받을 것이 없으면 loadMore가 조회하지 않는다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository(
        questionPages: <CursorPage<SpotQuestion>>[
          CursorPage<SpotQuestion>(
            items: <SpotQuestion>[fakeQuestion()],
            hasNextPage: false,
          ),
        ],
      );
      final ProviderContainer container = _container(repo);
      await container.read(spotQuestionsControllerProvider('c1').future);

      await container
          .read(spotQuestionsControllerProvider('c1').notifier)
          .loadMore();

      expect(repo.questionFetches, 1);
    });

    // 설계 §상태 관리 — 해결 표시만 낙관적으로 반영한다.
    test('해결 표시를 낙관적으로 먼저 반영한다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository(
        questionPages: <CursorPage<SpotQuestion>>[
          CursorPage<SpotQuestion>(
            items: <SpotQuestion>[fakeQuestion(resolved: false)],
            hasNextPage: false,
          ),
        ],
      );
      final ProviderContainer container = _container(repo);
      await container.read(spotQuestionsControllerProvider('c1').future);

      await container
          .read(spotQuestionsControllerProvider('c1').notifier)
          .resolve('q1');

      expect(
        container
            .read(spotQuestionsControllerProvider('c1'))
            .value!
            .items
            .single
            .resolved,
        isTrue,
      );
      expect(repo.lastResolved, 'q1');
    });

    test('해결 표시가 거부되면 되돌린다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(
          questionPages: <CursorPage<SpotQuestion>>[
            CursorPage<SpotQuestion>(
              items: <SpotQuestion>[fakeQuestion(resolved: false)],
              hasNextPage: false,
            ),
          ],
          resolveResult: const SpotQaMutationResult<void>.failure(
            'NOT_QUESTION_OWNER',
          ),
        ),
      );
      await container.read(spotQuestionsControllerProvider('c1').future);

      final SpotQaMutationResult<void> result = await container
          .read(spotQuestionsControllerProvider('c1').notifier)
          .resolve('q1');

      expect(result.succeeded, isFalse);
      expect(
        container
            .read(spotQuestionsControllerProvider('c1'))
            .value!
            .items
            .single
            .resolved,
        isFalse,
        reason: '거부되면 낙관 반영을 되돌린다',
      );
    });

    test('해결 표시가 전송 실패하면 되돌리고 예외를 알린다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(
          questionPages: <CursorPage<SpotQuestion>>[
            CursorPage<SpotQuestion>(
              items: <SpotQuestion>[fakeQuestion(resolved: false)],
              hasNextPage: false,
            ),
          ],
          resolveThrows: SpotQaFailure.network,
        ),
      );
      await container.read(spotQuestionsControllerProvider('c1').future);

      await expectLater(
        container
            .read(spotQuestionsControllerProvider('c1').notifier)
            .resolve('q1'),
        throwsA(isA<SpotQaFailure>()),
      );
      expect(
        container
            .read(spotQuestionsControllerProvider('c1'))
            .value!
            .items
            .single
            .resolved,
        isFalse,
      );
    });
  });

  group('SpotAnswersController', () {
    test('답글은 답변에 딸려 함께 온다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(
          answerPages: <CursorPage<SpotAnswer>>[
            CursorPage<SpotAnswer>(
              items: <SpotAnswer>[
                fakeAnswer(replies: <SpotAnswerReply>[fakeReply()]),
              ],
              hasNextPage: false,
            ),
          ],
        ),
      );

      final SpotAnswersState state = await container.read(
        spotAnswersControllerProvider('q1').future,
      );

      expect(state.items.single.replies, hasLength(1));
    });

    test('답변 조회 실패는 답변 provider만 오류로 만든다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(answersError: SpotQaFailure.network),
      );
      container.listen(
        spotAnswersControllerProvider('q1'),
        (_, _) {},
        fireImmediately: true,
      );

      await expectLater(
        container.read(spotAnswersControllerProvider('q1').future),
        throwsA(isA<SpotQaFailure>()),
      );
    });
  });

  group('SpotQaComposer', () {
    test('공백만으로는 제출할 수 없다', () {
      final ProviderContainer container = _container(FakeSpotQaRepository());
      final SpotQaComposer notifier = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.question, 'c1').notifier,
      );

      notifier.updateBody('   ');

      expect(
        container
            .read(spotQaComposerProvider(SpotQaComposerTarget.question, 'c1'))
            .canSubmit,
        isFalse,
      );
    });

    test('질문을 보내면 트림된 본문이 넘어가고 폼이 비워진다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository();
      final ProviderContainer container = _container(repo);
      final SpotQaComposer notifier = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.question, 'c1').notifier,
      );
      notifier.updateBody('  지금 붐비나요?  ');

      final SpotQaMutationResult<String> result = await notifier.submit();

      expect(result.succeeded, isTrue);
      expect(repo.lastCreateQuestion?.targetId, 'c1');
      expect(repo.lastCreateQuestion?.body, '지금 붐비나요?');
      // 서버에 업로드 뮤테이션이 없어 사진은 보내지 않는다(설계 §사진 첨부).
      expect(repo.lastCreateQuestion?.photoKeys, isEmpty);
      expect(
        container
            .read(spotQaComposerProvider(SpotQaComposerTarget.question, 'c1'))
            .body,
        isEmpty,
      );
    });

    // 설계 §작성 자격 표시 — 사용자가 쓴 글을 자격 문제로 날리지 않는다.
    test('자격 없음으로 거절돼도 입력을 보존한다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(
          createResult: const SpotQaMutationResult<String>.failure(
            'NOT_ELIGIBLE_TO_ASK',
          ),
        ),
      );
      final SpotQaComposer notifier = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.question, 'c1').notifier,
      );
      notifier.updateBody('지금 붐비나요?');

      final SpotQaMutationResult<String> result = await notifier.submit();

      expect(result.succeeded, isFalse);
      final SpotQaComposerState state = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.question, 'c1'),
      );
      expect(state.body, '지금 붐비나요?', reason: '쓴 글을 잃지 않는다');
      expect(state.notEligible, isTrue);
      expect(state.isSubmitting, isFalse);
    });

    test('전송 실패도 입력을 보존한다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(createThrows: SpotQaFailure.network),
      );
      final SpotQaComposer notifier = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.answer, 'q1').notifier,
      );
      notifier.updateBody('오후엔 한산해요');

      await expectLater(notifier.submit(), throwsA(isA<SpotQaFailure>()));

      final SpotQaComposerState state = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.answer, 'q1'),
      );
      expect(state.body, '오후엔 한산해요');
      expect(state.isSubmitting, isFalse);
    });

    test('입력을 고치면 지난 오류 안내가 사라진다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(
          createResult: const SpotQaMutationResult<String>.failure(
            'NOT_ELIGIBLE_TO_ASK',
          ),
        ),
      );
      final SpotQaComposer notifier = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.question, 'c1').notifier,
      );
      notifier.updateBody('첫 시도');
      await notifier.submit();

      notifier.updateBody('두 번째 시도');

      expect(
        container
            .read(spotQaComposerProvider(SpotQaComposerTarget.question, 'c1'))
            .errorCode,
        isNull,
      );
    });

    test('대상에 따라 부르는 뮤테이션이 갈린다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository();
      final ProviderContainer container = _container(repo);

      final SpotQaComposer answerNotifier = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.answer, 'q1').notifier,
      );
      answerNotifier.updateBody('답변');
      await answerNotifier.submit();

      final SpotQaComposer replyNotifier = container.read(
        spotQaComposerProvider(SpotQaComposerTarget.reply, 'a1').notifier,
      );
      replyNotifier.updateBody('답글');
      await replyNotifier.submit();

      expect(repo.lastCreateAnswer?.targetId, 'q1');
      expect(repo.lastCreateReply?.targetId, 'a1');
      expect(repo.lastCreateQuestion, isNull);
    });
  });

  group('작성 진입점 노출', () {
    // 좋아요 게이팅은 폐지됐다(2026-08-18 사용자 결정 —
    // `spot_qa_eligibility.dart`). 「지금 여기 어때?」는 가기 전에 나오는 질문이라
    // 좋아요를 조건으로 걸면 질문이 가장 필요한 사람을 막는다.
    test('자격과 질문 유무에 관계없이 진입점을 보인다', () {
      expect(showSpotQaEntry(), isTrue);
    });
  });

  group('SpotQaOrigin', () {
    // 설계 §DM 연결 — 이 필드를 non-null로 가정하면 기존 대화가 전부 깨진다.
    test('같은 값이면 동등하다', () {
      const SpotQaOrigin a = SpotQaOrigin(
        catalogId: 'c1',
        spotTitle: '경복궁',
        questionId: 'q1',
        questionBodySnapshot: '붐비나요?',
        answerId: 'a1',
        answerBodySnapshot: '한산해요',
      );
      const SpotQaOrigin b = SpotQaOrigin(
        catalogId: 'c1',
        spotTitle: '경복궁',
        questionId: 'q1',
        questionBodySnapshot: '붐비나요?',
        answerId: 'a1',
        answerBodySnapshot: '한산해요',
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('MyQuestionRef', () {
    test('인코딩한 뒤 다시 읽으면 같은 값이다', () {
      final MyQuestionRef ref = fakeQuestionRef(seenAnswerCount: 3);

      expect(MyQuestionRef.decode(ref.encode()), ref);
    });

    test('형식이 깨진 항목은 null이다', () {
      // 목록 전체를 잃지 않기 위해 항목 단위로 버린다.
      expect(MyQuestionRef.decode('{'), isNull);
      expect(MyQuestionRef.decode('{"c":"c1"}'), isNull);
    });

    test('장소명이 유실돼도 질문 자체는 살린다', () {
      final MyQuestionRef? ref = MyQuestionRef.decode(
        '{"c":"c1","q":"q1","a":"2026-08-18T00:00:00.000Z"}',
      );

      expect(ref?.questionId, 'q1');
      expect(ref?.spotTitle, isEmpty);
    });
  });

  group('MyQuestionsController', () {
    test('장소가 같은 질문은 한 번만 조회한다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository(
        questionsByCatalog: <String, List<SpotQuestion>>{
          'c1': <SpotQuestion>[fakeQuestion(id: 'q1'), fakeQuestion(id: 'q2')],
        },
      );
      final ProviderContainer container = _myQuestionsContainer(
        repo,
        FakeMyQuestionsStore(<MyQuestionRef>[
          fakeQuestionRef(questionId: 'q1'),
          fakeQuestionRef(questionId: 'q2'),
        ]),
      );

      final List<MyQuestionItem> items = await container.read(
        myQuestionsControllerProvider.future,
      );

      expect(items, hasLength(2));
      expect(repo.fetchedCatalogs, <String>['c1']);
    });

    test('한 장소 조회가 실패해도 나머지는 남는다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: <String, List<SpotQuestion>>{
            'c2': <SpotQuestion>[fakeQuestion(id: 'q2', catalogId: 'c2')],
          },
          failingCatalogs: const <String>{'c1'},
        ),
        FakeMyQuestionsStore(<MyQuestionRef>[
          fakeQuestionRef(questionId: 'q1'),
          fakeQuestionRef(catalogId: 'c2', questionId: 'q2'),
        ]),
      );

      final List<MyQuestionItem> items = await container.read(
        myQuestionsControllerProvider.future,
      );

      // 실패한 장소의 질문도 목록에서 지우지 않는다 — 본문만 비어 있다.
      expect(items, hasLength(2));
      expect(items.first.question, isNull);
      expect(items.last.question?.id, 'q2');
    });

    test('서버에서 못 찾은 질문에는 새 답변 배지를 달지 않는다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: const <String, List<SpotQuestion>>{},
        ),
        FakeMyQuestionsStore(<MyQuestionRef>[fakeQuestionRef()]),
      );

      final List<MyQuestionItem> items = await container.read(
        myQuestionsControllerProvider.future,
      );

      expect(items.single.hasNewAnswers, isFalse);
      expect(items.single.newAnswerCount, 0);
    });

    test('마지막으로 본 뒤 늘어난 답변 수를 센다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: <String, List<SpotQuestion>>{
            'c1': <SpotQuestion>[fakeQuestion(answerCount: 4)],
          },
        ),
        FakeMyQuestionsStore(<MyQuestionRef>[
          fakeQuestionRef(seenAnswerCount: 1),
        ]),
      );

      final List<MyQuestionItem> items = await container.read(
        myQuestionsControllerProvider.future,
      );

      expect(items.single.hasNewAnswers, isTrue);
      expect(items.single.newAnswerCount, 3);
    });

    test('새로 올린 질문이 목록 맨 앞에 붙는다', () async {
      final FakeMyQuestionsStore store = FakeMyQuestionsStore(<MyQuestionRef>[
        fakeQuestionRef(questionId: 'old'),
      ]);
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: const <String, List<SpotQuestion>>{},
        ),
        store,
      );
      await container.read(myQuestionsControllerProvider.future);

      await container
          .read(myQuestionsControllerProvider.notifier)
          .remember(
            catalogId: 'c9',
            questionId: 'new',
            spotTitle: '남산',
            askedAt: DateTime.utc(2026, 8, 19),
          );

      expect(store.read().map((MyQuestionRef r) => r.questionId), <String>[
        'new',
        'old',
      ]);
    });

    test('같은 질문을 두 번 기록해도 하나만 남는다', () async {
      final FakeMyQuestionsStore store = FakeMyQuestionsStore();
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: const <String, List<SpotQuestion>>{},
        ),
        store,
      );
      await container.read(myQuestionsControllerProvider.future);

      final MyQuestionsController controller = container.read(
        myQuestionsControllerProvider.notifier,
      );
      for (int i = 0; i < 2; i++) {
        await controller.remember(
          catalogId: 'c1',
          questionId: 'q1',
          spotTitle: '경복궁',
          askedAt: DateTime.utc(2026, 8, 19),
        );
      }

      expect(store.read(), hasLength(1));
    });

    test('상한을 넘으면 오래된 기록을 버린다', () async {
      final FakeMyQuestionsStore store = FakeMyQuestionsStore(<MyQuestionRef>[
        for (int i = 0; i < myQuestionsLimit; i++)
          fakeQuestionRef(questionId: 'q$i'),
      ]);
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: const <String, List<SpotQuestion>>{},
        ),
        store,
      );
      await container.read(myQuestionsControllerProvider.future);

      await container
          .read(myQuestionsControllerProvider.notifier)
          .remember(
            catalogId: 'c1',
            questionId: 'newest',
            spotTitle: '경복궁',
            askedAt: DateTime.utc(2026, 8, 19),
          );

      expect(store.read(), hasLength(myQuestionsLimit));
      expect(store.read().first.questionId, 'newest');
      expect(
        store.read().map((MyQuestionRef r) => r.questionId),
        isNot(contains('q${myQuestionsLimit - 1}')),
      );
    });

    test('본 것으로 기록하면 새 답변 배지가 꺼진다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: <String, List<SpotQuestion>>{
            'c1': <SpotQuestion>[fakeQuestion(answerCount: 2)],
          },
        ),
        FakeMyQuestionsStore(<MyQuestionRef>[fakeQuestionRef()]),
      );
      final List<MyQuestionItem> before = await container.read(
        myQuestionsControllerProvider.future,
      );
      expect(before.single.hasNewAnswers, isTrue);

      await container
          .read(myQuestionsControllerProvider.notifier)
          .markSeen('q1', 2);
      final List<MyQuestionItem> after = await container.read(
        myQuestionsControllerProvider.future,
      );

      expect(after.single.hasNewAnswers, isFalse);
    });

    test('바뀐 것이 없으면 저장하지 않는다', () async {
      final FakeMyQuestionsStore store = FakeMyQuestionsStore(<MyQuestionRef>[
        fakeQuestionRef(seenAnswerCount: 2),
      ]);
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: const <String, List<SpotQuestion>>{},
        ),
        store,
      );
      await container.read(myQuestionsControllerProvider.future);

      await container
          .read(myQuestionsControllerProvider.notifier)
          .markSeen('q1', 2);

      expect(store.writes, 0);
    });

    testWidgets('새 답변이 있으면 목록에서 배지가 보인다', (WidgetTester tester) async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: <String, List<SpotQuestion>>{
            'c1': <SpotQuestion>[fakeQuestion(answerCount: 2)],
          },
        ),
        FakeMyQuestionsStore(<MyQuestionRef>[fakeQuestionRef()]),
      );

      await _pumpMyQuestions(tester, container);

      // 알림이 없어 이 배지가 "답이 달렸다"를 알리는 유일한 신호다.
      expect(find.text('2 new answers'), findsOneWidget);
      expect(find.text('지금 사람 많나요?'), findsOneWidget);
    });

    testWidgets('서버에서 못 찾은 질문도 목록에 남는다', (WidgetTester tester) async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: const <String, List<SpotQuestion>>{},
        ),
        FakeMyQuestionsStore(<MyQuestionRef>[fakeQuestionRef()]),
      );

      await _pumpMyQuestions(tester, container);

      expect(find.text('경복궁'), findsOneWidget);
      expect(
        find.text(
          "Couldn't find this question. It may have been deleted or hidden.",
        ),
        findsOneWidget,
      );
    });

    testWidgets('기록이 없으면 빈 상태와 로컬 저장 안내를 보여준다', (WidgetTester tester) async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(),
        FakeMyQuestionsStore(),
      );

      await _pumpMyQuestions(tester, container);

      expect(find.text("You haven't asked anything yet"), findsOneWidget);
      // 기기를 바꾸면 사라지는 목록임을 숨기지 않는다.
      expect(
        find.text('This list is saved on this device only.'),
        findsOneWidget,
      );
    });

    test('못 본 답변이 있는 질문 수를 센다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          questionsByCatalog: <String, List<SpotQuestion>>{
            'c1': <SpotQuestion>[
              fakeQuestion(id: 'q1', answerCount: 1),
              fakeQuestion(id: 'q2', answerCount: 0),
            ],
          },
        ),
        FakeMyQuestionsStore(<MyQuestionRef>[
          fakeQuestionRef(questionId: 'q1'),
          fakeQuestionRef(questionId: 'q2'),
        ]),
      );
      await container.read(myQuestionsControllerProvider.future);

      expect(container.read(myQuestionsUnseenCountProvider), 1);
    });
  });
}
