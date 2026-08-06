import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/report_reason.dart';
import 'community_labels.dart';

/// 오버플로 시트에서 고른 동작.
enum PostModerationAction { report, block, hide, edit, delete }

/// 카드 우상단 ⋮ 가 여는 바텀 시트(가이드 §5, 2차 가이드 §2).
///
/// ```
/// ├── 이 글 숨기기          (hidePost)        — 항상
/// ├── 이 글 신고하기        (reportContent)   — 남의 글일 때
/// ├── 이 사용자 차단하기     (blockUser)       — 남의 글일 때
/// ├── 글 수정하기           (editPost)        — 내 글이고 숨김이 아닐 때
/// └── 글 삭제하기           (deletePost)      — 내 글일 때
/// ```
///
/// **숨기기만 항상 보인다.** 소유권을 보지 않기 때문인데, 조치가 아니라 화면
/// 설정이라 내 글도 감출 수 있다(2차 가이드 §2). 신고·차단과 각각 다르다:
/// 차단은 사람 단위 양방향이고, 신고는 되돌릴 수 없는 운영 조치 요청이다.
///
/// **내 글에는 신고·차단을 두지 않는다** — 자기 자신은 차단할 수 없고
/// (`CANNOT_BLOCK_SELF`) 자기 글 신고는 의미가 없다.
///
/// **숨겨진 내 글은 수정을 비활성화하고 이유를 안내한다** — 눌러서
/// `POST_NOT_EDITABLE` 오류를 보는 것보다 낫다(가이드 §5). 여기서 [hidden]은
/// **신고 누적으로 모두에게 감춰진 것**이지 위의 "이 글 숨기기"와 다른 값이다.
///
/// [Navigator.pop]으로 [PostModerationAction]을 돌려주며, 배경을 눌러 닫으면 null이다.
Future<PostModerationAction?> showPostModerationSheet(
  BuildContext context, {
  required bool ownedByViewer,
  required bool hidden,
}) => showModalBottomSheet<PostModerationAction>(
  context: context,
  showDragHandle: true,
  builder: (BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // **노출 조건이 없다** — 소유권을 보지 않으므로 내 글에도 뜬다.
          ListTile(
            leading: const Icon(Icons.visibility_off_outlined),
            title: Text(l10n.communityHidePostAction),
            onTap: () => Navigator.pop(context, PostModerationAction.hide),
          ),
          if (!ownedByViewer) ...<Widget>[
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.communityReportAction),
              onTap: () => Navigator.pop(context, PostModerationAction.report),
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(l10n.communityBlockAction),
              onTap: () => Navigator.pop(context, PostModerationAction.block),
            ),
          ],
          if (ownedByViewer) ...<Widget>[
            ListTile(
              enabled: !hidden,
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.communityEditAction),
              // 왜 못 누르는지 밝힌다 — 비활성 이유가 없으면 고장으로 보인다.
              subtitle: hidden ? Text(l10n.communityEditDisabledHidden) : null,
              onTap: hidden
                  ? null
                  : () => Navigator.pop(context, PostModerationAction.edit),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
              ),
              title: Text(
                l10n.communityDeleteAction,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () => Navigator.pop(context, PostModerationAction.delete),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  },
);

/// 댓글 ⋮ 가 여는 시트. 내 댓글이면 삭제, 남의 댓글이면 신고다.
Future<PostModerationAction?> showCommentModerationSheet(
  BuildContext context, {
  required bool ownedByViewer,
}) => showModalBottomSheet<PostModerationAction>(
  context: context,
  showDragHandle: true,
  builder: (BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (ownedByViewer)
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
              ),
              title: Text(
                l10n.communityCommentDeleteAction,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () => Navigator.pop(context, PostModerationAction.delete),
            )
          else
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.communityCommentReportAction),
              onTap: () => Navigator.pop(context, PostModerationAction.report),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  },
);

/// 차단 확인(가이드 §6). **양방향임을 문구에 명시한다** — 되돌리기 전까지 서로 안
/// 보이게 되며, 유저가 그 결과를 알고 눌러야 한다.
///
/// true를 돌려주면 실행한다. 배경 탭·취소는 false다.
Future<bool> confirmBlock(BuildContext context, String nickname) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final ThemeData theme = Theme.of(context);
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(l10n.communityBlockConfirmTitle(nickname)),
      content: Text(l10n.communityBlockConfirmBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.communityCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          child: Text(l10n.communityBlockConfirmAction),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// 글 삭제 확인. 되돌릴 수 없으므로 확인을 둔다.
Future<bool> confirmDeletePost(BuildContext context) async {
  final AppLocalizations l10n = AppLocalizations.of(context);
  final ThemeData theme = Theme.of(context);
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(l10n.communityDeleteConfirmTitle),
      content: Text(l10n.communityDeleteConfirmBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.communityCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          child: Text(l10n.communityDeleteAction),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// 신고 시트가 돌려주는 값 — 고른 사유와, `OTHER`일 때의 상세.
class ReportSubmission {
  const ReportSubmission({required this.reason, this.detail});

  final ReportReason reason;

  /// [ReportReason.other]일 때만 채워진다(그때는 필수다).
  final String? detail;
}

/// 신고 사유 시트(가이드 §6).
///
/// **`OTHER`인데 상세가 비면 제출을 클라이언트에서 막는다** — 서버는
/// `REPORT_DETAIL_REQUIRED`로 거부하지만, 왕복해서 거절당하는 것보다 애초에 누를 수
/// 없는 편이 낫다.
Future<ReportSubmission?> showReportSheet(BuildContext context) =>
    showModalBottomSheet<ReportSubmission>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => Padding(
        // 상세 입력이 열릴 때 키보드에 가리지 않도록 뷰 인셋을 그대로 더한다.
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: const _ReportSheetBody(),
      ),
    );

class _ReportSheetBody extends StatefulWidget {
  const _ReportSheetBody();

  @override
  State<_ReportSheetBody> createState() => _ReportSheetBodyState();
}

class _ReportSheetBodyState extends State<_ReportSheetBody> {
  ReportReason? _reason;
  final TextEditingController _detail = TextEditingController();

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  /// 제출 가능 조건: 사유가 선택됐고, `OTHER`면 상세가 공백이 아닐 것.
  bool get _canSubmit {
    if (_reason == null) return false;
    if (_reason == ReportReason.other) return _detail.text.trim().isNotEmpty;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final bool needsDetail = _reason == ReportReason.other;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                l10n.communityReportTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
            // 라디오 그룹은 `RadioGroup` 조상이 값을 관리한다 — 개별 타일의
            // groupValue/onChanged는 Flutter 3.32에서 deprecated됐다.
            RadioGroup<ReportReason>(
              groupValue: _reason,
              onChanged: (ReportReason? next) => setState(() => _reason = next),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final ReportReason reason in ReportReason.values)
                    RadioListTile<ReportReason>(
                      value: reason,
                      title: Text(reportReasonLabel(l10n, reason)),
                    ),
                ],
              ),
            ),
            // "기타"를 골랐을 때만 상세가 나타난다. 늘 보여주면 다른 사유에서도
            // 채워야 하는 것처럼 보인다.
            if (needsDetail)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  controller: _detail,
                  autofocus: true,
                  maxLines: 3,
                  minLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.communityReportDetailLabel,
                    helperText: l10n.communityReportDetailRequired,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilledButton(
                onPressed: _canSubmit
                    ? () => Navigator.pop(
                        context,
                        ReportSubmission(
                          reason: _reason!,
                          detail: needsDetail ? _detail.text.trim() : null,
                        ),
                      )
                    : null,
                child: Text(l10n.communityReportSubmit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
