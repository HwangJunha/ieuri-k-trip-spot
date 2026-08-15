import 'dart:async';

import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/common/model/post_author.dart';
import 'package:ieuri_k_trip_spot/common/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/conversation.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/dm/model/typing_indicator.dart';
import 'package:ieuri_k_trip_spot/domain/dm/repository/dm_repository.dart';
import 'package:ieuri_k_trip_spot/domain/dm/repository/message_cache_store.dart';

/// 테스트용 작성자. 같은 id면 같은 사람이다.
PostAuthor author(String id, {String? nickname}) =>
    PostAuthor(id: id, nickname: nickname ?? '사용자$id');

Message message(
  String id, {
  String body = '메시지',
  bool ownedByViewer = false,
  DateTime? createdAt,
  MessageDeliveryStatus status = MessageDeliveryStatus.sent,
  bool localId = false,
}) => Message(
  id: id,
  body: body,
  sender: author(ownedByViewer ? 'me' : 'other'),
  createdAt: createdAt ?? DateTime.utc(2026, 8, 12),
  ownedByViewer: ownedByViewer,
  status: status,
  localId: localId,
);

/// 호출을 기록하고 미리 정한 값을 돌려주는 [DmRepository].
///
/// 실패는 두 갈래를 모두 흉내낸다 — 값으로 오는 `userErrors`(`...Result`)와
/// 예외로 오는 전송·인증 실패(`...Throws`).
class FakeDmRepository implements DmRepository {
  /// `fetchMessages`가 순서대로 돌려줄 페이지들.
  final List<CursorPage<Message>> messagePages = <CursorPage<Message>>[];

  /// 던질 예외. 설정되면 해당 연산이 예외로 실패한다.
  Object? fetchMessagesThrows;
  Object? sendMessageThrows;

  /// 값으로 돌려줄 실패 코드. null이면 성공이다.
  String? sendErrorCode;
  String? reportErrorCode;

  /// `sendMessage`가 부여할 서버 id들(순서대로).
  final List<String> sentMessageIds = <String>[];

  /// 타이핑 이벤트를 밀어넣는 통로.
  final StreamController<TypingIndicator> typingEvents =
      StreamController<TypingIndicator>.broadcast();

  /// 새 메시지 이벤트를 밀어넣는 통로. **자기 메시지도 에코된다**(다른 기기에서
  /// 보낸 경우가 있어서다).
  final StreamController<Message> newMessages =
      StreamController<Message>.broadcast();

  /// `markConversationRead`가 돌려줄 잔여 미읽음 수.
  int markReadResult = 0;

  /// 읽음 처리 호출 기록 — (대화, upToMessageId).
  final List<({String conversationId, String? upTo})> markReadCalls =
      <({String conversationId, String? upTo})>[];

  // 호출 기록.
  final List<String?> messageAfterCursors = <String?>[];
  final List<String> sentBodies = <String>[];
  final List<String?> sentPhotoKeys = <String?>[];
  final List<List<String>> reportedMessageIds = <List<String>>[];
  int notifyTypingCalls = 0;

  int _messagePage = 0;
  int _sentIndex = 0;

  /// 발급할 URL들. 비면 요청 수만큼 자동으로 만든다.
  List<PostImageUploadUrl>? uploadUrls;

  /// PUT이 실패할 objectKey들.
  final Set<String> failingUploads = <String>{};

  /// 확인에서 떨어뜨릴 objectKey들.
  final Set<String> failingConfirms = <String>{};

  final List<String> putObjectKeys = <String>[];

  @override
  Future<List<PostImageUploadUrl>> createImageUploadUrls(
    List<PostImageUploadRequest> images,
  ) async =>
      uploadUrls ??
      <PostImageUploadUrl>[
        for (int i = 0; i < images.length; i++)
          PostImageUploadUrl(
            uploadUrl: 'https://storage/$i',
            objectKey: 'pending/$i',
            expiresAt: 'x',
          ),
      ];

  @override
  Future<void> uploadImage({
    required String uploadUrl,
    required LocalPhoto photo,
  }) async {
    final String key = 'pending/${uploadUrl.split('/').last}';
    putObjectKeys.add(key);
    if (failingUploads.contains(key)) throw StateError('upload failed');
  }

  @override
  Future<PostImageConfirmation> confirmImageUploads(
    List<String> objectKeys,
  ) async {
    final List<String> confirmed = <String>[];
    final List<PostImageUploadFailure> failed = <PostImageUploadFailure>[];
    for (final String key in objectKeys) {
      if (failingConfirms.contains(key)) {
        failed.add(PostImageUploadFailure(objectKey: key, code: 'NOT_FOUND'));
      } else {
        confirmed.add(key.replaceFirst('pending/', 'images/'));
      }
    }
    return PostImageConfirmation(confirmed: confirmed, failed: failed);
  }

  @override
  Future<DmMutationResult<String>> startConversation(String memberId) async {
    startedMemberIds.add(memberId);
    return const DmMutationResult<String>.success('c1');
  }

  /// `startConversation`에 실린 회원 id들.
  final List<String> startedMemberIds = <String>[];

  @override
  Future<CursorPage<Conversation>> fetchConversations({
    int? first,
    String? after,
  }) async => CursorPage.empty<Conversation>();

  @override
  Future<CursorPage<Message>> fetchMessages({
    required String conversationId,
    int? first,
    String? after,
  }) async {
    messageAfterCursors.add(after);
    final Object? error = fetchMessagesThrows;
    if (error != null) throw error;
    if (_messagePage >= messagePages.length) return CursorPage.empty<Message>();
    return messagePages[_messagePage++];
  }

  @override
  Future<DmMutationResult<String>> sendMessage({
    required String conversationId,
    required String body,
    String? photoKey,
  }) async {
    sentBodies.add(body);
    sentPhotoKeys.add(photoKey);
    final Object? error = sendMessageThrows;
    if (error != null) throw error;
    final String? code = sendErrorCode;
    if (code != null) return DmMutationResult<String>.failure(code);
    final String id = _sentIndex < sentMessageIds.length
        ? sentMessageIds[_sentIndex++]
        : 'server-${_sentIndex++}';
    return DmMutationResult<String>.success(id);
  }

  @override
  Future<void> notifyTyping(String conversationId) async {
    notifyTypingCalls++;
  }

  @override
  Stream<TypingIndicator> typingIndicator(String conversationId) =>
      typingEvents.stream;

  @override
  Stream<Message> newMessage(String conversationId) => newMessages.stream;

  @override
  Future<DmMutationResult<int>> markConversationRead({
    required String conversationId,
    String? upToMessageId,
  }) async {
    markReadCalls.add((conversationId: conversationId, upTo: upToMessageId));
    return DmMutationResult<int>.success(markReadResult);
  }

  @override
  Future<DmMutationResult<void>> reportMessages({
    required List<String> messageIds,
    required String reason,
    String? detail,
  }) async {
    reportedMessageIds.add(messageIds);
    final String? code = reportErrorCode;
    if (code != null) return DmMutationResult<void>.failure(code);
    return const DmMutationResult<void>.success(null);
  }
}

/// 메모리 기반 [MessageCacheStore]. 앱 재시작은 같은 인스턴스를 다시 읽는 것으로
/// 흉내낸다 — 실제 저장소를 세우지 않는다.
class FakeMessageCacheStore implements MessageCacheStore {
  FakeMessageCacheStore([Map<String, List<Message>>? seed])
    : _byConversation = <String, List<Message>>{...?seed};

  final Map<String, List<Message>> _byConversation;

  @override
  List<Message> read(String conversationId) =>
      _byConversation[conversationId] ?? const <Message>[];

  @override
  Future<void> write(String conversationId, List<Message> messages) async {
    // 실제 구현과 같은 규칙 — 확정된 메시지만 남긴다.
    _byConversation[conversationId] = messages
        .where(
          (Message m) => m.status == MessageDeliveryStatus.sent && !m.localId,
        )
        .toList();
  }
}
