import '../../../common/model/list_equality.dart';
import '../../../common/model/post_spot.dart';
import '../../../common/model/composer_photo.dart';

/// 피드 작성 폼의 상태.
///
/// **spot 1곳과 사진 1장 이상이 갖춰지기 전에는 제출할 수 없다**(R1·R2). 서버가 같은
/// 규칙을 다시 판정하지만, 제출 후 오류로 돌려보내는 것은 나쁜 경험이라 클라이언트가
/// 먼저 막는다(설계 §4) — 서버 판정을 대신하는 것이 아니라 UX용으로 미러링하는 것이다.
///
/// 순수 도메인 모델 — 위젯·GraphQL·Riverpod 의존 없음.
class FeedDraft {
  const FeedDraft({
    this.body = '',
    this.spot,
    this.photos = const <ComposerPhoto>[],
    this.submitting = false,
  });

  /// 본문 상한(서버 계약과 같은 값). 넘으면 서버가 `INVALID_INPUT`으로 거부한다.
  static const int maxBodyLength = 500;

  /// 사진 상한. 6장이면 서버가 `TOO_MANY_PHOTOS`로 거부하며 **앞 5장만 취해
  /// 성공시키지 않는다**(AC2-4).
  static const int maxPhotos = 5;

  /// 본문. 제출 가능 판정은 **앞뒤 공백을 제거한 뒤** 한다.
  final String body;

  /// 붙일 장소. **필수다** — 없으면 제출할 수 없다(R1).
  final PostSpot? spot;

  /// 고른 사진. 순서가 표시 순서이며 1~5장이어야 한다(R2).
  final List<ComposerPhoto> photos;

  /// 제출 진행 중인지. 중복 제출을 막는다.
  final bool submitting;

  String get trimmedBody => body.trim();

  /// 남은 사진 슬롯. 더 고를 수 있는 장수다.
  int get remainingPhotoSlots => maxPhotos - photos.length;

  /// 아직 업로드되지 않은 사진들. 제출 시점에 한 번에 올린다 — 고르는 즉시 올리면
  /// 작성을 그만둔 사용자의 오브젝트가 고아로 남는다.
  List<LocalPhoto> get pendingPhotos => photos.whereType<LocalPhoto>().toList();

  /// 이미 확정 키를 가진 사진들.
  List<String> get confirmedKeys =>
      photos.whereType<RemotePhoto>().map((p) => p.objectKey).toList();

  /// 제출 버튼을 활성화할지. **spot·사진·본문이 모두 갖춰져야 참이다.**
  ///
  /// 사진이 상한을 넘은 상태도 막는다 — 서버가 어차피 거부할 요청을 보내지 않는다.
  bool get canSubmit =>
      !submitting &&
      spot != null &&
      photos.isNotEmpty &&
      photos.length <= maxPhotos &&
      trimmedBody.isNotEmpty &&
      trimmedBody.length <= maxBodyLength;

  FeedDraft copyWith({
    String? body,
    PostSpot? spot,
    bool clearSpot = false,
    List<ComposerPhoto>? photos,
    bool? submitting,
  }) => FeedDraft(
    body: body ?? this.body,
    spot: clearSpot ? null : (spot ?? this.spot),
    photos: photos ?? this.photos,
    submitting: submitting ?? this.submitting,
  );

  @override
  bool operator ==(Object other) =>
      other is FeedDraft &&
      other.body == body &&
      other.spot == spot &&
      listEquals(other.photos, photos) &&
      other.submitting == submitting;

  @override
  int get hashCode =>
      Object.hash(body, spot, Object.hashAll(photos), submitting);
}
