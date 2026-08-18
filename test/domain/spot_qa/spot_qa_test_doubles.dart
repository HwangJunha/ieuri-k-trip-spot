import 'package:ieuri_k_trip_spot/common/model/post_author.dart';
import 'package:ieuri_k_trip_spot/common/model/post_spot.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer_reply.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_qa_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_question.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/repository/spot_qa_repository.dart';

/// SPEC-0026 테스트 더블. repository는 스텁한다 — 실제 GraphQL 전송을 세우지
/// 않는다(설계 §테스트가 실릴 단위).

SpotQuestion fakeQuestion({
  String id = 'q1',
  String body = '지금 사람 많나요?',
  bool resolved = false,
  int answerCount = 0,
  bool ownedByViewer = false,
}) => SpotQuestion(
  id: id,
  spot: const PostSpot(
    id: 'c1',
    title: '경복궁',
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
    this.questionsError,
    this.answersError,
    this.createResult,
    this.resolveResult,
    this.createThrows,
    this.resolveThrows,
  });

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
    questionCursors.add(after);
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
    lastCreateAnswer = (
      targetId: questionId,
      body: body,
      photoKeys: photoKeys,
    );
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
