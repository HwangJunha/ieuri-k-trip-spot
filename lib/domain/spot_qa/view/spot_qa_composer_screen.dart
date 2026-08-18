import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/media/photo_picker_providers.dart';
import '../../../common/model/composer_photo.dart';
import '../../../common/navigation/spot_qa_routes.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_qa_failure.dart';
import '../component/spot_qa_photo_strip.dart';
import '../provider/my_questions_providers.dart';
import '../provider/spot_qa_composer_providers.dart';
import '../provider/spot_questions_providers.dart';

/// 질문 작성 화면(R3, 디자인 §3, Stitch `af479788e45e42658cd54ead6f7027ac`).
///
/// ```
/// 상단바  ✕ · "질문 작성" · [올리기](본문 비면 비활성)
/// 장소 헤더  📍 어디에 묻는지 (장소명 없으면 생략)
/// 테두리 없는 멀티라인 입력 — 남은 공간 전부
/// 예시 칩  본문·사진이 모두 비었을 때만
/// 사진 줄  [사진][사진][＋] 최대 5장
/// 하단 우측  글자수 카운터(90% 근접부터)
/// ```
///
/// **거절돼도 화면을 닫지 않는다.** 안내만 띄우고 입력한 본문은 그대로 남긴다 —
/// 사용자가 쓴 글을 서버 사정으로 날리지 않는다.
///
/// 좋아요 자격 게이팅은 **없다**(2026-08-18 서버가 걷어냈다). 반응 없음·싫어요를
/// 포함해 누구나 쓸 수 있다.
///
/// **사진은 제출 시점에 올라간다.** 고르는 즉시 올리면 질문을 쓰지 않고 나간 사용자의
/// 사진이 고아로 남는다 — 붙였다 뺐다를 반복하면 그만큼 쌓인다. 업로드 뮤테이션은
/// 커뮤니티 것을 그대로 쓴다(설계 §사진 첨부).
///
/// **사진 일부가 실패해도 질문은 올라간다.** 실패한 장수만 알린다 — 사진 한 장 때문에
/// 사용자가 쓴 글을 통째로 버리게 하지 않는다.
///
/// 성공하면 `true`를 돌려주고 닫힌다 — 호출한 목록이 그 값으로 재조회한다.
class SpotQaComposerScreen extends ConsumerStatefulWidget {
  const SpotQaComposerScreen({
    super.key,
    required this.catalogId,
    this.spotTitle = '',
  });

  static String get routeName => spotQaComposerRouteName;

  /// 질문을 다는 장소(`/spot/:spotId/qa/compose`의 경로 파라미터).
  final String catalogId;

  /// 「내 질문」 목록에 적어 둘 장소명. **표시용이라 없어도 된다** — 딥링크로 들어와
  /// 비어 있으면 목록이 서버 조회로 장소명을 채운다. 이 값 때문에 작성이 실패하는
  /// 일은 없어야 한다.
  final String spotTitle;

  @override
  ConsumerState<SpotQaComposerScreen> createState() =>
      _SpotQaComposerScreenState();
}

class _SpotQaComposerScreenState extends ConsumerState<SpotQaComposerScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SpotQaComposerProvider get _provider =>
      spotQaComposerProvider(SpotQaComposerTarget.question, widget.catalogId);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SpotQaComposerState state = ref.watch(_provider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _close,
        ),
        title: Text(l10n.spotQaAskTitle),
        actions: <Widget>[
          if (state.isSubmitting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: state.canSubmit ? _submit : null,
              child: Text(l10n.spotQaSubmitAction),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 어느 장소에 묻는지. **비어 있으면 줄째로 생략한다** — 딥링크로 들어오면
            // 장소명이 없고, 빈 라벨을 그리면 값이 없다는 사실만 드러난다.
            if (widget.spotTitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.place_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.spotQaComposeContext(widget.spotTitle),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  // **테두리 없는 전면 입력**이다 — 글쓰기 화면에서 가장 큰 면적을
                  // 차지해야 하는 것은 본문이고, 테두리는 그 면적을 잘라 먹는다.
                  decoration: InputDecoration(
                    // 동어반복("질문을 입력하세요") 대신 실제 예시를 보여준다.
                    hintText: l10n.spotQaBodyHintExample,
                    border: InputBorder.none,
                  ),
                  style: theme.textTheme.bodyLarge,
                  onChanged: (String value) =>
                      ref.read(_provider.notifier).updateBody(value),
                ),
              ),
            ),
            // 예시 칩은 **본문이 비었을 때만** 나온다 — 쓰기 시작하면 방해다.
            // 사진을 붙였다면 그것이 이미 단서라 칩을 접는다.
            if (state.body.isEmpty && state.photos.isEmpty)
              _Suggestions(onPick: _fill),
            const SizedBox(height: 8),
            SpotQaPhotoStrip(
              photos: state.photos,
              onAdd: _pickPhotos,
              onRemove: (String id) =>
                  ref.read(_provider.notifier).removePhoto(id),
            ),
            _Counter(body: state.body),
          ],
        ),
      ),
    );
  }

  /// 예시 칩을 고르면 입력창을 채우고 **커서를 끝에 둔다.**
  ///
  /// 곧바로 제출하지 않는 것이 핵심이다 — 예시는 출발점이지 완성된 질문이 아니고,
  /// 사용자가 자기 상황에 맞게 고칠 여지를 남겨야 한다. 빈 화면에서 문장을 짓는 것보다
  /// 있는 문장을 고치는 편이 쉽다.
  void _fill(String text) {
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    ref.read(_provider.notifier).updateBody(text);
  }

  /// 작성을 접는다.
  ///
  /// **이미 확정한 사진 키를 지우고 나간다**(설계 §사진 첨부). 제출이 서버에 거부돼
  /// 사진만 올라간 상태로 나가는 경우가 있는데, 정리하지 않으면 어떤 질문에도 붙지
  /// 않은 오브젝트가 서버에 남는다.
  ///
  /// **정리를 기다리지 않고 닫는다.** 화면을 떠나는 길을 네트워크에 묶을 이유가 없다 —
  /// 실패하면 남은 오브젝트는 서버 lifecycle의 몫이다.
  void _close() {
    unawaited(ref.read(_provider.notifier).discardUploaded());
    Navigator.of(context).maybePop();
  }

  /// 갤러리를 열어 사진을 붙인다.
  ///
  /// **크기 상한을 여기서 거른다.** 사전 서명 URL 발급은 하나만 어긋나도 전부
  /// 거부하므로(부분 발급 없음), 큰 장 하나가 나머지를 같이 죽이지 않도록 고른
  /// 직후에 뺀다. 걸러진 장은 안내로 알린다 — 조용히 사라지면 왜 안 붙었는지 모른다.
  Future<void> _pickPhotos() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final int room = ref.read(_provider).remainingPhotoSlots;
    if (room <= 0) return;

    final List<LocalPhoto>? picked = await ref.read(photoPickerProvider)(
      limit: room,
    );
    if (picked == null || !mounted) return;

    final List<LocalPhoto> withinLimit = picked
        .where((LocalPhoto p) => p.contentLength <= maxComposerPhotoBytes)
        .toList(growable: false);
    final int tooLarge = picked.length - withinLimit.length;

    ref.read(_provider.notifier).addPhotos(withinLimit);
    if (tooLarge > 0) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.communityComposePhotoTooLarge(tooLarge))),
      );
    }
  }

  Future<void> _submit() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final NavigatorState navigator = Navigator.of(context);

    SpotQaMutationResult<String> result;
    try {
      result = await ref.read(_provider.notifier).submit();
    } on Object {
      // 전송·인증 실패도 **입력을 지우지 않는다** — 다시 시도하면 되는 상황이다.
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.spotQaSubmitFailed)));
      return;
    }
    if (!mounted) return;

    if (!result.succeeded) {
      // **입력은 그대로 남는다**(provider가 본문을 지우지 않는다) — 안내만 띄우고
      // 화면을 유지해 사용자가 고쳐서 다시 낼 수 있게 한다.
      messenger.showSnackBar(SnackBar(content: Text(l10n.spotQaSubmitFailed)));
      return;
    }

    // **사진 일부가 실패해도 질문은 올라갔다.** 실패한 장수만 알린다 — 사진 한 장
    // 때문에 사용자가 쓴 글을 통째로 버리게 하지 않는다(설계 §사진 첨부).
    final SpotQaPhotoUploadResult? upload = ref
        .read(_provider.notifier)
        .lastPhotoUpload;
    if (upload != null && upload.hasFailures) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.spotQaPhotoUploadFailed(upload.failedNames.length)),
        ),
      );
    }

    // **로컬에 적어 둘 것이 없다.** 서버가 `spotQuestions(mine:)`으로 내 질문을
    // 돌려주므로(2026-08-18) 「내 질문」 목록은 서버가 소스다 — 예전에는 여기서
    // catalogId·questionId를 로컬에 쌓아야 했다.
    //
    // 방금 올린 질문이 그 목록에 보이도록 캐시만 비운다. 실패해도 화면은 성공으로
    // 닫는다 — 질문은 이미 서버에 올라갔고, 목록은 다음에 열 때 받으면 된다.
    ref.invalidate(myQuestionsControllerProvider);

    // **이 장소의 질문 목록도 다시 받는다.** 이것이 없으면 상세로 돌아왔을 때
    // 진입점이 여전히 "질문 없음"으로 보이고, 방금 올린 질문이 목록에도 없다 —
    // 첫 질문을 올린 사용자에게는 글이 사라진 것처럼 보인다.
    //
    // 호출부가 아니라 여기서 무효화하는 이유: 작성 진입이 상세·목록 두 곳이라
    // 각자 처리하면 한쪽이 빠진다.
    ref.invalidate(spotQuestionsControllerProvider(widget.catalogId));

    // 성공만 목록 재조회를 부른다.
    navigator.pop(true);
  }
}

/// 예시 질문 칩.
///
/// **왜 두는가.** 질문이 하나도 없는 장소가 대부분이라(신규 장소는 항상 0개) 사용자는
/// 여기서 무엇을 물어도 되는지 알 수 없다. 빈 입력창은 "무엇이든 쓰세요"가 아니라
/// "무엇을 써야 할지 모르겠다"로 읽힌다 — 칩은 이 기능의 범위를 보여주는 가장 싼
/// 수단이다.
///
/// 부수 효과가 더 중요하다: **답변 가능한 질문으로 수렴시킨다.** 혼잡·주차·날씨·운영
/// 여부는 그 장소에 가 본 사람이면 바로 답할 수 있다. 답이 안 달리는 질문이 쌓이면
/// 기능 자체가 죽는데(구글 지도가 커뮤니티 Q&A를 접은 이유가 그것이다), 무엇을 묻게
/// 하느냐가 그 갈림길이다.
///
/// **카테고리가 아니다.** 고르면 입력창을 채우고 사라질 뿐, 질문에 꼬리표로 남지
/// 않는다 — 서버 계약에 그런 개념이 없고, 칩을 분류로 승격시키면 없는 필드를 만들게
/// 된다.
class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    // **칩 라벨은 주제어, 채워지는 것은 완성된 질문이다.** 문장을 그대로 칩에 넣었더니
    // 하나가 한 줄씩 차지해 화면 아래 1/3을 먹었다(렌더로 확인). 라벨을 주제어로
    // 줄이면 네 개가 한두 줄에 들어가고, 탭했을 때 입력창에는 여전히 온전한 질문이
    // 들어간다 — 사용자가 고쳐 쓸 출발점이어야 하므로 문장이어야 한다.
    final List<({String label, String fill})> examples =
        <({String label, String fill})>[
          (label: l10n.spotQaSuggestCrowd, fill: l10n.spotQaFillCrowd),
          (label: l10n.spotQaSuggestHours, fill: l10n.spotQaFillHours),
          (label: l10n.spotQaSuggestParking, fill: l10n.spotQaFillParking),
          (label: l10n.spotQaSuggestWeather, fill: l10n.spotQaFillWeather),
        ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            l10n.spotQaSuggestTitle,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          // **가로 스크롤 한 줄이 아니라 Wrap이다.** 4개 언어의 길이가 제각각이라
          // 한 줄에 담기는 개수가 언어마다 다르다 — 넘치면 다음 줄로 접는다.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: examples
                .map(
                  (({String label, String fill}) e) => ActionChip(
                    label: Text(e.label),
                    onPressed: () => onPick(e.fill),
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

/// 글자수 카운터. **90%에 가까워질 때만 나타난다**(디자인 §3) — 평소에 숫자를 띄우면
/// 짧은 질문에도 한계가 있다는 인상을 준다.
///
/// **세는 방식을 [SpotQaComposerState.canSubmit]과 일치시킨다.** 디자인 §3은
/// 코드포인트 기준을 권하지만 제출 가능 판정은 이미 `String.length`로 서 있어,
/// 여기만 `runes`로 세면 이모지가 든 본문에서 "초과"로 붉게 표시되는데 버튼은
/// 활성인 상태가 생긴다. 둘이 어긋나는 것이 세는 단위보다 나쁘다 — 서버 판정과
/// 정확히 맞추려면 provider의 판정을 함께 바꿔야 한다(범위 밖).
class _Counter extends StatelessWidget {
  const _Counter({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int used = body.trim().length;
    if (used < kSpotQaBodyMaxLength * 0.9) return const SizedBox(height: 16);

    final bool over = used > kSpotQaBodyMaxLength;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          '$used/$kSpotQaBodyMaxLength',
          style: theme.textTheme.labelSmall?.copyWith(
            color: over
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
