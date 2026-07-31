import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/permission/component/permission_blocked_notice.dart';
import '../../../common/permission/model/permission_kind.dart';
import '../../../common/permission/model/permission_state.dart';
import '../../../common/permission/provider/permission_providers.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/category_bar.dart';
import '../component/drag_feedback_overlay.dart';
import '../component/swipe_card.dart';
import '../model/spot_category.dart';
import '../model/spot_reaction.dart';
import '../model/swipe_queue.dart';
import '../model/tourist_spot.dart';
import '../provider/swipe_providers.dart';

/// Discover 스와이프 화면 본체(spec §3·§7). 상단 카테고리 바 + 카드 스택.
///
/// 상태 처리(§7): 위치 권한 거부 → 안내+설정 CTA(SPEC-0001 컴포넌트 재사용),
/// 초기 로딩 → 스피너, 소진/0건 → 빈 상태(반경/카테고리 CTA), 오류 → 재시도 배너.
class DiscoverSwipeView extends ConsumerWidget {
  const DiscoverSwipeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 위치가 설정에서만 켤 수 있는 상태면 카드 대신 권한 안내를 먼저 보여준다(§7).
    final PermissionState? locationState = ref.watch(
      permissionControllerProvider.select((s) => s[PermissionKind.location]),
    );
    final bool locationBlocked = locationState?.needsSettings ?? false;

    final SpotCategory? category = ref.watch(selectedSpotCategoryProvider);
    final AsyncValue<SwipeQueue> queue = ref.watch(
      swipeControllerProvider(category),
    );

    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        const CategoryBar(),
        const SizedBox(height: 8),
        Expanded(
          child: locationBlocked
              ? const _LocationBlocked()
              : _QueueBody(category: category, queue: queue),
        ),
      ],
    );
  }
}

/// 위치 영구거부 상태: SPEC-0001의 [PermissionBlockedNotice]를 재사용해 설정 이동
/// 경로를 노출한다(중복 구현 없음).
class _LocationBlocked extends StatelessWidget {
  const _LocationBlocked();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: PermissionBlockedNotice(kind: PermissionKind.location),
      ),
    );
  }
}

class _QueueBody extends ConsumerWidget {
  const _QueueBody({required this.category, required this.queue});

  final SpotCategory? category;
  final AsyncValue<SwipeQueue> queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return queue.when(
      loading: () => const _LoadingState(),
      error: (Object error, _) => _ErrorState(
        onRetry: () =>
            ref.read(swipeControllerProvider(category).notifier).reload(),
      ),
      data: (SwipeQueue data) {
        if (data.isExhausted) return const _EmptyState();
        return _CardStack(category: category, queue: data);
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.discoverLoading),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(l10n.discoverLoadError, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.discoverRetryButton),
            ),
          ],
        ),
      ),
    );
  }
}

/// 소진/0건 빈 상태: 반경 확대·카테고리 변경 유도(§7). 반경 슬라이더는 이 스펙 범위
/// 밖이라, 카테고리 변경은 "전체" 선택으로 되돌려 재조회를 유도한다.
class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.explore_off_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(l10n.discoverEmptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              l10n.discoverEmptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.zoom_out_map),
                  label: Text(l10n.discoverWidenRadius),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => ref
                      .read(selectedSpotCategoryProvider.notifier)
                      .select(null),
                  icon: const Icon(Icons.category_outlined),
                  label: Text(l10n.discoverChangeCategory),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 드래그 가능한 카드 스택. 맨 위 카드만 제스처를 받고, 그 아래 다음 카드는 살짝
/// 작게(scale-up 대기) 깔린다. 확정 임계값·기울기·다음 카드 스케일업은 [_DraggableTop].
class _CardStack extends ConsumerStatefulWidget {
  const _CardStack({required this.category, required this.queue});

  final SpotCategory? category;
  final SwipeQueue queue;

  @override
  ConsumerState<_CardStack> createState() => _CardStackState();
}

class _CardStackState extends ConsumerState<_CardStack> {
  /// 현재 수평 드래그 변위(px, 오른쪽 양수).
  double _dragX = 0;

  /// 확정 임계값: 카드 폭의 28%(spec §3 시작값).
  static const double _confirmFraction = 0.28;

  /// fling 확정 속도 임계(px/s).
  static const double _flingVelocity = 800;

  void _onReaction(SpotReaction reaction) {
    ref.read(swipeControllerProvider(widget.category).notifier).swipe(reaction);
    setState(() => _dragX = 0);
  }

  @override
  Widget build(BuildContext context) {
    final List<TouristSpot> cards = widget.queue.cards;
    final TouristSpot top = cards.first;
    final TouristSpot? next = cards.length > 1 ? cards[1] : null;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        // 드래그 강도에 따라 다음 카드가 0.92 → 1.0으로 스케일업(§3).
        final double progress = width == 0
            ? 0
            : (_dragX.abs() / (width * _confirmFraction)).clamp(0.0, 1.0);
        final double nextScale = 0.92 + 0.08 * progress;

        return Padding(
          key: const Key('discover_card_stack'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Stack(
            children: <Widget>[
              if (next != null)
                Positioned.fill(
                  child: Transform.scale(
                    scale: nextScale,
                    child: SwipeCard(
                      key: ValueKey<String>(next.id),
                      spot: next,
                    ),
                  ),
                ),
              Positioned.fill(
                child: _DraggableTop(
                  key: ValueKey<String>(top.id),
                  spot: top,
                  width: width,
                  dragX: _dragX,
                  confirmFraction: _confirmFraction,
                  flingVelocity: _flingVelocity,
                  onDragUpdate: (double dx) => setState(() => _dragX = dx),
                  onReaction: _onReaction,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 맨 위 카드의 드래그·기울기·확정/스프링백 처리. 확정 시 [onReaction]으로 낙관적
/// 제거를 트리거한다. 되돌리기 UI 없음(spec §7).
class _DraggableTop extends StatelessWidget {
  const _DraggableTop({
    super.key,
    required this.spot,
    required this.width,
    required this.dragX,
    required this.confirmFraction,
    required this.flingVelocity,
    required this.onDragUpdate,
    required this.onReaction,
  });

  final TouristSpot spot;
  final double width;
  final double dragX;
  final double confirmFraction;
  final double flingVelocity;
  final ValueChanged<double> onDragUpdate;
  final ValueChanged<SpotReaction> onReaction;

  @override
  Widget build(BuildContext context) {
    // 변위 비례 회전(최대 ±0.12rad). 카드 폭 절반에서 최대치.
    final double angle = width == 0
        ? 0
        : (dragX / (width / 2)).clamp(-1.0, 1.0) * 0.12;

    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails d) =>
          onDragUpdate(dragX + d.delta.dx),
      onHorizontalDragEnd: (DragEndDetails d) {
        final double velocity = d.primaryVelocity ?? 0;
        final bool passedThreshold =
            dragX.abs() >= width * confirmFraction ||
            velocity.abs() >= flingVelocity;
        if (passedThreshold) {
          final bool like = dragX > 0 || velocity > 0;
          onReaction(like ? SpotReaction.like : SpotReaction.dislike);
        } else {
          onDragUpdate(0); // 스프링백.
        }
      },
      child: Transform.translate(
        offset: Offset(dragX, 0),
        child: Transform.rotate(
          angle: angle,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SwipeCard(spot: spot),
              DragFeedbackOverlay(dragX: dragX, width: width),
            ],
          ),
        ),
      ),
    );
  }
}
