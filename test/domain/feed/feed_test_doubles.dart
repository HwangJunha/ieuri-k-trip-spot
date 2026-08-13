import 'dart:async';

import 'package:ieuri_k_trip_spot/common/model/composer_photo.dart';
import 'package:ieuri_k_trip_spot/common/model/post_author.dart';
import 'package:ieuri_k_trip_spot/common/model/post_image_upload.dart';
import 'package:ieuri_k_trip_spot/common/model/post_spot.dart';
import 'package:ieuri_k_trip_spot/common/pagination/page.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/conversation.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/feed_item.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/message.dart';
import 'package:ieuri_k_trip_spot/domain/feed/model/typing_indicator.dart';
import 'package:ieuri_k_trip_spot/domain/feed/repository/feed_repository.dart';
import 'package:ieuri_k_trip_spot/domain/feed/repository/message_cache_store.dart';

/// 테스트용 작성자. 같은 id면 같은 사람이다.
PostAuthor author(String id, {String? nickname}) =>
    PostAuthor(id: id, nickname: nickname ?? '사용자$id');

PostSpot spot(String id) =>
    PostSpot(id: id, title: '장소$id', thumbnailImageUrl: 'https://cdn/$id.jpg');

FeedItem feedItem(
  String id, {
  int likeCount = 0,
  bool likedByViewer = false,
  bool ownedByViewer = false,
  DateTime? createdAt,
}) => FeedItem(
  id: id,
  body: '본문$id',
  spot: spot('s$id'),
  photoKeys: <String>['images/$id-1'],
  author: author('a$id'),
  createdAt: createdAt ?? DateTime.utc(2026, 8, 12),
  likeCount: likeCount,
  likedByViewer: likedByViewer,
  ownedByViewer: ownedByViewer,
);

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

/// 호출을 기록하고 미리 정한 값을 돌려주는 [FeedRepository].
///
/// 실패는 두 갈래를 모두 흉내낸다 — 값으로 오는 `userErrors`(`...Result`)와
/// 예외로 오는 전송·인증 실패(`...Throws`).
class FakeFeedRepository implements FeedRepository {
  /// `fetchFeed`가 순서대로 돌려줄 페이지들. 비면 빈 페이지를 준다.
  final List<CursorPage<FeedItem>> feedPages = <CursorPage<FeedItem>>[];

  /// `fetchMessages`가 순서대로 돌려줄 페이지들.
  final List<CursorPage<Message>> messagePages = <CursorPage<Message>>[];

  /// 던질 예외. 설정되면 해당 연산이 예외로 실패한다.
  Object? fetchFeedThrows;
  Object? fetchMessagesThrows;
  Object? sendMessageThrows;
  Object? likeThrows;

  /// 값으로 돌려줄 실패 코드. null이면 성공이다.
  String? likeErrorCode;
  String? sendErrorCode;
  String? reportErrorCode;
  String? createErrorCode;

  /// 서버가 되돌려줄 좋아요 수. null이면 payload에 값이 없는 경우다.
  int? likeCountResult;

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
  final List<String?> feedAfterCursors = <String?>[];
  final List<String?> messageAfterCursors = <String?>[];
  final List<String> sentBodies = <String>[];
  final List<String?> sentFeedItemIds = <String?>[];
  final List<String?> sentPhotoKeys = <String?>[];
  final List<List<String>> reportedMessageIds = <List<String>>[];
  int notifyTypingCalls = 0;
  int likeCalls = 0;
  int unlikeCalls = 0;

  int _feedPage = 0;
  int _messagePage = 0;
  int _sentIndex = 0;

  @override
  Future<CursorPage<FeedItem>> fetchFeed({int? first, String? after}) async {
    feedAfterCursors.add(after);
    final Object? error = fetchFeedThrows;
    if (error != null) throw error;
    if (_feedPage >= feedPages.length) return CursorPage.empty<FeedItem>();
    return feedPages[_feedPage++];
  }

  @override
  Future<FeedItem?> fetchFeedItem(String id) async => null;

  @override
  Future<FeedMutationResult<String>> createFeedItem({
    required String body,
    required String spotId,
    required List<String> photoKeys,
  }) async {
    createdPhotoKeys = photoKeys;
    final String? code = createErrorCode;
    if (code != null) return FeedMutationResult<String>.failure(code);
    return const FeedMutationResult<String>.success('feed-1');
  }

  /// 마지막 `createFeedItem`에 실린 확정 키.
  List<String> createdPhotoKeys = <String>[];

  @override
  Future<FeedMutationResult<int>> likeFeedItem(String feedItemId) async {
    likeCalls++;
    final Object? error = likeThrows;
    if (error != null) throw error;
    final String? code = likeErrorCode;
    if (code != null) return FeedMutationResult<int>.failure(code);
    return FeedMutationResult<int>.success(likeCountResult);
  }

  @override
  Future<FeedMutationResult<int>> unlikeFeedItem(String feedItemId) async {
    unlikeCalls++;
    final Object? error = likeThrows;
    if (error != null) throw error;
    final String? code = likeErrorCode;
    if (code != null) return FeedMutationResult<int>.failure(code);
    return FeedMutationResult<int>.success(likeCountResult);
  }

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
  Future<FeedMutationResult<String>> startConversation(
    String feedItemId,
  ) async => const FeedMutationResult<String>.success('c1');

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
  Future<FeedMutationResult<String>> sendMessage({
    required String conversationId,
    required String body,
    String? feedItemId,
    String? photoKey,
  }) async {
    sentBodies.add(body);
    sentFeedItemIds.add(feedItemId);
    sentPhotoKeys.add(photoKey);
    final Object? error = sendMessageThrows;
    if (error != null) throw error;
    final String? code = sendErrorCode;
    if (code != null) return FeedMutationResult<String>.failure(code);
    final String id = _sentIndex < sentMessageIds.length
        ? sentMessageIds[_sentIndex++]
        : 'server-${_sentIndex++}';
    return FeedMutationResult<String>.success(id);
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
  Future<FeedMutationResult<int>> markConversationRead({
    required String conversationId,
    String? upToMessageId,
  }) async {
    markReadCalls.add((conversationId: conversationId, upTo: upToMessageId));
    return FeedMutationResult<int>.success(markReadResult);
  }

  @override
  Future<FeedMutationResult<void>> reportMessages({
    required List<String> messageIds,
    required String reason,
    String? detail,
  }) async {
    reportedMessageIds.add(messageIds);
    final String? code = reportErrorCode;
    if (code != null) return FeedMutationResult<void>.failure(code);
    return const FeedMutationResult<void>.success(null);
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
        .where((Message m) => m.status == MessageDeliveryStatus.sent && !m.localId)
        .toList();
  }
}
