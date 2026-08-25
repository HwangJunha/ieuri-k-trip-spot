import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/navigation/alarm_routes.dart';
import '../../../common/permission/model/permission_kind.dart';
import '../../../common/permission/provider/permission_providers.dart';
import '../../../common/widget/app_skeleton.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/os_permission_notice.dart';
import '../model/notification_preference.dart';
import '../model/notification_preference_skeleton_samples.dart';
import '../provider/notification_preference_controller.dart';

/// 카테고리별 푸시 수신 설정(SPEC-0028 R19·R21).
///
/// 토글은 **둘뿐이다** — 메시지(DM)와 질문·답변. 답변과 답글은 사용자에게 같은 성격의
/// 알림이고 목적지도 같은 화면이라 나누지 않는다(설계 §6).
///
/// 화면 맨 위에 OS 권한 안내가 붙는다(R21). 앱 토글이 켜져 있어도 OS가 꺼져 있으면
/// 알림은 오지 않으므로, 그 사실을 여기서 알리지 않으면 사용자는 고장으로 오해한다.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  /// 이름은 `common/navigation/alarm_routes.dart`가 소유한다 — 진입점(설정 화면)이
  /// 다른 기능에 있어 이름만 공용으로 둔다(설계 §2).
  static String get routeName => notificationSettingsRouteName;

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // 진입 시 OS 상태를 다시 읽는다 — 사용자가 OS 설정에서 바꾸고 돌아왔을 수 있고,
    // 부팅 시퀀스 이후로 값이 갱신되지 않았을 수 있다(AC21.1).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(permissionControllerProvider.notifier)
          .check(PermissionKind.notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<NotificationPreference>> preferences = ref.watch(
      notificationPreferenceControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.alarmSettingsTitle)),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const OsPermissionNotice(),
            ...switch (preferences) {
              AsyncData<List<NotificationPreference>>(:final value) => _toggles(
                l10n,
                value,
              ),
              AsyncError<List<NotificationPreference>>() => <Widget>[
                _Message(l10n.alarmSettingsLoadFailed),
              ],
              // **`SkeletonList`가 아니라 `AppSkeleton`이다.** 이 갈래는 바깥
              // `ListView`의 children으로 펼쳐지므로 여기 스크롤 목록을 또 넣으면
              // 목록이 겹친다. 토글은 항상 정확히 둘이라(설계 §6) 실제 토글을
              // 더미 값으로 그린 뒤 시머로 덮으면 데이터가 와도 줄 수가 그대로다.
              _ => <Widget>[
                AppSkeleton(
                  child: Column(
                    children: _toggles(
                      l10n,
                      notificationPreferenceSkeletonSamples,
                    ),
                  ),
                ),
              ],
            },
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  List<Widget> _toggles(
    AppLocalizations l10n,
    List<NotificationPreference> preferences,
  ) => <Widget>[
    _toggle(
      title: l10n.alarmCategoryMessage,
      subtitle: l10n.alarmCategoryMessageDescription,
      category: NotificationCategory.message,
      enabled: preferences.isEnabled(NotificationCategory.message),
    ),
    _toggle(
      title: l10n.alarmCategorySpotQa,
      subtitle: l10n.alarmCategorySpotQaDescription,
      category: NotificationCategory.spotQa,
      enabled: preferences.isEnabled(NotificationCategory.spotQa),
    ),
  ];

  Widget _toggle({
    required String title,
    required String subtitle,
    required NotificationCategory category,
    required bool enabled,
  }) => SwitchListTile(
    title: Text(title),
    subtitle: Text(subtitle),
    value: enabled,
    onChanged: (bool value) => _onToggle(category, value),
  );

  Future<void> _onToggle(NotificationCategory category, bool enabled) async {
    try {
      await ref
          .read(notificationPreferenceControllerProvider.notifier)
          .toggle(category, enabled);
    } on Object {
      // 낙관적 갱신은 notifier가 이미 되돌렸다. 사용자에게는 저장되지 않았다는
      // 사실만 알린다 — 서버 문구를 그대로 띄우지 않는다(POL-013).
      if (!mounted) return;
      final AppLocalizations l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.alarmSettingsSaveFailed)));
    }
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}
