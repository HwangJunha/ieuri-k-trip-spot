import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/gen/app_localizations.dart';
import '../navigation/settings_routes.dart';

/// 설정으로 들어가는 앱바 액션(SPEC-0011 R1).
///
/// `common/`에 사는 이유는 `LogoutButton`과 같다 — 홈(`domain/spot`)이 설정
/// (`domain/settings`)을 직접 import하면 기능 간 의존이 생긴다(CLAUDE.md §3).
/// 라우트 이름은 [settingsRouteName]에서 오므로 화면 클래스를 끌어오지 않고도
/// 진실의 출처는 하나다.
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return IconButton(
      icon: const Icon(Icons.settings_outlined),
      tooltip: l10n.settingsTooltip,
      onPressed: () => context.pushNamed(settingsRouteName),
    );
  }
}
