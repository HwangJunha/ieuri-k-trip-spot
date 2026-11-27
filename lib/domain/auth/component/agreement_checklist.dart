import 'package:flutter/material.dart';

import '../../../common/model/terms_code.dart';
import '../../../common/widget/document_web_view.dart';
import '../../../l10n/gen/app_localizations.dart';

/// The consent items shown in the sign-up form. `null` [termsCode] is the
/// age-verification item (maps to `ageVerified`, not an agreement).
enum AgreementItem {
  age(null, required: true),
  service(TermsCode.service, required: true),
  privacy(TermsCode.privacy, required: true),
  location(TermsCode.location, required: true),
  marketing(TermsCode.marketing, required: false);

  const AgreementItem(this.termsCode, {required this.required});

  final TermsCode? termsCode;
  final bool required;

  static List<AgreementItem> get all => AgreementItem.values;
  static List<AgreementItem> get requiredItems =>
      AgreementItem.values.where((AgreementItem i) => i.required).toList();
}

/// The current checked state of the consent checklist (spec §5.2). Immutable;
/// the sign-up screen holds one and swaps it on each toggle.
class AgreementSelection {
  const AgreementSelection([this._checked = const <AgreementItem>{}]);

  final Set<AgreementItem> _checked;

  bool isChecked(AgreementItem item) => _checked.contains(item);

  bool get allChecked => _checked.length == AgreementItem.all.length;

  /// Whether every REQUIRED item is checked — the gate for enabling submit.
  bool get requiredSatisfied =>
      AgreementItem.requiredItems.every(_checked.contains);

  bool get ageVerified => _checked.contains(AgreementItem.age);

  AgreementSelection toggle(AgreementItem item, bool value) {
    final Set<AgreementItem> next = <AgreementItem>{..._checked};
    if (value) {
      next.add(item);
    } else {
      next.remove(item);
    }
    return AgreementSelection(next);
  }

  /// Master toggle: all on, or all off (spec §5.2).
  AgreementSelection toggleAll(bool value) => AgreementSelection(
    value ? <AgreementItem>{...AgreementItem.all} : const <AgreementItem>{},
  );
}

/// Inline consent checklist (spec §5.2): a master "agree to all"
/// row that toggles every child and auto-checks when all children are on, plus
/// individual rows with a required/optional badge and a link to the full text.
///
/// **전문은 웹뷰로 띄운다**(2026-08-24). 예전에는 행을 펼쳐 "준비 중" 자리표시
/// 문구를 보여 줬는데, 약관 본문 없이 동의를 받는 화면이라 심사에서 반려된다.
/// 펼침 상태를 들고 있을 이유가 사라져 `StatelessWidget`이 됐다.
class AgreementChecklist extends StatelessWidget {
  const AgreementChecklist({
    super.key,
    required this.selection,
    required this.onChanged,
  });

  final AgreementSelection selection;
  final ValueChanged<AgreementSelection> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CheckboxListTile(
          value: selection.allChecked,
          onChanged: (bool? v) => onChanged(selection.toggleAll(v ?? false)),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            l10n.agreementSelectAll,
            style: theme.textTheme.titleMedium,
          ),
        ),
        const Divider(height: 1),
        for (final AgreementItem item in AgreementItem.all)
          _AgreementRow(
            item: item,
            checked: selection.isChecked(item),
            label: _label(l10n, item),
            badge: item.required
                ? l10n.agreementRequiredBadge
                : l10n.agreementOptionalBadge,
            viewLabel: l10n.agreementViewDetail,
            onChanged: (bool v) => onChanged(selection.toggle(item, v)),
          ),
      ],
    );
  }

  String _label(AppLocalizations l10n, AgreementItem item) => switch (item) {
    AgreementItem.age => l10n.agreementAge,
    AgreementItem.service => l10n.agreementService,
    AgreementItem.privacy => l10n.agreementPrivacy,
    AgreementItem.location => l10n.agreementLocation,
    AgreementItem.marketing => l10n.agreementMarketing,
  };
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.item,
    required this.checked,
    required this.label,
    required this.badge,
    required this.viewLabel,
    required this.onChanged,
  });

  final AgreementItem item;
  final bool checked;
  final String label;
  final String badge;
  final String viewLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color badgeColor = item.required
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    // 전문이 게시된 항목만 "보기"를 준다. 만 14세 확인과 마케팅 수신은 별도
    // 문서가 없다(마케팅 조항은 서비스 약관 안에 있다).
    final Uri? url = item.termsCode?.documentUrl;

    return Row(
      children: <Widget>[
        Checkbox(value: checked, onChanged: (bool? v) => onChanged(v ?? false)),
        Text(
          '[$badge]',
          style: theme.textTheme.labelSmall?.copyWith(color: badgeColor),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        // **웹뷰로 전문을 띄운다.** 예전에는 "전문은 준비 중"이라는 자리표시
        // 문구를 펼쳐 보여 줬는데, 개인정보를 수집하는 앱이 약관 본문 없이
        // 동의를 받는 셈이라 심사에서 그대로 반려된다.
        if (url != null)
          TextButton(
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => DocumentWebView(title: label, url: url),
              ),
            ),
            child: Text(viewLabel),
          ),
      ],
    );
  }
}
