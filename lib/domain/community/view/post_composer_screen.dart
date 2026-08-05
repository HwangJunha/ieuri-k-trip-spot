import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/auth_route.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/post_topic_label.dart';
import '../model/post_draft.dart';
import '../model/post_target.dart';
import '../model/post_topic.dart';
import '../provider/composer_targets_providers.dart';
import '../provider/post_composer_providers.dart';

/// 글 작성 화면(R1~R4, 디자인 §3) — **당근 동네생활 컴포저 순서**를 따른다.
///
/// ```
/// AppBar   "새 글" · 닫기(X) · 우측 [등록] (조건 미충족 시 비활성)
/// 본문
///   ├── 게시판(주제) 선택   ← 당근처럼 **먼저** 고른다
///   ├── 장소 선택
///   ├── 본문 TextField      멀티라인, 힌트
///   ├── 잔여 글자 수         500 - runes (코드포인트, 가이드 §12)
///   └── 사진 첨부 행         이번 범위 밖 — 아래 참조
/// ```
///
/// **등록 버튼은 본문·장소·주제가 모두 갖춰지기 전까지 비활성이다**(R1-1). 서버
/// 검증을 기다렸다가 에러를 보여주는 방식이 아니라 화면이 애초에 잘못된 상태를
/// 만들지 못하게 한다(설계 §3).
///
/// **500자를 넘으면 입력이 막히는 것이 아니라 등록이 막히고 초과분이 드러난다** —
/// 입력을 자르면 붙여넣기한 유저가 무엇이 사라졌는지 모른다(설계 §3).
///
/// **사진 첨부는 이번 범위에 없다.** 업로드가 3단계(서명 발급 → R2 직접 PUT →
/// 확인)라 손이 크고, 텍스트 컴포저가 먼저 도는 편이 낫다는 판단이다(가이드 §17의
/// 권장 순서도 "사진 없이 먼저"다). 지금은 `photoKeys: []`로 등록한다.
class PostComposerScreen extends ConsumerStatefulWidget {
  const PostComposerScreen({
    super.key,
    this.initialTargetId,
    this.initialTargetTitle,
  });

  static String get routeName => 'post-composer';

  /// 관광지 상세에서 진입하면 대상이 이미 정해져 있다. 커뮤니티 탭에서 열면
  /// null이라 화면이 장소 선택을 요구한다(디자인 §3).
  final String? initialTargetId;
  final String? initialTargetTitle;

  @override
  ConsumerState<PostComposerScreen> createState() => _PostComposerScreenState();
}

class _PostComposerScreenState extends ConsumerState<PostComposerScreen> {
  final TextEditingController _body = TextEditingController();

  /// 등록 진행 중인지. 중복 제출을 막고 버튼을 스피너로 바꾼다.
  bool _submitting = false;

  PostComposerProvider get _provider => postComposerProvider(
    initialTargetId: widget.initialTargetId,
    initialTargetTitle: widget.initialTargetTitle,
  );

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final PostDraft draft = ref.watch(_provider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.communityCancel,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l10n.communityComposeTitle),
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
                    // 조건이 모두 갖춰지기 전까지 비활성(R1-1).
                    onPressed: draft.canSubmit ? _submit : null,
                    child: Text(l10n.communityComposeSubmit),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: <Widget>[
            // 당근은 게시판을 **먼저** 고르게 한다 — 무엇을 쓸지가 정해져야 본문이
            // 나온다.
            _SectionLabel(text: l10n.communityComposeTopicLabel),
            const SizedBox(height: 8),
            _TopicPicker(
              selected: draft.topic,
              onSelected: (PostTopic topic) =>
                  ref.read(_provider.notifier).setTopic(topic),
            ),
            const SizedBox(height: 20),
            _SectionLabel(text: l10n.communityComposeSpotLabel),
            const SizedBox(height: 8),
            _TargetField(
              title: draft.targetTitle,
              // 상세에서 진입해 대상이 고정된 경우에는 바꿀 수 없다 — 그 화면의
              // 글이라는 것이 진입의 전제다.
              onTap: widget.initialTargetId != null ? null : _pickTarget,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _body,
              maxLines: 8,
              minLines: 5,
              // **maxLength를 두지 않는다** — 두면 입력이 잘려 초과분이 사라진다.
              decoration: InputDecoration(
                hintText: l10n.communityComposeBodyHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (String value) =>
                  ref.read(_provider.notifier).setBody(value),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                // 초과했으면 남은 수 대신 **넘긴 수**를 보여준다 — 음수 카운터보다
                // "몇 자를 줄여야 하는지"가 바로 읽힌다.
                draft.isBodyTooLong
                    ? l10n.communityComposeTooLong(-draft.remainingRunes)
                    : l10n.communityComposeCounter(draft.bodyRunes),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: draft.isBodyTooLong
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 장소 선택 시트. 목록은 "주변에 글이 있는 장소"다 — 왜 그런지는
  /// [composerTargetsProvider]의 주석에 있다.
  Future<void> _pickTarget() async {
    final PostTarget? picked = await showModalBottomSheet<PostTarget>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _TargetPickerSheet(),
    );
    if (picked == null || !mounted) return;
    ref.read(_provider.notifier).setTarget(id: picked.id, title: picked.title);
  }

  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    setState(() => _submitting = true);
    final ComposerResult result = await ref.read(_provider.notifier).submit();
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case ComposerSucceeded():
        // `createPost`는 postId만 준다(가이드 §11). 피드로 돌아가면 목록을 새로
        // 고치는 것으로 충분하므로 상세 재조회 없이 닫는다 — 닫힌 뒤 피드 화면이
        // provider를 invalidate한다.
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.communityComposeDone)));
      case ComposerUnauthenticated():
        // 버튼을 감추지 않고 눌렀을 때 로그인으로 보낸다(가이드 §13).
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.communitySignInRequired)));
        context.pushNamed(loginRouteName);
      case ComposerRejected(:final String? code):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_messageFor(l10n, code))));
      case ComposerFailed():
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.communityActionFailed)));
    }
  }

  /// 서버 `userErrors.code` → 화면 문구(가이드 §7). 모르는 코드는 일반 실패로
  /// 떨어뜨린다 — 서버 message를 그대로 띄우지 않는다(PII가 실릴 수 있다, POL-013).
  String _messageFor(AppLocalizations l10n, String? code) => switch (code) {
    'POST_BODY_REQUIRED' => l10n.communityComposeErrorBodyRequired,
    'POST_BODY_LENGTH_INVALID' => l10n.communityComposeErrorBodyLength,
    'SPOT_NOT_FOUND' => l10n.communityComposeErrorSpotNotFound,
    'TOO_MANY_PHOTOS' => l10n.communityComposeErrorTooManyPhotos,
    _ => l10n.communityActionFailed,
  };
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.titleSmall);
}

/// 게시판(주제) 선택. 단일 선택이며 미선택으로 시작한다(디자인 §3).
class _TopicPicker extends StatelessWidget {
  const _TopicPicker({required this.selected, required this.onSelected});

  final PostTopic? selected;
  final ValueChanged<PostTopic> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final PostTopic topic in PostTopic.values)
          ChoiceChip(
            label: Text(postTopicLabel(l10n, topic)),
            selected: selected == topic,
            onSelected: (_) => onSelected(topic),
          ),
      ],
    );
  }
}

/// 선택된 장소를 보여주는 필드. [onTap]이 null이면 고정된 것이라 눌러도 반응하지
/// 않는다(관광지 상세에서 진입한 경우).
class _TargetField extends StatelessWidget {
  const _TargetField({required this.title, required this.onTap});

  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final bool chosen = title != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: onTap == null ? null : const Icon(Icons.expand_more),
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
                title ?? l10n.communityComposeSpotMissing,
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
      ),
    );
  }
}

/// 장소 선택 시트. 조회가 실패하거나 비면 **그 사실을 드러낸다** — 빈 목록을 조용히
/// 두면 사용자가 시트가 고장난 줄 안다.
class _TargetPickerSheet extends ConsumerWidget {
  const _TargetPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<PostTarget>> targets = ref.watch(
      composerTargetsProvider,
    );

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        child: targets.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
            child: Center(
              child: Text(
                l10n.communityFeedUnavailable,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          data: (List<PostTarget> items) => items.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 48,
                    horizontal: 32,
                  ),
                  child: Center(
                    child: Text(
                      l10n.communityFeedEmpty,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(items[index].title),
                    onTap: () => Navigator.pop(context, items[index]),
                  ),
                ),
        ),
      ),
    );
  }
}
