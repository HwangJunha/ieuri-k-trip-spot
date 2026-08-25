import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/composer_photo.dart';
import '../../../common/model/post_image_upload.dart';
import '../model/spot_qa_failure.dart';
import '../repository/spot_qa_repository.dart';
import 'spot_qa_providers.dart';

part 'spot_qa_composer_providers.g.dart';

/// 본문 최대 길이(계약 — 1~500자, 서버가 앞뒤 공백을 제거한 뒤 판정한다).
const int kSpotQaBodyMaxLength = 500;

/// 첨부 사진 최대 장수(R9).
const int kSpotQaMaxPhotos = 5;

/// 사진 업로드 결과. **부분 성공이 정상이다** — 실패한 장만 알리고 통과한 키는
/// 살린다. 5장 중 3장째 실패를 "업로드 실패"로 뭉뚱그리지 않는다(설계 §사진 첨부).
class SpotQaPhotoUploadResult {
  const SpotQaPhotoUploadResult({
    this.confirmedKeys = const <String>[],
    this.failedNames = const <String>[],
  });

  /// 작성 뮤테이션의 `photoKeys`에 실을 확정 키.
  final List<String> confirmedKeys;

  /// 올리지 못한 사진의 이름. 화면이 "이 장만 다시" 안내에 쓴다 — 사용자는 키가
  /// 아니라 사진을 본다.
  final List<String> failedNames;

  bool get hasFailures => failedNames.isNotEmpty;
}

/// 무엇을 쓰는 중인지. 대상에 따라 부르는 뮤테이션이 다르다.
enum SpotQaComposerTarget {
  /// 장소에 질문하기.
  question,

  /// 질문에 답변하기.
  answer,

  /// 답변에 답글 달기(1단계만).
  reply,
}

/// 작성 폼 상태.
///
/// **제출 실패가 [body]를 지우지 않는다.** 무엇 때문에 거절됐든 화면을 닫지 않고
/// 안내만 띄운다 — 사용자가 쓴 글을 서버 사정으로 날리는 것은 과하다.
class SpotQaComposerState {
  const SpotQaComposerState({
    this.body = '',
    this.isSubmitting = false,
    this.errorCode,
    this.photos = const <ComposerPhoto>[],
  });

  final String body;
  final bool isSubmitting;

  /// 마지막 제출이 남긴 서버 오류 코드. 다음 입력·제출에서 지운다.
  final String? errorCode;

  /// 붙인 사진. **순서가 곧 표시 순서다.**
  ///
  /// 아직 올리지 않은 [LocalPhoto]와, 올려서 확정된 [RemotePhoto]가 한 줄에 섞인다 —
  /// 제출이 서버에 거부돼 다시 눌렀을 때 **이미 올라간 장을 또 올리지 않기** 위해서다.
  final List<ComposerPhoto> photos;

  /// 아직 올리지 않은 장들. 제출 시점에 이것만 업로드한다.
  List<LocalPhoto> get pendingPhotos =>
      photos.whereType<LocalPhoto>().toList(growable: false);

  /// 더 붙일 수 있는 장수. 원격·로컬을 합쳐 센다.
  int get remainingPhotoSlots => kSpotQaMaxPhotos - photos.length;

  /// 공백만으로는 제출할 수 없다 — 서버도 트림 후 1자 미만을 거부한다.
  String get trimmedBody => body.trim();

  bool get canSubmit =>
      !isSubmitting &&
      trimmedBody.isNotEmpty &&
      trimmedBody.length <= kSpotQaBodyMaxLength;

  SpotQaComposerState copyWith({
    String? body,
    bool? isSubmitting,
    String? errorCode,
    bool clearError = false,
    List<ComposerPhoto>? photos,
  }) => SpotQaComposerState(
    body: body ?? this.body,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    errorCode: clearError ? null : (errorCode ?? this.errorCode),
    photos: photos ?? this.photos,
  );
}

/// 질문·답변·답글 작성 폼(R3·R4·R7).
///
/// **낙관적으로 목록에 넣지 않는다**(설계 §상태 관리). 서버가 자격을 판정하므로
/// 거부 시 롤백이 필요한데, 그 사이 사용자가 자기 글을 이미 본 상태가 된다. 작성은
/// 서버 응답을 기다린 뒤 목록을 갱신한다.
///
/// [targetId]는 대상에 따라 다르다 — 질문이면 `catalogId`, 답변이면 `questionId`,
/// 답글이면 `parentAnswerId`.
@riverpod
class SpotQaComposer extends _$SpotQaComposer {
  SpotQaRepository get _repository => ref.read(spotQaRepositoryProvider);

  /// 마지막 제출에서 사진 업로드가 어떻게 됐는지. 화면이 실패한 장의 이름을 읽어
  /// "이 장만 다시" 안내를 띄운다.
  ///
  /// **상태(`state`)가 아니라 필드다** — 이 값이 바뀐다고 폼을 다시 그릴 이유가
  /// 없고, 제출 직후 한 번 읽고 끝난다.
  SpotQaPhotoUploadResult? lastPhotoUpload;

  @override
  SpotQaComposerState build(SpotQaComposerTarget target, String targetId) =>
      const SpotQaComposerState();

  /// 입력이 바뀌면 지난 오류를 지운다 — 고친 뒤에도 빨간 안내가 남아 있으면
  /// 사용자는 아직 막혀 있다고 읽는다.
  void updateBody(String value) =>
      state = state.copyWith(body: value, clearError: true);

  /// 고른 사진을 붙인다. 상한(5장)을 넘는 만큼은 버린다.
  ///
  /// **고르는 즉시 올리지 않는다.** 업로드는 제출 시점이다 — 여기서 올리면 글을 쓰지
  /// 않고 나간 사용자의 사진이 스토리지에 고아로 남고, 붙였다 뺐다를 반복하면 그만큼
  /// 쌓인다(커뮤니티와 같은 판단).
  void addPhotos(List<LocalPhoto> photos) {
    if (photos.isEmpty) return;
    final int room = state.remainingPhotoSlots;
    if (room <= 0) return;
    state = state.copyWith(
      photos: <ComposerPhoto>[...state.photos, ...photos.take(room)],
      clearError: true,
    );
  }

  /// 붙인 사진 한 장을 뺀다.
  ///
  /// **아직 올리지 않은 장은 네트워크를 타지 않는다** — 올린 적이 없으니 지울
  /// 오브젝트도 없다. 이미 확정된 장은 [discardUploaded]가 정리한다.
  void removePhoto(String id) => state = state.copyWith(
    photos: state.photos
        .where((ComposerPhoto p) => p.id != id)
        .toList(growable: false),
  );

  /// 아직 올리지 않은 장들을 올린다. **제출 직전에 한 번** 돈다.
  ///
  /// **1단계는 전부 아니면 전무다** — 하나라도 형식·크기가 어긋나면 `uploadUrls`가
  /// 빈 목록으로 온다. 반대로 **3단계는 장별로 갈린다** — `failed`가 있어도
  /// `confirmed`의 키는 유효하므로 통과한 것만 살린다(설계 §사진 첨부).
  ///
  /// 통과한 장은 상태에서 **같은 자리의 [RemotePhoto]로 바뀐다**(순서가 곧 표시
  /// 순서다). 그래서 제출이 거부돼 다시 눌러도 이미 올라간 장을 또 올리지 않는다.
  Future<SpotQaPhotoUploadResult> uploadPending() async {
    final List<LocalPhoto> photos = state.pendingPhotos;
    if (photos.isEmpty) {
      // 이미 확정된 장만 있으면 그 키를 그대로 쓴다.
      return SpotQaPhotoUploadResult(confirmedKeys: _confirmedKeys());
    }

    final List<PostImageUploadUrl> urls = await _repository
        .createImageUploadUrls(
          photos
              .map(
                (LocalPhoto p) => PostImageUploadRequest(
                  contentType: p.contentType,
                  contentLength: p.contentLength,
                ),
              )
              .toList(growable: false),
        );
    // 부분 발급이 없으므로 빈 목록은 "전부 거부"다.
    if (urls.isEmpty) {
      return SpotQaPhotoUploadResult(
        confirmedKeys: _confirmedKeys(),
        failedNames: photos.map((LocalPhoto p) => p.name).toList(),
      );
    }

    // **응답은 요청과 같은 순서로 온다** — 그 계약에 기대어 짝짓는다.
    final Map<String, LocalPhoto> byPendingKey = <String, LocalPhoto>{};
    final List<String> failed = <String>[];
    for (int i = 0; i < urls.length && i < photos.length; i++) {
      final LocalPhoto photo = photos[i];
      try {
        await _repository.uploadImage(
          uploadUrl: urls[i].uploadUrl,
          photo: photo,
        );
        byPendingKey[urls[i].objectKey] = photo;
      } on Object {
        // 스토리지 PUT 실패는 GraphQL 응답에 안 나온다 — 여기서만 보인다.
        failed.add(photo.name);
      }
    }
    if (byPendingKey.isEmpty) {
      return SpotQaPhotoUploadResult(
        confirmedKeys: _confirmedKeys(),
        failedNames: failed,
      );
    }

    final List<String> uploaded = byPendingKey.keys.toList(growable: false);
    final PostImageConfirmation confirmation = await _repository
        .confirmImageUploads(uploaded);
    // 확정에 실패한 장의 이름을 되찾는다 — 사용자는 키가 아니라 사진을 본다.
    for (final PostImageUploadFailure f in confirmation.failed) {
      final LocalPhoto? photo = byPendingKey[f.objectKey];
      if (photo != null) failed.add(photo.name);
    }

    // 확정 키를 **원래 자리에** 끼운다. 서버는 확정 키에서 임시 키로 되짚을 수단을
    // 주지 않고 `confirmed`만 순서대로 주므로, 넘긴 임시 키에서 실패한 것을 뺀
    // 나머지와 순서로 짝짓는다 — 남는 것이 곧 통과한 장이다.
    final Set<String> failedKeys = confirmation.failed
        .map((PostImageUploadFailure f) => f.objectKey)
        .toSet();
    final List<String> confirmedOrder = uploaded
        .where((String key) => !failedKeys.contains(key))
        .toList(growable: false);
    final Map<String, String> confirmedByLocalId = <String, String>{};
    for (
      int i = 0;
      i < confirmation.confirmed.length && i < confirmedOrder.length;
      i++
    ) {
      final LocalPhoto? photo = byPendingKey[confirmedOrder[i]];
      if (photo != null) {
        confirmedByLocalId[photo.id] = confirmation.confirmed[i];
      }
    }

    state = state.copyWith(
      photos: state.photos
          .map((ComposerPhoto p) {
            if (p is! LocalPhoto) return p;
            final String? key = confirmedByLocalId[p.id];
            return key == null ? p : RemotePhoto(key);
          })
          .toList(growable: false),
    );

    return SpotQaPhotoUploadResult(
      confirmedKeys: _confirmedKeys(),
      failedNames: failed,
    );
  }

  /// 작성을 취소할 때 이미 확정한 키를 지운다(설계 §사진 첨부).
  ///
  /// **정리하지 않으면 서버에 고아 파일이 남는다.** 실패해도 조용히 넘어간다 —
  /// 화면을 떠나는 길을 막을 이유가 없고, 남은 오브젝트는 서버 lifecycle의 몫이다.
  ///
  /// **키와 저장소를 루프 전에 스냅샷한다.** 화면이 이것을 `unawaited`로 띄워 놓고
  /// 곧바로 닫으므로(`_close()`), 첫 `deleteImage`가 끝나기도 전에 이 provider는
  /// 구독자가 0이 되어 폐기된다. 그 뒤 `state`나 `ref.read`를 만지면
  /// `UnmountedRefException`이 나는데, `unawaited`라 아무도 잡지 않고 zone으로
  /// 샌다 — 지울 키 목록은 진입 시점에 이미 확정돼 있으니 들고 들어가면 된다.
  Future<void> discardUploaded() async {
    final List<String> keys = _confirmedKeys();
    if (keys.isEmpty) return;
    final SpotQaRepository repository = _repository;
    for (final String key in keys) {
      try {
        await repository.deleteImage(key);
      } on Object {
        // 정리 실패는 사용자가 할 수 있는 일이 없다.
      }
    }
  }

  /// 지금 상태에서 작성 뮤테이션에 실을 확정 키(순서 유지).
  List<String> _confirmedKeys() => state.photos
      .whereType<RemotePhoto>()
      .map((RemotePhoto p) => p.objectKey)
      .toList(growable: false);

  /// 제출한다. 성공하면 새로 만들어진 id, 실패하면 사유 코드가 담긴 결과를 준다.
  ///
  /// **사진 업로드가 실패해도 글은 올라간다**([photoResult]로 알린다). 5장 중 1장이
  /// 실패하면 나머지로 작성하고 실패 사실만 알린다 — 사진 한 장 때문에 사용자가 쓴
  /// 글을 통째로 버리게 하지 않는다(커뮤니티와 같은 판단).
  ///
  /// 업로드 자체가 예외로 터지면 작성도 하지 않고 그대로 던진다 — 전송이 안 되는
  /// 상황에서 글만 올리면 사진 없는 질문이 남는다.
  Future<SpotQaMutationResult<String>> submit() async {
    if (!state.canSubmit) {
      return const SpotQaMutationResult<String>.failure(null);
    }

    final String body = state.trimmedBody;
    state = state.copyWith(isSubmitting: true, clearError: true);

    late final SpotQaPhotoUploadResult upload;
    try {
      upload = await uploadPending();
    } on Object {
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
    // 실패한 장의 이름을 화면이 읽을 수 있도록 남긴다. 성공 여부와 무관하게
    // 마지막 시도의 결과이며, 다음 제출에서 덮어쓴다.
    lastPhotoUpload = upload;
    final List<String> photoKeys = upload.confirmedKeys;

    late final SpotQaMutationResult<String> result;
    try {
      result = switch (target) {
        SpotQaComposerTarget.question => await _repository.createQuestion(
          catalogId: targetId,
          body: body,
          photoKeys: photoKeys,
        ),
        SpotQaComposerTarget.answer => await _repository.createAnswer(
          questionId: targetId,
          body: body,
          photoKeys: photoKeys,
        ),
        SpotQaComposerTarget.reply => await _repository.createReply(
          parentAnswerId: targetId,
          body: body,
          photoKeys: photoKeys,
        ),
      };
    } on Object {
      // 전송·인증 실패도 입력을 지우지 않는다 — 다시 시도하면 되는 상황이다.
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }

    if (!result.succeeded) {
      // **본문을 그대로 둔다.** 자격 없음이든 다른 규칙 위반이든, 사용자가 쓴 글을
      // 날리지 않고 안내만 띄운다.
      state = state.copyWith(isSubmitting: false, errorCode: result.errorCode);
      return result;
    }

    state = const SpotQaComposerState();
    return result;
  }
}
