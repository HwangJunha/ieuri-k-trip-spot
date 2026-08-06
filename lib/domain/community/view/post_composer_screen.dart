import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/auth_route.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/community_labels.dart';
import '../component/post_photo.dart';
import '../model/community_chip.dart';
import '../model/post_draft.dart';
import '../model/target_category.dart';
import '../provider/community_providers.dart';
import '../provider/moderation_providers.dart';
import '../provider/photo_picker_providers.dart';
import '../provider/post_composer_providers.dart';

/// 글 작성·수정 화면 — **당근 동네생활 컴포저 순서**를 따른다.
///
/// ```
/// AppBar   "새 글" · 닫기(X) · 우측 [등록] (조건 미충족 시 비활성)
/// 본문
///   ├── 카테고리 선택      ← **필수**. 당근처럼 먼저 고른다
///   ├── 제목 (50 코드포인트 카운터)
///   ├── 내용 (500 코드포인트 카운터)
///   ├── 태그 (최대 5, 공백 불가)
///   ├── 장소 (선택 — 없어도 등록된다)
///   └── 사진 (최대 5, 4단계 업로드)
/// ```
///
/// **등록 버튼은 카테고리·제목·내용이 갖춰지기 전까지 비활성이다.** 서버 검증을
/// 기다렸다가 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를 만들지
/// 못하게 한다. **장소는 조건이 아니다** — 선택 항목이다(가이드 §5).
///
/// **길이 제한을 넘으면 입력이 막히는 것이 아니라 등록이 막히고 초과분이 드러난다** —
/// 입력을 자르면 붙여넣기한 유저가 무엇이 사라졌는지 모른다. 카운터는 전부
/// **코드포인트** 기준이다(가이드 §8).
///
/// [editPostId]가 있으면 **수정 모드**다. 수정은 제목·본문·사진만 바꾸므로
/// 카테고리·태그·장소 입력을 숨긴다 — 서버가 받지 않는 값을 만지게 하면 안 된다.
class PostComposerScreen extends ConsumerStatefulWidget {
  const PostComposerScreen({
    super.key,
    this.initialSpotId,
    this.initialSpotTitle,
    this.initialCategory,
    this.editPostId,
    this.initialTitle,
    this.initialBody,
  });

  static String get routeName => 'post-composer';

  /// 장소 상세에서 진입하면 장소가 이미 정해져 있다. 커뮤니티 탭에서 열면 null이고
  /// **그래도 등록할 수 있다**(가이드 §5).
  final String? initialSpotId;
  final String? initialSpotTitle;

  /// 장소의 카테고리 제안(`PostSpot.category`). 서버가 그 용도로 내려주는 값이다.
  final TargetCategory? initialCategory;

  /// 수정 대상 글 id. null이면 새 글 작성이다.
  final String? editPostId;
  final String? initialTitle;
  final String? initialBody;

  @override
  ConsumerState<PostComposerScreen> createState() => _PostComposerScreenState();
}

class _PostComposerScreenState extends ConsumerState<PostComposerScreen> {
  late final TextEditingController _title = TextEditingController(
    text: widget.initialTitle ?? '',
  );
  late final TextEditingController _body = TextEditingController(
    text: widget.initialBody ?? '',
  );
  final TextEditingController _tag = TextEditingController();

  /// 등록 진행 중인지. 중복 제출을 막고 버튼을 스피너로 바꾼다.
  bool _submitting = false;

  bool get _isEditing => widget.editPostId != null;

  PostComposerProvider get _provider => postComposerProvider(
    initialSpotId: widget.initialSpotId,
    initialSpotTitle: widget.initialSpotTitle,
    initialCategory: widget.initialCategory,
  );

  @override
  void initState() {
    super.initState();
    // 수정 모드에서는 서버가 준 제목·본문으로 초안을 채운다. build 중에 provider를
    // 건드리면 안 되므로 프레임 뒤로 미룬다.
    if (widget.initialTitle != null || widget.initialBody != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(_provider.notifier)
          ..setTitle(widget.initialTitle ?? '')
          ..setBody(widget.initialBody ?? '');
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _tag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PostDraft draft = ref.watch(_provider);
    // 수정은 카테고리를 바꾸지 않으므로 제목·본문만 갖춰지면 저장할 수 있다.
    final bool canSubmit = _isEditing
        ? draft.hasTitle &&
              !draft.isTitleTooLong &&
              draft.hasBody &&
              !draft.isBodyTooLong
        : draft.canSubmit;

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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: <Widget>[
            // 수정에서는 카테고리를 바꿀 수 없다 — 바뀌면 글이 다른 피드로
            // 순간이동한다(가이드 §5).
            if (!_isEditing) ...<Widget>[
              _SectionLabel(text: l10n.communityComposeCategoryLabel),
              const SizedBox(height: 8),
              _CategoryPicker(
                selected: draft.category,
                onSelected: (TargetCategory c) =>
                    ref.read(_provider.notifier).setCategory(c),
              ),
              const SizedBox(height: 20),
            ],
            _SectionLabel(text: l10n.communityComposeTitleLabel),
            const SizedBox(height: 8),
            TextField(
              controller: _title,
              // **maxLength를 두지 않는다** — 두면 입력이 잘려 초과분이 사라진다.
              decoration: InputDecoration(
                hintText: l10n.communityComposeTitleHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (String value) =>
                  ref.read(_provider.notifier).setTitle(value),
            ),
            _Counter(
              text: draft.isTitleTooLong
                  ? l10n.communityComposeTooLong(-draft.remainingTitleRunes)
                  : l10n.communityTitleCounter(draft.titleRunes),
              isError: draft.isTitleTooLong,
            ),
            const SizedBox(height: 12),
            _SectionLabel(text: l10n.communityComposeBodyLabel),
            const SizedBox(height: 8),
            TextField(
              controller: _body,
              maxLines: 8,
              minLines: 5,
              decoration: InputDecoration(
                hintText: l10n.communityComposeBodyHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (String value) =>
                  ref.read(_provider.notifier).setBody(value),
            ),
            _Counter(
              text: draft.isBodyTooLong
                  ? l10n.communityComposeTooLong(-draft.remainingBodyRunes)
                  : l10n.communityBodyCounter(draft.bodyRunes),
              isError: draft.isBodyTooLong,
            ),
            // 태그·장소도 수정 대상이 아니다(가이드 §5).
            if (!_isEditing) ...<Widget>[
              const SizedBox(height: 20),
              _SectionLabel(text: l10n.communityComposeTagsLabel),
              const SizedBox(height: 8),
              _TagField(
                controller: _tag,
                tags: draft.tags,
                canAdd: draft.canAddTag,
                onAdd: _addTag,
                onRemove: (String tag) =>
                    ref.read(_provider.notifier).removeTag(tag),
              ),
              const SizedBox(height: 20),
              _SectionLabel(text: l10n.communityComposeSpotLabel),
              const SizedBox(height: 8),
              _SpotField(
                title: draft.spotTitle,
                // 장소 상세에서 진입해 고정된 경우에는 바꿀 수 없다 — 그 화면의
                // 글이라는 것이 진입의 전제다.
                onClear: widget.initialSpotId != null || draft.spotId == null
                    ? null
                    : () => ref.read(_provider.notifier).clearSpot(),
              ),
            ],
            const SizedBox(height: 20),
            _SectionLabel(text: l10n.communityComposePhotosLabel),
            const SizedBox(height: 8),
            _PhotoRow(
              photoKeys: draft.photoKeys,
              onAdd: _addPhotos,
              onRemove: (String key) =>
                  ref.read(_provider.notifier).removePhoto(key),
            ),
          ],
        ),
      ),
    );
  }

  /// 태그를 더한다. 공백이 들어가면 서버가 `INVALID_TAG`로 거부하므로 **여기서
  /// 미리 막고 그 이유를 보여준다**(가이드 §5).
  void _addTag() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String raw = _tag.text;
    if (raw.trim().isEmpty) return;

    final PostDraft draft = ref.read(_provider);
    if (!draft.canAddTag) {
      _toast(l10n.communityComposeTagLimit);
      return;
    }
    if (!PostDraft.isValidTag(raw)) {
      _toast(l10n.communityComposeTagInvalid);
      return;
    }
    if (ref.read(_provider.notifier).addTag(raw)) _tag.clear();
  }

  /// 사진을 고르고 4단계 업로드 중 1~3단계를 돌린다(가이드 §4).
  ///
  /// **고르는 수단은 주입된다**([photoPickerProvider]) — 사진 선택 패키지가 아직
  /// 없어 기본 구현이 null을 돌려주며, 그때는 그 사실을 안내한다. 사진 없이 쓰는
  /// 경로는 그대로 열려 있다.
  Future<void> _addPhotos() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PostDraft draft = ref.read(_provider);
    final int remaining = maxPostPhotos - draft.photoKeys.length;
    if (remaining <= 0) {
      _toast(l10n.communityComposeErrorTooManyPhotos);
      return;
    }

    final List<PickedPhoto>? picked = await ref.read(photoPickerProvider)(
      limit: remaining,
    );
    if (!mounted) return;
    if (picked == null) {
      _toast(l10n.communityComposePhotoUnavailable);
      return;
    }
    if (picked.isEmpty) return;

    try {
      final PhotoUploadResult result = await ref
          .read(_provider.notifier)
          .uploadPhotos(picked);
      if (!mounted) return;
      // **부분 성공이 정상이다** — 실패한 장만 알리고 통과한 키는 이미 초안에 있다.
      if (result.hasFailures) {
        _toast(l10n.communityComposePhotoFailed(result.failedNames.length));
      }
    } on Object {
      if (mounted) _toast(l10n.communityComposeErrorPhotoNotUploaded);
    }
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

  Future<void> _submitCreate() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ComposerResult result = await ref.read(_provider.notifier).submit();
    if (!mounted) return;

    switch (result) {
      case ComposerSucceeded():
        // `createPost`는 postId만 준다(가이드 §5). 피드로 돌아가면 목록을 새로
        // 고치는 것으로 충분하므로 상세 재조회 없이 닫는다.
        Navigator.of(context).pop(true);
        _toast(l10n.communityComposeDone);
      case ComposerUnauthenticated():
        _toast(l10n.communitySignInRequired);
        context.pushNamed(loginRouteName);
      case ComposerRejected(:final String? code):
        _toast(_messageFor(l10n, code));
      case ComposerFailed():
        _toast(l10n.communityActionFailed);
    }
  }

  Future<void> _submitEdit() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PostDraft draft = ref.read(_provider);
    final ModerationOutcome outcome = await ref
        .read(moderationControllerProvider.notifier)
        .editPost(
          postId: widget.editPostId!,
          title: draft.title.trim(),
          body: draft.body.trim(),
          // 사진을 건드리지 않았으면 **변수를 아예 보내지 않는다** — 빈 배열을
          // 보내면 붙어 있던 사진이 전부 떨어진다(가이드 §5).
          photoKeys: draft.photoKeys.isEmpty ? null : draft.photoKeys,
        );
    if (!mounted) return;

    switch (outcome) {
      case ModerationOutcome.success:
        Navigator.of(context).pop(true);
        _toast(l10n.communityEditDone);
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.titleSmall);
}

/// 글자 수 카운터. 초과했으면 남은 수 대신 **넘긴 수**를 보여준다 — 음수 카운터보다
/// "몇 자를 줄여야 하는지"가 바로 읽힌다.
class _Counter extends StatelessWidget {
  const _Counter({required this.text, required this.isError});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isError
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// 카테고리 선택. **서버가 내려준 칩 구성을 그대로 쓴다** — 언어마다 가용 카테고리가
/// 달라 클라이언트가 전체 목록을 하드코딩하면 안 된다(가이드 §2).
///
/// 칩 조회가 실패하거나 비면 [TargetCategory]의 전체 집합으로 떨어진다 — 카테고리가
/// 필수라 고를 수단이 없으면 글을 아예 쓸 수 없기 때문이다.
class _CategoryPicker extends ConsumerWidget {
  const _CategoryPicker({required this.selected, required this.onSelected});

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

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final TargetCategory category in options)
          ChoiceChip(
            label: Text(targetCategoryLabel(l10n, category)),
            selected: selected == category,
            // 필수 항목이라 해제되지 않는다 — 다시 눌러도 선택이 유지된다.
            onSelected: (_) => onSelected(category),
          ),
      ],
    );
  }
}

/// 태그 입력. 공백이 든 태그는 서버가 거부하므로 **여기서 미리 막는다**(가이드 §5).
class _TagField extends StatelessWidget {
  const _TagField({
    required this.controller,
    required this.tags,
    required this.canAdd,
    required this.onAdd,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<String> tags;
  final bool canAdd;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: controller,
          enabled: canAdd,
          decoration: InputDecoration(
            hintText: l10n.communityComposeTagHint,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: canAdd ? onAdd : null,
              icon: const Icon(Icons.add),
            ),
          ),
          onSubmitted: (_) => onAdd(),
        ),
        if (tags.isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final String tag in tags)
                // 태그는 사용자가 입력한 원문 그대로 보여준다 — 번역 대상이
                // 아니다(가이드 §9).
                InputChip(label: Text('#$tag'), onDeleted: () => onRemove(tag)),
            ],
          ),
        ],
      ],
    );
  }
}

/// 선택된 장소. **비어 있어도 등록할 수 있다** — 장소는 선택 항목이다(가이드 §5).
class _SpotField extends StatelessWidget {
  const _SpotField({required this.title, required this.onClear});

  final String? title;

  /// 장소를 뺄 수 있으면 콜백, 고정이거나 아예 없으면 null.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final bool chosen = title != null;
    return InputDecorator(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: onClear == null
            ? null
            : IconButton(
                onPressed: onClear,
                tooltip: l10n.communityComposeSpotClear,
                icon: const Icon(Icons.close),
              ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.place_outlined,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title ?? l10n.communityComposeSpotOptional,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: chosen
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 첨부한 사진 줄. 최대 5장이며 상한에 닿으면 추가 버튼이 사라진다.
class _PhotoRow extends StatelessWidget {
  const _PhotoRow({
    required this.photoKeys,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> photoKeys;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 84,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for (final String key in photoKeys)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 84,
                      height: 84,
                      child: PostPhoto(photoKey: key),
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: IconButton(
                      onPressed: () => onRemove(key),
                      iconSize: 18,
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ],
              ),
            ),
          if (photoKeys.length < maxPostPhotos)
            OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(l10n.communityComposePhotoAdd),
            ),
        ],
      ),
    );
  }
}
