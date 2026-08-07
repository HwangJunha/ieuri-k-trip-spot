import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/community_failure.dart';
import '../model/composer_photo.dart';
import '../model/post_draft.dart';
import '../model/post_image_upload.dart';
import '../../../common/model/target_category.dart';
import '../repository/community_repository.dart';
import 'community_providers.dart';

part 'post_composer_providers.g.dart';

/// 등록 시도의 결과. 화면이 이 값으로 다음 행동을 고른다.
sealed class ComposerResult {
  const ComposerResult();
}

/// 등록 성공. [postId]로 상세를 다시 조회하거나 피드를 새로 고친다 —
/// **`createPost`는 `postId`만 주고 `post`는 항상 null이다**(가이드 §5).
class ComposerSucceeded extends ComposerResult {
  const ComposerSucceeded(
    this.postId, {
    this.failedPhotoNames = const <String>[],
  });

  /// 서버가 준 새 글 id. 스키마상 nullable이라 null일 수 있고, 그때는 상세로 가는
  /// 대신 피드만 새로 고친다.
  final String? postId;

  /// 올리지 못한 사진의 이름. **비어 있지 않아도 글은 등록된 것이다** — 사진 한 장
  /// 때문에 사용자가 쓴 글을 버리지 않는다(디자인 §3). 화면은 등록 성공을 알린 뒤
  /// 못 올린 장이 있다는 것만 덧붙인다.
  final List<String> failedPhotoNames;
}

/// 서버가 `userErrors`로 거부했다. [code]를 화면이 필드별 메시지로 옮긴다(가이드 §7).
class ComposerRejected extends ComposerResult {
  const ComposerRejected(this.code);

  final String? code;
}

/// 로그인이 필요하다(가이드 §1). 화면이 로그인으로 유도한다.
class ComposerUnauthenticated extends ComposerResult {
  const ComposerUnauthenticated();
}

/// 전송 실패. 재시도 안내를 띄운다.
class ComposerFailed extends ComposerResult {
  const ComposerFailed();
}

/// 사진 업로드(1~3단계) 결과. **부분 성공이 정상이다** — 실패한 장만 알리고 통과한
/// 키는 살린다(가이드 §4).
class PhotoUploadResult {
  const PhotoUploadResult({
    this.confirmedKeys = const <String>[],
    this.failedNames = const <String>[],
  });

  /// `createPost`/`editPost`에 넘길 최종 키(`images/...`).
  final List<String> confirmedKeys;

  /// 올리지 못한 사진의 이름. 화면이 "이 장만 다시" 안내에 쓴다.
  final List<String> failedNames;

  bool get hasFailures => failedNames.isNotEmpty;
}

/// 컴포저가 편집 중인 초안. 화면 하나에 속한 상태라 autoDispose(codegen 기본)로
/// 둔다 — 컴포저를 닫으면 초안이 사라지는 것이 맞다.
///
/// **등록 가능 여부는 [PostDraft.canSubmit]이 판정한다.** 서버 검증을 기다렸다가
/// 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지 못하게 한다
/// (디자인 §3).
@riverpod
class PostComposer extends _$PostComposer {
  /// [initialSpotId]가 주어지면 장소 상세에서 진입한 것이라 장소가 이미 정해져
  /// 있다. 커뮤니티 탭에서 진입하면 null이고 **그래도 등록할 수 있다** — 장소는
  /// 선택 항목이다(가이드 §5).
  ///
  /// [initialCategory]는 그 장소의 카테고리 제안이다(`PostSpot.category`) — 서버가
  /// 그 용도로 내려주는 값이라 기본 선택으로 채운다.
  ///
  /// [editing]은 **이미 서버에 있는 글을 고치는 중**이라는 뜻이다. 초안의 내용은
  /// 같지만 사진을 뺄 때의 처리가 갈린다([removePhoto] 참고).
  @override
  PostDraft build({
    String? initialSpotId,
    String? initialSpotTitle,
    TargetCategory? initialCategory,
    bool editing = false,
  }) => PostDraft(
    spotId: initialSpotId,
    spotTitle: initialSpotTitle,
    category: initialCategory,
  );

  /// 수정 모드에서 서버가 채워 준 장소 id. `null`은 두 가지를 함께 뜻할 수 있으므로
  /// ([_seededSpotKnown] 참고) 이 값만으로 판단하지 않는다.
  String? _seededSpotId;

  /// [seedFromPost]가 한 번이라도 돌았는지. 새 글 작성에서는 false다.
  bool _seededSpotKnown = false;

  /// 사용자가 장소를 실제로 바꿨는지. `editPost(changeSpot:)`에 그대로 실린다.
  ///
  /// **`spotId`만으로는 판정할 수 없다** — 서버 입력에서 `spotId: null`은 "떼기"와
  /// "그대로 두기" 둘 다로 읽힐 수 있어 `changeSpot`이 따로 있다. 그래서 씨앗 값과
  /// 지금 값을 비교해 **바뀐 경우에만** true를 준다.
  ///
  /// 수정 모드가 아니면(씨앗이 없으면) 언제나 false다 — 새 글에는 바꿀 원본이 없다.
  bool get spotChanged => _seededSpotKnown && state.spotId != _seededSpotId;

  /// 수정 모드에서 서버가 준 글 내용으로 초안을 채운다.
  ///
  /// 제목·본문뿐 아니라 **사진 키·카테고리·태그·장소까지 함께 받는다** — 이것이
  /// 없으면 수정 화면이 새 글처럼 비어 열려, 사용자가 자기 글의 현재 값을 보지도
  /// 지키지도 못한다. 서버가 `editPost`로 그 셋을 받기 시작한 이상 빈 채로 저장하면
  /// 값이 날아간다.
  void seedFromPost({
    required String title,
    required String body,
    required List<String> photoKeys,
    TargetCategory? category,
    List<String> tags = const <String>[],
    String? spotId,
    String? spotTitle,
  }) {
    _seededSpotId = spotId;
    _seededSpotKnown = true;
    state = PostDraft(
      // 서버 값이 없으면(매핑 안 된 카테고리) 기존 선택을 남긴다 — 진입 인자로 받은
      // 제안이 있을 수 있다.
      category: category ?? state.category,
      spotId: spotId,
      spotTitle: spotTitle,
      title: title,
      body: body,
      tags: tags,
      photos: photoKeys.map(RemotePhoto.new).toList(growable: false),
    );
  }

  /// 카테고리를 고른다. **필수 항목이라 해제되지 않는다** — 같은 칩을 다시 눌러도
  /// 선택이 유지된다(해제하면 등록이 막히는데 사용자는 왜인지 모른다).
  void setCategory(TargetCategory category) =>
      state = state.copyWith(category: category);

  void setTitle(String title) => state = state.copyWith(title: title);

  /// 본문을 갱신한다. **500자를 넘어도 자르지 않는다** — 초과분을 드러내고 등록만
  /// 막는다(디자인 §3: 붙여넣기한 유저가 무엇이 사라졌는지 모르면 안 된다).
  void setBody(String body) => state = state.copyWith(body: body);

  void setSpot({required String id, required String title}) =>
      state = state.copyWith(spotId: id, spotTitle: title);

  /// 장소 선택을 해제한다 — 장소 없는 글도 유효하다(가이드 §5).
  void clearSpot() => state = state.withoutSpot();

  /// 태그를 더한다. 공백이 든 태그는 서버가 `INVALID_TAG`로 거부하므로 **여기서
  /// 미리 막고**, 상한(5개)에 닿아도 막는다(가이드 §5·§7).
  ///
  /// 이미 있는 태그는 다시 넣지 않는다 — 대소문자만 다른 태그는 서버가 같은 것으로
  /// 검색하지만 표시는 원문을 보존하므로, 중복 판정도 대소문자를 가리지 않는다.
  bool addTag(String raw) {
    final String tag = raw.trim();
    if (!PostDraft.isValidTag(tag)) return false;
    if (!state.canAddTag) return false;
    final String lower = tag.toLowerCase();
    if (state.tags.any((String t) => t.toLowerCase() == lower)) return false;
    state = state.copyWith(tags: <String>[...state.tags, tag]);
    return true;
  }

  void removeTag(String tag) => state = state.copyWith(
    tags: state.tags.where((String t) => t != tag).toList(growable: false),
  );

  CommunityRepository get _repository => ref.read(communityRepositoryProvider);

  /// 고른 사진을 초안에 붙인다. **네트워크를 타지 않는다** — 바이트만 들고 있다가
  /// 등록/수정을 누를 때 올린다([uploadPending]).
  ///
  /// 고르는 즉시 올리면, 글을 쓰지 않고 나간 사용자의 사진이 스토리지에 고아로
  /// 남는다. 골랐다 뺐다를 반복하면 그만큼 쌓인다 — 실제 저장 비용이다.
  ///
  /// 상한(5장)은 **원격·로컬을 합쳐** 센다.
  void addPhotos(List<LocalPhoto> photos) {
    if (photos.isEmpty) return;
    final int room = state.remainingPhotoSlots;
    if (room <= 0) return;
    state = state.copyWith(
      photos: <ComposerPhoto>[...state.photos, ...photos.take(room)],
    );
  }

  /// 붙였던 사진 한 장을 뺀다. [id]는 원격이면 오브젝트 키, 로컬이면 고를 때 부여한
  /// 식별자다.
  ///
  /// **아직 올리지 않은 로컬 장은 네트워크를 전혀 타지 않는다** — 올린 적이 없으니
  /// 지울 오브젝트도 없다.
  ///
  /// 원격 장은 **연결만 끊고 오브젝트는 그대로 둔다.** 그 키는 아직 서버의 글에 붙어
  /// 있고, 저장이 성공하기 전까지 살아 있어야 한다 — 여기서 지우면 사용자가 저장을
  /// 취소하고 나갔을 때 원래 글의 사진이 깨진다. 떨어져 나간 오브젝트 정리는 서버
  /// lifecycle의 몫이다(가이드 §4).
  void removePhoto(String id) => state = state.copyWith(
    photos: state.photos
        .where((ComposerPhoto p) => p.id != id)
        .toList(growable: false),
  );

  /// 아직 올리지 않은 장들을 올린다(가이드 §4의 1~3단계). **등록/수정 직전에
  /// 한 번** 돈다.
  ///
  /// **1단계는 전부 아니면 전무다** — 하나라도 어긋나면 `uploadUrls`가 빈 목록으로
  /// 온다. 반대로 **3단계는 장별로 갈린다** — `failed`가 있어도 `confirmed`의 키는
  /// 유효하므로 통과한 것만 살린다.
  ///
  /// 통과한 장은 초안에서 **같은 자리의 [RemotePhoto]로 바뀐다**(순서가 곧 표시
  /// 순서다). 그래서 등록이 서버에 거부돼 다시 눌러도 **이미 올라간 장을 또 올리지
  /// 않는다.** 실패한 장은 로컬로 남아 다음 시도에 다시 올라간다.
  Future<PhotoUploadResult> uploadPending() async {
    final List<LocalPhoto> photos = state.pendingPhotos;
    if (photos.isEmpty) return const PhotoUploadResult();

    final List<PostImageUploadUrl> urls = await _repository
        .createPostImageUploadUrls(
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
      return PhotoUploadResult(
        failedNames: photos.map((LocalPhoto p) => p.name).toList(),
      );
    }

    // **응답은 요청과 같은 순서로 온다**(가이드 §4) — 그 계약에 기대어 짝짓는다.
    final Map<String, LocalPhoto> byPendingKey = <String, LocalPhoto>{};
    final List<String> failed = <String>[];
    for (int i = 0; i < urls.length && i < photos.length; i++) {
      final LocalPhoto photo = photos[i];
      try {
        await _repository.uploadPostImage(
          uploadUrl: urls[i].uploadUrl,
          contentType: photo.contentType,
          bytes: photo.bytes,
        );
        byPendingKey[urls[i].objectKey] = photo;
      } on Object {
        // 스토리지 PUT 실패는 GraphQL 응답에 안 나온다 — 여기서만 보인다.
        failed.add(photo.name);
      }
    }
    if (byPendingKey.isEmpty) return PhotoUploadResult(failedNames: failed);

    final List<String> uploaded = byPendingKey.keys.toList(growable: false);
    final PostImageConfirmation confirmation = await _repository
        .confirmPostImageUploads(uploaded);
    // 확인에 실패한 장의 이름을 되찾는다 — 사용자는 키가 아니라 사진을 본다.
    for (final PostImageUploadFailure f in confirmation.failed) {
      final LocalPhoto? photo = byPendingKey[f.objectKey];
      if (photo != null) failed.add(photo.name);
    }

    // 확정된 키를 **원래 자리에** 끼운다(순서가 곧 표시 순서다, 가이드 §4).
    //
    // 서버는 확정 키에서 임시 키로 되짚을 수단을 주지 않고 `confirmed`만 순서대로
    // 준다. 그래서 넘긴 임시 키에서 **실패한 것을 뺀 나머지**와 순서로 짝짓는다 —
    // 남는 것이 곧 통과한 장이기 때문이다.
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
            final String? key = confirmedByLocalId[p.id];
            return key == null ? p : RemotePhoto(key);
          })
          .toList(growable: false),
    );

    return PhotoUploadResult(
      confirmedKeys: confirmation.confirmed,
      failedNames: failed,
    );
  }

  /// 등록한다. [PostDraft.canSubmit]이 false면 아무것도 하지 않는다 — 버튼이 이미
  /// 비활성이지만, 상태와 판정을 한 곳에 두어 화면이 우회할 수 없게 한다.
  ///
  /// **사진 업로드가 실패해도 글은 올라간다.** 5장 중 1장이 실패하면 나머지 4장으로
  /// 등록하고 실패 사실만 알린다 — 사진 한 장 때문에 사용자가 쓴 글을 통째로 버리게
  /// 하지 않는다(디자인 §3). 실패한 장은 초안에 로컬로 남는다.
  Future<ComposerResult> submit() async {
    if (!state.canSubmit) return const ComposerFailed();

    // 업로드 자체가 통째로 실패해도(발급 뮤테이션 오류 등) 글은 올린다.
    List<String> failedNames = const <String>[];
    try {
      failedNames = (await uploadPending()).failedNames;
    } on Object {
      failedNames = state.pendingPhotos
          .map((LocalPhoto p) => p.name)
          .toList(growable: false);
    }

    final PostDraft draft = state;
    try {
      final String? postId = await _repository.createPost(
        category: draft.category!,
        title: draft.title.trim(),
        body: draft.body.trim(),
        // **선택 항목이다** — null이면 장소 없는 글로 등록된다(가이드 §5).
        spotId: draft.spotId,
        tags: draft.tags,
        // 확정된 키만 넘긴다. 못 올린 장은 빠진 채로 등록된다.
        photoKeys: draft.remoteKeys,
      );
      return ComposerSucceeded(postId, failedPhotoNames: failedNames);
    } on CommunityFailure catch (failure) {
      if (failure.kind == CommunityFailureKind.unauthenticated) {
        return const ComposerUnauthenticated();
      }
      if (failure.kind == CommunityFailureKind.userError) {
        return ComposerRejected(failure.code);
      }
      return const ComposerFailed();
    } on Object {
      return const ComposerFailed();
    }
  }
}
