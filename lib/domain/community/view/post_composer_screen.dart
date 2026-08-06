import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/auth_route.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/community_labels.dart';
import '../component/post_photo.dart';
import '../component/spot_picker_sheet.dart';
import '../model/community_chip.dart';
import '../model/composer_photo.dart';
import '../model/nearby_spot.dart';
import '../model/post.dart';
import '../model/post_draft.dart';
import '../model/target_category.dart';
import '../provider/community_providers.dart';
import '../provider/moderation_providers.dart';
import '../provider/photo_picker_providers.dart';
import '../provider/post_composer_providers.dart';
import '../provider/post_detail_providers.dart';

/// 글 작성·수정 화면 — **당근 컴포저처럼 전면(full-bleed) 입력**이다.
///
/// ```
/// AppBar   "새 글" · 닫기(X) · 우측 [등록] (조건 미충족 시 비활성)
/// 본문
///   ├── 카테고리 인라인 선택기   ← **필수**. 한 줄짜리 드롭다운형 칩
///   ├── 제목 (테두리 없음, 크고 굵게)
///   ├── 얇은 구분선
///   └── 내용 (테두리 없음, **남은 높이를 전부 채운다**)
/// 하단 액션 바   태그 · 장소 · 사진 + 카운터
/// ```
///
/// **테두리 있는 짧은 입력 상자를 두지 않는다.** 글쓰기 화면에서 가장 큰 면적을
/// 차지해야 하는 것은 본문이며, 테두리는 그 면적을 잘라 먹기만 한다. 태그·장소·사진은
/// 세로로 긴 라벨 섹션이 아니라 하단 바의 버튼으로 접어 각자 시트에서 다룬다.
///
/// **등록 버튼은 카테고리·제목·내용이 갖춰지기 전까지 비활성이다.** 서버 검증을
/// 기다렸다가 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지
/// 못하게 한다. **장소는 조건이 아니다** — 선택 항목이다(가이드 §5).
///
/// **길이 제한을 넘으면 입력이 막히는 것이 아니라 등록이 막히고 초과분이 드러난다** —
/// 입력을 자르면 붙여넣기한 유저가 무엇이 사라졌는지 모른다. 카운터는 전부
/// **코드포인트** 기준이며(가이드 §8), 평소에는 눈에 띄지 않게 하단 바에 두고
/// 한계에 가까워지거나 넘으면 드러낸다.
///
/// [editPostId]가 있으면 **수정 모드**다. 수정도 새 글과 **같은 입력을 준다** —
/// 서버가 `editPost`로 카테고리·장소·태그를 받기 시작했기 때문이다(1차 가이드 §5의
/// "못 바꾼다"는 낡은 서술이고 라이브 스키마가 정본이다).
///
/// 수정할 내용은 **서버에서 다시 받아 온다**([postDetailProvider]). 라우트
/// 파라미터로 제목·본문만 실어 보내던 방식은 사진 키를 실을 수 없어(URL 길이·이스케이프)
/// 수정 화면이 사진 없는 새 글처럼 열렸다 — 사용자가 기존 사진을 보지도 지키지도
/// 못하던 원인이 이것이다. 카테고리·태그·장소도 같은 조회로 채우므로 사용자는
/// **자기 글의 현재 값을 보고 고친다** — 빈 채로 열어 저장하면 값이 날아간다.
class PostComposerScreen extends ConsumerStatefulWidget {
  const PostComposerScreen({
    super.key,
    this.initialSpotId,
    this.initialSpotTitle,
    this.initialCategory,
    this.editPostId,
  });

  static String get routeName => 'post-composer';

  /// 장소 상세에서 진입하면 장소가 이미 정해져 있다. 커뮤니티 탭에서 열면 null이고
  /// **그래도 등록할 수 있다**(가이드 §5).
  final String? initialSpotId;
  final String? initialSpotTitle;

  /// 장소의 카테고리 제안(`PostSpot.category`). 서버가 그 용도로 내려주는 값이다.
  final TargetCategory? initialCategory;

  /// 수정 대상 글 id. null이면 새 글 작성이다. 제목·본문·사진은 이 id로 다시
  /// 조회한다.
  final String? editPostId;

  @override
  ConsumerState<PostComposerScreen> createState() => _PostComposerScreenState();
}

class _PostComposerScreenState extends ConsumerState<PostComposerScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();

  /// 등록 진행 중인지. 중복 제출을 막고 버튼을 스피너로 바꾼다.
  bool _submitting = false;

  /// 수정 모드에서 서버가 준 내용을 초안에 한 번 옮겼는지. 조회가 끝난 뒤 딱 한 번만
  /// 채워야 한다 — 매 빌드마다 덮으면 사용자가 방금 친 글자가 되돌아간다.
  bool _seeded = false;

  bool get _isEditing => widget.editPostId != null;

  PostComposerProvider get _provider => postComposerProvider(
    initialSpotId: widget.initialSpotId,
    initialSpotTitle: widget.initialSpotTitle,
    initialCategory: widget.initialCategory,
    // 수정 중에는 사진을 빼도 오브젝트를 지우지 않는다 — 아직 서버의 글에 붙어
    // 있기 때문이다(가이드 §4).
    editing: _isEditing,
  );

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 수정 모드에서는 글을 다시 받아 제목·본문·사진을 채운다. 조회 중에는 빈 폼을
    // 보여주지 않는다 — 비었다가 갑자기 채워지면 무엇이 원본인지 알 수 없다.
    if (_isEditing) {
      final AsyncValue<Post?> state = ref.watch(
        postDetailProvider(widget.editPostId!),
      );
      return switch (state) {
        AsyncData<Post?>(value: final Post? post) when post != null =>
          _buildForm(context, seedFrom: post),
        // **null은 오류가 아니다** — 삭제·차단·숨김이면 서버가 오류 대신 null을
        // 준다(가이드 §6). 상세와 같은 안내를 띄우고, 다시 조회해도 같은 null이라
        // 재시도를 권하지 않는다.
        AsyncData<Post?>() => const _EditPlaceholder(unavailable: true),
        AsyncError<Post?>() => _EditPlaceholder(
          unavailable: true,
          onRetry: () => ref.invalidate(postDetailProvider(widget.editPostId!)),
        ),
        _ => const _EditPlaceholder(),
      };
    }
    return _buildForm(context);
  }

  Widget _buildForm(BuildContext context, {Post? seedFrom}) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 조회가 끝난 첫 빌드에서만 초안을 채운다. build 중에 provider를 건드리면 안
    // 되므로 프레임 뒤로 미룬다.
    if (seedFrom != null && !_seeded) {
      _seeded = true;
      _title.text = seedFrom.title;
      _body.text = seedFrom.body;
      final Post post = seedFrom;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(_provider.notifier)
            .seedFromPost(
              title: post.title,
              body: post.body,
              photoKeys: post.photoKeys,
              // 카테고리·태그·장소도 채운다 — 서버가 이제 이 셋을 받으므로 비운
              // 채로 저장하면 사용자가 뜻하지 않은 값이 나간다.
              category: post.category,
              tags: post.tags,
              spotId: post.spot?.id,
              spotTitle: post.spot?.title,
            );
      });
    }
    final PostDraft draft = ref.watch(_provider);
    // **수정도 카테고리를 요구한다.** 서버 입력에서는 nullable이지만 모든 글에 이미
    // 카테고리가 있고, null을 보내면 "지우기"인지 "그대로"인지 서버 해석이 불분명
    // 하다 — 화면이 그 애매함을 만들지 않는다.
    final bool canSubmit = draft.canSubmit;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.communityCancel,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          _isEditing ? l10n.communityEditTitle : l10n.communityComposeTitle,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _submitting
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: canSubmit ? _submit : null,
                    child: Text(l10n.communityComposeSubmit),
                  ),
          ),
        ],
      ),
      // 키보드가 올라와도 본문이 그만큼 줄어들 뿐 넘치지 않는다 — Scaffold가
      // viewInsets를 body 높이에서 빼 주고, 본문은 Expanded라 그 높이를 따라간다.
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 수정에서도 같은 선택기를 준다 — 서버가 `editPost(category:)`를
            // 받으므로 숨길 이유가 없어졌다.
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: _CategorySelector(
                selected: draft.category,
                onSelected: (TargetCategory c) =>
                    ref.read(_provider.notifier).setCategory(c),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _title,
                // **maxLength를 두지 않는다** — 두면 입력이 잘려 초과분이 사라진다.
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                  hintText: l10n.communityComposeTitleHint,
                  // 테두리 없음 — 화면 가득 쓰는 입력이 이 화면의 요지다.
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                textInputAction: TextInputAction.next,
                onChanged: (String value) =>
                    ref.read(_provider.notifier).setTitle(value),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(height: 1, thickness: 0.5),
            ),
            // **본문이 남은 높이를 전부 차지한다.** 이 화면에서 가장 큰 면적을
            // 차지해야 하는 것이 본문이고, 짧은 상자는 쓸 공간이 없어 보인다.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _body,
                  // null이면 높이 제한 없이 부모(Expanded)를 채우고 스크롤한다.
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: l10n.communityComposeBodyHint,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (String value) =>
                      ref.read(_provider.notifier).setBody(value),
                ),
              ),
            ),
            // 붙인 사진은 하단 바 바로 위에 줄로 남는다 — 무엇을 붙였는지 보이지
            // 않으면 지울 수도 없다.
            if (draft.photos.isNotEmpty)
              _PhotoRow(
                photos: draft.photos,
                onRemove: (String id) =>
                    ref.read(_provider.notifier).removePhoto(id),
              ),
            // 태그도 마찬가지다 — 시트에서 넣은 결과가 화면에 남아야 한다.
            if (draft.tags.isNotEmpty)
              _TagRow(
                tags: draft.tags,
                onRemove: (String tag) =>
                    ref.read(_provider.notifier).removeTag(tag),
              ),
            _BottomBar(
              draft: draft,
              // 장소 상세에서 진입해 고정된 경우에는 바꿀 수 없다 — 그 화면의
              // 글이라는 것이 진입의 전제다. **수정 모드는 여기 해당하지 않는다** —
              // 수정은 커뮤니티에서 열리므로 initialSpotId가 없다.
              spotLocked: widget.initialSpotId != null,
              onTags: _editTags,
              onSpot: _pickSpot,
              onClearSpot: () => ref.read(_provider.notifier).clearSpot(),
              onPhotos: _addPhotos,
            ),
          ],
        ),
      ),
    );
  }

  /// 장소 선택 시트를 연다(가이드 §5 — 장소는 선택 항목이다).
  ///
  /// 주변 장소와 **좋아요한 장소** 두 출처에서 고른다. 아무것도 고르지 않고 닫으면
  /// (null) 초안을 건드리지 않는다.
  ///
  /// **떼는 것은 이 시트가 아니라 하단 바의 지우기 버튼이 맡는다** — 고르는 목록
  /// 안에 "장소 없음"을 항목으로 섞어 두면 그것이 장소인 것처럼 읽힌다.
  Future<void> _pickSpot() async {
    final SpotPickerResult? result = await showSpotPickerSheet(context);
    if (!mounted || result == null) return;
    switch (result) {
      case SpotPickerChosen(:final NearbySpot spot):
        ref.read(_provider.notifier).setSpot(id: spot.id, title: spot.title);
    }
  }

  /// 태그 입력 시트를 연다. 공백이 든 태그는 서버가 `INVALID_TAG`로 거부하므로
  /// **시트가 미리 막고 그 이유를 보여준다**(가이드 §5).
  Future<void> _editTags() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext context) => _TagSheet(provider: _provider),
  );

  /// 사진을 고른다. **네트워크를 타지 않는다** — 고른 바이트를 초안에 들고 있다가
  /// 등록/수정을 누를 때 올린다(가이드 §4의 1~3단계는 그때 돈다).
  ///
  /// 고르는 즉시 올리면 글을 쓰지 않고 나간 사용자의 사진이 스토리지에 고아로 남고,
  /// 골랐다 뺐다를 반복하는 만큼 쌓인다 — 실제 저장 비용이다.
  ///
  /// **고르는 수단은 주입된다**([photoPickerProvider]) — 위젯 테스트가 갤러리를
  /// 열지 않도록 override할 수 있어야 하기 때문이다. null은 사용자가 취소한 것이라
  /// 아무 안내도 하지 않는다.
  ///
  /// **크기 상한은 여기서 거른다.** 업로드를 미뤄도 이 검사는 고르는 자리에 남는다 —
  /// 사용자는 사진이 너무 크다는 것을 글을 다 쓰고 나서가 아니라 그 자리에서 알아야
  /// 한다. 또 10 MiB를 넘는 장을 1단계에 그대로 넘기면 서버가
  /// `UNSUPPORTED_CONTENT_TYPE`으로 **전부** 거절해(부분 발급이 없다) 멀쩡한 장까지
  /// 같이 죽는다.
  Future<void> _addPhotos() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PostDraft draft = ref.read(_provider);
    // 상한은 원격·로컬을 합쳐 센다.
    final int remaining = draft.remainingPhotoSlots;
    if (remaining <= 0) {
      _toast(l10n.communityComposeErrorTooManyPhotos);
      return;
    }

    final List<LocalPhoto>? picked = await ref.read(photoPickerProvider)(
      limit: remaining,
    );
    if (!mounted) return;
    if (picked == null || picked.isEmpty) return;

    final List<LocalPhoto> withinLimit = picked
        .where((LocalPhoto p) => p.contentLength <= maxPostPhotoBytes)
        .toList();
    if (withinLimit.length != picked.length) {
      _toast(
        l10n.communityComposePhotoTooLarge(picked.length - withinLimit.length),
      );
    }
    if (withinLimit.isEmpty) return;

    ref.read(_provider.notifier).addPhotos(withinLimit);
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    if (_isEditing) {
      await _submitEdit();
    } else {
      await _submitCreate();
    }
    if (mounted) setState(() => _submitting = false);
  }

  /// 등록. 사진 업로드도 여기 안에서 일어난다 — [submit]이 먼저 올리고 확정 키로
  /// `createPost`를 부른다.
  ///
  /// **사진이 실패해도 글은 올라간다**(가이드 §4·디자인 §3). 그래서 성공 안내를
  /// 띄운 뒤 못 올린 장이 있다는 것만 덧붙인다 — 사진 한 장 때문에 사용자가 쓴 글을
  /// 통째로 버리게 하지 않는다.
  Future<void> _submitCreate() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ComposerResult result = await ref.read(_provider.notifier).submit();
    if (!mounted) return;

    switch (result) {
      case ComposerSucceeded(:final List<String> failedPhotoNames):
        // `createPost`는 postId만 준다(가이드 §5). 피드로 돌아가면 목록을 새로
        // 고치는 것으로 충분하므로 상세 재조회 없이 닫는다.
        Navigator.of(context).pop(true);
        _toast(
          failedPhotoNames.isEmpty
              ? l10n.communityComposeDone
              : l10n.communityComposeDonePhotosFailed(failedPhotoNames.length),
        );
      case ComposerUnauthenticated():
        _toast(l10n.communitySignInRequired);
        context.pushNamed(loginRouteName);
      case ComposerRejected(:final String? code):
        _toast(_messageFor(l10n, code));
      case ComposerFailed():
        _toast(l10n.communityActionFailed);
    }
  }

  /// 수정 저장. 등록과 같은 순서다 — **먼저 새로 고른 장을 올리고**, 확정된 키만
  /// 실어 `editPost`를 부른다.
  Future<void> _submitEdit() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 업로드가 통째로 실패해도 저장은 진행한다 — 못 올린 장만 빠진다.
    List<String> failedPhotoNames = const <String>[];
    try {
      failedPhotoNames =
          (await ref.read(_provider.notifier).uploadPending()).failedNames;
    } on Object {
      failedPhotoNames = ref
          .read(_provider)
          .pendingPhotos
          .map((LocalPhoto p) => p.name)
          .toList(growable: false);
    }
    if (!mounted) return;

    final PostDraft draft = ref.read(_provider);
    // 장소를 실제로 바꿨는지는 초안이 아니라 **씨앗과의 차이**가 판정한다 —
    // `spotId: null`만으로는 "뗐다"와 "원래 없었다"가 구분되지 않는다.
    final bool spotChanged = ref.read(_provider.notifier).spotChanged;
    final ModerationOutcome outcome = await ref
        .read(moderationControllerProvider.notifier)
        .editPost(
          postId: widget.editPostId!,
          title: draft.title.trim(),
          body: draft.body.trim(),
          // **항상 현재 목록을 보낸다.** `photoKeys`는 전체 교체이고 생략하면
          // 사진이 그대로 남는다(가이드 §5) — 화면이 기존 사진을 채워 열고 뺄
          // 수단까지 주는 이상, 생략하면 "다 지웠는데 그대로"가 된다. 빈 목록도
          // 사용자가 뜻한 결과이므로 그대로 보낸다.
          //
          // 확정 키만 실린다 — 못 올린 장은 빠진 채로 저장된다.
          photoKeys: draft.remoteKeys,
          // 카테고리·태그도 같은 이유로 현재 값을 그대로 보낸다(전체 교체).
          category: draft.category,
          tags: draft.tags,
          // **바꾸지 않았으면 false다** — 그때 서버는 붙어 있던 장소를 유지한다.
          // true일 때만 `spotId`가 반영되고, true + null이 "장소 떼기"다.
          changeSpot: spotChanged,
          spotId: spotChanged ? draft.spotId : null,
        );
    if (!mounted) return;

    switch (outcome) {
      case ModerationOutcome.success:
        Navigator.of(context).pop(true);
        _toast(
          failedPhotoNames.isEmpty
              ? l10n.communityEditDone
              : l10n.communityEditDonePhotosFailed(failedPhotoNames.length),
        );
      case ModerationOutcome.notEditable:
        _toast(l10n.communityComposeErrorNotEditable);
      case ModerationOutcome.unauthenticated:
        _toast(l10n.communitySignInRequired);
        context.pushNamed(loginRouteName);
      case ModerationOutcome.alreadyReported:
      case ModerationOutcome.failure:
        _toast(l10n.communityActionFailed);
    }
  }

  /// 서버 `userErrors.code` → 화면 문구(가이드 §7). 모르는 코드는 일반 실패로
  /// 떨어뜨린다 — 서버 message를 그대로 띄우지 않는다(PII가 실릴 수 있다, POL-013).
  String _messageFor(AppLocalizations l10n, String? code) => switch (code) {
    'POST_TITLE_REQUIRED' => l10n.communityComposeErrorTitleRequired,
    'POST_TITLE_LENGTH_INVALID' => l10n.communityComposeErrorTitleLength,
    'POST_BODY_REQUIRED' => l10n.communityComposeErrorBodyRequired,
    'POST_BODY_LENGTH_INVALID' => l10n.communityComposeErrorBodyLength,
    'INVALID_TAG' => l10n.communityComposeErrorInvalidTag,
    'TOO_MANY_TAGS' => l10n.communityComposeErrorTooManyTags,
    'SPOT_NOT_FOUND' => l10n.communityComposeErrorSpotNotFound,
    'TOO_MANY_PHOTOS' => l10n.communityComposeErrorTooManyPhotos,
    'PHOTO_NOT_UPLOADED' => l10n.communityComposeErrorPhotoNotUploaded,
    _ => l10n.communityActionFailed,
  };

  void _toast(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}

/// 수정할 글을 받아 오는 동안, 또는 받아 오지 못했을 때 폼 대신 서는 화면.
///
/// **빈 폼을 먼저 보여주지 않는다** — 비었다가 갑자기 채워지면 사용자가 무엇이
/// 원본인지 알 수 없고, 그 사이에 친 글자는 덮여 사라진다.
///
/// [unavailable]이면 삭제·차단·숨김으로 볼 수 없는 글이다(가이드 §6). [onRetry]가
/// null이면 재시도 버튼을 두지 않는다 — 다시 조회해도 같은 null이다.
class _EditPlaceholder extends StatelessWidget {
  const _EditPlaceholder({this.unavailable = false, this.onRetry});

  final bool unavailable;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.communityCancel,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l10n.communityEditTitle),
      ),
      body: SafeArea(
        child: Center(
          child: unavailable
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        l10n.communityPostUnavailableTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.communityPostUnavailable,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (onRetry != null) ...<Widget>[
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: onRetry,
                          child: Text(l10n.communityRetry),
                        ),
                      ],
                    ],
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

/// 하단 액션 바 — 태그·장소·사진과 글자 수.
///
/// 세로로 긴 라벨 섹션 대신 한 줄로 접는다. 본문이 화면 대부분을 차지해야 하고,
/// 이 셋은 **선택 항목이라 늘 펼쳐 둘 이유가 없다.**
///
/// 카운터는 **평소에 조용하다** — 한계에 가까워지거나(90%) 넘었을 때만 드러낸다.
/// 늘 띄워 두면 500자 중 12자를 쓴 사람에게도 남은 분량을 재촉하는 것처럼 보인다.
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.draft,
    required this.spotLocked,
    required this.onTags,
    required this.onSpot,
    required this.onClearSpot,
    required this.onPhotos,
  });

  final PostDraft draft;

  /// 장소 상세에서 진입해 장소가 고정된 경우. 버튼은 남기되 누를 수 없다.
  final bool spotLocked;

  final VoidCallback onTags;
  final VoidCallback onSpot;

  /// 붙은 장소를 뗀다. 시트에서 "장소 없이"를 걷어 냈으므로 **해제 수단은 이것
  /// 하나뿐이다**(가이드 §5).
  final VoidCallback onClearSpot;

  final VoidCallback onPhotos;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: <Widget>[
          // 태그·장소는 **수정에서도 그대로 준다** — 서버가 `editPost`로 둘 다
          // 받기 시작했다.
          _BarButton(
            icon: Icons.tag,
            label: l10n.communityComposeTagsAction,
            onPressed: onTags,
          ),
          _BarButton(
            icon: Icons.place_outlined,
            // 고른 장소가 있으면 그 이름이 곧 상태 표시다.
            label: draft.spotTitle ?? l10n.communityComposeSpotAction,
            active: draft.spotId != null,
            onPressed: spotLocked ? null : onSpot,
          ),
          // **장소를 떼는 유일한 수단이다**(가이드 §5 — 장소는 선택 항목이라 뗄 길이
          // 반드시 있어야 한다). 시트 안의 "장소 없이" 항목을 걷어 냈으므로 해제는
          // 여기서만 한다. 붙어 있고 고정되지 않았을 때만 나타난다.
          if (draft.spotId != null && !spotLocked)
            IconButton(
              onPressed: onClearSpot,
              tooltip: l10n.communityComposeSpotClear,
              visualDensity: VisualDensity.compact,
              iconSize: 18,
              icon: const Icon(Icons.close),
            ),
          _BarButton(
            icon: Icons.photo_outlined,
            label: l10n.communityComposePhotosAction,
            onPressed: onPhotos,
          ),
          const Spacer(),
          _Counters(draft: draft),
        ],
      ),
    );
  }
}

/// 하단 바의 버튼 하나. 값이 정해져 있으면 강조색으로 그 사실을 알린다.
class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Flexible(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: TextButton.styleFrom(
          foregroundColor: active
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}

/// 글자 수 카운터(코드포인트 기준, 가이드 §8).
///
/// **한계 근처에서만 나타난다.** 초과했으면 남은 수 대신 **넘긴 수**를 보여준다 —
/// 음수 카운터보다 "몇 자를 줄여야 하는지"가 바로 읽힌다.
class _Counters extends StatelessWidget {
  const _Counters({required this.draft});

  final PostDraft draft;

  /// 카운터를 드러내는 문턱 — 한계의 90%.
  static const double _showFrom = 0.9;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    final bool showTitle =
        draft.isTitleTooLong ||
        draft.titleRunes >= maxPostTitleRunes * _showFrom;
    final bool showBody =
        draft.isBodyTooLong || draft.bodyRunes >= maxPostBodyRunes * _showFrom;

    final String? text = draft.isTitleTooLong
        ? l10n.communityComposeTooLong(-draft.remainingTitleRunes)
        : draft.isBodyTooLong
        ? l10n.communityComposeTooLong(-draft.remainingBodyRunes)
        : showTitle
        ? l10n.communityTitleCounter(draft.titleRunes)
        : showBody
        ? l10n.communityBodyCounter(draft.bodyRunes)
        : null;
    if (text == null) return const SizedBox.shrink();

    final bool isError = draft.isTitleTooLong || draft.isBodyTooLong;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isError
              ? theme.colorScheme.error
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// 카테고리 인라인 선택기. **서버가 내려준 칩 구성을 그대로 쓴다** — 언어마다 가용
/// 카테고리가 달라 클라이언트가 전체 목록을 하드코딩하면 안 된다(가이드 §2).
///
/// 칩 조회가 실패하거나 비면 [TargetCategory]의 전체 집합으로 떨어진다 — 카테고리가
/// 필수라 고를 수단이 없으면 글을 아예 쓸 수 없기 때문이다.
///
/// 아홉 개를 Wrap으로 펼치면 화면 위쪽을 다 먹으므로 **한 줄 가로 스크롤**로 둔다.
class _CategorySelector extends ConsumerWidget {
  const _CategorySelector({required this.selected, required this.onSelected});

  final TargetCategory? selected;
  final ValueChanged<TargetCategory> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<TargetCategory> categories =
        ref
            .watch(communityChipsProvider)
            .value
            ?.map((CommunityChip c) => c.category)
            .toList(growable: false) ??
        const <TargetCategory>[];

    final List<TargetCategory> options = categories.isEmpty
        ? TargetCategory.values
        : categories;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (BuildContext context, int index) {
          final TargetCategory category = options[index];
          return Center(
            child: ChoiceChip(
              label: Text(targetCategoryLabel(l10n, category)),
              selected: selected == category,
              visualDensity: VisualDensity.compact,
              // 필수 항목이라 해제되지 않는다 — 다시 눌러도 선택이 유지된다.
              onSelected: (_) => onSelected(category),
            ),
          );
        },
      ),
    );
  }
}

/// 태그 입력 시트. 공백이 든 태그는 서버가 거부하므로 **여기서 미리 막는다**
/// (가이드 §5).
class _TagSheet extends ConsumerStatefulWidget {
  const _TagSheet({required this.provider});

  final PostComposerProvider provider;

  @override
  ConsumerState<_TagSheet> createState() => _TagSheetState();
}

class _TagSheetState extends ConsumerState<_TagSheet> {
  final TextEditingController _tag = TextEditingController();

  @override
  void dispose() {
    _tag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PostDraft draft = ref.watch(widget.provider);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.communityComposeTagsSheetTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tag,
            enabled: draft.canAddTag,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.communityComposeTagHint,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: draft.canAddTag ? _addTag : null,
                icon: const Icon(Icons.add),
              ),
            ),
            onSubmitted: (_) => _addTag(),
          ),
          if (draft.tags.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final String tag in draft.tags)
                  // 태그는 사용자가 입력한 원문 그대로 보여준다 — 번역 대상이
                  // 아니다(가이드 §9).
                  InputChip(
                    label: Text('#$tag'),
                    onDeleted: () =>
                        ref.read(widget.provider.notifier).removeTag(tag),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.communityComposeSheetDone),
            ),
          ),
        ],
      ),
    );
  }

  /// 태그를 더한다. 상한과 공백은 **여기서 미리 막고 그 이유를 보여준다**.
  void _addTag() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String raw = _tag.text;
    if (raw.trim().isEmpty) return;

    final PostDraft draft = ref.read(widget.provider);
    if (!draft.canAddTag) {
      _toast(l10n.communityComposeTagLimit);
      return;
    }
    if (!PostDraft.isValidTag(raw)) {
      _toast(l10n.communityComposeTagInvalid);
      return;
    }
    if (ref.read(widget.provider.notifier).addTag(raw)) _tag.clear();
  }

  void _toast(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));
}

/// 붙인 태그 줄. 시트를 닫아도 무엇을 넣었는지 화면에 남아야 뺄 수 있다.
class _TagRow extends StatelessWidget {
  const _TagRow({required this.tags, required this.onRemove});

  final List<String> tags;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tags.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (BuildContext context, int index) => Center(
        child: InputChip(
          label: Text('#${tags[index]}'),
          visualDensity: VisualDensity.compact,
          onDeleted: () => onRemove(tags[index]),
        ),
      ),
    ),
  );
}

/// 첨부한 사진 줄. 붙인 것이 있을 때만 나타나며, 추가는 하단 바가 맡는다.
///
/// **두 종류가 한 줄에 섞인다.** 아직 올리지 않은 장은 손에 든 바이트로 바로 그리고
/// ([Image.memory]), 이미 올라간 장은 CDN에서 받아 그린다([PostPhoto]) — 사용자에게는
/// 구분 없이 똑같은 썸네일이다. 업로드 전이라고 빈 칸을 두면 무엇을 골랐는지 알 수
/// 없다.
class _PhotoRow extends StatelessWidget {
  const _PhotoRow({required this.photos, required this.onRemove});

  final List<ComposerPhoto> photos;

  /// 뺄 장을 [ComposerPhoto.id]로 지목한다.
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 84,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: <Widget>[
        for (final ComposerPhoto photo in photos)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 84,
                    height: 84,
                    child: switch (photo) {
                      RemotePhoto(:final String objectKey) => PostPhoto(
                        photoKey: objectKey,
                      ),
                      LocalPhoto(:final Uint8List bytes) => Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                      ),
                    },
                  ),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: IconButton(
                    onPressed: () => onRemove(photo.id),
                    iconSize: 18,
                    icon: const Icon(Icons.cancel),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
