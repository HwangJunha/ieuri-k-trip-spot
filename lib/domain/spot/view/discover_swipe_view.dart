import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/permission/component/permission_blocked_notice.dart';
import '../../../common/permission/model/permission_kind.dart';
import '../../../common/permission/model/permission_state.dart';
import '../../../common/permission/provider/permission_providers.dart';
import '../../../common/storage/search_radius_controller.dart';
import '../../../common/widget/failure_notice.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/category_bar.dart';
import '../component/drag_feedback_overlay.dart';
import '../component/spot_category_seed.dart';
import '../component/swipe_card.dart';
import '../model/retry_exhausted.dart';
import '../model/spot_category.dart';
import '../model/spot_category_selection.dart';
import '../model/spot_reaction.dart';
import '../model/swipe_queue.dart';
import '../model/tourist_spot.dart';
import '../provider/swipe_providers.dart';
import 'spot_detail_view.dart';

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

    // 목록이 오면 기본 선택을 심는다(R4·AC4.1·AC4.2). 목록은 비동기이므로
    // `listen`으로 받는다 — build 안에서 provider 상태를 바꾸면 Riverpod이 막는다.
    // `seedDefault`는 이미 고른 것이 있으면 아무 일도 하지 않아, 언어 전환으로 목록이
    // 다시 와도 사용자의 선택을 덮지 않는다.
    seedSpotCategoryDefault(
      ref,
      () => ref.read(selectedSpotCategoryProvider.notifier),
    );

    final Set<SpotCategory> selected = ref.watch(selectedSpotCategoryProvider);
    final SpotCategorySelection selection = SpotCategorySelection(selected);
    final AsyncValue<SwipeQueue> queue = ref.watch(
      swipeControllerProvider(selection),
    );

    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        // 스와이프의 선택 상태는 세션에 속하는 keepAlive provider다(탭을
        // 옮겼다 와도 유지된다, AC12.3).
        CategoryBar(
          selected: selected,
          onToggle: (SpotCategory next) =>
              ref.read(selectedSpotCategoryProvider.notifier).toggle(next),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: locationBlocked
              ? const _LocationBlocked()
              : _QueueBody(selection: selection, queue: queue),
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
  const _QueueBody({required this.selection, required this.queue});

  final SpotCategorySelection selection;
  final AsyncValue<SwipeQueue> queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return queue.when(
      loading: () => const _LoadingState(),
      error: (Object error, _) => _ErrorState(
        error: error,
        onRetry: () =>
            ref.read(swipeControllerProvider(selection).notifier).reload(),
      ),
      data: (SwipeQueue data) {
        if (data.isExhausted) return const _EmptyState();
        return _CardStack(selection: selection, queue: data);
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

/// 조회 실패 상태. 자동 재시도 상한을 소진했으면 종료 상태를, 아니면 일반 오류를
/// 보여준다(SPEC-0006 AC-5·AC-6). 두 경우 모두 명시적 재시도는 가능하다(AC-8).
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (error is RetryExhausted) {
      return FailureNotice.terminal(
        title: l10n.retryExhaustedTitle,
        body: l10n.retryExhaustedBody,
        actionLabel: l10n.retryExhaustedAction,
        onAction: onRetry,
      );
    }

    return FailureNotice.retryable(
      title: l10n.discoverLoadError,
      body: l10n.discoverRetryBanner,
      actionLabel: l10n.discoverRetryButton,
      onAction: onRetry,
    );
  }
}

/// 소진/0건 빈 상태: 반경 확대·카테고리 변경 유도(§7).
///
/// **"반경 넓히기"는 실제로 반경을 넓힌다**(SPEC-0011 R13으로 반경이 조회에 실리게
/// 되면서 가능해졌다). 그전에는 소비처가 없어 빈 콜백이었다 — 눌러도 아무 일이
/// 없는 버튼이었다.
class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  /// 반경을 한 단계 넓힌다. 피드는 [SwipeController]가 반경을 watch하고 있어
  /// **저절로 다시 받는다** — 여기서 따로 reload를 부르지 않는다.
  ///
  /// 이미 상한이면 넓힐 수 없다는 것을 알린다. 조용히 아무 일도 안 하면 사용자는
  /// 버튼이 고장 난 것으로 읽는다(실제로 그 상태였다).
  Future<void> _widen(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final bool widened = await ref
        .read(searchRadiusControllerProvider.notifier)
        .widen();
    if (!widened) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.discoverRadiusAtMax)));
    }
  }

  /// 선택을 기본 카테고리 하나로 되돌린다(R4의 기본값과 같은 규칙).
  ///
  /// 가용 목록이 아직 없으면 아무 일도 하지 않는다 — 심을 값이 없다. 빈 집합으로
  /// 만들지 않는 이유는 그것이 서버가 거절하는 상태이기 때문이다(AC5.1).
  void _resetCategory(WidgetRef ref) {
    final List<SpotCategory> available =
        ref.read(availableSpotCategoriesProvider).value ??
        const <SpotCategory>[];
    if (available.isEmpty) return;
    ref.read(selectedSpotCategoryProvider.notifier).replace(<SpotCategory>{
      available.firstWhere(
        (SpotCategory c) => c.code == kDefaultSpotCategoryCode,
        orElse: () => available.first,
      ),
    });
  }

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
                  onPressed: () => _widen(context, ref, l10n),
                  icon: const Icon(Icons.zoom_out_map),
                  label: Text(l10n.discoverWidenRadius),
                ),
                // 예전에는 "전체 보기"로 되돌리는 버튼이었으나 그 상태가 사라져
                // (SPEC-0020 R1) 기본 카테고리로 되돌린다 — 어느 쪽이든 뜻은
                // "지금 필터로는 결과가 없으니 필터를 바꿔 보라"로 같다.
                FilledButton.tonalIcon(
                  onPressed: () => _resetCategory(ref),
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
  const _CardStack({required this.selection, required this.queue});

  final SpotCategorySelection selection;
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
    ref
        .read(swipeControllerProvider(widget.selection).notifier)
        .swipe(reaction);
    setState(() => _dragX = 0);
  }

  /// 카드 탭 → 상세로 push(§5, R9). 식별자만 넘기고, Discover 스택은 셸에 보존된다.
  ///
  /// **카테고리는 더 이상 넘기지 않는다**(SPEC-0020) — 서버가 상세의 `intro`/`infoItems`를
  /// spot 자신의 카테고리로 해석하므로 호출부가 알려줄 것이 없다.
  ///
  /// 썸네일 URL은 함께 넘긴다(SPEC-0006 R8) — 상세가 본문 조회를 기다리는 동안 카드에서
  /// 보던 같은 이미지를 그대로 그려, 같은 URL을 다시 로드하며 깜빡이는 것을 막는다(AC-24).
  void _openDetail(TouristSpot spot) {
    context.pushNamed(
      SpotDetailView.routeName,
      pathParameters: <String, String>{'id': spot.id},
      queryParameters: <String, String>{
        if (spot.thumbnailImageUrl != null) 'thumb': spot.thumbnailImageUrl!,
        // 어느 피드에서 열렸는지(R11) — 반응 후 이 피드에서 카드를 소비한다.
        // 정렬된 코드를 콤마로 이어 싣고, 라우트가 같은 규약으로 되돌린다.
        'feed': widget.selection.codes.join(','),
      },
    );
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
                  onTap: () => _openDetail(top),
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
    required this.onTap,
  });

  final TouristSpot spot;
  final double width;
  final double dragX;
  final double confirmFraction;
  final double flingVelocity;
  final ValueChanged<double> onDragUpdate;
  final ValueChanged<SpotReaction> onReaction;

  /// 카드 탭(드래그 아님) 콜백 — 상세 진입.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 변위 비례 회전(최대 ±0.12rad). 카드 폭 절반에서 최대치.
    final double angle = width == 0
        ? 0
        : (dragX / (width / 2)).clamp(-1.0, 1.0) * 0.12;

    return GestureDetector(
      onTap: onTap,
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
