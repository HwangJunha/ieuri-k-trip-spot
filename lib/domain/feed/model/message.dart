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
    this.status = MessageDeliveryStatus.sent,
    this.localId = false,
    this.retryCount = 0,
  });

  final String id;

  /// 본문(1~1000자). 앞뒤 공백은 제거된 뒤 판정된다.
  final String body;

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
    status,
    localId,
    retryCount,
  );
}
