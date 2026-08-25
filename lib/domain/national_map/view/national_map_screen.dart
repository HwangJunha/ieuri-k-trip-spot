import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widget/floating_bottom_nav_scaffold.dart';
import '../../../common/analytics/analytics_events.dart';
import '../../../common/analytics/app_analytics.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../component/cell_sheet.dart';
import '../component/national_map_canvas.dart';
import '../component/photo_sync_sheet.dart';
import '../model/cell_geometry.dart';
import '../model/current_location_check.dart';
import '../model/map_cell.dart';
import '../model/province_progress.dart';
import '../provider/current_location_provider.dart';
import '../provider/national_map_providers.dart';
import '../provider/share_providers.dart';
import '../provider/visit_controller.dart';
import 'relation_map_screen.dart';

/// 전국 지도 — 161칸을 채워나가는 화면(R20~R22·R29·R33~R36).
///
/// 참조 디자인은 스크래치 지도 포스터다. **지도가 주인공이고 나머지는 비켜선다** —
/// 진척 바·선택 바를 화면에 상시로 쌓으면 지도가 작아지고 자잘해 보인다. 진척은
/// 상단에 한 줄, 칸을 누르면 아래에서 시트가 올라온다.
class NationalMapScreen extends ConsumerWidget {
  const NationalMapScreen({super.key});

  static String get routeName => 'national-map';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final AsyncValue<List<MapCell>> cells = ref.watch(mapCellsProvider);
    final AsyncValue<List<CellGeometry>> geometries = ref.watch(
      cellGeometriesProvider,
    );

    return Scaffold(
      // 지도를 화면 끝까지 쓰기 위해 AppBar를 두지 않는다. 제목·동작은 지도 위에
      // 떠 있는 얇은 바가 대신한다.
      body: switch ((cells, geometries)) {
        (AsyncError<List<MapCell>>(), _) ||
        (_, AsyncError<List<CellGeometry>>()) => SafeArea(
          child: _ErrorBody(
            message: l10n.nationalMapUnavailable,
            retryLabel: l10n.nationalMapRetry,
            onRetry: () => ref.invalidate(mapCellsProvider),
          ),
        ),
        (
          AsyncData<List<MapCell>>(value: final List<MapCell> c),
          AsyncData<List<CellGeometry>>(value: final List<CellGeometry> g),
        ) =>
          _Body(cells: c, geometries: g, l10n: l10n),
        // **여기는 뼈대를 두지 않는다**(사용자 지적 2026-08-25). 한때 한반도
        // 실루엣을 시머로 그렸는데, 목록 화면의 뼈대가 "화면이 채워진 느낌"을
        // 주는 것과 달리 이쪽은 실루엣 하나에서 250여 칸 지도로 **그림이 통째로
        // 바뀌어** 오히려 튀었다. 뼈대의 목적은 올 것을 미리 보여 주는 것인데
        // 그 역할을 못 하면 없는 편이 낫다.
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.cells,
    required this.geometries,
    required this.l10n,
  });

  final List<MapCell> cells;
  final List<CellGeometry> geometries;
  final AppLocalizations l10n;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  String? _selectedCellId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = widget.l10n;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    final Set<String> visited = <String>{
      for (final MapCell c in widget.cells)
        if (c.visited) c.id,
    };
    final ProvinceProgress nationwide = nationwideProgressOf(
      widget.cells,
      label: l10n.nationalMapNationwide,
    );

    return Stack(
      children: <Widget>[
        // 지도가 화면 전체를 쓴다. 상단 바와 하단 탭에 가리는 만큼만 여백을 준다.
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 52,
              // 바가 SafeArea 안에 있으므로 인셋까지 더하면 지도가 위로 떠
              // 버린다. 바 높이만 비켜서고 인셋은 바가 알아서 쓴다.
              //
              // 28을 더하는 이유: 제주가 지도 맨 아래라 바에 닿아 보인다.
              // 여백을 늘려 지도를 위로 당긴다.
              bottom: FloatingBottomNavScaffold.barExtent + 28,
            ),
            child: NationalMapCanvas(
              cells: widget.geometries,
              visitedCellIds: visited,
              selectedCellId: _selectedCellId,
              onCellTap: _onCellTap,
              // **전국이 한눈에 들어와야 한다.** cover로 세로를 채우면 배율이
              // 두 배가 되어 좌우가 414px 잘리고 제주와 북쪽 일부가 화면 밖으로
              // 나간다(실기기 확인). 먼 섬을 뺀 본토 비율이 0.73이라 fit이면
              // 가로가 꽉 차고 남는 세로에 제주가 들어온다.
              cover: false,
            ),
          ),
        ),

        // 상단: 진척 막대와 동작 아이콘만. 숫자는 적지 않는다.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(
            progress: nationwide,
            onPhotoSync: () => showPhotoSyncSheet(context),
            onShare: () => _share(context),
            onRelations: () =>
                context.pushNamed(RelationMapScreen.routeName),
            l10n: l10n,
          ),
        ),

        if (nationwide.visited == 0)
          Positioned(
            left: 24,
            right: 24,
            // 하단 인셋을 더한다 — Android는 시스템 내비게이션이 더 있어
            // barExtent만으로는 안내가 바에 가린다.
            bottom:
                FloatingBottomNavScaffold.barExtent +
                MediaQuery.paddingOf(context).bottom +
                24,
            child: _EmptyHint(text: l10n.nationalMapEmptyHint, scheme: scheme),
          ),
      ],
    );
  }

  void _onCellTap(String cellId) {
    setState(() => _selectedCellId = cellId);
    // 칸 정보를 화면에 상시로 붙여 두지 않고 시트로 띄운다 — 지도가 넓어진다.
    showCellSheet(context, cellId: cellId).whenComplete(() {
      if (mounted) setState(() => _selectedCellId = null);
    });
  }

  Future<void> _share(BuildContext context) async {
    try {
      await ref
          .read(shareControllerProvider.notifier)
          .share();
    } on Object {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.l10n.nationalMapShareFailed)),
      );
    }
  }
}

/// 지도 위에 떠 있는 얇은 상단 바.
///
/// **숫자를 적지 않는다** — "161칸 중 7칸"은 막대가 이미 보여주는 것을 글자로
/// 반복할 뿐이고 지도를 가리는 값을 한다. 정확한 수치는 지역 상세에 있다.
///
/// 오른쪽 **맨 끝이 현재 위치 등록**이다. 지도를 채우는 주 동작이라 엄지가 가장
/// 먼저 닿는 자리에 두고, 브랜드 코럴로 칠해 다른 아이콘과 구분한다.
class _TopBar extends ConsumerWidget {
  const _TopBar({
    required this.progress,
    required this.onPhotoSync,
    required this.onShare,
    required this.onRelations,
    required this.l10n,
  });

  final ProvinceProgress progress;
  final VoidCallback onPhotoSync;
  final VoidCallback onShare;

  /// 관계 지도로 간다.
  final VoidCallback onRelations;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: scheme.surface.withValues(alpha: 0.92),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.paddingOf(context).top + 6,
          4,
          8,
        ),
        child: Row(
          children: <Widget>[
            // 진척은 막대만. 얼마나 찼는지는 길이로 읽는다.
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.ratio,
                  minHeight: 6,
                  backgroundColor: scheme.surfaceDim,
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 관계 지도. 공유와 나란히 둔다 — 링크를 뿌리는 것과 그 결과를 보는
            // 것이 한 쌍이라 서로 옆에 있어야 흐름이 읽힌다.
            IconButton(
              icon: const Icon(Icons.group_outlined),
              tooltip: l10n.relationMapTitle,
              onPressed: onRelations,
            ),
            // 공유는 상단 우측이 표준이다(iOS 내비게이션 바, Android 앱바).
            // 하단 FAB에 두면 "이 화면의 주 동작"으로 읽혀 과하다.
            _ShareButton(onShare: onShare, l10n: l10n),
            IconButton(
              icon: const Icon(Icons.photo_library_outlined),
              tooltip: l10n.photoSyncTitle,
              onPressed: onPhotoSync,
            ),
            // 맨 끝. 빨간색으로 이것이 주 동작임을 알린다.
            _HereButton(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

/// 공유 링크를 발급해 시스템 공유 시트로 넘긴다(R36).
class _ShareButton extends ConsumerWidget {
  const _ShareButton({required this.onShare, required this.l10n});

  final VoidCallback onShare;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool sharing = ref.watch(shareControllerProvider);

    return IconButton(
      icon: sharing
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.ios_share),
      tooltip: l10n.nationalMapShare,
      onPressed: sharing ? null : onShare,
    );
  }
}

/// 한 칸도 없을 때의 안내.
///
/// **3초 뒤 사라진다.** 지도를 채우기 전까지 계속 떠 있으면 지도를 가리는
/// 방해물이 된다 — 한 번 읽으면 되는 문구다.
class _EmptyHint extends StatefulWidget {
  const _EmptyHint({required this.text, required this.scheme});

  final String text;
  final ColorScheme scheme;

  @override
  State<_EmptyHint> createState() => _EmptyHintState();
}

class _EmptyHintState extends State<_EmptyHint> {
  static const Duration _visibleFor = Duration(seconds: 3);

  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_visibleFor, () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: _visible ? 1 : 0,
    duration: const Duration(milliseconds: 300),
    // 사라진 뒤에는 탭을 가로채지 않아야 한다 — 투명해도 자리는 남는다.
    child: IgnorePointer(
      ignoring: !_visible,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.scheme.inverseSurface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          // 두 줄까지 접는다 — 한 줄로 두면 긴 문구가 잘린다.
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: widget.scheme.onInverseSurface,
            ),
          ),
        ),
      ),
    ),
  );
}

/// 현재 위치의 시군구를 등록한다(R33~R35). 상단 바의 아이콘이다.
class _HereButton extends ConsumerWidget {
  const _HereButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CurrentLocationCheck> check = ref.watch(
      currentLocationCheckProvider,
    );
    final bool busy = ref.watch(visitControllerProvider);

    // 위치를 얻지 못하면 버튼을 비활성화한다(R35).
    final bool disabled =
        busy ||
        check.isLoading ||
        check.value is LocationNotAvailable ||
        check.value is LocationOutsideKorea;

    final ColorScheme scheme = Theme.of(context).colorScheme;

    // **브랜드 코럴로 칠한다.** 지도를 채우는 주 동작이라 다른 아이콘과 구분되어야
    // 한다. 비활성일 때는 색을 빼 눌러도 안 된다는 것을 보여준다.
    return IconButton(
      icon: check.isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.my_location),
      color: scheme.primary,
      tooltip: l10n.nationalMapHere,
      onPressed: disabled ? null : () => _onPressed(context, ref, check.value),
    );
  }

  Future<void> _onPressed(
    BuildContext context,
    WidgetRef ref,
    CurrentLocationCheck? check,
  ) async {
    if (check == null) return;

    switch (check) {
      case LocationRegistrable(
        districtCode: final String code,
        districtName: final String name,
      ):
        // **확인을 받아야 등록한다**(R33). 취소하면 아무 일도 없다.
        final bool ok =
            await showDialog<bool>(
              context: context,
              builder: (BuildContext ctx) => AlertDialog(
                title: Text(l10n.nationalMapRegisterTitle),
                content: Text(l10n.nationalMapRegisterBody(name)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(l10n.commonCancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(l10n.nationalMapRecordVisit),
                  ),
                ],
              ),
            ) ??
            false;
        if (!ok || !context.mounted) return;

        await ref.read(visitControllerProvider.notifier).record(<String>[code]);
        // 사진 경로와 구분하기 위해 호출부에 심는다(→`photo_sync_sheet.dart`).
        AppAnalytics.logEvent(
          AnalyticsEvents.nationalMapRegionAdd,
          <String, Object>{AnalyticsParams.from: 'current_location'},
        );
        // 방문이 늘었으니 다음 판정은 "이미 방문"이 되어야 한다.
        ref.invalidate(currentLocationCheckProvider);

      case LocationAlreadyVisited(cellName: final String name):
        _toast(context, l10n.nationalMapAlreadyVisited(name));

      case LocationOutsideKorea():
        _toast(context, l10n.nationalMapOutsideKorea);

      case LocationNotAvailable():
        _toast(context, l10n.nationalMapLocationUnavailable);
    }
  }

  void _toast(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(message, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
      ],
    ),
  );
}
