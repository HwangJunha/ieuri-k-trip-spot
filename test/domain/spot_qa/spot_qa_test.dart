import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ieuri_k_trip_spot/common/model/spot_qa_origin.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer_reply.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_qa_eligibility.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_qa_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_question.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_answers_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_composer_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_qa_providers.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/provider/spot_questions_providers.dart';

import 'spot_qa_test_doubles.dart';

ProviderContainer _container(FakeSpotQaRepository repo) {
  final ProviderContainer container = ProviderContainer(
    overrides: [spotQaRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
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
      expect(
        state.items.map((SpotQuestion q) => q.id),
        <String>['q1', 'q2'],
        reason: '앞 페이지를 덮어쓰지 않고 이어 붙인다',
      );
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

  group('작성 자격 판정', () {
    test('좋아요한 경우에만 쓸 수 있다', () {
      expect(canWriteSpotQa(viewerLikedSpot: true), isTrue);
      // 반응 없음과 DISLIKE는 둘 다 자격 없음이라 호출부가 false로 접어 넘긴다.
      expect(canWriteSpotQa(viewerLikedSpot: false), isFalse);
    });

    test('자격이 없고 질문도 없으면 진입점을 숨긴다', () {
      expect(
        showSpotQaEntry(viewerLikedSpot: false, hasQuestions: false),
        isFalse,
      );
    });

    test('질문이 있으면 자격과 무관하게 진입점을 보인다', () {
      // 읽기는 비로그인 포함 누구에게나 열려 있다(AC-1.4).
      expect(
        showSpotQaEntry(viewerLikedSpot: false, hasQuestions: true),
        isTrue,
      );
    });

    test('자격이 있으면 질문이 없어도 진입점을 보인다', () {
      expect(
        showSpotQaEntry(viewerLikedSpot: true, hasQuestions: false),
        isTrue,
      );
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
}
