import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../model/spot_intro.dart';

/// 운영 정보 행들(SPEC-0003). 값이 있는 항목만 라벨+값으로 쌓는다.
///
/// 어떤 항목이 표시 대상인지는 [SpotIntro.presentEntries]가 정하고, 이 위젯은 받은
/// [entries]를 그리기만 한다 — 빈 값 판단을 위젯에 흩지 않는다(AC-25).
/// 리스트가 비면 호출부가 섹션 자체를 렌더하지 않는다.
class SpotIntroRows extends StatelessWidget {
  const SpotIntroRows({super.key, required this.entries});

  final List<SpotIntroEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 값 비교가 아니라 인덱스로 첫 행을 가른다 — 값이 같은 항목이 생겨도 간격이
        // 사라지지 않는다(SpotInfoItemList와 같은 이유).
        for (int i = 0; i < entries.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: 8),
          _IntroRow(entry: entries[i]),
        ],
      ],
    );
  }
}

class _IntroRow extends StatelessWidget {
  const _IntroRow({required this.entry});

  final SpotIntroEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final (IconData icon, String label) = _labelFor(entry.field, l10n);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        // 라벨 폭을 고정해 값들이 세로로 가지런히 맞는다.
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Text(entry.value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }

  /// 항목 종류 → 아이콘과 다국어 라벨. 문구는 l10n에 있고 모델은 종류만 안다.
  (IconData, String) _labelFor(SpotIntroField field, AppLocalizations l10n) =>
      switch (field) {
        SpotIntroField.businessHours => (
          Icons.schedule_outlined,
          l10n.spotDetailIntroBusinessHours,
        ),
        SpotIntroField.closedDays => (
          Icons.event_busy_outlined,
          l10n.spotDetailIntroClosedDays,
        ),
        SpotIntroField.fee => (
          Icons.confirmation_number_outlined,
          l10n.spotDetailIntroFee,
        ),
        SpotIntroField.parking => (
          Icons.local_parking_outlined,
          l10n.spotDetailIntroParking,
        ),
        SpotIntroField.petAllowed => (
          Icons.pets_outlined,
          l10n.spotDetailIntroPetAllowed,
        ),
        SpotIntroField.creditCardAccepted => (
          Icons.credit_card_outlined,
          l10n.spotDetailIntroCreditCard,
        ),
        SpotIntroField.inquiryPhone => (
          Icons.support_agent_outlined,
          l10n.spotDetailIntroInquiryPhone,
        ),
      };
}
