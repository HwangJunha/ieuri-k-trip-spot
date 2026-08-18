import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/model/post_author.dart';
import '../../../common/model/post_spot.dart';
import '../../../common/model/target_category.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
// `Enum$TargetCategory`는 공용 조각이 선언한다 — codegen이 모든 조각을 한 네임스페이스로
// 합치므로 생성 타입의 집은 하나뿐이고, 그 집이 공용 자리에 있어야 기능 간 의존이 안 생긴다.
import '../../../common/network/shared_schema.graphql.dart';
import '../../../common/pagination/page.dart';
import '../model/spot_answer.dart';
import '../model/spot_answer_reply.dart';
import '../model/spot_qa_failure.dart';
import '../model/spot_question.dart';
import 'spot_qa_operations.graphql.dart';
import 'spot_qa_repository.dart';

/// GraphQL 기반 [SpotQaRepository](SPEC-0026). 생성 타입은 **이 파일 밖으로 나가지
/// 않는다**(CLAUDE.md §3, POL-020).
///
/// 실패 판정이 두 갈래다(계약 §오류 코드):
///  - 조회의 최상위 `errors[]` — 예외로 던진다
///  - 뮤테이션 payload의 `userErrors[]` — **예외가 아니라 값으로 돌려준다**
///    ([SpotQaMutationResult]) — 작성 화면이 폼 상태를 유지한 채 분기해야 하기 때문이다
class SpotQaRepositoryImpl implements SpotQaRepository {
  SpotQaRepositoryImpl(this._client);

  final GraphQLClient _client;

  // ------------------------------------------------------------------ 조회

  @override
  Future<CursorPage<SpotQuestion>> fetchQuestions({
    required String catalogId,
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySpotQuestions,
      Variables$Query$SpotQuestions(
        catalogId: catalogId,
        first: first,
        after: after,
      ).toJson(),
      'spotQuestions',
    );
    final result = Query$SpotQuestions.fromJson(data).spotQuestions;
    return CursorPage<SpotQuestion>(
      items: result.edges.map((e) => _question(e.node)).toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<CursorPage<SpotAnswer>> fetchAnswers({
    required String questionId,
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQuerySpotAnswers,
      Variables$Query$SpotAnswers(
        questionId: questionId,
        first: first,
        after: after,
      ).toJson(),
      'spotAnswers',
    );
    final result = Query$SpotAnswers.fromJson(data).spotAnswers;
    return CursorPage<SpotAnswer>(
      items: result.edges.map((e) => _answer(e.node)).toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  // ------------------------------------------------------------------ 작성

  @override
  Future<SpotQaMutationResult<String>> createQuestion({
    required String catalogId,
    required String body,
    List<String> photoKeys = const <String>[],
  }) => _mutateResult<String>(
    documentNodeMutationCreateSpotQuestion,
    Variables$Mutation$CreateSpotQuestion(
      catalogId: catalogId,
      body: body,
      photoKeys: photoKeys,
    ).toJson(),
    'createSpotQuestion',
    (Map<String, dynamic> data) {
      final payload = Mutation$CreateSpotQuestion.fromJson(
        data,
      ).createSpotQuestion;
      return (
        success: payload.success,
        codes: payload.userErrors.map((e) => e.code).toList(growable: false),
        value: payload.questionId,
      );
    },
  );

  @override
  Future<SpotQaMutationResult<void>> deleteQuestion(String questionId) =>
      _mutateResult<void>(
        documentNodeMutationDeleteSpotQuestion,
        Variables$Mutation$DeleteSpotQuestion(questionId: questionId).toJson(),
        'deleteSpotQuestion',
        (Map<String, dynamic> data) {
          final payload = Mutation$DeleteSpotQuestion.fromJson(
            data,
          ).deleteSpotQuestion;
          return (
            success: payload.success,
            codes: payload.userErrors
                .map((e) => e.code)
                .toList(growable: false),
            value: null,
          );
        },
      );

  @override
  Future<SpotQaMutationResult<void>> resolveQuestion(String questionId) =>
      _mutateResult<void>(
        documentNodeMutationResolveSpotQuestion,
        Variables$Mutation$ResolveSpotQuestion(questionId: questionId).toJson(),
        'resolveSpotQuestion',
        (Map<String, dynamic> data) {
          final payload = Mutation$ResolveSpotQuestion.fromJson(
            data,
          ).resolveSpotQuestion;
          return (
            success: payload.success,
            codes: payload.userErrors
                .map((e) => e.code)
                .toList(growable: false),
            value: null,
          );
        },
      );

  @override
  Future<SpotQaMutationResult<String>> createAnswer({
    required String questionId,
    required String body,
    List<String> photoKeys = const <String>[],
  }) => _mutateResult<String>(
    documentNodeMutationCreateSpotAnswer,
    Variables$Mutation$CreateSpotAnswer(
      questionId: questionId,
      body: body,
      photoKeys: photoKeys,
    ).toJson(),
    'createSpotAnswer',
    (Map<String, dynamic> data) {
      final payload = Mutation$CreateSpotAnswer.fromJson(data).createSpotAnswer;
      return (
        success: payload.success,
        codes: payload.userErrors.map((e) => e.code).toList(growable: false),
        value: payload.answerId,
      );
    },
  );

  @override
  Future<SpotQaMutationResult<void>> deleteAnswer(String answerId) =>
      _mutateResult<void>(
        documentNodeMutationDeleteSpotAnswer,
        Variables$Mutation$DeleteSpotAnswer(answerId: answerId).toJson(),
        'deleteSpotAnswer',
        (Map<String, dynamic> data) {
          final payload = Mutation$DeleteSpotAnswer.fromJson(
            data,
          ).deleteSpotAnswer;
          return (
            success: payload.success,
            codes: payload.userErrors
                .map((e) => e.code)
                .toList(growable: false),
            value: null,
          );
        },
      );

  @override
  Future<SpotQaMutationResult<String>> createReply({
    required String parentAnswerId,
    required String body,
    List<String> photoKeys = const <String>[],
  }) => _mutateResult<String>(
    documentNodeMutationCreateSpotAnswerReply,
    Variables$Mutation$CreateSpotAnswerReply(
      parentAnswerId: parentAnswerId,
      body: body,
      photoKeys: photoKeys,
    ).toJson(),
    'createSpotAnswerReply',
    (Map<String, dynamic> data) {
      final payload = Mutation$CreateSpotAnswerReply.fromJson(
        data,
      ).createSpotAnswerReply;
      return (
        success: payload.success,
        codes: payload.userErrors.map((e) => e.code).toList(growable: false),
        value: payload.replyId,
      );
    },
  );

  @override
  Future<SpotQaMutationResult<void>> deleteReply(String replyId) =>
      _mutateResult<void>(
        documentNodeMutationDeleteSpotAnswerReply,
        Variables$Mutation$DeleteSpotAnswerReply(replyId: replyId).toJson(),
        'deleteSpotAnswerReply',
        (Map<String, dynamic> data) {
          final payload = Mutation$DeleteSpotAnswerReply.fromJson(
            data,
          ).deleteSpotAnswerReply;
          return (
            success: payload.success,
            codes: payload.userErrors
                .map((e) => e.code)
                .toList(growable: false),
            value: null,
          );
        },
      );

  // ------------------------------------------------------------------ 매핑

  SpotQuestion _question(Fragment$SpotQuestionParts node) => SpotQuestion(
    id: node.id,
    spot: _spot(node.spot),
    body: node.body,
    author: _author(node.author),
    resolved: node.resolved,
    answerCount: node.answerCount,
    createdAt: _time(node.createdAt),
    photoKeys: List<String>.unmodifiable(node.photoKeys),
    ownedByViewer: node.ownedByViewer,
    hidden: node.hidden,
  );

  SpotAnswer _answer(Fragment$SpotAnswerParts node) => SpotAnswer(
    id: node.id,
    questionId: node.questionId,
    body: node.body,
    author: _author(node.author),
    createdAt: _time(node.createdAt),
    photoKeys: List<String>.unmodifiable(node.photoKeys),
    replies: node.replies.map(_reply).toList(growable: false),
    ownedByViewer: node.ownedByViewer,
    hidden: node.hidden,
  );

  SpotAnswerReply _reply(Fragment$SpotAnswerReplyParts node) => SpotAnswerReply(
    id: node.id,
    answerId: node.answerId,
    body: node.body,
    author: _author(node.author),
    createdAt: _time(node.createdAt),
    photoKeys: List<String>.unmodifiable(node.photoKeys),
    ownedByViewer: node.ownedByViewer,
    hidden: node.hidden,
  );

  PostAuthor _author(Fragment$SpotQaAuthorParts author) => PostAuthor(
    id: author.id,
    nickname: author.nickname,
    profileImageUrl: author.profileImageUrl,
  );

  PostSpot _spot(Fragment$SpotQaSpotParts spot) => PostSpot(
    id: spot.id,
    title: spot.title,
    thumbnailImageUrl: spot.thumbnailImageUrl,
    category: _category(spot.category),
  );

  /// 서버가 아직 매핑되지 않은 카테고리를 추가했으면 null이다 — 질문 전체를 실패시키지
  /// 않는다(`PostSpot.category`와 같은 규칙).
  TargetCategory? _category(Enum$TargetCategory? value) => switch (value) {
    Enum$TargetCategory.TOURIST_SPOT => TargetCategory.touristSpot,
    Enum$TargetCategory.CULTURAL_FACILITY => TargetCategory.culturalFacility,
    Enum$TargetCategory.FESTIVAL_EVENT => TargetCategory.festivalEvent,
    Enum$TargetCategory.TRAVEL_COURSE => TargetCategory.travelCourse,
    Enum$TargetCategory.LEISURE_SPORTS => TargetCategory.leisureSports,
    Enum$TargetCategory.LODGING => TargetCategory.lodging,
    Enum$TargetCategory.SHOPPING => TargetCategory.shopping,
    Enum$TargetCategory.RESTAURANT => TargetCategory.restaurant,
    Enum$TargetCategory.TRANSPORT => TargetCategory.transport,
    Enum$TargetCategory.$unknown || null => null,
  };

  /// ISO-8601 문자열 → [DateTime]. **파싱 실패를 질문 전체의 실패로 만들지 않는다** —
  /// 시각 하나 때문에 목록이 통째로 비면 사용자가 잃는 것이 더 크다. 파싱하지 못하면
  /// epoch을 쓰고 정렬 위치만 어긋난다(서버가 이미 정렬해 내려주므로 표시 순서는 유지된다).
  DateTime _time(String raw) =>
      DateTime.tryParse(raw)?.toLocal() ??
      DateTime.fromMillisecondsSinceEpoch(0);

  // ------------------------------------------------------------------ 전송

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.query(QueryOptions(document: document, variables: variables)),
    operation,
    variables,
  );

  /// 뮤테이션을 실행하고 **`userErrors`를 값으로** 돌려준다.
  ///
  /// 전송·인증 실패는 예외로 나가고(그건 폼 상태로 분기할 성질이 아니다), 도메인 규칙
  /// 위반만 [SpotQaMutationResult.failure]가 된다.
  Future<SpotQaMutationResult<T>> _mutateResult<T>(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
    ({bool success, List<String> codes, Object? value}) Function(
      Map<String, dynamic> data,
    )
    parse,
  ) async {
    final Map<String, dynamic> data = await _run(
      () => _client.mutate(
        MutationOptions(document: document, variables: variables),
      ),
      operation,
      variables,
    );
    final parsed = parse(data);
    if (parsed.codes.isNotEmpty) {
      GraphqlDebugLog.userErrors(
        operation,
        parsed.codes
            .map((String c) => (code: c, field: null as String?))
            .toList(growable: false),
      );
      return SpotQaMutationResult<T>.failure(parsed.codes.first);
    }
    if (!parsed.success) return const SpotQaMutationResult.failure(null);
    return SpotQaMutationResult<T>.success(parsed.value as T?);
  }

  Future<Map<String, dynamic>> _run(
    Future<QueryResult<Object?>> Function() call,
    String operation,
    Map<String, dynamic> variables,
  ) async {
    GraphqlDebugLog.request(operation, variables);
    late final QueryResult<Object?> result;
    try {
      result = await call();
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew(operation, error);
      throw SpotQaFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw SpotQaFailure.fromQueryErrorCode(_rootErrorCode(result, operation));
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw SpotQaFailure.unknown;
    return data;
  }

  /// 전체 실패로 판정된 오류의 코드. `extensions.code`가 관례이고, 없으면 코드처럼
  /// 보이는 메시지(SCREAMING_SNAKE)를 폴백으로 본다.
  String? _rootErrorCode(QueryResult<Object?> result, String rootField) {
    final GraphQLError? error = firstRootError(result, rootField);
    if (error == null) return null;
    final Object? code = error.extensions?['code'];
    if (code is String && code.isNotEmpty) return code;
    final String message = error.message;
    return RegExp(r'^[A-Z][A-Z0-9_]+$').hasMatch(message) ? message : null;
  }
}
