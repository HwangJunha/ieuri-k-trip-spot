import 'package:flutter/material.dart';

import '../../../common/model/terms_code.dart';
import '../../../common/widget/document_web_view.dart';
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

/// 약관 전문으로 가는 버튼. 전문이 게시되지 않은 항목(마케팅)은 `null`을 돌려
/// 아무것도 그리지 않는다.
///
/// **동의한 뒤에도 언제든 다시 읽을 수 있어야 한다** — 개인정보 처리방침은
/// 가입 시점뿐 아니라 상시 열람 경로가 필요하다.
Widget? termsDocumentButton(
  BuildContext context,
  AppLocalizations l10n,
  TermsCode code,
) {
  final Uri? url = code.documentUrl;
  if (url == null) return null;
  return IconButton(
    tooltip: l10n.agreementViewDetail,
    icon: const Icon(Icons.article_outlined),
    onPressed: () => Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            DocumentWebView(title: termsLabel(l10n, code), url: url),
      ),
    ),
  );
}

/// 필수 약관 한 줄(디자인 참조 §5).
///
/// **토글이 있다.** 사용자가 동의를 거두는 것을 막지 않는다 — 막으면 스위치가
/// 있는데 안 움직이는 화면이 되고, 그건 고장으로 읽힌다. 대신 끄면 라우터
/// 게이트(R11)가 걸려 서비스를 쓸 수 없게 되고, 그 사실을 **끄기 전에** 부제로
/// 알린다.
///
/// 부제는 동의했을 때 **동의 일자만** 보여준다 — 나머지 설명은 사용자가 이미 아는
/// 것이고, 정작 필요한 정보(언제 동의했나)를 가린다.
class RequiredAgreementRow extends StatelessWidget {
  const RequiredAgreementRow({super.key, required this.status, this.onChanged});

  final AgreementStatus status;

  /// null이면 **읽기 전용**이다. 동의 안내 화면(`RequiredTermsScreen`)이 그렇게
  /// 쓴다 — 거기서는 아래의 "동의하고 계속" 하나가 유일한 동작이고, 끌 수 있는
  /// 스위치를 같이 두면 무엇을 눌러야 하는지 흐려진다.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 서버의 ISO 타임스탬프를 값으로 바꾼다 — 표시 형식은 l10n이 언어별로 정한다.
    final DateTime? agreedAt = status.agreedAtDate;

    // 동의했으면 **일자만**, 안 했으면 서비스를 쓸 수 없다는 사실을 보여준다.
    // 형식은 l10n(`yMMMd`)이 언어별로 정한다 — 여기서 문자열로 박지 않는다.
    final Widget subtitle = Text(
      status.agreed && agreedAt != null
          ? l10n.termsAgreedOn(agreedAt)
          : l10n.termsRequiredNotice,
      style: theme.textTheme.bodySmall?.copyWith(
        color: status.agreed
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.error,
      ),
    );
    final Widget title = Text(
      termsLabel(l10n, status.termsCode),
      style: theme.textTheme.bodyLarge,
    );

    final Widget? document = termsDocumentButton(context, l10n, status.termsCode);

    // 읽기 전용이면 스위치를 그리지 않는다 — 누를 수 없는 스위치는 고장으로 읽힌다.
    if (onChanged == null) {
      return ListTile(
        title: title,
        subtitle: subtitle,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (status.agreed)
              Icon(Icons.check, color: theme.colorScheme.primary),
            ?document,
          ],
        ),
      );
    }

    return SwitchListTile(
      value: status.agreed,
      onChanged: onChanged,
      title: title,
      subtitle: subtitle,
      // 스위치가 trailing을 차지하므로 전문 버튼은 앞쪽에 둔다.
      secondary: document,
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
      secondary: termsDocumentButton(context, l10n, status.termsCode),
      title: Text(
        termsLabel(l10n, status.termsCode),
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        // 동의했으면 **일자**를, 아니면 무엇에 동의하는지 설명한다. 필수 항목과
        // 같은 규칙이다 — 이미 동의한 항목에서 사용자가 궁금한 것은 설명이 아니라
        // "언제 동의했나"다.
        status.agreed && status.agreedAtDate != null
            ? l10n.termsAgreedOn(status.agreedAtDate!)
            : termsDescription(l10n, status.termsCode),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
