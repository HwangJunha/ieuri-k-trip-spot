import '../../../common/model/composer_photo.dart';
import '../../../common/model/post_image_upload.dart';
import '../../../common/pagination/page.dart';
import '../model/conversation.dart';
import '../model/message.dart';
import '../model/typing_indicator.dart';

/// DM 데이터 접근 경계(SPEC-0017 · SPEC-0021).
///
/// 생성 타입은 이 경계 밖으로 나가지 않는다 — 구현체가 도메인 모델로 매핑한다
/// (POL-020).
///
/// 실패는 두 갈래다(계약 §에러 코드):
/// - 최상위 `errors[]` — 세션·권한 신호. `UNAUTHENTICATED`, `FORBIDDEN`.
///   구현체가 예외로 던진다
/// - `userErrors[]` — 도메인 규칙 위반. 폼 상태를 유지한 채 분기해야 하므로
///   **예외가 아니라 값으로 돌려준다**([DmMutationResult])
abstract interface class DmRepository {
  /// 사진 업로드 URL 발급. 커뮤니티와 같은 프로토콜을 쓴다(POL-042) — DM 전용
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

  /// 지정한 회원과의 1:1 대화를 시작한다(SPEC-0021 R11).
  ///
  /// **입력이 피드 항목 id에서 회원 id로 바뀌었다.** 피드가 사라지면서 "이 글의
  /// 작성자와 대화" 라는 간접 지정이 성립하지 않기 때문이다. 서버 필드명은
  /// `counterpartMemberId`이며 — 상대를 가리키는 값이라는 뜻이 이름에 들어 있다 —
  /// 이 경계의 인자명도 그대로 따른다. 이미 대화가 있으면 새로 만들지 않고 기존
  /// 대화를 돌려준다(AC7-2).
  ///
  /// **인용 인자를 받지 않는다**(2026-08-18 서버가 옮겼다). 대화를 여는 것과 인용을
  /// 붙이는 것이 분리됐고, 인용은 [sendMessage]가 받는다.
  Future<DmMutationResult<String>> startConversation(String counterpartMemberId);

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

  /// 메시지 전송(R9).
  ///
  /// **[body]는 non-null이라 사진·인용만 보낼 때도 빈 문자열을 넘긴다** — 생략하면
  /// GraphQL 검증에서 실패한다. 다만 [body]·[photoKey]·[sourceAnswerId]가 **모두**
  /// 비면 서버가 거부한다.
  ///
  /// [photoKey]는 `confirmImageUploads`가 확정한 키다 — DM 전용 업로드 경로는 없다.
  ///
  /// [sourceAnswerId]를 주면 그 질문/답변 스냅샷이 **이 메시지에** 남는다
  /// (SPEC-0026). 한 대화에서 몇 번이든, 서로 다른 질문을 인용할 수 있고 앞선 인용은
  /// 덮이지 않는다.
  ///
  /// **인용을 만들지 못해도 메시지는 간다** — 답변이 삭제됐거나 작성자가 대화 상대가
  /// 아니면 서버가 조용히 무시하고 일반 메시지로 보낸다. 거절이 아니므로 호출부는
  /// `Message.spotQaOrigin`이 null인 경우를 처리해야 한다.
  ///
  /// 본문 없이 인용만 보낼 수 있다(`body: ''`).
  Future<DmMutationResult<String>> sendMessage({
    required String conversationId,
    required String body,
    String? photoKey,
    String? sourceAnswerId,
  });

  /// 대화를 읽음 처리한다.
  ///
  /// **메시지를 조회하는 것만으로는 읽음이 되지 않는다** — 목록 미리보기나 알림에서
  /// 스쳐 본 것이 읽음이 되면 사용자가 메시지를 놓치기 때문이다. 화면이 시점을 정해
  /// 명시적으로 부른다.
  ///
  /// [upToMessageId]를 생략하면 **모두 읽음**이다. 읽음 지점은 뒤로 가지 않으므로
  /// 멱등이며 중복 호출·재시도가 안전하다. 반환값이 처리 후 잔여 수라 재조회가
  /// 필요 없다.
  Future<DmMutationResult<int>> markConversationRead({
    required String conversationId,
    String? upToMessageId,
  });

  /// 새 메시지 구독(R9).
  ///
  /// **전달 보장이 아니라 신호다** — 끊긴 동안의 메시지는 오지 않으므로 재연결 시
  /// [fetchMessages]로 공백을 메운다. 원본은 언제나 서버다. 타이핑과 결정적으로
  /// 다른 점이며, 타이핑은 버려도 되지만 메시지는 안 된다.
  ///
  /// **자기 메시지도 에코된다**(다른 기기에서 보낸 경우가 있어서다). 낙관적으로 그린
  /// 말풍선과 `Message.id`로 dedupe하지 않으면 내 메시지가 두 번 뜬다.
  Stream<Message> newMessage(String conversationId);

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
  Future<DmMutationResult<void>> reportMessages({
    required List<String> messageIds,
    required String reason,
    String? detail,
  });
}

/// 뮤테이션 결과. **`userErrors[]`는 예외가 아니라 값이다**(계약 §에러 코드).
///
/// 도메인 규칙 위반은 요청이 정상 처리된 뒤 걸린 것이라, 화면이 폼 상태를 유지한 채
/// 분기해야 한다. 예외로 던지면 그 분기가 어려워진다.
class DmMutationResult<T> {
  const DmMutationResult.success(this.value)
    : errorCode = null,
      succeeded = true;

  const DmMutationResult.failure(this.errorCode)
    : value = null,
      succeeded = false;

  final bool succeeded;

  /// 성공 시의 반환값(생성된 id, 잔여 안 읽은 수 등). 없을 수 있다.
  final T? value;

  /// 실패 사유 코드. `PHOTO_REQUIRED`·`BLOCKED`·`NOT_CONVERSATION_PARTICIPANT`·
  /// `ALREADY_REPORTED` 등.
  ///
  /// **문자열로 둔다** — 계약이 가산적이라 서버가 새 코드를 더할 수 있고, 열거형으로
  /// 전수 분기하면 그 시점에 깨진다(설계 §8과 같은 이유).
  final String? errorCode;
}
