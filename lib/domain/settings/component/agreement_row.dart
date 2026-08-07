import 'package:flutter/material.dart';

import '../../../common/model/terms_code.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../model/agreement_status.dart';

/// `TermsCode`를 화면 문구로 옮긴다(POL-023 — 코드는 **식별자이지 문구가 아니다**).
///
/// 서버가 모르는 코드를 추가하면 도메인 enum 매핑에서 이미 걸리므로 여기에는
/// 폴백이 필요 없다.
String termsLabel(AppLocalizations l10n, TermsCode code) => switch (code) {
  TermsCode.service => l10n.termsService,
  TermsCode.privacy => l10n.termsPrivacy,
  TermsCode.location => l10n.termsLocation,
  TermsCode.marketing => l10n.termsMarketing,
};

/// 선택 항목에 붙는 한 줄 설명. 필수 항목은 동의 일자를 대신 보여주므로 쓰지 않는다.
String termsDescription(AppLocalizations l10n, TermsCode code) =>
    switch (code) {
      TermsCode.service => l10n.termsServiceDescription,
      TermsCode.privacy => l10n.termsPrivacyDescription,
      TermsCode.location => l10n.termsLocationDescription,
      TermsCode.marketing => l10n.termsMarketingDescription,
    };

/// 필수 약관 한 줄(디자인 참조 §5). **토글이 없다** — 철회 경로가 없어서 스위치를
/// 두면 누를 수 있는 것처럼 보인다. 대신 체크 표시와 동의 일자를 보여준다.
class RequiredAgreementRow extends StatelessWidget {
  const RequiredAgreementRow({super.key, required this.status});

  final AgreementStatus status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? agreedAt = status.agreedAt;

    return ListTile(
      title: Text(
        termsLabel(l10n, status.termsCode),
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        // 서버가 준 문자열을 그대로 쓴다 — 형식을 클라이언트가 정하지 않는다.
        agreedAt == null
            ? l10n.termsAgreedRequired
            : l10n.termsAgreedOn(agreedAt),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: status.agreed
          ? Icon(Icons.check, color: theme.colorScheme.primary)
          : null,
    );
  }
}

/// 선택 약관 한 줄(디자인 참조 §5). 위치·마케팅만 여기로 온다.
///
/// 토글은 **낙관적으로** 움직인다 — 상태는 provider가 이미 바꿔 놓았고 이 위젯은
/// 그것을 그리기만 한다(R10).
class OptionalAgreementRow extends StatelessWidget {
  const OptionalAgreementRow({
    super.key,
    required this.status,
    required this.onChanged,
  });

  final AgreementStatus status;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SwitchListTile.adaptive(
      value: status.agreed,
      onChanged: onChanged,
      title: Text(
        termsLabel(l10n, status.termsCode),
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        termsDescription(l10n, status.termsCode),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
