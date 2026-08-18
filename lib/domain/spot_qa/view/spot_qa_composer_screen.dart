import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/navigation/spot_qa_routes.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/spot_qa_eligibility_banner.dart';
import '../model/spot_qa_failure.dart';
import '../provider/my_questions_providers.dart';
import '../provider/spot_qa_composer_providers.dart';

/// 질문 작성 화면(R3, 디자인 §3, Stitch `af479788e45e42658cd54ead6f7027ac`).
///
/// ```
/// 상단바  ✕ · "질문 작성" · [올리기](본문 비면 비활성)
/// (자격 거부 시) 인라인 배너
/// 테두리 없는 멀티라인 입력 — 남은 공간 전부
/// 하단 우측  글자수 카운터(90% 근접부터)
/// ```
///
/// **서버가 `NOT_ELIGIBLE_TO_ASK`로 거부해도 화면을 닫지 않는다**(설계 §작성 자격
/// 표시). 배너를 띄우고 입력한 본문은 그대로 남긴다 — 진입 시점엔 자격 있는 사용자만
/// 왔겠지만 다른 기기에서 좋아요가 풀린 경우를 반드시 처리한다.
///
/// **사진 첨부 UI가 없다.** 서버에 업로드 뮤테이션이 없어 이번 범위에서 빠졌다(설계
/// §사진 첨부) — 카메라·갤러리 아이콘도, 사진 그리드도 그리지 않는다.
///
/// 성공하면 `true`를 돌려주고 닫힌다 — 호출한 목록이 그 값으로 재조회한다.
///
/// **성공한 질문은 로컬에 기록한다**(`MyQuestionsController.remember`). 서버에
/// `myQuestions`가 없어 여기서 적어 두지 않으면 사용자가 자기 질문에 달린 답변을
/// 영영 볼 수 없다 — 「내 질문」 화면의 유일한 출처다.
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
          onPressed: () => Navigator.of(context).maybePop(),
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
            // 배너가 떠도 **아래 입력의 텍스트는 그대로 유지된다**(디자인 §3).
            if (state.notEligible)
              const SpotQaEligibilityBanner(
                target: SpotQaComposerTarget.question,
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
                    hintText: l10n.spotQaBodyHint,
                    border: InputBorder.none,
                  ),
                  style: theme.textTheme.bodyLarge,
                  onChanged: (String value) =>
                      ref.read(_provider.notifier).updateBody(value),
                ),
              ),
            ),
            _Counter(body: state.body),
          ],
        ),
      ),
    );
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
      // 자격 없음은 배너가 이미 말한다 — 스낵바를 겹치면 같은 말을 두 번 한다.
      if (!result.notEligible) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.spotQaSubmitFailed)),
        );
      }
      return;
    }

    // **성공한 질문만 로컬에 적는다.** 서버에 `myQuestions`가 없어 이 기록이
    // 「내 질문」의 유일한 출처다(설계 후속 결정). id가 없으면(계약상 성공이면 항상
    // 오지만) 적을 것이 없으므로 건너뛴다.
    //
    // 기록 실패가 작성 성공을 되돌리게 두지 않는다 — 질문은 이미 서버에 올라갔다.
    final String? questionId = result.value;
    if (questionId != null) {
      try {
        await ref
            .read(myQuestionsControllerProvider.notifier)
            .remember(
              catalogId: widget.catalogId,
              questionId: questionId,
              spotTitle: widget.spotTitle,
              askedAt: DateTime.now(),
            );
      } on Object {
        // 기록에 실패해도 화면은 성공으로 닫는다. 다음 화면에서 안 보일 뿐이다.
      }
    }

    // 성공만 목록 재조회를 부른다.
    navigator.pop(true);
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
