import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/terms_code.dart';

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

/// DANAWA-style inline consent checklist (spec §5.2): a master "agree to all"
/// row that toggles every child and auto-checks when all children are on, plus
/// individual rows with a required/optional badge and an expandable detail.
class AgreementChecklist extends StatefulWidget {
  const AgreementChecklist({
    super.key,
    required this.selection,
    required this.onChanged,
  });

  final AgreementSelection selection;
  final ValueChanged<AgreementSelection> onChanged;

  @override
  State<AgreementChecklist> createState() => _AgreementChecklistState();
}

class _AgreementChecklistState extends State<AgreementChecklist> {
  final Set<AgreementItem> _expanded = <AgreementItem>{};

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CheckboxListTile(
          value: widget.selection.allChecked,
          onChanged: (bool? v) =>
              widget.onChanged(widget.selection.toggleAll(v ?? false)),
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
            checked: widget.selection.isChecked(item),
            expanded: _expanded.contains(item),
            label: _label(l10n, item),
            badge: item.required
                ? l10n.agreementRequiredBadge
                : l10n.agreementOptionalBadge,
            detail: l10n.agreementDetailPlaceholder,
            viewLabel: l10n.agreementViewDetail,
            onChanged: (bool v) =>
                widget.onChanged(widget.selection.toggle(item, v)),
            onToggleExpand: () => setState(() {
              _expanded.contains(item)
                  ? _expanded.remove(item)
                  : _expanded.add(item);
            }),
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
    required this.expanded,
    required this.label,
    required this.badge,
    required this.detail,
    required this.viewLabel,
    required this.onChanged,
    required this.onToggleExpand,
  });

  final AgreementItem item;
  final bool checked;
  final bool expanded;
  final String label;
  final String badge;
  final String detail;
  final String viewLabel;
  final ValueChanged<bool> onChanged;
  final VoidCallback onToggleExpand;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color badgeColor = item.required
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: checked,
              onChanged: (bool? v) => onChanged(v ?? false),
            ),
            Text(
              '[$badge]',
              style: theme.textTheme.labelSmall?.copyWith(color: badgeColor),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            TextButton(onPressed: onToggleExpand, child: Text(viewLabel)),
          ],
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text(
              detail,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
