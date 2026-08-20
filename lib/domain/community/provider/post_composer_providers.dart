import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/community_failure.dart';
import '../../../common/localization/locale_controller.dart';
import '../../../common/model/composer_photo.dart';
import '../model/post_draft.dart';
import '../../../common/model/post_image_upload.dart';
import '../../../common/model/stored_draft.dart';
import '../../../common/model/target_category.dart';
import '../../../common/storage/draft_store.dart';
import '../../../common/storage/draft_store_impl.dart';
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

/// 이어쓰기 제안의 상태(SPEC-0022 R5).
///
/// **판정이 끝났다는 사실을 상태에 남긴다.** 복원한 초안은 곧바로 다시 저장되므로,
/// 이 표시가 없으면 "초안 있음" 조건이 계속 참이 되어 저장이 제안을 되살린다(R5-4).
enum DraftRestorePrompt {
  /// 아직 판정하지 않았다. 화면이 열리면서 [PostComposer.considerDraft]가 돈다.
  undecided,

  /// 이어쓸 초안이 있다. 화면이 다이얼로그를 띄운다.
  offered,

  /// 판정이 끝났다 — 이어썼든 버렸든 없었든. 다시 묻지 않는다.
  settled,
}

/// 자동 저장 디바운스 간격(SPEC-0022 §4). 상태가 바뀔 때마다 디스크에 쓰면 타이핑
/// 한 글자마다 파일 I/O가 일어난다.
const Duration draftAutosaveDebounce = Duration(seconds: 2);

/// 컴포저가 편집 중인 초안.
///
/// **autoDispose(codegen 기본)를 유지하되 초안은 디스크에 남는다**(SPEC-0022 §1).
/// 예전에는 "컴포저를 닫으면 초안이 사라지는 것이 맞다"고 보았지만 SPEC-0022가 그
/// 판단을 철회했다. 그렇다고 `keepAlive`로 바꾸지는 않는다 — 프로바이더 수명은 앱
/// 종료를 견디지 못해 R3를 만족하지 못하고, 화면 밖에서 컴포저 상태가 계속 살아 있는
/// 부작용만 생긴다. 초안이 살아남는 곳을 **수명이 아니라 디스크로** 옮긴 것이 이
/// 설계의 요지다.
///
/// **수정 모드는 저장도 복원도 하지 않는다**(R11). 서버에 이미 있는 글을 고치는
/// 중이라 초안이라는 개념이 성립하지 않고, 수정 모드 진입이 새 글 초안을 지우지도
/// 않는다(R11-3).
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
  }) {
    // **저장소를 여기서 붙잡아 둔다.** dispose 콜백 안에서는 `ref.read`가 금지돼
    // 있어(Riverpod 3), 화면이 닫힐 때 마지막 저장을 하려면 참조가 미리 있어야 한다.
    _storeRef = ref.read(draftStoreProvider);

    // 활성 언어도 같은 이유로 미리 읽어 둔다(SPEC-0029 AC-26.2). 저장 시점에
    // `ref.read`를 부르면 dispose 경로의 마지막 저장에서 그 금지에 걸린다 —
    // 언어가 바뀌면 컴포저는 어차피 다시 빌드되므로 빌드 시점의 값이 맞다.
    _languageCode = ref.read(localeControllerProvider).languageCode;

    // 새 글에서만 자동 저장이 붙는다(R11). 수정 모드는 상태가 바뀌어도 디스크를
    // 건드리지 않는다.
    if (!editing) {
      // 상태 변경 후 디바운스 간격 동안 추가 변경이 없으면 저장한다(§4).
      listenSelf((PostDraft? previous, PostDraft next) {
        if (previous == null) return;
        _scheduleSave();
      });
      // 화면이 닫히면 대기 중인 변경을 흘리지 않도록 즉시 쓴다(§4).
      ref.onDispose(() {
        _debounce?.cancel();
        _debounce = null;
        if (_pendingSave) _writeNow(_lastState ?? state);
      });
    }
    return PostDraft(
      spotId: initialSpotId,
      spotTitle: initialSpotTitle,
      category: initialCategory,
    );
  }

  /// [build]에서 붙잡아 둔 활성 언어 코드(SPEC-0029). 저장한 초안의 장소 참조가
  /// 어느 언어에서 유효한지를 기록하는 값이다. [_storeRef]와 같은 이유로 미리 읽는다.
  late String _languageCode;

  /// [build]에서 붙잡아 둔 저장소. dispose 시점에는 `ref.read`를 쓸 수 없다.
  /// 매 빌드에서 다시 채우므로 `late final`이 아니다 — 재빌드가 두 번째 대입에서
  /// 죽는다.
  DraftStore? _storeRef;

  DraftStore get _store => _storeRef ?? ref.read(draftStoreProvider);

  /// 이어쓰기 제안의 현재 단계. 화면이 이 값으로 다이얼로그를 띄울지 정한다.
  DraftRestorePrompt get restorePrompt => _restorePrompt;
  DraftRestorePrompt _restorePrompt = DraftRestorePrompt.undecided;

  Timer? _debounce;

  /// 디바운스 대기 중인 변경이 있는지. dispose 때 흘리지 않기 위해 본다.
  bool _pendingSave = false;

  /// 마지막으로 관찰한 상태. dispose 시점에는 프로바이더가 이미 내려가 `state`를
  /// 읽을 수 없으므로 따로 들고 있는다.
  PostDraft? _lastState;

  /// 이어쓰기 제안을 받아 둔 초안. 사용자가 "이어쓰기"를 고르면 이 값으로 채운다.
  DraftLoaded? _offered;

  /// 이어쓸 초안의 미리보기. 화면이 다이얼로그에 제목을 보여줄 때 쓴다.
  StoredDraft? get offeredDraft => _offered?.draft;

  void _scheduleSave() {
    _lastState = state;
    _pendingSave = true;
    _debounce?.cancel();
    _debounce = Timer(draftAutosaveDebounce, () {
      _debounce = null;
      final PostDraft? pending = _lastState;
      if (pending != null) _writeNow(pending);
    });
  }

  /// 대기 중인 변경을 지금 쓴다. 앱이 백그라운드로 갈 때 화면이 부른다 — OS가 그
  /// 뒤에 앱을 죽여도 마지막 상태가 남는다(§4).
  void flush() {
    _debounce?.cancel();
    _debounce = null;
    if (_pendingSave) _writeNow(_lastState ?? state);
  }

  /// 실제로 디스크에 쓴다. **빈 초안은 저장 대신 삭제한다**(R1-3) — 그래야 "다
  /// 지웠는데도 이어쓰기를 묻는" 상태가 생기지 않는다.
  ///
  /// 실패는 [DraftStore]가 삼킨다(R9).
  void _writeNow(PostDraft draft) {
    _pendingSave = false;
    final StoredDraft stored = StoredDraft.fromDraft(
      savedAt: DateTime.now(),
      category: draft.category,
      // 장소 참조의 유효 범위를 함께 남긴다(SPEC-0029 AC-26.2) — 다른 언어에서
      // 복원하면 이 id는 해소되지 않는다.
      languageCode: _languageCode,
      spotId: draft.spotId,
      spotTitle: draft.spotTitle,
      title: draft.title,
      body: draft.body,
      tags: draft.tags,
      photos: draft.photos,
    );
    // 저장은 기다리지 않는다 — 실패해도 작성을 막지 않으므로 결과를 볼 이유가 없다.
    //
    // **여기서도 한 번 더 삼킨다**(R9). 구현이 예외를 삼키는 것이 계약이지만,
    // 삼키지 않는 구현이 끼어들어도 타이핑이 죽어서는 안 된다 — 자동 저장의 실패는
    // 사용자가 원래 겪던 상태(초안이 없는 것)로 돌아가는 것뿐이다.
    unawaited(
      (stored.isEmpty ? _store.clear() : _store.save(stored, draft.photos))
          .onError((Object? _, StackTrace _) {}),
    );
  }

  /// 저장된 초안이 있는지 판정한다. **컴포저를 여는 시점에 한 번만** 돈다(§5).
  ///
  /// 수정 모드는 이 분기에 아예 들어오지 않는다(R11) — 호출 자체를 화면이 막지만,
  /// 여기서도 한 번 더 막아 수정 모드가 초안을 건드릴 길을 없앤다.
  ///
  /// TTL 초과·복원 불가는 **지우고 빈 상태로 시작한다**(R8·R10). 조용히 넘어가며
  /// 사용자에게 알리지 않는다 — 할 수 있는 일이 없는 실패다(R10-3).
  Future<void> considerDraft({DateTime? now}) async {
    if (editing) return;
    if (_restorePrompt != DraftRestorePrompt.undecided) return;

    // 읽기 자체가 실패하면 **조용히 빈 상태로 시작한다**(R10-3) — 글을 쓰려고
    // 화면을 연 사람에게 처리할 수 없는 실패를 알리는 것은 방해다.
    DraftLoadResult result;
    try {
      result = await _store.load();
    } on Object {
      _restorePrompt = DraftRestorePrompt.settled;
      return;
    }

    switch (result) {
      case DraftAbsent():
        _restorePrompt = DraftRestorePrompt.settled;
      case DraftUnrestorable():
        await _clearQuietly();
        _restorePrompt = DraftRestorePrompt.settled;
      case DraftLoaded(:final StoredDraft draft):
        if (isDraftExpired(savedAt: draft.savedAt, now: now ?? DateTime.now())) {
          await _clearQuietly();
          _restorePrompt = DraftRestorePrompt.settled;
          return;
        }
        _offered = result;
        _restorePrompt = DraftRestorePrompt.offered;
    }
  }

  /// 초안을 지우되 실패를 밖으로 내보내지 않는다(R9).
  Future<void> _clearQuietly() =>
      _store.clear().onError((Object? _, StackTrace _) {});

  /// 제안한 초안으로 상태를 채운다(R5). 판정을 끝난 것으로 표시하므로 **복원 직후의
  /// 저장이 제안을 되살리지 않는다**(R5-4).
  void restoreDraft() {
    final DraftLoaded? offered = _offered;
    _restorePrompt = DraftRestorePrompt.settled;
    _offered = null;
    if (offered == null) return;
    // 저장 이후 언어가 바뀌었으면 장소 참조를 비운다(SPEC-0029 AC-26.2). spot이
    // 언어별로 갈리므로 그 id는 지금 언어에서 해소되지 않을 수 있고, 그대로 제출하면
    // 사용자가 쓴 글이 이유 없이 거절당한다. **본문·사진은 그대로 복원한다** —
    // 사용자가 쓴 것을 언어 때문에 버리지 않는다.
    final String activeLanguage = _languageCode;

    state = PostDraft(
      // 서버 목록에서 사라진 카테고리는 null로 온다 — 초안 전체를 버리지 않고 그
      // 값만 비워 사용자가 다시 고르게 한다(§3). 장소도 같은 결이다.
      category: offered.draft.restoredCategory,
      spotId: offered.draft.restoredSpotId(activeLanguage),
      spotTitle: offered.draft.restoredSpotTitle(activeLanguage),
      title: offered.draft.title,
      body: offered.draft.body,
      tags: offered.draft.tags,
      photos: offered.photos,
    );
  }

  /// 제안을 닫되 초안은 남긴다. 사용자가 다이얼로그 밖을 눌러 아무 결정도 하지 않은
  /// 경우다 — 실수로 닫았는데 글이 사라지면 이 기능의 취지가 무너지므로 지우지
  /// 않는다. 판정만 끝난 것으로 표시해 이후의 저장이 제안을 되살리지 않게 한다(R5-4).
  void dismissDraftPrompt() {
    _restorePrompt = DraftRestorePrompt.settled;
    _offered = null;
  }

  /// 제안을 버린다 — 저장된 초안을 지우고 빈 상태로 시작한다(R6-3).
  Future<void> discardDraft() async {
    _restorePrompt = DraftRestorePrompt.settled;
    _offered = null;
    await _clearQuietly();
  }

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
        catalogId: draft.spotId,
        tags: draft.tags,
        // 확정된 키만 넘긴다. 못 올린 장은 빠진 채로 등록된다.
        photoKeys: draft.remoteKeys,
      );
      // **등록에 성공했으므로 초안을 지운다**(R6-1). 대기 중인 디바운스도 함께
      // 취소한다 — 남겨 두면 방금 지운 초안을 2초 뒤에 되살린다.
      //
      // **삭제 실패가 등록 성공을 뒤집지 않는다**(R9) — 글은 이미 서버에 올라갔다.
      _debounce?.cancel();
      _debounce = null;
      _pendingSave = false;
      await _clearQuietly();
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
