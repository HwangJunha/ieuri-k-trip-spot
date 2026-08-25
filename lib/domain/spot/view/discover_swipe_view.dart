import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/permission/component/permission_blocked_notice.dart';
import '../../../common/permission/model/permission_kind.dart';
import '../../../common/permission/model/permission_state.dart';
import '../../../common/permission/provider/permission_providers.dart';
import '../../../common/storage/search_radius_controller.dart';
import '../../../common/widget/failure_notice.dart';
import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../common/category/spot_category_bar.dart';
import '../component/drag_feedback_overlay.dart';
import '../component/swipe_card.dart';
import '../model/retry_exhausted.dart';
import '../../../common/category/spot_category.dart';
import '../../../common/category/spot_category_selection.dart';
import '../model/swipe_card_metrics.dart';
import '../model/swipe_drag.dart';
import '../model/swipe_queue.dart';
import '../model/tourist_spot.dart';
import '../provider/spot_detail_providers.dart';
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

    // 최초 상태는 "전체"다(사용자 결정, 2026-08-15) — 아무것도 심지 않는다. 예전에는
    // 진입 시 TOURIST_SPOT을 심었는데(R4), "전체" 칩이 생기면서 그 자리가 자연스러운
    // 시작 상태가 됐다.
    final Set<SpotCategory> selected = ref.watch(selectedSpotCategoryProvider);
    final SpotCategorySelection selection = SpotCategorySelection(selected);
    final AsyncValue<SwipeQueue> queue = ref.watch(
      swipeControllerProvider(selection),
    );

    final Widget body = locationBlocked
        ? const _LocationBlocked()
        : _QueueBody(selection: selection, queue: queue);

    // **카테고리 바가 사진 위에 겹친다**(R14, 사용자 결정 2026-08-17). 예전에는
    // `Column`으로 카드 위에 쌓여 그만큼 사진을 밀어냈는데, 전체화면화는 사진 면적을
    // 최대로 두는 쪽을 택했다.
    //
    // 카드가 화면 상단부터 시작하므로 카테고리 바는 `Stack`으로 얹는다 — 여기서
    // 자리를 차지하면 카드 높이가 그만큼 줄어 AC R1-2를 만족할 수 없다.
    return Stack(
      children: <Widget>[
        Positioned.fill(child: body),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _OverlayControls(
            // **대화 목록 진입점을 이 화면에서 뺐다**(사용자 결정 2026-08-18).
            //
            // SPEC-0021이 피드를 걷으면서 임시로 둘러보기 앱바에 얹어 둔 것인데,
            // 관광 추천 화면에 메일 아이콘이 붙어 있는 어색함을 그 스펙도 이미
            // 인정하고 있었다. 사용자가 "발견에서는 쓰지 않는다"고 정리했다 —
            // 추후 단체방 기능에서 쓸 자리를 따로 잡는다.
            //
            // `MessagesEntryButton`은 지우지 않는다. 컴포넌트는 그대로 두고 이
            // 화면에서만 걷어낸 것이라, 단체방이 생기면 그 자리에 그대로 쓴다.
            child: SpotCategoryBar(
              // 사진 위에 얹히므로 라벨을 흰색으로 받는다(R14의 가독성 보조).
              onImage: true,
              // 스와이프의 선택 상태는 세션에 속하는 keepAlive provider다(탭을
              // 옮겼다 와도 유지된다, AC12.3).
              available:
                  ref.watch(availableSpotCategoriesProvider).value ??
                  const <SpotCategory>[],
              selected: selected,
              onToggle: (SpotCategory next) =>
                  ref.read(selectedSpotCategoryProvider.notifier).toggle(next),
              onSelectAll: () =>
                  ref.read(selectedSpotCategoryProvider.notifier).selectAll(),
            ),
          ),
        ),
      ],
    );
  }
}

/// 겹쳐 놓인 카테고리 바의 배경. **가독성 보조는 R14의 일부다.**
///
/// 44x44 원형 아이콘이 가로로 늘어선 형태라 밝은 사진 위에서 특히 취약하다
/// (설계 §2.5). 위에서 아래로 옅어지는 스크림을 깔아 아이콘이 사진에 묻히지 않게
/// 한다 — 아이콘마다 배경을 다는 대신 한 겹으로 끝낸다.
class _OverlayControls extends StatelessWidget {
  const _OverlayControls({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // 앱바가 없으므로(→[DiscoverScreen]) 상태바만 피하면 된다. 예전에는 여기에
    // `kToolbarHeight`를 더했는데, 그 앱바가 칩과 같은 띠를 두고 다투던 것이
    // 문제였다.
    final double topInset = MediaQuery.of(context).viewPadding.top;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // **상태바와 칩 라벨을 함께 덮어야 한다.** 처음에는 아래쪽이 일찍 투명해져
          // 칩 라벨이 묻혔고, 그것을 고치자 이번에는 맨 위 시계가 밝은 사진에
          // 묻혔다(실기기 확인 2026-08-18). 위를 더 진하게 시작해 라벨이 끝나는
          // 지점까지 끌고 간 뒤 거기서만 풀어 준다.
          colors: <Color>[Colors.black, Colors.black54, Colors.transparent],
          stops: <double>[0, 0.8, 1],
        ),
      ),
      child: Padding(
        // 아래 여백을 넉넉히 둬야 그라데이션이 칩 아래에서 자연스럽게 사라진다.
        padding: EdgeInsets.only(top: topInset + 8, bottom: 28),
        child: child,
      ),
    );
  }
}

/// 겹쳐 놓인 카테고리 칩 줄이 차지하는 높이.
///
/// **`CategoryBar`의 실제 높이(88)와 위아래 패딩(8+28)을 더한 값이다.** 68로 어림잡았더니
/// 20px 모자라 **칩 라벨이 사진 위로 삐져나왔다**(사용자 지적 2026-08-18) — 사진은 이
/// 높이만큼 내려오므로 여기가 작으면 그만큼 라벨이 사진을 침범한다.
///
/// `CategoryBar`의 높이를 바꾸면 이 값도 함께 고쳐야 한다.
const double _overlayControlsHeight = 88 + 8 + 28;

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

  /// 선택을 "전체"로 되돌린다.
  ///
  /// 예전에는 기본 카테고리 하나로 되돌렸으나(R4), "전체" 칩이 생기면서 필터를 가장
  /// 넓히는 자리가 그쪽이 됐다 — "결과가 없으니 필터를 풀어 보라"는 이 버튼의 뜻에
  /// 맞는다. 빈 집합은 서버에 인자를 보내지 않는 상태다(AC5.1).
  void _resetCategory(WidgetRef ref) =>
      ref.read(selectedSpotCategoryProvider.notifier).selectAll();

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

class _CardStackState extends ConsumerState<_CardStack>
    with SingleTickerProviderStateMixin {
  /// 현재 드래그 변위(px). 오른쪽·아래가 양수.
  ///
  /// **`setState`가 아니라 [ValueNotifier]다.** 이것이 "뚝뚝 끊긴다"의 핵심
  /// 원인이었다 — 매 프레임 `setState`를 부르면 카드 스택 전체(사진·텍스트·
  /// 오버레이)가 60fps로 다시 빌드된다. 변위만 듣는 [AnimatedBuilder]로 좁히면
  /// 프레임마다 다시 그리는 것은 `Transform` 하나뿐이라, 손가락을 따라오는 동안
  /// 프레임을 흘리지 않는다.
  final ValueNotifier<Offset> _drag = ValueNotifier<Offset>(Offset.zero);

  /// 스프링백과 날아가기를 굴리는 컨트롤러.
  ///
  /// **`late final`이 아니라 `initState`에서 만든다.** 지연 초기화로 두면 카드를
  /// 한 번도 밀지 않은 화면에서 `dispose()`가 첫 접근이 되어, 이미 비활성화된
  /// 트리에서 `createTicker`가 조상을 찾다가 터진다.
  late final AnimationController _controller;

  Animation<Offset>? _animation;

  /// 날아가는 중인가 — 중복 확정을 막는다.
  bool _flyingOut = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
  }

  @override
  void dispose() {
    // 리스너를 먼저 뗀다 — 컨트롤러가 정리되며 마지막 틱을 흘리면 이미 해제된
    // notifier를 건드리게 된다.
    _controller
      ..removeListener(_onTick)
      ..stop()
      ..dispose();
    _drag.dispose();
    super.dispose();
  }

  void _onTick() {
    final Animation<Offset>? animation = _animation;
    if (animation != null) _drag.value = animation.value;
  }

  /// 진행 중인 애니메이션을 멈추고 변위를 지금 값으로 고정한다.
  void _stopAnimation() {
    _controller.stop();
    _animation = null;
    _controller.removeListener(_onTick);
  }

  /// 손을 뗐을 때 원위치로 튕겨 돌아간다.
  ///
  /// **감쇠 스프링이다** — 임계 근처까지 끌다 놓으면 살짝 오버슈트하며 제자리를
  /// 찾는다. 선형 보간이나 순간 이동(예전 동작)보다 손맛이 산다.
  ///
  /// 손을 떼는 순간의 속도를 스프링에 그대로 실어 준다 — 빠르게 놓았는데 느리게
  /// 돌아오면 손가락과 카드가 따로 논다.
  void _springBack(Offset velocity) {
    final Offset from = _drag.value;
    if (from == Offset.zero) return;

    final double distance = from.distance;
    // 스프링을 0→1 스칼라로 굴리고 변위는 그 위에 태운다. 속도도 같은 척도로
    // 환산해야 한다(px/s → 진행도/s).
    final double normalized = distance == 0
        ? 0
        : -(velocity.dx * from.dx + velocity.dy * from.dy) /
              (distance * distance);

    _animation = _controller.drive(
      Tween<Offset>(begin: from, end: Offset.zero),
    );
    _controller
      ..removeListener(_onTick)
      ..addListener(_onTick)
      ..value = 0
      ..animateWith(
        SpringSimulation(
          const SpringDescription(mass: 1, stiffness: 500, damping: 30),
          0,
          1,
          normalized.clamp(-8.0, 8.0),
        ),
      ).whenCompleteOrCancel(() {
        if (!mounted) return;
        _animation = null;
        _drag.value = Offset.zero;
      });
  }

  /// 확정 — 카드를 그 방향으로 날려 보낸 뒤 반응을 올린다.
  ///
  /// **날아가는 동안 큐를 건드리지 않는다.** 반응을 먼저 보내면 큐가 즉시 다음
  /// 장을 맨 위로 올리는데, 그 카드가 방금 민 방향으로 날아가 버린다 — 엉뚱한
  /// 카드가 사라지는 것처럼 보인다.
  ///
  /// **던진 속도를 이어받는다.** 세게 튕겼는데 카드가 정해진 속도로만 나가면
  /// 그 순간 손과 화면이 끊긴다 — 튕긴 세기만큼 빨리 빠져야 이어져 보인다.
  void _confirm(SwipeDirection direction, Size2D size, Offset velocity) {
    if (_flyingOut) return; // 연타로 두 장이 한꺼번에 소비되는 것을 막는다.
    _flyingOut = true;

    final Offset from = _drag.value;
    final double distance = size.width + size.height;
    final Offset target = from + direction.unit * distance;

    // 던진 속도가 빠를수록 짧게 — 최소 140ms, 기본 260ms.
    final double speed = velocity.distance;
    final Duration duration = Duration(
      milliseconds: speed <= 0
          ? 260
          : (260 - (speed / 40)).clamp(140, 260).round(),
    );

    _animation = _controller.drive(Tween<Offset>(begin: from, end: target));
    _controller
      ..removeListener(_onTick)
      ..addListener(_onTick)
      ..value = 0;
    _controller.animateTo(1, duration: duration, curve: Curves.easeOutCubic)
        .whenCompleteOrCancel(() {
          if (!mounted) return;
          ref
              .read(swipeControllerProvider(widget.selection).notifier)
              .swipe(direction.reaction);
          _drag.value = Offset.zero;
          _animation = null;
          _flyingOut = false;
        });
  }

  /// 카드 탭 → 상세로 push(§5, R9). 식별자만 넘기고, Discover 스택은 셸에 보존된다.
  ///
  /// **카테고리는 더 이상 넘기지 않는다**(SPEC-0020) — 서버가 상세의 `intro`/`infoItems`를
  /// **spot의 카테고리 코드를 상세에 알려준다.** 서버가 `intro`/`infoItems`에
  /// `categoryCode`를 요구하는데 상세 응답의 `category.code`는 null로 오므로,
  /// 카드가 이미 가진 값을 넘겨야 운영정보가 뜬다.
  ///
  /// 썸네일 URL은 함께 넘긴다(SPEC-0006 R8) — 상세가 본문 조회를 기다리는 동안 카드에서
  /// 보던 같은 이미지를 그대로 그려, 같은 URL을 다시 로드하며 깜빡이는 것을 막는다(AC-24).
  void _openDetail(TouristSpot spot) {
    ref
        .read(spotCategoryCodesProvider.notifier)
        .remember(spot.id, spot.category?.code);
    AppAnalytics.logEvent(AnalyticsEvents.spotDetailView, <String, Object>{
      AnalyticsParams.from: 'swipe',
    });
    context.pushNamed(
      SpotDetailView.routeName,
      pathParameters: <String, String>{'id': spot.id},
      queryParameters: <String, String>{
        if (spot.thumbnailImageUrl != null) 'thumb': spot.thumbnailImageUrl!,
        // 어느 스와이프 세션에서 열렸는지(R11) — 반응 후 이 세션에서 카드를
        // 소비한다. 정렬된 코드를 콤마로 이어 싣고, 라우트가 같은 규약으로 되돌린다.
        //
        // **선택이 비어도(=전체) 파라미터를 싣는다.** 값은 빈 문자열이 되는데,
        // 라우트가 부재(null)와 빈 값을 구분해 빈 값을 "전체 세션"으로 되돌린다.
        'category': widget.selection.codes.join(','),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TouristSpot> cards = widget.queue.cards;
    final TouristSpot top = cards.first;
    final TouristSpot? next = cards.length > 1 ? cards[1] : null;

    // 하단 인셋은 기기가 정한다 — 고정 픽셀값은 기기별로 어긋난다(설계 §2.2).
    //
    // **`MediaQuery.of`가 아니라 `viewPaddingOf`다.** 통짜로 구독하면 키보드가
    // 오르내릴 때(`viewInsets`)나 글자 크기·밝기가 바뀔 때도 카드 스택 전체가
    // 다시 빌드된다 — 여기서 실제로 읽는 것은 `viewPadding` 하나뿐이다.
    final EdgeInsets viewPadding = MediaQuery.viewPaddingOf(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final SwipeCardMetrics metrics = SwipeCardMetrics.fromScreen(
          screenWidth: width,
          screenHeight: constraints.maxHeight,
          // **카드는 화면 끝까지 그린다**(AC R1-2) — 셸이 `extendBody: true`라
          // 떠 있는 내비 바 아래까지 사진이 깔린다. 높이에서 빼지 않는 이유가
          // 이것이다.
          bottomNavHeight: 0,
          // 대신 **하단 정보는 그 바를 피해야 한다.** 사진은 바 뒤로 흘러도
          // 좋지만 글자가 가리면 읽을 수 없다(실기기 확인, 2026-08-18: 출처와
          // 거리가 내비 바에 묻혔다).
          //
          // 값을 여기 복사하지 않고 셸의 상수를 쓴다 — 바 높이가 바뀌면 이
          // 보정도 함께 따라와야 한다(그 파일의 주석이 명시한 계약이다).
          bottomViewPadding:
              viewPadding.bottom + FloatingBottomNavScaffold.barExtent,
          topViewPadding: viewPadding.top,
          overlayControlsHeight: _overlayControlsHeight,
        );

        final Size2D size = Size2D(width, constraints.maxHeight);

        // **두 카드 모두 변위만 듣는다.** 사진·텍스트를 담은 `SwipeCard`는
        // `AnimatedBuilder`의 `child`로 한 번만 만들어져 프레임마다 재사용되고,
        // 매 프레임 다시 그려지는 것은 바깥의 `Transform`뿐이다. 이 구조가
        // 아니면 60fps로 카드 전체가 리빌드돼 스와이프가 끊긴다.
        return Stack(
          key: const Key('discover_card_stack'),
          children: <Widget>[
            if (next != null)
              Positioned.fill(
                // **아래 카드도 같은 배치로 그린다** — 위 카드를 밀어내면 그 아래에서
                // 똑같은 모양이 드러나야 한다. 배치를 안 주면 사진만 꽉 찬 다른
                // 모양이 비쳐 카드가 바뀌는 순간 화면이 튄다.
                child: ValueListenableBuilder<Offset>(
                  valueListenable: _drag,
                  // **`RepaintBoundary`가 `child`를 레이어로 굳힌다.** `child`는
                  // 프레임마다 다시 *빌드*되지 않지만, 경계가 없으면 바깥
                  // `Transform`이 움직일 때마다 다시 *래스터화*된다 — 사진 한 장을
                  // 옮기는 대신 카드를 통째로 다시 그리는 셈이다.
                  child: RepaintBoundary(
                    child: SwipeCard(
                      key: ValueKey<String>(next.id),
                      spot: next,
                      metrics: metrics,
                    ),
                  ),
                  builder: (BuildContext context, Offset drag, Widget? child) =>
                      Transform.scale(
                        // 드래그 강도에 따라 0.92 → 1.0으로 스케일업(§3).
                        scale: SwipeDrag.nextCardScale2D(drag, size),
                        child: child,
                      ),
                ),
              ),
            Positioned.fill(
              child: _DraggableTop(
                key: ValueKey<String>(top.id),
                spot: top,
                size: size,
                drag: _drag,
                metrics: metrics,
                onDragStart: _stopAnimation,
                onDragUpdate: (Offset d) => _drag.value = d,
                onConfirm: (SwipeDirection direction, Offset velocity) =>
                    _confirm(direction, size, velocity),
                onSpringBack: _springBack,
                onTap: () => _openDetail(top),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 맨 위 카드의 드래그·기울기·확정/스프링백 처리. 되돌리기 UI 없음(spec §7).
///
/// **2차원 팬으로 받되 판정은 좌우로만 한다** — 카드는 손가락을 그대로 따라
/// 위아래로도 움직여야 자연스럽지만(수평으로만 붙어 있으면 뻣뻣하다), 좋아요와
/// 패스를 가르는 것은 좌우다(사용자 결정 2026-08-24).
class _DraggableTop extends StatelessWidget {
  const _DraggableTop({
    super.key,
    required this.spot,
    required this.size,
    required this.drag,
    required this.metrics,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onConfirm,
    required this.onSpringBack,
    required this.onTap,
  });

  final TouristSpot spot;
  final Size2D size;

  /// 변위 소스. **값이 아니라 notifier를 받는다** — 프레임마다 이 위젯 전체가
  /// 아니라 `Transform`만 다시 그리기 위해서다.
  final ValueNotifier<Offset> drag;
  final SwipeCardMetrics metrics;

  /// 드래그를 시작하면 진행 중인 애니메이션을 멈춘다 — 스프링백 도중 다시 잡으면
  /// 손가락과 카드가 따로 놀지 않아야 한다.
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final void Function(SwipeDirection direction, Offset velocity) onConfirm;
  final ValueChanged<Offset> onSpringBack;

  /// 카드 탭(드래그 아님) 콜백 — 상세 진입.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onPanStart: (DragStartDetails _) => onDragStart(),
      onPanUpdate: (DragUpdateDetails d) => onDragUpdate(drag.value + d.delta),
      onPanEnd: (DragEndDetails d) {
        final Offset velocity = d.velocity.pixelsPerSecond;
        // 판정은 순수 함수가 한다 — 같은 계산이 그대로 단위 테스트가 된다(설계 §2.4).
        final SwipeDirection? direction = SwipeDrag.resolveHorizontal(
          drag: drag.value,
          size: size,
          velocity: velocity,
        );
        if (direction != null) {
          onConfirm(direction, velocity);
        } else {
          onSpringBack(velocity);
        }
      },
      // 사진·텍스트는 `child`로 한 번만 만들고, 프레임마다 바뀌는 변환만 다시
      // 그린다. 오버레이 라벨은 변위에 따라 투명도가 변하므로 안쪽에 둔다.
      child: ValueListenableBuilder<Offset>(
        valueListenable: drag,
        // `child`는 다시 빌드되지 않지만, 경계가 없으면 바깥 `Transform`이 움직일
        // 때마다 사진·블러 배경이 다시 래스터화된다. 경계를 두면 굳은 레이어를
        // 옮기기만 한다 — 드래그가 부드러워지는 핵심이다.
        child: RepaintBoundary(child: SwipeCard(spot: spot, metrics: metrics)),
        builder: (BuildContext context, Offset value, Widget? child) =>
            Transform.translate(
              offset: value,
              child: Transform.rotate(
                // 변위 비례 회전(최대 ±0.12rad). 카드 폭 절반에서 최대치.
                angle: SwipeDrag.tilt(value.dx, size.width),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    child!,
                    DragFeedbackOverlay(drag: value, size: size),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
