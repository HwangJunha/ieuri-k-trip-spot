import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/relation_orbit.dart';
import '../model/map_relation.dart';
import '../provider/relation_providers.dart';
import 'relation_detail_screen.dart';

/// 관계 지도 — 공유 링크로 맺은 사람들과의 겹침(SPEC-0030 관계 지도).
///
/// **겹침은 열 때마다 다시 계산된다.** 서로 여행을 더 다니면 다음에 열었을 때
/// 숫자가 늘어난다 — 그것이 이 화면을 다시 볼 이유다.
class RelationMapScreen extends ConsumerWidget {
  const RelationMapScreen({super.key});

  static String get routeName => 'relation-map';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<MapRelationPage> page = ref.watch(mapRelationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.relationMapTitle)),
      body: SafeArea(
        child: switch (page) {
          AsyncError<MapRelationPage>() => _Message(
            text: l10n.nationalMapUnavailable,
          ),
          AsyncData<MapRelationPage>(value: final MapRelationPage p) =>
            p.relations.isEmpty
                ? _Message(text: l10n.relationMapEmpty)
                : _Body(page: p, l10n: l10n),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.page, required this.l10n});

  final MapRelationPage page;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    // 겹침이 많은 순으로 배치한다 — 서버 정렬은 맺은 시각 순이라 그대로 두면
    // 가까운 사람이 아무 자리에나 놓인다.
    final List<MapRelation> ordered = page.byOverlapDesc;

    return Column(
      children: <Widget>[
        // 요약 한 줄. 인원과 「가장 많이 겹친 곳」을 나란히 둔다 — 숫자만
        // 적혀 있으면 화면이 비어 보인다.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: <Widget>[
              _Stat(
                value: '${ordered.length}',
                label: l10n.relationMapTitle,
                accent: false,
              ),
              const SizedBox(width: 12),
              _Stat(
                value: '${ordered.first.overlappingCount}',
                label: ordered.first.nickname,
                accent: true,
              ),
              const Spacer(),
              if (page.hasMore)
                TextButton(
                  onPressed: () =>
                      ref.read(mapRelationsProvider.notifier).loadMore(),
                  child: Text(l10n.commonMore),
                ),
            ],
          ),
        ),
        Expanded(
          child: RelationOrbit(
            relations: ordered,
            meLabel: l10n.relationMapMe,
            onTap: (MapRelation r) => context.pushNamed(
              RelationDetailScreen.routeName,
              pathParameters: <String, String>{'memberId': r.memberId},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Text(
            l10n.relationMapHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

}

/// 요약 칩 하나.
class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    required this.accent,
  });

  final String value;
  final String label;

  /// 강조할지. 「가장 많이 겹친 사람」쪽만 켠다.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent
            ? scheme.primary.withValues(alpha: 0.10)
            : scheme.surfaceDim,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: accent ? scheme.primary : scheme.onSurface,
            ),
          ),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 88),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
  );
}
