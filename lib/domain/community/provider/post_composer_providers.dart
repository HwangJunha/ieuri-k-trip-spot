import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/community_failure.dart';
import '../model/post_draft.dart';
import '../model/post_image_upload.dart';
import '../model/target_category.dart';
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
  const ComposerSucceeded(this.postId);

  /// 서버가 준 새 글 id. 스키마상 nullable이라 null일 수 있고, 그때는 상세로 가는
  /// 대신 피드만 새로 고친다.
  final String? postId;
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

/// 컴포저가 고른 사진 한 장 — **바이트를 들고 있다.**
///
/// 사진을 고르는 UI는 이 슬라이스 밖이다(사진 선택 패키지가 pubspec에 없고, 이것
/// 하나 때문에 새 의존을 들이지 않는다). 화면이 어떤 수단으로 골랐든 바이트와
/// MIME 타입을 이 값으로 만들어 넘기면 업로드 4단계가 돈다 — 그 이음매가 이 타입이다.
class PickedPhoto {
  const PickedPhoto({
    required this.bytes,
    required this.contentType,
    required this.name,
  });

  final Uint8List bytes;

  /// `image/jpeg` · `image/png` · `image/webp`. 그 밖이면 서버가
  /// `UNSUPPORTED_CONTENT_TYPE`으로 거부하므로 **고르는 단계에서 미리 거른다.**
  final String contentType;

  /// 썸네일 식별과 표시에 쓰는 이름. 서버에 보내지 않는다.
  final String name;

  /// **실제 바이트 수.** 1단계 선언과 2단계 PUT이 이 값으로 일치해야 서명이 맞는다
  /// (가이드 §4).
  int get contentLength => bytes.length;
}

/// 사진 업로드(4단계) 결과. **부분 성공이 정상이다** — 실패한 장만 다시 올리게 하고
/// 통과한 키는 살린다(가이드 §4).
class PhotoUploadResult {
  const PhotoUploadResult({
    this.confirmedKeys = const <String>[],
    this.failedNames = const <String>[],
  });

  /// `createPost`에 넘길 최종 키(`images/...`).
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
  @override
  PostDraft build({
    String? initialSpotId,
    String? initialSpotTitle,
    TargetCategory? initialCategory,
  }) => PostDraft(
    spotId: initialSpotId,
    spotTitle: initialSpotTitle,
    category: initialCategory,
  );

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

  /// 사진 4단계 업로드 중 1~3단계(가이드 §4). 성공한 키를 초안의 `photoKeys`에
  /// 넣는다 — 4단계(`createPost(photoKeys:)`)는 [submit]이 한다.
  ///
  /// **1단계는 전부 아니면 전무다** — 하나라도 어긋나면 `uploadUrls`가 빈 목록으로
  /// 온다. 반대로 **3단계는 장별로 갈린다** — `failed`가 있어도 `confirmed`의 키는
  /// 유효하므로 통과한 것만 살린다.
  Future<PhotoUploadResult> uploadPhotos(List<PickedPhoto> photos) async {
    if (photos.isEmpty) return const PhotoUploadResult();

    final List<PostImageUploadUrl> urls = await _repository
        .createPostImageUploadUrls(
          photos
              .map(
                (PickedPhoto p) => PostImageUploadRequest(
                  contentType: p.contentType,
                  contentLength: p.contentLength,
                ),
              )
              .toList(growable: false),
        );
    // 부분 발급이 없으므로 빈 목록은 "전부 거부"다.
    if (urls.isEmpty) {
      return PhotoUploadResult(
        failedNames: photos.map((PickedPhoto p) => p.name).toList(),
      );
    }

    // **응답은 요청과 같은 순서로 온다**(가이드 §4) — 그 계약에 기대어 짝짓는다.
    final List<String> uploaded = <String>[];
    final List<String> failed = <String>[];
    for (int i = 0; i < urls.length && i < photos.length; i++) {
      final PickedPhoto photo = photos[i];
      try {
        await _repository.uploadPostImage(
          uploadUrl: urls[i].uploadUrl,
          contentType: photo.contentType,
          bytes: photo.bytes,
        );
        uploaded.add(urls[i].objectKey);
      } on Object {
        // 스토리지 PUT 실패는 GraphQL 응답에 안 나온다 — 여기서만 보인다.
        failed.add(photo.name);
      }
    }
    if (uploaded.isEmpty) return PhotoUploadResult(failedNames: failed);

    final PostImageConfirmation confirmation = await _repository
        .confirmPostImageUploads(uploaded);
    // 확인에 실패한 장의 이름을 되찾는다 — 사용자는 키가 아니라 사진을 본다.
    for (final PostImageUploadFailure f in confirmation.failed) {
      final int index = uploaded.indexOf(f.objectKey);
      if (index >= 0 && index < photos.length) failed.add(photos[index].name);
    }

    state = state.copyWith(
      photoKeys: <String>[...state.photoKeys, ...confirmation.confirmed],
    );
    return PhotoUploadResult(
      confirmedKeys: confirmation.confirmed,
      failedNames: failed,
    );
  }

  /// 붙였던 사진을 뺀다. **글과의 연결만 끊는 것이 아니라 오브젝트도 지운다** —
  /// 아직 글을 만들기 전이라 이 키를 쓸 곳이 없고, 남겨두면 고아 오브젝트가 된다
  /// (가이드 §4). 없는 키를 지워도 오류가 아니다(멱등).
  Future<void> removePhoto(String objectKey) async {
    state = state.copyWith(
      photoKeys: state.photoKeys
          .where((String k) => k != objectKey)
          .toList(growable: false),
    );
    try {
      await _repository.deletePostImage(objectKey);
    } on Object {
      // 스토리지 정리 실패로 글쓰기를 막지 않는다 — lifecycle이 결국 치운다.
    }
  }

  /// 등록한다. [PostDraft.canSubmit]이 false면 아무것도 하지 않는다 — 버튼이 이미
  /// 비활성이지만, 상태와 판정을 한 곳에 두어 화면이 우회할 수 없게 한다.
  Future<ComposerResult> submit() async {
    final PostDraft draft = state;
    if (!draft.canSubmit) return const ComposerFailed();

    try {
      final String? postId = await _repository.createPost(
        category: draft.category!,
        title: draft.title.trim(),
        body: draft.body.trim(),
        // **선택 항목이다** — null이면 장소 없는 글로 등록된다(가이드 §5).
        spotId: draft.spotId,
        tags: draft.tags,
        photoKeys: draft.photoKeys,
      );
      return ComposerSucceeded(postId);
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
