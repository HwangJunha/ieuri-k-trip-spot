import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/permission_providers.dart';

/// 위치 권한이 없는 동안 앱 전체를 대신하는 화면(2026-08-26, 사용자 결정).
///
/// **왜 탭마다 안내를 띄우지 않는가.** 예전에는 발견 탭만 「위치가 꺼져 있어요」를
/// 보여 주고 나머지 탭은 열려 있었다. 그런데 이 앱이 보여 주는 것은 전부 "내
/// 주변"이라, 위치를 거부한 사용자는 홈에서 캐시된 좌표로 받은 스팟을 보거나
/// 전국 지도·스팟톡처럼 좌표 없이도 되는 화면을 그대로 썼다 — 실기기에서 확인된
/// 증상이다. 안내 문구를 탭마다 늘리는 것으로는 그 조회들을 막을 수 없다.
///
/// 그래서 라우터 게이트(`route_gate.dart`)가 이 화면 하나로 보내고, 여기서
/// 나가는 길은 **설정에서 위치를 켜는 것**뿐이다. 설정 화면 계열은 열어 두므로
/// (`_locationAllows`) 로그아웃·탈퇴·언어 변경으로 빠져나갈 수는 있다.
class LocationRequiredScreen extends ConsumerWidget {
  const LocationRequiredScreen({super.key});

  static String get routeName => 'locationRequired';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.location_off_outlined,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.permissionLocationRationaleTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.permissionLocationBlockedMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => ref
                      .read(permissionControllerProvider.notifier)
                      .openSettings(),
                  child: Text(l10n.permissionOpenSettings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
