import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/spot_qa_routes.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../provider/my_questions_providers.dart';

/// 「내 질문」으로 가는 목록 행 — 못 본 답변 수를 배지로 단다.
///
/// **설정(마이페이지)이 이 위젯을 쓴다.** 진입점은 설정에 있지만 못 본 답변을 세는
/// provider는 `spot_qa`가 소유하므로, 설정이 그 provider를 직접 watch하지 않도록
/// 배지 계산을 이 기능 안에 가둔다.
///
/// **배지가 이 행의 존재 이유다.** 서버에 답변 알림이 없어서 목록을 열기 전에
/// "답이 달렸다"를 알릴 수단이 이것뿐이다 — 0이면 배지를 그리지 않는다.
///
/// 설정 목록의 다른 행과 같은 [ListTile] 골격을 쓴다. 후행 값이 배지라 공용
/// `SettingsTile`(문자열 값만 받는다)을 쓰지 못하고 직접 그린다.
class MyQuestionsEntryTile extends ConsumerWidget {
  const MyQuestionsEntryTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    // 목록 전체가 아니라 "못 본 질문이 몇 개인가"만 구독한다(CLAUDE.md §5).
    final int unseen = ref.watch(myQuestionsUnseenCountProvider);

    return ListTile(
      leading: Icon(Icons.help_outline, color: theme.colorScheme.onSurface),
      title: Text(
        l10n.spotQaMyQuestionsEntry,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (unseen > 0) _UnseenBadge(count: unseen),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
      onTap: () => context.pushNamed(myQuestionsRouteName),
    );
  }
}

/// 못 본 답변이 있는 질문 수. 숫자만 담은 강조색 원형 배지다.
class _UnseenBadge extends StatelessWidget {
  const _UnseenBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
