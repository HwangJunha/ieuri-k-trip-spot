import 'package:flutter/material.dart';

/// 설정 목록의 섹션 라벨 한 줄(디자인 참조 §2). 작은 대문자 muted 텍스트다.
class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// 설정 목록의 한 행: 아이콘 + 제목 + (후행 값) + chevron.
///
/// **카드가 아니라 납작한 행이다**(디자인 참조 §2) — 그림자를 쓰지 않고 얇은
/// 구분선으로만 나눈다. 커뮤니티 목록과 같은 결이다.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.onTap,
    this.destructive = false,
    this.showChevron = true,
  });

  final IconData? icon;
  final String title;

  /// 오른쪽 chevron 앞에 붙는 현재 값(예: "20 km", "English"). 없으면 생략된다.
  final String? value;

  final VoidCallback? onTap;

  /// 탈퇴처럼 되돌릴 수 없는 동작. 제목과 아이콘이 error 색으로 바뀐다.
  final bool destructive;

  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground = destructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return ListTile(
      leading: icon == null ? null : Icon(icon, color: foreground),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(color: foreground),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (value != null)
            Text(
              value!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          if (showChevron) ...<Widget>[
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
