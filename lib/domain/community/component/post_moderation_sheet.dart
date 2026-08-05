import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/report_reason.dart';

/// 오버플로 시트에서 고른 동작.
enum PostModerationAction { block, report, delete }

/// 카드 우상단 오버플로가 여는 바텀 시트(R15·R16, 디자인 §5).
///
/// ```
/// ├── 이 사용자 차단하기   (blockUser)
/// ├── 신고하기             (reportContent)
/// └── 글 삭제하기          (deletePost) — 내 글일 때만
/// ```
///
/// **미인증이어도 항목을 감추지 않는다**(가이드 §13, 디자인 §7) — 감추면 기능이
/// 없는 것처럼 보이므로 눌렀을 때 로그인으로 유도한다. 감추는 것은 [ownedByViewer]
/// 하나뿐이고, 그것도 "내 글이 아니면 삭제 항목이 아예 의미가 없어서"다.
///
/// [Navigator.pop]으로 [PostModerationAction]을 돌려주며, 배경을 눌러 닫으면 null이다.
Future<PostModerationAction?> showPostModerationSheet(
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
          ListTile(
            leading: const Icon(Icons.block),
            title: Text(l10n.communityBlockAction),
            onTap: () => Navigator.pop(context, PostModerationAction.block),
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(l10n.communityReportAction),
            onTap: () => Navigator.pop(context, PostModerationAction.report),
          ),
          // 내 글이 아니면 서버가 `NOT_POST_OWNER`로 거부한다 — 애초에 보여주지
          // 않는다. 차단·신고와 달리 미인증 유도의 대상이 아니다(내 글이라는 판정
          // 자체가 로그인을 전제한다).
          if (ownedByViewer)
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
          const SizedBox(height: 8),
        ],
      ),
    );
  },
);

/// 차단 확인(R15). **양방향임을 문구에 명시한다** — 되돌리기 전까지 서로 안 보이게
/// 되며, 유저가 그 결과를 알고 눌러야 한다(가이드 §6, 디자인 §5).
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

/// 글 삭제 확인. 글 수정 기능이 없어(가이드 §15) 삭제는 재작성을 뜻하므로 확인을
/// 둔다.
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

/// 신고 사유 시트(R16, 디자인 §5).
///
/// ```
/// ├── 제목 "신고"
/// ├── 사유 라디오 4종 (서버 ReportReason와 1:1)
/// ├── 상세 TextField — "기타" 선택 시에만 노출, 이때 필수
/// └── [제출] (사유 미선택·기타인데 상세 없음 → 비활성)
/// ```
///
/// **`OTHER`인데 상세가 비면 제출을 클라이언트에서 막는다** — 서버는
/// `REPORT_DETAIL_REQUIRED`로 거부하지만, 왕복해서 거절당하는 것보다 애초에 누를 수
/// 없는 편이 낫다(가이드 §9).
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
                      title: Text(_reasonLabel(l10n, reason)),
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

/// 사유의 표시 문자열(POL-023). `PostTopic`과 같이 **서버는 표시명을 주지 않는다** —
/// enum은 안정 식별자이고 매핑은 클라이언트 몫이다.
String _reasonLabel(AppLocalizations l10n, ReportReason reason) =>
    switch (reason) {
      ReportReason.spam => l10n.communityReportReasonSpam,
      ReportReason.abuse => l10n.communityReportReasonAbuse,
      ReportReason.inappropriateContent =>
        l10n.communityReportReasonInappropriate,
      ReportReason.other => l10n.communityReportReasonOther,
    };
