import 'package:ieuri_k_trip_spot/common/model/post_author.dart';
import 'package:ieuri_k_trip_spot/common/model/post_spot.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer_reply.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/my_question_ref.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_qa_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_question.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/repository/my_questions_store.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/repository/spot_qa_repository.dart';

/// SPEC-0026 테스트 더블. repository는 스텁한다 — 실제 GraphQL 전송을 세우지
/// 않는다(설계 §테스트가 실릴 단위).

SpotQuestion fakeQuestion({
  String id = 'q1',
  String body = '지금 사람 많나요?',
  bool resolved = false,
  int answerCount = 0,
  bool ownedByViewer = false,
  String catalogId = 'c1',
  String spotTitle = '경복궁',
}) => SpotQuestion(
  id: id,
  spot: PostSpot(
    id: catalogId,
    title: spotTitle,
    thumbnailImageUrl: 'https://example.com/t.jpg',
  ),
  body: body,
  author: const PostAuthor(id: 'm1', nickname: '여행자'),
  resolved: resolved,
  answerCount: answerCount,
  createdAt: DateTime.utc(2026, 8, 18),
  ownedByViewer: ownedByViewer,
);

SpotAnswer fakeAnswer({
  String id = 'a1',
  String questionId = 'q1',
  String body = '오후엔 한산해요.',
  List<SpotAnswerReply> replies = const <SpotAnswerReply>[],
}) => SpotAnswer(
  id: id,
  questionId: questionId,
  body: body,
  author: const PostAuthor(id: 'm2', nickname: '현지인'),
  createdAt: DateTime.utc(2026, 8, 18),
  replies: replies,
);

SpotAnswerReply fakeReply({String id = 'r1', String answerId = 'a1'}) =>
    SpotAnswerReply(
      id: id,
      answerId: answerId,
      body: '감사합니다!',
      author: const PostAuthor(id: 'm1', nickname: '여행자'),
      createdAt: DateTime.utc(2026, 8, 18),
    );

/// 마지막 작성 호출의 인자. 무엇이 서버로 넘어갔는지 검증한다.
typedef CreateCall = ({String targetId, String body, List<String> photoKeys});

class FakeSpotQaRepository implements SpotQaRepository {
  FakeSpotQaRepository({
    this.questionPages = const <CursorPage<SpotQuestion>>[],
    this.answerPages = const <CursorPage<SpotAnswer>>[],
    this.questionsByCatalog,
    this.failingCatalogs = const <String>{},
    this.questionsError,
    this.answersError,
    this.createResult,
    this.resolveResult,
    this.createThrows,
    this.resolveThrows,
  });

  /// 장소별 질문. 「내 질문」처럼 여러 장소를 조회하는 흐름에서 쓴다. null이면
  /// [questionPages]로 떨어진다(기존 테스트의 동작).
  final Map<String, List<SpotQuestion>>? questionsByCatalog;

  /// 조회가 실패하는 장소. 한 장소가 죽어도 나머지가 남는지 보기 위한 것이다.
  final Set<String> failingCatalogs;

  /// 조회된 장소 id를 순서대로 기록한다 — 같은 장소를 두 번 부르지 않는지 본다.
  final List<String> fetchedCatalogs = <String>[];

  /// 호출 순서대로 돌려줄 질문 페이지. 다 쓰면 마지막 페이지를 반복한다.
  final List<CursorPage<SpotQuestion>> questionPages;
  final List<CursorPage<SpotAnswer>> answerPages;

  final Object? questionsError;
  final Object? answersError;

  /// 작성 결과. null이면 성공으로 본다.
  final SpotQaMutationResult<String>? createResult;
  final SpotQaMutationResult<void>? resolveResult;

  /// 전송·인증 실패(예외로 나가는 갈래)를 흉내 낸다.
  final Object? createThrows;
  final Object? resolveThrows;

  int questionFetches = 0;
  int answerFetches = 0;
  final List<String?> questionCursors = <String?>[];
  final List<String?> answerCursors = <String?>[];

  CreateCall? lastCreateQuestion;
  CreateCall? lastCreateAnswer;
  CreateCall? lastCreateReply;
  String? lastResolved;
  final List<String> deletedQuestions = <String>[];

  CursorPage<T> _page<T>(List<CursorPage<T>> pages, int index) {
    if (pages.isEmpty) return CursorPage.empty<T>();
    return pages[index < pages.length ? index : pages.length - 1];
  }

  @override
  Future<CursorPage<SpotQuestion>> fetchQuestions({
    required String catalogId,
    int? first,
    String? after,
  }) async {
    if (questionsError != null) throw questionsError!;
    fetchedCatalogs.add(catalogId);
    if (failingCatalogs.contains(catalogId)) {
      throw StateError('catalog $catalogId unavailable');
    }
    questionCursors.add(after);
    if (questionsByCatalog != null) {
      questionFetches++;
      return CursorPage<SpotQuestion>(
        items: questionsByCatalog![catalogId] ?? const <SpotQuestion>[],
        hasNextPage: false,
      );
    }
    return _page(questionPages, questionFetches++);
  }

  @override
  Future<CursorPage<SpotAnswer>> fetchAnswers({
    required String questionId,
    int? first,
    String? after,
  }) async {
    if (answersError != null) throw answersError!;
    answerCursors.add(after);
    return _page(answerPages, answerFetches++);
  }

  @override
  Future<SpotQaMutationResult<String>> createQuestion({
    required String catalogId,
    required String body,
    List<String> photoKeys = const <String>[],
  }) async {
    if (createThrows != null) throw createThrows!;
    lastCreateQuestion = (
      targetId: catalogId,
      body: body,
      photoKeys: photoKeys,
    );
    return createResult ?? const SpotQaMutationResult<String>.success('q-new');
  }

  @override
  Future<SpotQaMutationResult<String>> createAnswer({
    required String questionId,
    required String body,
    List<String> photoKeys = const <String>[],
  }) async {
    if (createThrows != null) throw createThrows!;
    lastCreateAnswer = (targetId: questionId, body: body, photoKeys: photoKeys);
    return createResult ?? const SpotQaMutationResult<String>.success('a-new');
  }

  @override
  Future<SpotQaMutationResult<String>> createReply({
    required String parentAnswerId,
    required String body,
    List<String> photoKeys = const <String>[],
  }) async {
    if (createThrows != null) throw createThrows!;
    lastCreateReply = (
      targetId: parentAnswerId,
      body: body,
      photoKeys: photoKeys,
    );
    return createResult ?? const SpotQaMutationResult<String>.success('r-new');
  }

  @override
  Future<SpotQaMutationResult<void>> resolveQuestion(String questionId) async {
    if (resolveThrows != null) throw resolveThrows!;
    lastResolved = questionId;
    return resolveResult ?? const SpotQaMutationResult<void>.success(null);
  }

  @override
  Future<SpotQaMutationResult<void>> deleteQuestion(String questionId) async {
    deletedQuestions.add(questionId);
    return const SpotQaMutationResult<void>.success(null);
  }

  @override
  Future<SpotQaMutationResult<void>> deleteAnswer(String answerId) async =>
      const SpotQaMutationResult<void>.success(null);

  @override
  Future<SpotQaMutationResult<void>> deleteReply(String replyId) async =>
      const SpotQaMutationResult<void>.success(null);
}

/// 「내 질문」 로컬 기록의 인메모리 구현. SharedPreferences를 세우지 않는다 —
/// 저장소 인터페이스가 있는 이유가 이 교체다.
class FakeMyQuestionsStore implements MyQuestionsStore {
  FakeMyQuestionsStore([List<MyQuestionRef> initial = const <MyQuestionRef>[]])
    : _refs = List<MyQuestionRef>.of(initial);

  List<MyQuestionRef> _refs;

  int writes = 0;

  @override
  List<MyQuestionRef> read() => List<MyQuestionRef>.unmodifiable(_refs);

  @override
  Future<void> write(List<MyQuestionRef> refs) async {
    writes++;
    _refs = List<MyQuestionRef>.of(refs);
  }
}

MyQuestionRef fakeQuestionRef({
  String catalogId = 'c1',
  String questionId = 'q1',
  String spotTitle = '경복궁',
  int seenAnswerCount = 0,
}) => MyQuestionRef(
  catalogId: catalogId,
  questionId: questionId,
  spotTitle: spotTitle,
  askedAt: DateTime.utc(2026, 8, 18),
  seenAnswerCount: seenAnswerCount,
);
