import 'dart:io';

import 'package:gql/ast.dart' show DocumentNode;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/model/composer_photo.dart';
import '../../../common/model/post_author.dart';
import '../../../common/model/post_image_upload.dart';
import '../../../common/network/graphql_debug_log.dart';
import '../../../common/network/graphql_failure.dart';
import '../../../common/pagination/page.dart';
// 생성 타입 하나만 가져온다 — 업로드 프로토콜(createPostImageUploadUrls·
// confirmPostImageUploads)은 커뮤니티 오퍼레이션이 이미 선언했고, DM 전용 업로드
// 뮤테이션은 서버에 없다. 같은 오퍼레이션을 다시 선언하면 codegen이 중복으로 깨진다.
// 이 타입은 repository 밖으로 나가지 않는다(CLAUDE.md §3, POL-020).
import '../../community/repository/community_operations.graphql.dart';
import '../../community/repository/community_schema.graphql.dart';
import '../model/conversation.dart';
import '../model/dm_failure.dart';
import '../model/message.dart';
import '../model/typing_indicator.dart';
import 'dm_operations.graphql.dart';
import 'dm_repository.dart';

/// GraphQL 기반 [DmRepository](SPEC-0017 · SPEC-0021). 생성 타입은 **이 파일 밖으로 나가지
/// 않는다**(CLAUDE.md §3, POL-020).
///
/// 실패 판정이 두 갈래다(계약 §에러):
///  - 조회·구독의 최상위 `errors[]` — `UNAUTHENTICATED`·`FORBIDDEN`. 예외로 던진다
///  - 뮤테이션 payload의 `userErrors[]` — 도메인 규칙. **예외가 아니라 값으로 돌려준다**
///    ([DmMutationResult]) — 화면이 폼 상태를 유지한 채 분기해야 하기 때문이다
///
/// 구독은 **별도 소켓 클라이언트**를 쓴다. 쿼리·뮤테이션은 HTTP, 구독만 WebSocket이다.
class DmRepositoryImpl implements DmRepository {
  DmRepositoryImpl(
    this._client, {
    required this.socketClient,
    HttpClient? httpClient,
  }) : _httpClient = httpClient,
       // 우리가 만든 클라이언트만 닫는다 — 주입받은 것은 호출부 소유다.
       _ownsHttpClient = httpClient == null;

  final GraphQLClient _client;

  /// 구독 전용. HTTP 클라이언트와 분리돼 있다(`common/network/graphql_socket_client`).
  final GraphQLClient socketClient;

  /// 스토리지 PUT 전용. 커뮤니티와 같은 이유로 `dart:io`의 [HttpClient]를 쓴다.
  final HttpClient? _httpClient;
  final bool _ownsHttpClient;

  // ------------------------------------------------------------ 사진 업로드
  //
  // **커뮤니티와 같은 오퍼레이션을 쓴다** — DM 전용 업로드 뮤테이션은 서버에
  // 없다(POL-042). 새로 만들면 서버에 없는 연산을 부르게 된다.

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
    // 발급은 전부 아니면 전무다 — 실패하면 빈 목록이 오고, 호출부가 그것으로 판단한다.
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
        throw DmFailure.network;
      }
    } on DmFailure {
      rethrow;
    } on Exception catch (error) {
      GraphqlDebugLog.clientThrew('uploadImage', error);
      throw DmFailure.network;
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
    // **장별로 성패가 갈리므로 던지지 않고 값으로 돌려준다** — 실패한 장만 다시 올리게
    // 하고 나머지는 살린다.
    return PostImageConfirmation(
      confirmed: payload.confirmed,
      failed: payload.failed
          .map(
            (e) => PostImageUploadFailure(objectKey: e.objectKey, code: e.code),
          )
          .toList(growable: false),
    );
  }

  // ------------------------------------------------------------------ DM

  @override
  Future<DmMutationResult<String>> startConversation(String memberId) =>
      _mutateResult(
        documentNodeMutationStartConversation,
        Variables$Mutation$StartConversation(memberId: memberId).toJson(),
        'startConversation',
        (Map<String, dynamic> data) {
          final payload = Mutation$StartConversation.fromJson(
            data,
          ).startConversation;
          return (
            success: payload.success,
            codes: payload.userErrors
                .map((e) => e.code)
                .toList(growable: false),
            value: payload.conversationId,
          );
        },
      );

  @override
  Future<CursorPage<Conversation>> fetchConversations({
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryConversations,
      Variables$Query$Conversations(first: first, after: after).toJson(),
      'conversations',
    );
    final result = Query$Conversations.fromJson(data).conversations;
    return CursorPage<Conversation>(
      items: result.edges
          .map((e) => _conversation(e.node))
          .toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<CursorPage<Message>> fetchMessages({
    required String conversationId,
    int? first,
    String? after,
  }) async {
    final Map<String, dynamic> data = await _query(
      documentNodeQueryConversationMessages,
      Variables$Query$ConversationMessages(
        conversationId: conversationId,
        first: first,
        after: after,
      ).toJson(),
      'conversationMessages',
    );
    final result = Query$ConversationMessages.fromJson(
      data,
    ).conversationMessages;
    return CursorPage<Message>(
      items: result.edges.map((e) => _message(e.node)).toList(growable: false),
      hasNextPage: result.pageInfo.hasNextPage,
      endCursor: result.pageInfo.endCursor,
    );
  }

  @override
  Future<DmMutationResult<String>> sendMessage({
    required String conversationId,
    required String body,
    String? photoKey,
  }) => _mutateResult(
    documentNodeMutationSendMessage,
    Variables$Mutation$SendMessage(
      conversationId: conversationId,
      // `body`는 non-null이다 — 사진만 보낼 때도 빈 문자열이 실린다. 생략하면
      // GraphQL 검증 단계에서 실패한다.
      body: body,
      photoKey: photoKey,
    ).toJson(),
    'sendMessage',
    (Map<String, dynamic> data) {
      final payload = Mutation$SendMessage.fromJson(data).sendMessage;
      return (
        success: payload.success,
        codes: payload.userErrors.map((e) => e.code).toList(growable: false),
        value: payload.messageId,
      );
    },
  );

  @override
  Future<void> notifyTyping(String conversationId) async {
    // **실패해도 재시도하지 않는다**(AC10-2) — 받을 사람이 없는 것은 실패가 아니고,
    // 유실 허용 기능을 살리려고 큐를 두지 않는다(POL-048).
    await _mutateResult(
      documentNodeMutationNotifyTyping,
      Variables$Mutation$NotifyTyping(conversationId: conversationId).toJson(),
      'notifyTyping',
      (Map<String, dynamic> data) {
        final payload = Mutation$NotifyTyping.fromJson(data).notifyTyping;
        return (
          success: payload.success,
          codes: payload.userErrors.map((e) => e.code).toList(growable: false),
          value: null,
        );
      },
    );
  }

  @override
  Future<DmMutationResult<int>> markConversationRead({
    required String conversationId,
    String? upToMessageId,
  }) => _mutateResult(
    documentNodeMutationMarkConversationRead,
    Variables$Mutation$MarkConversationRead(
      conversationId: conversationId,
      // 생략이 "모두 읽음"이다.
      upToMessageId: upToMessageId,
    ).toJson(),
    'markConversationRead',
    (Map<String, dynamic> data) {
      final payload = Mutation$MarkConversationRead.fromJson(
        data,
      ).markConversationRead;
      return (
        success: payload.success,
        codes: payload.userErrors.map((e) => e.code).toList(growable: false),
        // 처리 후 잔여 수 — 재조회가 필요 없다.
        value: payload.unreadCount,
      );
    },
  );

  @override
  Future<DmMutationResult<void>> reportMessages({
    required List<String> messageIds,
    required String reason,
    String? detail,
  }) => _mutateResult<void>(
    documentNodeMutationReportMessages,
    Variables$Mutation$ReportMessages(
      messageIds: messageIds,
      reason: _reportReason(reason),
      detail: detail,
    ).toJson(),
    'reportMessages',
    (Map<String, dynamic> data) {
      final payload = Mutation$ReportMessages.fromJson(data).reportMessages;
      return (
        success: payload.success,
        codes: payload.userErrors.map((e) => e.code).toList(growable: false),
        value: null,
      );
    },
  );

  // ---------------------------------------------------------------- 구독

  @override
  Stream<TypingIndicator> typingIndicator(String conversationId) =>
      _subscribe(
        documentNodeSubscriptionTypingIndicator,
        Variables$Subscription$TypingIndicator(
          conversationId: conversationId,
        ).toJson(),
        'typingIndicator',
      ).map((Map<String, dynamic> data) {
        final event = Subscription$TypingIndicator.fromJson(
          data,
        ).typingIndicator;
        return TypingIndicator(
          sender: _author(event.sender),
          emittedAt: _parseTime(event.emittedAt),
        );
      });

  @override
  Stream<Message> newMessage(String conversationId) =>
      _subscribe(
        documentNodeSubscriptionNewMessage,
        Variables$Subscription$NewMessage(
          conversationId: conversationId,
        ).toJson(),
        'newMessage',
      ).map(
        (Map<String, dynamic> data) =>
            _message(Subscription$NewMessage.fromJson(data).newMessage),
      );

  /// 구독을 열고 payload만 흘린다.
  ///
  /// **권한 실패는 구독 시작 시점의 최상위 `errors[]`로 온다** — `userErrors`가
  /// 아니다. 여기서 [DmFailure]로 번역해 던지면, 재연결 로직이
  /// [DmFailure.permanent]를 보고 `FORBIDDEN`에는 재시도하지 않을 수 있다.
  Stream<Map<String, dynamic>> _subscribe(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) {
    GraphqlDebugLog.request(operation, variables);
    return socketClient
        .subscribe(
          SubscriptionOptions(document: document, variables: variables),
        )
        .map((QueryResult<Object?> result) {
          if (hasRootFailure(result, operation)) {
            GraphqlDebugLog.transportFailure(operation, result);
            throw DmFailure.fromQueryErrorCode(
              _rootErrorCode(result, operation),
            );
          }
          final Object? data = result.data;
          if (data is! Map<String, dynamic>) throw DmFailure.unknown;
          return data;
        });
  }

  // ---------------------------------------------------------------- 매핑

  Message _message(Fragment$MessageParts node) => Message(
    id: node.id,
    // 빈 문자열일 수 있다 — 첨부만 보낸 메시지가 그렇다. 접거나 숨기지 않는다.
    body: node.body,
    sender: _author(node.sender),
    createdAt: _parseTime(node.createdAt),
    ownedByViewer: node.ownedByViewer,
    photoKey: node.photoKey,
  );

  Conversation _conversation(Fragment$ConversationParts node) => Conversation(
    id: node.id,
    counterpart: _author(node.counterpart),
    lastMessage: node.lastMessage == null ? null : _message(node.lastMessage!),
    unreadCount: node.unreadCount,
    updatedAt: _parseTime(node.updatedAt),
  );

  PostAuthor _author(Fragment$DmAuthorParts a) => PostAuthor(
    id: a.id,
    nickname: a.nickname,
    profileImageUrl: a.profileImageUrl,
  );

  /// 신고 사유 문자열 → 생성 enum. 커뮤니티가 이미 쓰는 열거형을 그대로 쓴다.
  Enum$ReportReason _reportReason(String reason) =>
      switch (reason.toUpperCase()) {
        'SPAM' => Enum$ReportReason.SPAM,
        'ABUSE' => Enum$ReportReason.ABUSE,
        'INAPPROPRIATE_CONTENT' => Enum$ReportReason.INAPPROPRIATE_CONTENT,
        _ => Enum$ReportReason.OTHER,
      };

  /// ISO-8601 문자열 → UTC [DateTime]. 파싱에 실패하면 epoch로 접는다 — 시각 하나
  /// 때문에 목록 전체가 실패하지 않게 한다.
  DateTime _parseTime(String raw) =>
      DateTime.tryParse(raw)?.toUtc() ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  // ---------------------------------------------------------------- 실행

  Future<Map<String, dynamic>> _query(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
  ) => _run(
    () => _client.query(QueryOptions(document: document, variables: variables)),
    operation,
    variables,
  );

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

  /// 뮤테이션을 실행하고 **`userErrors`를 값으로** 돌려준다.
  ///
  /// 전송·인증·권한 실패는 예외로 나가고(그건 폼 상태로 분기할 성질이 아니다),
  /// 도메인 규칙 위반만 [DmMutationResult.failure]가 된다.
  Future<DmMutationResult<T>> _mutateResult<T>(
    DocumentNode document,
    Map<String, dynamic> variables,
    String operation,
    ({bool success, List<String> codes, Object? value}) Function(
      Map<String, dynamic> data,
    )
    parse,
  ) async {
    final Map<String, dynamic> data = await _mutate(
      document,
      variables,
      operation,
    );
    final parsed = parse(data);
    if (parsed.codes.isNotEmpty) {
      GraphqlDebugLog.userErrors(
        operation,
        parsed.codes
            .map((String c) => (code: c, field: null as String?))
            .toList(growable: false),
      );
      return DmMutationResult<T>.failure(parsed.codes.first);
    }
    if (!parsed.success) return const DmMutationResult.failure(null);
    return DmMutationResult<T>.success(parsed.value as T?);
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
      throw DmFailure.network;
    }

    GraphqlDebugLog.response(operation, result);

    if (hasRootFailure(result, operation)) {
      GraphqlDebugLog.transportFailure(operation, result);
      throw DmFailure.fromQueryErrorCode(_rootErrorCode(result, operation));
    }

    final Object? data = result.data;
    if (data is! Map<String, dynamic>) throw DmFailure.unknown;
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
