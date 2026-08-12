import '../../../common/model/composer_photo.dart';
import '../../../common/model/post_image_upload.dart';
import '../../../common/pagination/page.dart';
import '../model/conversation.dart';
import '../model/feed_item.dart';
import '../model/message.dart';
import '../model/typing_indicator.dart';

/// 피드·DM 데이터 접근 경계(SPEC-0017).
///
/// **구현이 아직 없다.** 서버의 SPEC-0017(피드·DM 쿼리·뮤테이션·Subscription)이
/// 배포되지 않아 생성 타입을 만들 수 없다 — 오퍼레이션을 지금 쓰면 스키마 검증을
/// 통과하지 못해 codegen이 실패한다. 인터페이스만 먼저 두어 provider·화면이 이
/// 경계에 대고 개발되게 하고, 서버가 배포되면 구현체만 채운다(CLAUDE.md §13).
///
/// 생성 타입은 이 경계 밖으로 나가지 않는다 — 구현체가 도메인 모델로 매핑한다
/// (POL-020).
///
/// 실패는 두 갈래다(계약 §에러 코드):
/// - 최상위 `errors[]` — 세션·권한 신호. `UNAUTHENTICATED`, `FORBIDDEN`.
///   구현체가 예외로 던진다
/// - `userErrors[]` — 도메인 규칙 위반. 폼 상태를 유지한 채 분기해야 하므로
///   **예외가 아니라 값으로 돌려준다**([FeedMutationResult])
abstract interface class FeedRepository {
  /// 피드 목록. 최신순 고정이며 정렬 인자가 없다(R4). 총 개수는 내려오지 않으므로
  /// 소진은 `hasNextPage`로만 판정한다.
  Future<CursorPage<FeedItem>> fetchFeed({int? first, String? after});

  /// 피드 단건. 삭제되었거나 차단 관계의 작성자면 **오류가 아니라 null이다.**
  Future<FeedItem?> fetchFeedItem(String id);

  /// 피드 작성(R1·R2). [photoKeys]는 [confirmImageUploads]가 확정한 키여야 한다.
  Future<FeedMutationResult<String>> createFeedItem({
    required String body,
    required String spotId,
    required List<String> photoKeys,
  });

  /// 좋아요. **멱등이므로 중복 탭이 수를 어긋내지 않는다**(AC6-2). 성공하면 서버가
  /// 계산한 좋아요 수를 돌려주며, 그 값이 정본이다.
  Future<FeedMutationResult<int>> likeFeedItem(String feedItemId);

  /// 좋아요 취소. 멱등이며 좋아요 수가 음수가 되지 않는다(AC6-3).
  Future<FeedMutationResult<int>> unlikeFeedItem(String feedItemId);

  /// 사진 업로드 URL 발급. 커뮤니티와 같은 프로토콜을 쓴다(POL-042) — 피드 전용
  /// 업로드 경로를 새로 만들지 않는다.
  Future<List<PostImageUploadUrl>> createImageUploadUrls(
    List<PostImageUploadRequest> images,
  );

  /// 발급받은 URL로 직접 PUT한다. **GraphQL이 아니다.** 인증 헤더를 붙이지 않으며
  /// 바이트 수가 1이라도 다르면 스토리지가 403으로 거부한다.
  Future<void> uploadImage({
    required String uploadUrl,
    required LocalPhoto photo,
  });

  /// 업로드 확정. **장별로 성패가 갈리며 실패는 값으로 돌아온다** — 5장 중 3장째
  /// 실패를 "업로드 실패"로 뭉뚱그리지 않는다(설계 §4).
  Future<PostImageConfirmation> confirmImageUploads(List<String> objectKeys);

  /// 피드 작성자와의 1:1 대화를 시작한다(R7). 입력이 회원 id가 아니라 [feedItemId]라
  /// **커뮤니티 글 작성자는 구조적으로 상대가 될 수 없다.** 이미 대화가 있으면 새로
  /// 만들지 않고 기존 대화를 돌려준다(AC7-2).
  Future<FeedMutationResult<String>> startConversation(String feedItemId);

  /// 내가 참여한 대화 목록. 최근 활동순이다.
  Future<CursorPage<Conversation>> fetchConversations({
    int? first,
    String? after,
  });

  /// 대화의 메시지. **최신순이며 위로 올릴수록 과거를 더 불러온다**(AC8-2).
  /// 참여자가 아니면 최상위 `FORBIDDEN`이라 예외로 던져진다.
  Future<CursorPage<Message>> fetchMessages({
    required String conversationId,
    int? first,
    String? after,
  });

  /// 메시지 전송(R9). 본문은 앞뒤 공백 제거 후 1~1000자여야 한다.
  Future<FeedMutationResult<String>> sendMessage({
    required String conversationId,
    required String body,
  });

  /// 타이핑 알림(R10). **상대가 구독 중이 아니어도 성공한다** — 받을 사람이 없는
  /// 것은 실패가 아니다(AC10-2). 실패해도 재시도하지 않는 것이 정상이다.
  Future<void> notifyTyping(String conversationId);

  /// 상대의 타이핑 이벤트 구독(R10).
  ///
  /// **전달 보장이 없다** — 연결이 끊긴 동안의 이벤트는 유실되며 재연결해도
  /// 재전송되지 않는다. 구독이 끊겼다고 표시를 켠 채 두면 안 되는 이유이며,
  /// 표시 해제는 이벤트가 아니라 타임아웃이 판정한다(AC10-4).
  Stream<TypingIndicator> typingIndicator(String conversationId);

  /// DM 메시지 다건 신고(R15). **한 신고는 한 대화에 대한 것이다** — 여러 대화의
  /// 메시지를 섞으면 서버가 `INVALID_INPUT`으로 거부한다(AC15-4).
  Future<FeedMutationResult<void>> reportMessages({
    required List<String> messageIds,
    required String reason,
    String? detail,
  });
}

/// 뮤테이션 결과. **`userErrors[]`는 예외가 아니라 값이다**(계약 §에러 코드).
///
/// 도메인 규칙 위반은 요청이 정상 처리된 뒤 걸린 것이라, 화면이 폼 상태를 유지한 채
/// 분기해야 한다. 예외로 던지면 그 분기가 어려워진다.
class FeedMutationResult<T> {
  const FeedMutationResult.success(this.value)
    : errorCode = null,
      succeeded = true;

  const FeedMutationResult.failure(this.errorCode)
    : value = null,
      succeeded = false;

  final bool succeeded;

  /// 성공 시의 반환값(생성된 id, 갱신된 좋아요 수 등). 없을 수 있다.
  final T? value;

  /// 실패 사유 코드. `SPOT_REQUIRED`·`PHOTO_REQUIRED`·`BLOCKED`·
  /// `NOT_CONVERSATION_PARTICIPANT`·`ALREADY_REPORTED` 등.
  ///
  /// **문자열로 둔다** — 계약이 가산적이라 서버가 새 코드를 더할 수 있고, 열거형으로
  /// 전수 분기하면 그 시점에 깨진다(설계 §8과 같은 이유).
  final String? errorCode;
}
