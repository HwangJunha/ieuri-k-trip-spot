import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/common/model/spot_qa_origin.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/component/spot_qa_entry_button.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer_reply.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_qa_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_question.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/my_questions_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_answers_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_composer_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/seen_answer_counts_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_question_by_id_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_questions_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/repository/seen_answer_counts_store.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/repository/spot_qa_repository_impl.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/view/my_questions_screen.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/view/spot_question_detail_screen.dart';
import 'package:ieuri_k_trip_spot/l10n/gen/app_localizations.dart';

import 'spot_qa_test_doubles.dart';

ProviderContainer _container(FakeSpotQaRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [spotQaRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// 「내 질문」 컨트롤러용 컨테이너. 「마지막에 본 답변 수」 저장소도 함께 갈아
/// 끼운다 — SharedPreferences를 세우지 않기 위해서다.
ProviderContainer _myQuestionsContainer(
  FakeSpotQaRepository repo,
  SeenAnswerCountsStore store,
) {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      spotQaRepositoryProvider.overrideWithValue(repo),
      seenAnswerCountsStoreProvider.overrideWithValue(store),
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
          .resolve('q1', resolved: true);

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
          .resolve('q1', resolved: true);

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
            .resolve('q1', resolved: true),
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

    // 서버가 거절해도 쓴 글을 날리지 않는다. 좋아요 게이팅은 사라졌지만
    // (2026-08-18) 본문 검증 같은 다른 거절은 남아 있어 이 보존 규칙은 그대로다.
    test('서버가 거절해도 입력을 보존한다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(
          createResult: const SpotQaMutationResult<String>.failure(
            'INVALID_INPUT',
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
      expect(state.errorCode, 'INVALID_INPUT');
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

  group('SpotQaEntryButton', () {
    // 좋아요 게이팅은 서버에서도 폐지됐다(2026-08-18). 진입점을 조건부로 가리는
    // 코드가 되살아나면 여기서 잡힌다 — 「지금 여기 어때?」는 가기 전에 나오는
    // 질문이라 좋아요를 조건으로 걸면 질문이 가장 필요한 사람을 막는다.
    testWidgets('질문이 없어도 진입점을 보이고 작성으로 보낸다', (WidgetTester tester) async {
      final ProviderContainer container = _container(FakeSpotQaRepository());
      bool composed = false;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: Scaffold(
              body: SpotQaEntryButton(
                catalogId: 'c1',
                onOpenList: () {},
                onCompose: () => composed = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.forum_outlined));
      // 질문이 하나도 없으면 빈 목록을 거치지 않고 곧장 작성으로 간다.
      expect(composed, isTrue);
    });

    testWidgets('질문이 있으면 개수를 보이고 목록으로 보낸다', (WidgetTester tester) async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(
          questionsByCatalog: <String, List<SpotQuestion>>{
            'c1': <SpotQuestion>[
              fakeQuestion(id: 'q1'),
              fakeQuestion(id: 'q2'),
            ],
          },
        ),
      );
      bool opened = false;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: Scaffold(
              body: SpotQaEntryButton(
                catalogId: 'c1',
                onOpenList: () => opened = true,
                onCompose: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2 questions'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.forum_outlined));
      expect(opened, isTrue);
    });
  });

  group('질문 상세 — 해결 표시', () {
    Future<void> pumpDetail(
      WidgetTester tester,
      FakeSpotQaRepository repo,
    ) async {
      final ProviderContainer container = _container(repo);
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            home: SpotQuestionDetailScreen(catalogId: 'c1', questionId: 'q1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    FakeSpotQaRepository repoWith(SpotQuestion question) =>
        FakeSpotQaRepository(
          questionPages: <CursorPage<SpotQuestion>>[
            CursorPage<SpotQuestion>(
              items: <SpotQuestion>[question],
              hasNextPage: false,
            ),
          ],
        );

    // 본문 아래에 두었더니 바로 위 「해결됨」 배지와 자리·아이콘이 같아 버튼이
    // 아니라 상태 표시로 읽혔다. 본문 옆으로 되돌아오면 여기서 잡힌다.
    testWidgets('해결 표시가 본문 옆이 아니라 ⋮ 메뉴 안에 있다', (WidgetTester tester) async {
      await pumpDetail(tester, repoWith(fakeQuestion(ownedByViewer: true)));

      // 메뉴를 열기 전에는 화면 어디에도 없다.
      expect(find.text('Mark as resolved'), findsNothing);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      expect(find.text('Mark as resolved'), findsOneWidget);
    });

    // 2026-08-18 서버가 `resolved` 인자를 열어 되돌리기가 가능해졌다.
    testWidgets('이미 해결된 질문에는 되돌리기가 나온다', (WidgetTester tester) async {
      await pumpDetail(
        tester,
        repoWith(fakeQuestion(ownedByViewer: true, resolved: true)),
      );

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Mark as unresolved'), findsOneWidget);
      expect(find.text('Mark as resolved'), findsNothing);
    });

    testWidgets('되돌리기를 누르면 resolved: false로 보낸다', (WidgetTester tester) async {
      final FakeSpotQaRepository repo = repoWith(
        fakeQuestion(ownedByViewer: true, resolved: true),
      );
      await pumpDetail(tester, repo);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as unresolved'));
      await tester.pumpAndSettle();

      expect(repo.lastResolved, 'q1');
      expect(repo.lastResolvedValue, isFalse);
    });

    testWidgets('남의 질문에는 해결 표시가 없고 신고만 있다', (WidgetTester tester) async {
      await pumpDetail(tester, repoWith(fakeQuestion()));

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Mark as resolved'), findsNothing);
      expect(find.text('Report'), findsOneWidget);
    });

    // 되돌릴 수 있게 되어 확인 다이얼로그를 없앴다 — 누르면 곧장 나간다.
    testWidgets('해결 표시를 누르면 resolved: true로 보낸다', (WidgetTester tester) async {
      final FakeSpotQaRepository repo = repoWith(
        fakeQuestion(ownedByViewer: true),
      );
      await pumpDetail(tester, repo);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as resolved'));
      await tester.pumpAndSettle();

      expect(repo.lastResolved, 'q1');
      expect(repo.lastResolvedValue, isTrue);
    });

    // 답변이 달렸는지 보러 다시 들어오는 화면이라 갱신 수단이 있어야 한다.
    testWidgets('당겨서 새로고침하면 질문과 답변을 다시 받는다', (WidgetTester tester) async {
      final FakeSpotQaRepository repo = repoWith(fakeQuestion());
      await pumpDetail(tester, repo);
      final int questionsBefore = repo.questionFetches;
      final int answersBefore = repo.answerFetches;

      await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      expect(repo.questionFetches, greaterThan(questionsBefore));
      expect(repo.answerFetches, greaterThan(answersBefore));
    });
  });

  group('사진 첨부', () {
    SpotQaComposer composerOf(ProviderContainer c) => c.read(
      spotQaComposerProvider(SpotQaComposerTarget.question, 'c1').notifier,
    );
    SpotQaComposerState stateOf(ProviderContainer c) =>
        c.read(spotQaComposerProvider(SpotQaComposerTarget.question, 'c1'));

    test('상한을 넘겨 고르면 넘치는 만큼 버린다', () {
      final ProviderContainer container = _container(FakeSpotQaRepository());
      final SpotQaComposer notifier = composerOf(container);

      notifier.addPhotos(<LocalPhoto>[
        for (int i = 0; i < 7; i++) fakeLocalPhoto(name: 'p$i.jpg'),
      ]);

      expect(stateOf(container).photos, hasLength(kSpotQaMaxPhotos));
      expect(stateOf(container).remainingPhotoSlots, 0);
    });

    // 고르는 즉시 올리면 질문을 안 쓰고 나간 사용자의 사진이 고아로 남는다.
    test('고르기만 해서는 업로드가 일어나지 않는다', () {
      final FakeSpotQaRepository repo = FakeSpotQaRepository();
      final ProviderContainer container = _container(repo);

      composerOf(container).addPhotos(<LocalPhoto>[fakeLocalPhoto()]);

      expect(repo.uploadRequests, isEmpty);
      expect(repo.uploadedNames, isEmpty);
    });

    test('제출하면 확정 키가 작성 뮤테이션에 실린다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository()
        ..issuedKeys = <String>['pending/a', 'pending/b'];
      final ProviderContainer container = _container(repo);
      final SpotQaComposer notifier = composerOf(container);
      notifier.updateBody('붐비나요?');
      notifier.addPhotos(<LocalPhoto>[
        fakeLocalPhoto(name: 'a.jpg'),
        fakeLocalPhoto(name: 'b.jpg'),
      ]);

      await notifier.submit();

      expect(repo.lastCreateQuestion?.photoKeys, <String>[
        'images/a',
        'images/b',
      ]);
    });

    // 설계 §사진 첨부 — 부분 성공이 정상이다.
    test('일부만 실패하면 나머지로 올리고 실패한 이름을 남긴다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository()
        ..issuedKeys = <String>['pending/a', 'pending/b']
        ..failingUploadNames = <String>{'b.jpg'};
      final ProviderContainer container = _container(repo);
      final SpotQaComposer notifier = composerOf(container);
      notifier.updateBody('붐비나요?');
      notifier.addPhotos(<LocalPhoto>[
        fakeLocalPhoto(name: 'a.jpg'),
        fakeLocalPhoto(name: 'b.jpg'),
      ]);

      final SpotQaMutationResult<String> result = await notifier.submit();

      // 사진 한 장이 실패해도 질문 자체는 올라간다.
      expect(result.succeeded, isTrue);
      expect(repo.lastCreateQuestion?.photoKeys, <String>['images/a']);
      expect(notifier.lastPhotoUpload?.failedNames, <String>['b.jpg']);
    });

    test('확정에 실패한 장도 이름으로 알린다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository()
        ..issuedKeys = <String>['pending/a', 'pending/b']
        ..failingConfirmKeys = <String>{'pending/b'};
      final ProviderContainer container = _container(repo);
      final SpotQaComposer notifier = composerOf(container);
      notifier.updateBody('붐비나요?');
      notifier.addPhotos(<LocalPhoto>[
        fakeLocalPhoto(name: 'a.jpg'),
        fakeLocalPhoto(name: 'b.jpg'),
      ]);

      await notifier.submit();

      expect(repo.lastCreateQuestion?.photoKeys, <String>['images/a']);
      expect(notifier.lastPhotoUpload?.failedNames, <String>['b.jpg']);
    });

    // 발급은 전부 아니면 전무다 — 빈 목록이 곧 "전부 거부"다.
    test('URL 발급이 전부 거부되면 사진 없이 올라간다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository();
      final ProviderContainer container = _container(repo);
      final SpotQaComposer notifier = composerOf(container);
      notifier.updateBody('붐비나요?');
      notifier.addPhotos(<LocalPhoto>[fakeLocalPhoto()]);

      final SpotQaMutationResult<String> result = await notifier.submit();

      expect(result.succeeded, isTrue);
      expect(repo.lastCreateQuestion?.photoKeys, isEmpty);
      expect(notifier.lastPhotoUpload?.hasFailures, isTrue);
    });

    // 제출이 거부돼 다시 눌렀을 때 이미 올라간 장을 또 올리면 중복이 쌓인다.
    test('확정된 장은 다시 제출해도 재업로드하지 않는다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository()
        ..issuedKeys = <String>['pending/a'];
      final ProviderContainer container = _container(repo);
      final SpotQaComposer notifier = composerOf(container);
      notifier.updateBody('붐비나요?');
      notifier.addPhotos(<LocalPhoto>[fakeLocalPhoto(name: 'a.jpg')]);

      await notifier.submit();
      await notifier.uploadPending();

      expect(repo.uploadedNames, <String>['a.jpg'], reason: '두 번 올리지 않는다');
    });

    test('취소하면 확정한 키를 지운다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository()
        ..issuedKeys = <String>['pending/a'];
      final ProviderContainer container = _container(repo);
      final SpotQaComposer notifier = composerOf(container);
      notifier.addPhotos(<LocalPhoto>[fakeLocalPhoto(name: 'a.jpg')]);
      await notifier.uploadPending();

      await notifier.discardUploaded();

      expect(repo.deletedKeys, <String>['images/a']);
    });

    test('올리지 않은 장을 빼면 네트워크를 타지 않는다', () {
      final FakeSpotQaRepository repo = FakeSpotQaRepository();
      final ProviderContainer container = _container(repo);
      final SpotQaComposer notifier = composerOf(container);
      notifier.addPhotos(<LocalPhoto>[fakeLocalPhoto(name: 'a.jpg')]);

      notifier.removePhoto('local-a.jpg');

      expect(stateOf(container).photos, isEmpty);
      expect(repo.deletedKeys, isEmpty);
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

  group('MyQuestionsController', () {
    test('서버가 준 질문으로 목록을 채운다', () async {
      final FakeSpotQaRepository repo = FakeSpotQaRepository(
        myQuestions: <SpotQuestion>[
          fakeQuestion(id: 'q1'),
          fakeQuestion(id: 'q2'),
        ],
      );
      final ProviderContainer container = _myQuestionsContainer(
        repo,
        FakeSeenAnswerCountsStore(),
      );

      final List<MyQuestionItem> items = await container.read(
        myQuestionsControllerProvider.future,
      );

      expect(items.map((MyQuestionItem i) => i.question.id), <String>[
        'q1',
        'q2',
      ]);
      // 목록은 한 번의 서버 조회로 끝난다 — 장소별로 나눠 부르던 예전 방식이
      // 되살아나면 여기서 잡힌다.
      expect(repo.myQuestionFetches, 1);
    });

    test('본 기록이 없으면 서버 답변 수가 그대로 새 답변이다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          myQuestions: <SpotQuestion>[fakeQuestion(answerCount: 3)],
        ),
        FakeSeenAnswerCountsStore(),
      );

      final List<MyQuestionItem> items = await container.read(
        myQuestionsControllerProvider.future,
      );

      expect(items.single.seenAnswerCount, 0);
      expect(items.single.hasNewAnswers, isTrue);
      expect(items.single.newAnswerCount, 3);
    });

    test('마지막으로 본 뒤 늘어난 답변 수만 센다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          myQuestions: <SpotQuestion>[fakeQuestion(answerCount: 4)],
        ),
        FakeSeenAnswerCountsStore(const <String, int>{'q1': 1}),
      );

      final List<MyQuestionItem> items = await container.read(
        myQuestionsControllerProvider.future,
      );

      expect(items.single.newAnswerCount, 3);
    });

    test('본 것으로 기록하면 새 답변 배지가 꺼진다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          myQuestions: <SpotQuestion>[fakeQuestion(answerCount: 2)],
        ),
        FakeSeenAnswerCountsStore(),
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
      final FakeSeenAnswerCountsStore store = FakeSeenAnswerCountsStore(
        const <String, int>{'q1': 2},
      );
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          myQuestions: <SpotQuestion>[fakeQuestion(answerCount: 2)],
        ),
        store,
      );
      await container.read(myQuestionsControllerProvider.future);

      await container
          .read(myQuestionsControllerProvider.notifier)
          .markSeen('q1', 2);

      expect(store.writes, 0);
    });

    // 비로그인·전송 실패를 빈 목록으로 접으면 "쓴 적 없음"으로 오해된다.
    // 첫 build의 실패는 provider 단위로 재현되지 않으므로(테스트 전략 skill)
    // 한 번 성공시킨 뒤 reload로 같은 실패를 낸다.
    test('조회가 실패하면 빈 목록이 아니라 오류다', () async {
      final _FailAfterFirstRepository repo = _FailAfterFirstRepository(
        <SpotQuestion>[fakeQuestion()],
      );
      final ProviderContainer container = _myQuestionsContainer(
        repo,
        FakeSeenAnswerCountsStore(),
      );
      await container.read(myQuestionsControllerProvider.future);

      await container.read(myQuestionsControllerProvider.notifier).reload();

      final AsyncValue<List<MyQuestionItem>> state = container.read(
        myQuestionsControllerProvider,
      );
      expect(state.hasError, isTrue);
      expect(state.error, isA<SpotQaFailure>());
    });

    test('못 본 답변이 있는 질문 수를 센다', () async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          myQuestions: <SpotQuestion>[
            fakeQuestion(id: 'q1', answerCount: 1),
            fakeQuestion(id: 'q2', answerCount: 0),
          ],
        ),
        FakeSeenAnswerCountsStore(),
      );
      await container.read(myQuestionsControllerProvider.future);

      expect(container.read(myQuestionsUnseenCountProvider), 1);
    });

    testWidgets('새 답변이 있으면 목록에서 배지가 보인다', (WidgetTester tester) async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(
          myQuestions: <SpotQuestion>[fakeQuestion(answerCount: 2)],
        ),
        FakeSeenAnswerCountsStore(),
      );

      await _pumpMyQuestions(tester, container);

      // 알림이 없어 이 배지가 "답이 달렸다"를 알리는 유일한 신호다.
      expect(find.text('2 new answers'), findsOneWidget);
      expect(find.text('지금 사람 많나요?'), findsOneWidget);
      expect(find.text('경복궁'), findsOneWidget);
    });

    testWidgets('질문이 없으면 빈 상태를 보여준다', (WidgetTester tester) async {
      final ProviderContainer container = _myQuestionsContainer(
        FakeSpotQaRepository(),
        FakeSeenAnswerCountsStore(),
      );

      await _pumpMyQuestions(tester, container);

      expect(find.text("You haven't asked anything yet"), findsOneWidget);
    });
  });

  // 빈 목록 단축은 구현체(SpotQaRepositoryImpl)에 있으므로 페이크 repository로는
  // 검증되지 않는다 — 여기만 GraphQL 링크를 세워 실제로 나간 요청을 본다.
  group('SpotQaRepositoryImpl.fetchQuestionsByIds', () {
    test('빈 목록이면 서버를 부르지 않는다', () async {
      final _RecordingLink link = _RecordingLink();

      final CursorPage<SpotQuestion> page = await _impl(
        link,
      ).fetchQuestionsByIds(const <String>[]);

      expect(page.items, isEmpty);
      expect(link.requests, isEmpty, reason: '부를 이유가 없는 왕복을 아낀다');
    });

    test('id를 그대로 넘긴다', () async {
      final _RecordingLink link = _RecordingLink(
        data: <String, dynamic>{
          'spotQuestions': <String, dynamic>{
            'edges': <dynamic>[],
            'pageInfo': <String, dynamic>{
              'hasNextPage': false,
              'endCursor': null,
            },
          },
        },
      );

      await _impl(link).fetchQuestionsByIds(const <String>['q1', 'q2']);

      expect(link.requests.single['ids'], <String>['q1', 'q2']);
    });

    // GraphQL은 실패해도 HTTP 200이라 errors 배열이 실패 판정의 유일한 근거다.
    test('errors 배열이 오면 실패로 던진다', () async {
      final _RecordingLink link = _RecordingLink(
        errors: const <GraphQLError>[GraphQLError(message: 'boom')],
      );

      await expectLater(
        _impl(link).fetchQuestionsByIds(const <String>['q1']),
        throwsA(isA<SpotQaFailure>()),
      );
    });
  });

  group('spotQuestionByIdProvider', () {
    test('서버가 준 질문을 돌려준다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(myQuestions: <SpotQuestion>[fakeQuestion()]),
      );

      final SpotQuestion? question = await container.read(
        spotQuestionByIdProvider('q1').future,
      );

      expect(question?.id, 'q1');
    });

    // 차단·숨김·삭제로 가려진 질문은 결과에서 빠진다 — 오류가 아니다.
    test('결과가 비면 오류가 아니라 null이다', () async {
      final ProviderContainer container = _container(
        FakeSpotQaRepository(questionsByIdResult: const <SpotQuestion>[]),
      );

      final SpotQuestion? question = await container.read(
        spotQuestionByIdProvider('gone').future,
      );

      expect(question, isNull);
    });
  });
}

/// 첫 조회만 성공하고 이후 재조회는 실패하는 repository. 첫 build 실패는 provider
/// 단위로 재현되지 않아(AsyncNotifier가 로딩 중 폐기된다) reload로 같은 실패를 낸다.
class _FailAfterFirstRepository extends FakeSpotQaRepository {
  _FailAfterFirstRepository(this._first);

  final List<SpotQuestion> _first;
  int _calls = 0;

  @override
  Future<CursorPage<SpotQuestion>> fetchMyQuestions({
    int? first,
    String? after,
  }) async {
    if (_calls++ == 0) {
      return CursorPage<SpotQuestion>(items: _first, hasNextPage: false);
    }
    throw SpotQaFailure.unauthenticated;
  }
}

/// 나간 요청의 변수를 기록하는 링크. 실제 전송 대신 "무엇이 서버로 갔는가"만 본다.
class _RecordingLink extends Link {
  _RecordingLink({this.data, this.errors});

  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;

  final List<Map<String, dynamic>> requests = <Map<String, dynamic>>[];

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    requests.add(request.variables);
    yield Response(
      data: data,
      errors: errors,
      response: const <String, dynamic>{},
      context: const Context(),
    );
  }
}

SpotQaRepositoryImpl _impl(Link link) => SpotQaRepositoryImpl(
  GraphQLClient(
    link: link,
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
    ),
  ),
);
