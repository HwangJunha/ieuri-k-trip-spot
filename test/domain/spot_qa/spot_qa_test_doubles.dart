import 'dart:typed_data';

import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/common/model/post_author.dart';
import 'package:ieuri_k_trip_spot/common/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/common/model/post_spot.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_answer_reply.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_qa_failure.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/model/spot_question.dart';
import 'package:ieuri_k_trip_spot/domain/spot_qa/repository/seen_answer_counts_store.dart';
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
    this.questionsError,
    this.answersError,
    this.myQuestions = const <SpotQuestion>[],
    this.myQuestionsError,
    this.questionsByIdResult,
    this.createResult,
    this.resolveResult,
    this.createThrows,
    this.resolveThrows,
  });

  /// 장소별 질문. null이면 [questionPages]로 떨어진다(기존 테스트의 동작).
  final Map<String, List<SpotQuestion>>? questionsByCatalog;

  /// 서버가 돌려줄 「내 질문」 목록.
  final List<SpotQuestion> myQuestions;

  /// 「내 질문」 조회 실패(비로그인 등). 던지면 컨트롤러가 오류로 떠야 한다 —
  /// 빈 목록으로 접으면 "쓴 적 없음"으로 오해된다.
  final Object? myQuestionsError;

  /// id 조회가 돌려줄 질문. null이면 [myQuestions]에서 id로 골라낸다.
  final List<SpotQuestion>? questionsByIdResult;

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

  /// 「내 질문」 조회 횟수. 목록을 몇 번 다시 받는지 본다.
  int myQuestionFetches = 0;

  /// id 조회에 넘어간 id 목록을 호출 순서대로 기록한다 — 빈 목록일 때 아예
  /// 부르지 않는지까지 여기서 갈린다.
  final List<List<String>> fetchedIds = <List<String>>[];

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
  Future<CursorPage<SpotQuestion>> fetchMyQuestions({
    int? first,
    String? after,
  }) async {
    myQuestionFetches++;
    if (myQuestionsError != null) throw myQuestionsError!;
    return CursorPage<SpotQuestion>(items: myQuestions, hasNextPage: false);
  }

  @override
  Future<CursorPage<SpotQuestion>> fetchQuestionsByIds(
    List<String> ids, {
    int? first,
  }) async {
    // 구현체와 같은 단축이다 — 빈 목록이면 서버를 부르지 않는다. 여기서 기록까지
    // 건너뛰어야 "부르지 않았다"를 테스트가 볼 수 있다.
    if (ids.isEmpty) return CursorPage.empty<SpotQuestion>();

    fetchedIds.add(List<String>.of(ids));
    final List<SpotQuestion> found =
        questionsByIdResult ??
        myQuestions
            .where((SpotQuestion q) => ids.contains(q.id))
            .toList(growable: false);
    return CursorPage<SpotQuestion>(items: found, hasNextPage: false);
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

  // ------------------------------------------------------ 사진 업로드(3단계)

  /// 1단계가 돌려줄 임시 키. 비우면 "전부 거부"(부분 발급이 없다).
  List<String> issuedKeys = const <String>[];

  /// PUT이 실패할 사진 이름. 스토리지 실패는 GraphQL 응답에 안 나온다.
  Set<String> failingUploadNames = const <String>{};

  /// 3단계에서 확정에 실패할 임시 키.
  Set<String> failingConfirmKeys = const <String>{};

  final List<PostImageUploadRequest> uploadRequests =
      <PostImageUploadRequest>[];
  final List<String> uploadedNames = <String>[];
  final List<String> confirmedKeys = <String>[];
  final List<String> deletedKeys = <String>[];

  @override
  Future<List<PostImageUploadUrl>> createImageUploadUrls(
    List<PostImageUploadRequest> images,
  ) async {
    uploadRequests.addAll(images);
    if (issuedKeys.isEmpty) return const <PostImageUploadUrl>[];
    // 요청 수만큼만 돌려준다 — 서버가 요청과 같은 순서로 준다는 계약을 흉내 낸다.
    return issuedKeys
        .take(images.length)
        .map(
          (String key) => PostImageUploadUrl(
            uploadUrl: 'https://storage.example/$key',
            objectKey: key,
            expiresAt: '2026-08-18T00:00:00Z',
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> uploadImage({
    required String uploadUrl,
    required LocalPhoto photo,
  }) async {
    if (failingUploadNames.contains(photo.name)) {
      throw StateError('upload failed: ${photo.name}');
    }
    uploadedNames.add(photo.name);
  }

  @override
  Future<PostImageConfirmation> confirmImageUploads(
    List<String> objectKeys,
  ) async {
    confirmedKeys.addAll(objectKeys);
    final List<String> ok = objectKeys
        .where((String k) => !failingConfirmKeys.contains(k))
        .toList(growable: false);
    return PostImageConfirmation(
      // 확정 키는 임시 키와 다른 값이다(`pending/` → `images/`).
      confirmed: ok.map((String k) => k.replaceFirst('pending/', 'images/')).toList(growable: false),
      failed: objectKeys
          .where(failingConfirmKeys.contains)
          .map(
            (String k) =>
                PostImageUploadFailure(objectKey: k, code: 'PHOTO_NOT_UPLOADED'),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> deleteImage(String objectKey) async => deletedKeys.add(objectKey);
}

/// 테스트용 사진 한 장. 바이트는 내용이 중요하지 않아 길이만 맞춘다.
LocalPhoto fakeLocalPhoto({String name = 'a.jpg', int bytes = 10}) =>
    LocalPhoto(
      id: 'local-$name',
      bytes: Uint8List.fromList(List<int>.filled(bytes, 0)),
      contentType: 'image/jpeg',
      name: name,
    );

/// 「마지막에 본 답변 수」 저장소의 인메모리 구현. SharedPreferences를 세우지
/// 않는다 — 저장소 인터페이스가 있는 이유가 이 교체다.
class FakeSeenAnswerCountsStore implements SeenAnswerCountsStore {
  FakeSeenAnswerCountsStore([Map<String, int> initial = const <String, int>{}])
    : _counts = Map<String, int>.of(initial);

  Map<String, int> _counts;

  /// 저장 횟수. 바뀐 것이 없을 때 쓰지 않는지를 이것으로 본다.
  int writes = 0;

  @override
  Map<String, int> read() => Map<String, int>.unmodifiable(_counts);

  @override
  Future<void> write(Map<String, int> counts) async {
    writes++;
    _counts = Map<String, int>.of(counts);
  }
}
