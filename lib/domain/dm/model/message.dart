import '../../../common/model/post_author.dart';

/// 메시지 한 건의 전송 상태.
///
/// 서버가 주는 값이 아니라 **클라이언트가 낙관적 업데이트를 위해 붙이는 상태다**
/// (설계 §3). 서버에서 조회한 메시지는 항상 [sent]다.
enum MessageDeliveryStatus {
  /// 전송 중. 말풍선은 즉시 그리되 아직 서버가 받았다는 보장은 없다.
  sending,

  /// 서버가 받았다. 조회로 내려온 메시지도 이 상태다.
  sent,

  /// 전송 실패. **조용히 사라지지 않는다** — 실패 표시와 재시도 수단을 남긴다.
  failed,
}

/// 대화 메시지 하나(서버 `Message`).
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음(POL-020).
///
/// **[id]가 서버 id가 아닐 수 있다.** 전송 중·실패한 메시지는 아직 서버 id가 없어
/// 클라이언트가 만든 임시 id를 쓴다([localId]가 참). 전송이 성공하면 서버 id로
/// 교체된다.
class Message {
  const Message({
    required this.id,
    required this.body,
    required this.sender,
    required this.createdAt,
    required this.ownedByViewer,
    this.photoKey,
    this.status = MessageDeliveryStatus.sent,
    this.localId = false,
    this.retryCount = 0,
  });

  final String id;

  /// 본문. **non-null이지만 빈 문자열일 수 있다** — 사진만 보낸 메시지가 그렇고,
  /// 피드 인용만 있던 과거 메시지도 인용이 사라진 뒤로는 그렇다(SPEC-0021 R4).
  /// 빈 문자열을 "본문 없음"으로 보고 말풍선을 접거나 숨기면 첨부만 보낸 메시지가
  /// 화면에서 사라진다 — 표시 여부는 [hasContent]가 가른다.
  final String body;

  /// 첨부 사진의 확정 키(URL 아님). 커뮤니티와 **같은 업로드 경로**를 쓴다
  /// (`createPostImageUploadUrls` → PUT → `confirmPostImageUploads`) — DM 전용
  /// 업로드 뮤테이션은 없다. 표시 계층이 CDN 베이스와 조합한다.
  final String? photoKey;

  final PostAuthor sender;

  /// 작성 시각(UTC). 정렬 기준이다. 전송 중인 메시지는 클라이언트가 만든 시각이며,
  /// 성공하면 서버 시각으로 교체된다.
  final DateTime createdAt;

  /// 내가 보낸 메시지인지. **말풍선 정렬과 신고 선택 가능 여부를 함께 가른다** —
  /// 자기 메시지는 신고 대상이 아니다(AC15-5).
  final bool ownedByViewer;

  final MessageDeliveryStatus status;

  /// [id]가 클라이언트가 만든 임시 값인지. 전송 성공 전까지 참이다. 로컬 캐시에
  /// 확정되지 않은 메시지를 섞지 않기 위한 판별값이다.
  final bool localId;

  /// 지금까지 재시도한 횟수. **시간 기반 백오프가 아니라 횟수로 제한한다**
  /// (POL-040) — 근거 없는 시간 수치를 박지 않는다.
  final int retryCount;

  /// 신고 대상이 될 수 있는지. 자기 메시지는 제외하고(AC15-5), 아직 서버에 없는
  /// 메시지도 제외한다 — 서버가 id로 지목할 수 없기 때문이다.
  bool get reportable => !ownedByViewer && !localId;

  /// 본문 글자가 있는지. 없으면 첨부(사진)만 그린다.
  bool get hasBody => body.isNotEmpty;

  /// 보낼 내용이 하나라도 있는지. **둘 다 비면 서버가 거부한다.**
  bool get hasContent => body.isNotEmpty || photoKey != null;

  /// 그릴 내용이 하나도 없는 메시지인지(SPEC-0021 R4).
  ///
  /// **피드 인용만 있던 과거 메시지가 여기 해당한다.** 서버가 인용을 걷어낸 뒤로
  /// 본문도 사진도 없이 내려오는데, 그대로 그리면 빈 말풍선이 된다. 말풍선을 숨기면
  /// 대화 기록에 구멍이 나므로, 숨기는 대신 "내용 없음" 표시를 그린다.
  ///
  /// [hasContent]와 값은 같지만 뜻이 다르다 — 저쪽은 **보낼 수 있는지**를 묻는
  /// 전송 전 판정이고, 이쪽은 **어떻게 그릴지**를 묻는 표시 판정이다. 한 이름으로
  /// 합치면 전송 규칙이 바뀔 때 표시가 조용히 따라 바뀐다.
  bool get isEmpty => !hasContent;

  Message copyWith({
    String? id,
    DateTime? createdAt,
    MessageDeliveryStatus? status,
    bool? localId,
    int? retryCount,
  }) => Message(
    id: id ?? this.id,
    body: body,
    sender: sender,
    createdAt: createdAt ?? this.createdAt,
    ownedByViewer: ownedByViewer,
    photoKey: photoKey,
    status: status ?? this.status,
    localId: localId ?? this.localId,
    retryCount: retryCount ?? this.retryCount,
  );

  @override
  bool operator ==(Object other) =>
      other is Message &&
      other.id == id &&
      other.body == body &&
      other.sender == sender &&
      other.createdAt == createdAt &&
      other.ownedByViewer == ownedByViewer &&
      other.photoKey == photoKey &&
      other.status == status &&
      other.localId == localId &&
      other.retryCount == retryCount;

  @override
  int get hashCode => Object.hash(
    id,
    body,
    sender,
    createdAt,
    ownedByViewer,
    photoKey,
    status,
    localId,
    retryCount,
  );
}
