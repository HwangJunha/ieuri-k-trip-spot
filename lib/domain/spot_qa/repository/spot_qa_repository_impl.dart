import 'dart:io';

import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/model/composer_photo.dart';
import '../../../common/model/post_author.dart';
import '../../../common/model/post_image_upload.dart';
import '../../../common/model/post_spot.dart';
import '../../../common/model/target_category.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
// `Enum$TargetCategory`는 공용 조각이 선언한다 — codegen이 모든 조각을 한 네임스페이스로
// 합치므로 생성 타입의 집은 하나뿐이고, 그 집이 공용 자리에 있어야 기능 간 의존이 안 생긴다.
import '../../../common/network/shared_schema.graphql.dart';
// 업로드 프로토콜(createPostImageUploadUrls·confirmPostImageUploads·deletePostImage)은
// 커뮤니티 오퍼레이션이 이미 선언했고 spot_qa 전용 뮤테이션은 서버에 없다(POL-042).
// 같은 오퍼레이션을 다시 선언하면 codegen이 중복으로 깨진다. 이 타입들은 repository
// 밖으로 나가지 않는다(CLAUDE.md §3, POL-020).
import '../../community/repository/community_operations.graphql.dart';
import '../../community/repository/community_schema.graphql.dart';
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
  SpotQaRepositoryImpl(this._client, {HttpClient? httpClient})
    : _httpClient = httpClient,
      // 우리가 만든 클라이언트만 닫는다 — 주입받은 것은 호출부 소유다.
      _ownsHttpClient = httpClient == null;

  final GraphQLClient _client;

  /// 스토리지 PUT 전용. 커뮤니티·DM과 같은 이유로 `dart:io`의 [HttpClient]를 쓴다 —
  /// presigned URL은 GraphQL이 아니라 스토리지로 직접 나간다.
  final HttpClient? _httpClient;
  final bool _ownsHttpClient;

  // ------------------------------------------------------------ 사진 업로드
  //
  // **커뮤니티와 같은 오퍼레이션을 쓴다**(POL-042). spot_qa 전용 업로드 뮤테이션은
  // 서버에 없고, 오브젝트 키 검증이 회원 소유 기준이라 질문/답변 사진도 이 흐름을
  // 그대로 통과한다. 전용 경로를 새로 만들면 같은 로직의 복사본이 된다.

  @override
  Future<List<PostImageUploadUrl>> createImageUploadUrls(
    List<PostImageUploadRequest> images,
  ) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationCreatePostImageUploadUrls,
      Variables$Mutation$CreatePostImageUploadUrls(
        images: images
            .map(
              (PostImageUploadRequest r) => Input$PostImageUploadRequest(
                contentType: r.contentType,
                contentLength: r.contentLength,
              ),
            )
            .toList(growable: false),
      ).toJson(),
      'createPostImageUploadUrls',
    );
    final payload = Mutation$CreatePostImageUploadUrls.fromJson(
      data,
    ).createPostImageUploadUrls;
    // 발급은 전부 아니면 전무다 — 실패하면 빈 목록이 오고 호출부가 그것으로 판단한다.
    if (!payload.success) return const <PostImageUploadUrl>[];
    return payload.uploadUrls
        .map(
          (e) => PostImageUploadUrl(
            uploadUrl: e.uploadUrl,
            objectKey: e.objectKey,
            expiresAt: e.expiresAt,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> uploadImage({
    required String uploadUrl,
    required LocalPhoto photo,
  }) async {
    final HttpClient client = _httpClient ?? HttpClient();
    try {
      final HttpClientRequest request = await client.putUrl(
        Uri.parse(uploadUrl),
      );
      // 두 헤더가 1단계 선언과 정확히 같아야 한다 — 서명에 들어 있어 다르면 403이다.
      // `contentType` 대신 `set`을 쓰는 이유: HttpHeaders.contentType은 charset을
      // 덧붙일 수 있고 그러면 서명이 깨진다.
      request.headers.set(HttpHeaders.contentTypeHeader, photo.contentType);
      request.headers.contentLength = photo.contentLength;
      // 압축이 걸리면 Content-Length가 바뀌어 서명이 깨진다.
      request.headers.set(HttpHeaders.acceptEncodingHeader, 'identity');
      // **인증 헤더를 붙이지 않는다** — 서명이 이미 URL에 들어 있다.
      request.add(photo.bytes);

      final HttpClientResponse response = await request.close();
      await response.drain<void>();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        GraphqlDebugLog.clientThrew(
          'uploadImage',
          HttpException('status ${response.statusCode}'),
        );
        throw SpotQaFailure.network;
      }
    } on SpotQaFailure {
      rethrow;
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew('uploadImage', error);
      throw SpotQaFailure.network;
    } finally {
      if (_ownsHttpClient) client.close();
    }
  }

  @override
  Future<PostImageConfirmation> confirmImageUploads(
    List<String> objectKeys,
  ) async {
    final Map<String, dynamic> data = await _mutate(
      documentNodeMutationConfirmPostImageUploads,
      Variables$Mutation$ConfirmPostImageUploads(
        objectKeys: objectKeys,
      ).toJson(),
      'confirmPostImageUploads',
    );
    final payload = Mutation$ConfirmPostImageUploads.fromJson(
      data,
    ).confirmPostImageUploads;
    // **장별로 성패가 갈리므로 던지지 않고 값으로 돌려준다** — 실패한 장만 다시
    // 올리게 하고 나머지는 살린다.
    return PostImageConfirmation(
      confirmed: payload.confirmed,
      failed: payload.failed
          .map(
            (e) => PostImageUploadFailure(objectKey: e.objectKey, code: e.code),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> deleteImage(String objectKey) async {
    await _mutate(
      documentNodeMutationDeletePostImage,
      Variables$Mutation$DeletePostImage(objectKey: objectKey).toJson(),
      'deletePostImage',
    );
  }

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
  Future<CursorPage<SpotQuestion>> fetchMyQuestions({
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryMyQuestions,
      Variables$Query$MyQuestions(first: first, after: after).toJson(),
      'spotQuestions',
    );
    final result = Query$MyQuestions.fromJson(data).spotQuestions;
    return CursorPage<SpotQuestion>(
      items: result.edges.map((e) => _question(e.node)).toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<CursorPage<SpotQuestion>> fetchQuestionsByIds(
    List<String> ids, {
    int? first,
  }) async {
    // 빈 목록이면 부를 이유가 없다. 서버도 `ids: []`를 "결과 없음"으로 답하므로
    // 결과는 같지만, 왕복 한 번을 아낀다.
    if (ids.isEmpty) return CursorPage.empty<SpotQuestion>();

    final Map<String, dynamic> data = await _query(
      documentNodeQuerySpotQuestionsByIds,
      Variables$Query$SpotQuestionsByIds(
        ids: ids,
        first: first ?? ids.length,
      ).toJson(),
      'spotQuestions',
    );
    final result = Query$SpotQuestionsByIds.fromJson(data).spotQuestions;
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
  Future<SpotQaMutationResult<void>> resolveQuestion(
    String questionId, {
    required bool resolved,
  }) => _mutateResult<void>(
        documentNodeMutationResolveSpotQuestion,
        Variables$Mutation$ResolveSpotQuestion(
          questionId: questionId,
          resolved: resolved,
        ).toJson(),
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

  /// 결과를 그대로 돌려주는 뮤테이션(업로드 3종). `userErrors`를 값으로 접는
  /// [_mutateResult]와 달리 payload를 호출부가 직접 읽는다.
  Future<Map<String, dynamic>> _mutate(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.mutate(
      MutationOptions(document: document, variables: variables),
    ),
    operation,
    variables,
  );

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
