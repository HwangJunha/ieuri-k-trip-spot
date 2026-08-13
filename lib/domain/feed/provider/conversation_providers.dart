import 'dart:async';
import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/list_equality.dart';
import '../../../common/model/post_author.dart';
import '../../../common/pagination/page.dart';
import '../../../common/storage/app_preferences.dart';
import '../model/feed_failure.dart';
import '../model/feed_item.dart';
import '../model/message.dart';
import '../repository/feed_repository.dart';
import '../repository/message_cache_store.dart';
import 'feed_providers.dart';
import 'typing_providers.dart';

part 'conversation_providers.g.dart';

/// 한 번에 받아오는 메시지 수. 서버 기본값 30 / 상한 50이다(계약 §페이지네이션).
const int _pageSize = 30;

/// 메시지 재전송 상한(POL-040 — **재시도는 횟수로 제한한다**).
///
/// 시간 기반 백오프 수치는 근거가 없어 두지 않는다(설계 §3). 이 횟수를 넘으면 더
/// 자동으로 보내지 않고, 다시 보낼지는 사용자가 정한다.
const int maxMessageRetries = 3;

/// 로컬 메시지 캐시의 출처. 테스트가 이 provider를 오버라이드해 가짜 저장소를 준다.
@riverpod
MessageCacheStore messageCacheStore(Ref ref) =>
    SharedPreferencesMessageCacheStore(ref.watch(sharedPreferencesProvider));

/// 대화 화면의 상태.
class ConversationState {
  const ConversationState({
    this.messages = const <Message>[],
    this.hasMore = false,
    this.endCursor,
    this.isLoadingMore = false,
    this.fromCacheOnly = false,
    this.isSyncing = false,
    this.syncFailed = false,
  });

  /// 최신순 메시지. 화면은 위로 올릴수록 과거를 더 불러온다(AC8-2).
  final List<Message> messages;

  final bool hasMore;
  final String? endCursor;
  final bool isLoadingMore;

  /// 아직 서버 응답이 얹히지 않은, 캐시만으로 그린 상태인지.
  final bool fromCacheOnly;

  /// 첫 서버 조회가 진행 중인지. 캐시가 비어 있을 때만 화면에 로딩을 그린다 —
  /// 캐시가 있으면 대화를 보여주는 쪽이 맞다(AC18-1).
  final bool isSyncing;

  /// 서버 조회가 실패했는지. **캐시가 있으면 오류 화면 대신 캐시를 계속 보여준다**
  /// (AC18-4) — 화면이 이 값으로 재시도 수단만 덧붙인다.
  final bool syncFailed;

  bool get isEmpty => messages.isEmpty;

  ConversationState copyWith({
    List<Message>? messages,
    bool? hasMore,
    String? endCursor,
    bool? isLoadingMore,
    bool? fromCacheOnly,
    bool? isSyncing,
    bool? syncFailed,
  }) => ConversationState(
    messages: messages ?? this.messages,
    hasMore: hasMore ?? this.hasMore,
    endCursor: endCursor ?? this.endCursor,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    fromCacheOnly: fromCacheOnly ?? this.fromCacheOnly,
    isSyncing: isSyncing ?? this.isSyncing,
    syncFailed: syncFailed ?? this.syncFailed,
  );

  @override
  bool operator ==(Object other) =>
      other is ConversationState &&
      listEquals(other.messages, messages) &&
      other.hasMore == hasMore &&
      other.endCursor == endCursor &&
      other.isLoadingMore == isLoadingMore &&
      other.fromCacheOnly == fromCacheOnly &&
      other.isSyncing == isSyncing &&
      other.syncFailed == syncFailed;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(messages),
    hasMore,
    endCursor,
    isLoadingMore,
    fromCacheOnly,
    isSyncing,
    syncFailed,
  );
}

/// 한 대화의 메시지(R8·R9·R18).
///
/// **캐시를 먼저 그리고 서버 조회를 그 뒤에 얹는다**(AC18-1) — 빈 화면을 거치지
/// 않는다. 캐시가 비어 있어도 정상 동작하며(AC18-4), 서버에서 사라진 과거 메시지가
/// 로컬에 남아 있으면 그대로 보여준다(AC18-3).
@riverpod
class ConversationController extends _$ConversationController {
  FeedRepository get _repository => ref.read(feedRepositoryProvider);
  MessageCacheStore get _cache => ref.read(messageCacheStoreProvider);

  /// **build가 동기인 것이 AC18-1의 핵심이다.** 캐시를 읽는 것은 즉시 끝나므로
  /// 화면은 첫 프레임부터 캐시된 대화를 그리고, 로딩 표시를 거치지 않는다.
  /// 서버 조회는 [sync]가 그 위에 얹는다 — 조회가 build를 막으면 캐시가 있어도
  /// 빈 화면이 한 번 지나간다.
  @override
  ConversationState build(String conversationId) => ConversationState(
    messages: _cache.read(conversationId),
    fromCacheOnly: true,
  );

  /// 새 메시지 구독을 연다. **화면이 열릴 때 [sync]와 함께 부른다.**
  ///
  /// 구독은 **전달 보장이 아니라 신호다** — 끊긴 동안의 메시지는 오지 않으므로
  /// 재연결할 때마다 [sync]로 공백을 메운다. 원본은 언제나 서버다.
  ///
  /// **권한 실패(`FORBIDDEN`)에는 재연결하지 않는다** — 재시도로 풀리지 않고
  /// 상한까지 헛돌 뿐이다.
  void listenForNewMessages() {
    if (_subscription != null) return;
    _subscription = _repository
        .newMessage(conversationId)
        .listen(
          _onRemoteMessage,
          onError: (Object error, StackTrace _) {
            developer.log(
              'newMessage stream failed: ${error.runtimeType}',
              name: 'ConversationController',
            );
            if (error is FeedFailure && error.permanent) {
              // 재연결해도 같은 결과다 — 구독을 접는다.
              _subscription?.cancel();
              _subscription = null;
              return;
            }
            // 끊겼다가 다시 붙는 동안의 메시지는 오지 않으므로 조회로 메운다.
            unawaited(sync());
          },
        );
    ref.onDispose(() {
      _subscription?.cancel();
      _subscription = null;
    });
  }

  StreamSubscription<Message>? _subscription;

  /// 구독으로 들어온 메시지를 반영한다.
  ///
  /// **자기 메시지도 에코된다**(다른 기기에서 보낸 경우가 있어서다). 낙관적으로
  /// 그려 둔 말풍선과 겹치면 두 번 뜨므로 두 단계로 dedupe한다:
  /// 1. 같은 서버 id가 이미 있으면 갱신만 한다
  /// 2. 아직 서버 id를 못 받은 내 말풍선 중 **본문·첨부가 같은 것**이 있으면 그것을
  ///    확정 처리한다 — 전송 응답보다 에코가 먼저 도착할 수 있다
  void _onRemoteMessage(Message incoming) {
    final List<Message> messages = <Message>[...state.messages];

    final int sameId = messages.indexWhere((Message m) => m.id == incoming.id);
    if (sameId >= 0) {
      messages[sameId] = incoming;
      state = state.copyWith(messages: messages);
      unawaited(_persist());
      return;
    }

    if (incoming.ownedByViewer) {
      final int pending = messages.indexWhere(
        (Message m) =>
            m.localId &&
            m.ownedByViewer &&
            m.body == incoming.body &&
            m.photoKey == incoming.photoKey,
      );
      if (pending >= 0) {
        messages[pending] = incoming;
        state = state.copyWith(messages: messages);
        unawaited(_persist());
        return;
      }
    }

    state = state.copyWith(
      messages: <Message>[incoming, ...messages],
      fromCacheOnly: false,
    );
    unawaited(_persist());
  }

  /// 대화를 읽음 처리한다.
  ///
  /// **조회만으로는 읽음이 되지 않는다** — 화면이 이 시점을 정해 부른다. 이 앱은
  /// **대화 화면에 들어올 때** 부르며(목록 미리보기나 알림에서 스쳐 본 것은 읽음이
  /// 아니다), `upToMessageId`를 생략해 "모두 읽음"으로 보낸다.
  ///
  /// 멱등이라 중복 호출이 안전하고, 잔여 수를 돌려주므로 재조회가 필요 없다.
  Future<int?> markRead() async {
    try {
      final FeedMutationResult<int> result = await _repository
          .markConversationRead(conversationId: conversationId);
      return result.succeeded ? result.value : null;
    } on Object catch (error) {
      // 읽음 처리 실패는 대화를 막지 않는다 — 다음 진입에서 다시 시도된다.
      developer.log(
        'markConversationRead failed: ${error.runtimeType}',
        name: 'ConversationController',
      );
      return null;
    }
  }

  /// 서버 조회를 캐시 위에 얹는다. **화면이 열릴 때 한 번 부른다.**
  ///
  /// build 안에서 스스로 시작하지 않는 이유는 Riverpod이 build 도중의 상태 변경을
  /// 금지하기 때문이다 — 화면이 명시적으로 부르는 편이 시점도 분명하다.
  Future<void> sync() async {
    if (state.isSyncing) return;
    state = state.copyWith(isSyncing: true, syncFailed: false);
    try {
      final CursorPage<Message> page = await _repository.fetchMessages(
        conversationId: conversationId,
        first: _pageSize,
      );
      // **서버에 없다는 이유로 기기의 기록을 지우지 않는다**(AC18-3).
      final List<Message> merged = mergeCachedMessages(
        cached: state.messages,
        fromServer: page.items,
      );
      await _cache.write(conversationId, merged);
      state = state.copyWith(
        messages: merged,
        hasMore: page.hasNextPage,
        endCursor: page.endCursor,
        fromCacheOnly: false,
        isSyncing: false,
      );
    } on Object catch (error) {
      // 조회 실패는 화면을 오류로 바꾸지 않는다 — 캐시가 있으면 그것이 계속
      // 보이는 것이 맞다(AC18-4). 캐시가 비었으면 빈 대화로 남는다.
      developer.log(
        'fetchMessages failed: ${error.runtimeType}',
        name: 'ConversationController',
      );
      state = state.copyWith(isSyncing: false, syncFailed: true);
    }
  }

  /// 과거 메시지를 더 불러온다(AC8-2).
  Future<void> loadMore() async {
    final ConversationState current = state;
    if (!current.hasMore || current.isLoadingMore) return;

    state = current.copyWith(isLoadingMore: true);
    try {
      final CursorPage<Message> page = await _repository.fetchMessages(
        conversationId: conversationId,
        first: _pageSize,
        after: current.endCursor,
      );
      final List<Message> merged = mergeCachedMessages(
        cached: state.messages,
        fromServer: page.items,
      );
      await _cache.write(conversationId, merged);
      state = state.copyWith(
        messages: merged,
        hasMore: page.hasNextPage,
        endCursor: page.endCursor,
        isLoadingMore: false,
      );
    } on Object catch (error) {
      developer.log(
        'loadMore failed: ${error.runtimeType}',
        name: 'ConversationController',
      );
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// 메시지를 보낸다(R9).
  ///
  /// **전송 중 상태로 즉시 말풍선을 그리고, 실패하면 실패 표시를 남긴다**(설계 §3).
  /// 조용히 사라지지 않는다.
  /// [photoKey]는 확정된 키여야 하고, [quoted]는 인용할 피드다.
  ///
  /// **본문·사진·인용이 셋 다 비면 보내지 않는다** — 서버가 거부할 요청이다. 반대로
  /// 사진만 보내는 것은 정상이며, 그때 본문은 빈 문자열로 나간다.
  Future<void> send({
    required PostAuthor me,
    String body = '',
    String? photoKey,
    FeedItem? quoted,
  }) async {
    final String trimmed = body.trim();
    if (trimmed.isEmpty && photoKey == null && quoted == null) return;

    final String localId =
        'local-${ref.read(typingClockProvider)().microsecondsSinceEpoch}';
    final Message pending = Message(
      id: localId,
      body: trimmed,
      sender: me,
      createdAt: ref.read(typingClockProvider)(),
      ownedByViewer: true,
      feedItem: quoted,
      photoKey: photoKey,
      status: MessageDeliveryStatus.sending,
      localId: true,
    );

    _insert(pending);
    await _deliver(pending);
  }

  /// 실패한 메시지를 다시 보낸다.
  ///
  /// **횟수 상한을 넘으면 보내지 않는다**(POL-040). 상한에 걸린 메시지는 실패 표시로
  /// 남으며, 사용자가 지우거나 새로 쓰는 것이 다음 수단이다.
  Future<void> retry(String messageId) async {
    final ConversationState current = state;
    final int at = current.messages.indexWhere(
      (Message m) => m.id == messageId,
    );
    if (at < 0) return;

    final Message failed = current.messages[at];
    if (failed.status != MessageDeliveryStatus.failed) return;
    if (failed.retryCount >= maxMessageRetries) return;

    final Message retrying = failed.copyWith(
      status: MessageDeliveryStatus.sending,
      retryCount: failed.retryCount + 1,
    );
    _replace(messageId, retrying);
    await _deliver(retrying);
  }

  /// 전송을 시도하고 결과에 따라 말풍선 상태를 옮긴다.
  Future<void> _deliver(Message pending) async {
    try {
      final FeedMutationResult<String> result = await _repository.sendMessage(
        conversationId: conversationId,
        // 사진만 보낼 때도 빈 문자열이 실린다 — non-null이라 생략할 수 없다.
        body: pending.body,
        feedItemId: pending.feedItem?.id,
        photoKey: pending.photoKey,
      );
      if (!result.succeeded) {
        developer.log(
          'sendMessage rejected: ${result.errorCode}',
          name: 'ConversationController',
        );
        _replace(
          pending.id,
          pending.copyWith(status: MessageDeliveryStatus.failed),
        );
        return;
      }
      final String? serverId = result.value;
      // **에코가 응답보다 먼저 도착했을 수 있다.** 그때는 구독이 이미 이 메시지를
      // 서버 id로 넣어 뒀으므로, 낙관적 말풍선만 걷어내고 끝낸다 — 다시 넣으면
      // 같은 메시지가 두 번 뜬다.
      if (serverId != null && _contains(serverId)) {
        _remove(pending.id);
        await _persist();
        return;
      }

      // 서버 id로 교체한다 — 이때부터 신고·캐시 대상이 된다.
      final Message sent = pending.copyWith(
        id: serverId ?? pending.id,
        status: MessageDeliveryStatus.sent,
        localId: serverId == null,
      );
      _replace(pending.id, sent);
      await _persist();
    } on Object catch (error) {
      developer.log(
        'sendMessage failed: ${error.runtimeType}',
        name: 'ConversationController',
      );
      _replace(
        pending.id,
        pending.copyWith(status: MessageDeliveryStatus.failed),
      );
    }
  }

  void _insert(Message message) {
    state = state.copyWith(
      messages: <Message>[message, ...state.messages],
      fromCacheOnly: false,
    );
  }

  void _replace(String messageId, Message replacement) {
    final List<Message> messages = <Message>[...state.messages];
    final int at = messages.indexWhere((Message m) => m.id == messageId);
    if (at < 0) return;
    messages[at] = replacement;
    state = state.copyWith(messages: messages);
  }

  bool _contains(String messageId) =>
      state.messages.any((Message m) => m.id == messageId);

  void _remove(String messageId) => state = state.copyWith(
    messages: state.messages
        .where((Message m) => m.id != messageId)
        .toList(growable: false),
  );

  /// 확정된 메시지만 캐시에 남긴다(AC18-2). 전송 중·실패는 저장소가 걸러낸다.
  Future<void> _persist() => _cache.write(conversationId, state.messages);
}
