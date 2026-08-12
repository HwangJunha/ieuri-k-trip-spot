import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/model/composer_photo.dart';
import '../../../common/model/post_image_upload.dart';
import '../../../common/model/post_spot.dart';
import '../model/feed_draft.dart';
import '../repository/feed_repository.dart';
import 'feed_providers.dart';

part 'feed_composer_providers.g.dart';

/// 피드 등록의 결과.
sealed class FeedComposerResult {
  const FeedComposerResult();
}

/// 등록 성공. [failedPhotoNames]가 비어 있지 않으면 **일부 사진이 빠진 채로**
/// 올라간 것이며, 화면은 어느 장이 빠졌는지 알려야 한다(설계 §4).
class FeedComposerSucceeded extends FeedComposerResult {
  const FeedComposerSucceeded(
    this.feedItemId, {
    this.failedPhotoNames = const <String>[],
  });

  final String? feedItemId;
  final List<String> failedPhotoNames;
}

/// 서버가 도메인 규칙으로 거부했다. [code]는 `SPOT_REQUIRED`·`PHOTO_REQUIRED` 등.
class FeedComposerRejected extends FeedComposerResult {
  const FeedComposerRejected(this.code);

  final String? code;
}

/// 사진이 **한 장도** 올라가지 않아 제출을 시도조차 못 했다.
///
/// 사진이 필수인 화면이라(R2) 전부 실패하면 제출할 수 없다. [failedPhotoNames]로
/// 어느 장이 실패했는지 알린다 — "업로드 실패"로 뭉뚱그리지 않는다.
class FeedComposerPhotosFailed extends FeedComposerResult {
  const FeedComposerPhotosFailed(this.failedPhotoNames);

  final List<String> failedPhotoNames;
}

/// 전송 자체가 실패했다(네트워크·인증).
class FeedComposerFailed extends FeedComposerResult {
  const FeedComposerFailed();
}

/// 피드 작성 폼(R1·R2).
///
/// **spot과 사진이 갖춰지기 전에는 제출할 수 없다** — 판정은 [FeedDraft.canSubmit]이
/// 하고, 화면은 그 값으로 버튼을 활성화한다(설계 §4).
///
/// spot 피커는 커뮤니티가 이미 쓰는 `searchSpots` 흐름을 재사용한다(SPEC-0013) —
/// 새로 만들면 검색 동작이 두 벌이 된다. 여기서는 고른 결과를 받기만 한다.
@riverpod
class FeedComposer extends _$FeedComposer {
  @override
  FeedDraft build() => const FeedDraft();

  void setBody(String body) => state = state.copyWith(body: body);

  void setSpot(PostSpot spot) => state = state.copyWith(spot: spot);

  void clearSpot() => state = state.copyWith(clearSpot: true);

  /// 사진을 더한다. **상한을 넘는 분은 받지 않는다** — 6장을 골라도 서버가
  /// `TOO_MANY_PHOTOS`로 거부할 뿐이라 고르는 단계에서 막는다(AC2-4).
  void addPhotos(List<LocalPhoto> photos) {
    final int room = state.remainingPhotoSlots;
    if (room <= 0) return;
    state = state.copyWith(
      photos: <ComposerPhoto>[...state.photos, ...photos.take(room)],
    );
  }

  void removePhoto(String id) => state = state.copyWith(
    photos: state.photos.where((ComposerPhoto p) => p.id != id).toList(),
  );

  /// 등록한다.
  ///
  /// 사진 업로드는 **이 시점에** 일어난다 — 고르는 즉시 올리면 작성을 그만둔
  /// 사용자의 오브젝트가 고아로 남는다.
  Future<FeedComposerResult> submit() async {
    final FeedDraft draft = state;
    if (!draft.canSubmit) return const FeedComposerFailed();
    final PostSpot? spot = draft.spot;
    if (spot == null) return const FeedComposerFailed();

    state = draft.copyWith(submitting: true);
    try {
      final FeedRepository repository = ref.read(feedRepositoryProvider);
      final _UploadOutcome uploaded = await _uploadPending(repository, draft);

      final List<String> keys = <String>[
        ...draft.confirmedKeys,
        ...uploaded.confirmedKeys,
      ];
      // 사진이 필수라 한 장도 못 올렸으면 제출하지 않는다(R2).
      if (keys.isEmpty) {
        return FeedComposerPhotosFailed(uploaded.failedNames);
      }

      final FeedMutationResult<String> result = await repository
          .createFeedItem(
            body: draft.trimmedBody,
            spotId: spot.id,
            photoKeys: keys,
          );
      if (!result.succeeded) return FeedComposerRejected(result.errorCode);
      return FeedComposerSucceeded(
        result.value,
        failedPhotoNames: uploaded.failedNames,
      );
    } on Object {
      return const FeedComposerFailed();
    } finally {
      state = state.copyWith(submitting: false);
    }
  }

  /// 아직 올라가지 않은 사진들을 올리고 확정한다.
  ///
  /// **어느 장이 실패했는지 이름으로 남긴다**(설계 §4) — 5장 중 3장째 실패를
  /// "업로드 실패"로 뭉뚱그리지 않는다.
  Future<_UploadOutcome> _uploadPending(
    FeedRepository repository,
    FeedDraft draft,
  ) async {
    final List<LocalPhoto> pending = draft.pendingPhotos;
    if (pending.isEmpty) {
      return const _UploadOutcome(<String>[], <String>[]);
    }

    final List<PostImageUploadUrl> urls = await repository
        .createImageUploadUrls(
          pending
              .map(
                (LocalPhoto p) => PostImageUploadRequest(
                  contentType: p.contentType,
                  contentLength: p.contentLength,
                ),
              )
              .toList(),
        );
    // 발급은 전부 아니면 전무다 — 빈 목록이면 전체 거절이다.
    if (urls.length != pending.length) {
      return _UploadOutcome(
        const <String>[],
        pending.map((LocalPhoto p) => p.name).toList(),
      );
    }

    final List<String> putKeys = <String>[];
    final List<String> failedNames = <String>[];
    for (int i = 0; i < pending.length; i++) {
      try {
        await repository.uploadImage(
          uploadUrl: urls[i].uploadUrl,
          photo: pending[i],
        );
        putKeys.add(urls[i].objectKey);
      } on Object {
        // 한 장의 실패가 나머지를 막지 않는다.
        failedNames.add(pending[i].name);
      }
    }
    if (putKeys.isEmpty) return _UploadOutcome(const <String>[], failedNames);

    final PostImageConfirmation confirmation = await repository
        .confirmImageUploads(putKeys);
    // 확인에서 떨어진 장도 이름으로 되짚는다.
    for (final PostImageUploadFailure failure in confirmation.failed) {
      final int at = putKeys.indexOf(failure.objectKey);
      if (at >= 0 && at < pending.length) failedNames.add(pending[at].name);
    }
    return _UploadOutcome(confirmation.confirmed, failedNames);
  }
}

/// 업로드 한 판의 결과 — 확정된 키와 실패한 사진 이름.
class _UploadOutcome {
  const _UploadOutcome(this.confirmedKeys, this.failedNames);

  final List<String> confirmedKeys;
  final List<String> failedNames;
}
