import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../component/cell_sheet.dart';
import '../component/overlap_list_sheet.dart';
import '../component/national_map_canvas.dart';
import '../model/cell_geometry.dart';
import '../model/national_map_failure.dart';
import '../model/shared_map.dart';
import '../provider/national_map_providers.dart';
import '../provider/relation_providers.dart';
import '../provider/share_providers.dart';
import 'national_map_screen.dart';

/// 공유 링크로 연 남의 지도(R37·R38).
///
/// 인증 없이 열린다. 본인 지도가 있으면 **겹치는 칸만** 칠한다 — 이 화면이
/// 답하는 질문은 "어디가 겹치나"이지 "이 사람이 어디를 갔나"가 아니다.
///
/// 전국 지도와 **같은 방식으로 보여준다**(사용자 결정, 2026-08-22) — 지도가
/// 화면을 채우고 확대·이동이 되며, 동작은 상단의 얇은 바에 아이콘으로 둔다.
class SharedMapScreen extends ConsumerWidget {
  const SharedMapScreen({required this.token, super.key});

  static String get routeName => 'shared-map';

  /// 링크의 마지막 경로 조각. 스킴이 바뀌어도 이 값만 넘기면 된다.
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<SharedMap> shared = ref.watch(sharedMapProvider(token));

    return Scaffold(
      // 전국 지도와 같이 AppBar를 두지 않는다 — 지도가 화면 끝까지 쓴다.
      body: switch (shared) {
        AsyncError<SharedMap>(error: final Object e) => SafeArea(
          child: _ErrorBody(message: _messageFor(e, l10n)),
        ),
        AsyncData<SharedMap>(value: final SharedMap map) => _Body(
          map: map,
          token: token,
          l10n: l10n,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  /// 폐기·차단·그 밖을 구분해 사유를 보여준다(R38).
  String _messageFor(Object error, AppLocalizations l10n) {
    if (error is NationalMapFailure) {
      // 서버가 "없음"과 "폐기됨"을 구분하지 않는다 — 구분하면 토큰을 넣어 보며
      // 그 사람이 공유했었는지 알아낼 수 있다.
      if (error.isShareLinkGone) return l10n.sharedMapGone;
      if (error.isShareLinkBlocked) return l10n.sharedMapBlocked;
    }
    return l10n.nationalMapUnavailable;
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.map, required this.token, required this.l10n});

  final SharedMap map;
  final String token;
  final AppLocalizations l10n;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  String? selectedCellId;

  void onCellTap(String cellId) {
    setState(() => selectedCellId = cellId);
    showCellSheet(context, cellId: cellId).whenComplete(() {
      if (mounted) setState(() => selectedCellId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SharedMap map = widget.map;
    final String token = widget.token;
    final AppLocalizations l10n = widget.l10n;
    // 조립 결과에서 도형만 꺼낸다 — 출처는 화면이 쓰지 않는다(SPEC-0034 R4).
    final AsyncValue<List<CellGeometry>> geometries = ref
        .watch(cellGeometriesProvider)
        .whenData((CellGeometrySet s) => s.geometries);

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 52,
              // **하단 바 높이를 비우지 않는다.** 전국 지도에서 값을 가져왔는데
              // 이 화면은 딥링크로 단독으로 열려 하단 바가 없다 — 그만큼이
              // 통째로 빈 공간이 되어 지도가 한 눈에 들어오지 않았다.
              // 제주가 잘리지 않을 만큼만 둔다.
              bottom: MediaQuery.paddingOf(context).bottom + 12,
            ),
            child: switch (geometries) {
              AsyncData<List<CellGeometry>>(
                value: final List<CellGeometry> g,
              ) =>
                NationalMapCanvas(
                  cells: g,
                  visitedCellIds: map.visitedCellIds.toSet(),
                  overlappingCellIds: map.overlappingCellIds?.toSet(),
                  selectedCellId: selectedCellId,
                  // 칸을 누르면 전국 지도와 같은 상세 시트가 열린다 — 지도만
                  // 봐서는 어디를 함께 갔는지 알 수 없다(사용자 확인).
                  onCellTap: onCellTap,
                  // 전국 지도와 같이 세로를 채운다.
                  cover: true,
                ),
              AsyncError<List<CellGeometry>>() => Center(
                child: Text(l10n.nationalMapUnavailable),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TopBar(map: map, token: token, l10n: l10n),
        ),
      ],
    );
  }
}

/// 지도 위에 떠 있는 얇은 상단 바.
///
/// 「등록됨」을 **큰 버튼으로 두지 않는다** — 화면 아래를 차지해 지도가 작아
/// 보였다(실기기 확인). 이미 끝난 상태를 알리는 것이므로 아이콘이면 충분하다.
class _TopBar extends ConsumerWidget {
  const _TopBar({required this.map, required this.token, required this.l10n});

  final SharedMap map;
  final String token;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return ColoredBox(
      color: scheme.surface.withValues(alpha: 0.92),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          4,
          MediaQuery.paddingOf(context).top + 4,
          4,
          6,
        ),
        child: Row(
          children: <Widget>[
            // **pop 할 수 있을 때만 pop 한다.** 딥링크로 바로 열리면 스택에
            // 이전 화면이 없어 기본 [BackButton]은 아무 일도 하지 않는다 —
            // 버튼이 눌리지 않는 것처럼 보였다. 그때는 전국 지도로 보낸다.
            BackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(NationalMapScreen.routeName);
                }
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    map.ownerNickname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // **겹침만 적는다**(사용자 결정, 2026-08-22). 상대가 몇 곳을
                  // 다녀왔는지는 이 화면이 답할 질문이 아니다.
                  Text(
                    switch (map) {
                      SharedMap(canCompare: false) =>
                        l10n.sharedMapSignInToCompare,
                      SharedMap(hasNoOverlap: true) => l10n.sharedMapNoOverlap,
                      _ => l10n.sharedMapOverlapCount(
                        map.overlappingCellIds!.length,
                      ),
                    },
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: map.canCompare && !map.hasNoOverlap
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // 겹치는 **곳이 어디인지**는 목록으로 본다. 지도에서 색칠된 칸을
            // 눈으로 찾는 것은 작은 칸이 섞이면 사실상 불가능하다(사용자 지적).
            if (map.canCompare && !map.hasNoOverlap)
              IconButton(
                icon: const Icon(Icons.format_list_bulleted),
                tooltip: l10n.sharedMapOverlapCount(
                  map.overlappingCellIds!.length,
                ),
                onPressed: () =>
                    OverlapListSheet.show(context, map.overlappingCellIds!),
              ),
            _ConnectAction(map: map, token: token, l10n: l10n),
          ],
        ),
      ),
    );
  }
}

/// 등록 아이콘. 이미 등록됐으면 체크만 보여준다.
class _ConnectAction extends ConsumerWidget {
  const _ConnectAction({
    required this.map,
    required this.token,
    required this.l10n,
  });

  final SharedMap map;
  final String token;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    // 겹침을 계산해 준다는 것은 서버가 나를 인증했다는 뜻이다 — 별도의 인증
    // 조회 없이 이 값으로 로그인 여부를 안다.
    if (!map.canCompare) return const SizedBox.shrink();

    final bool already = ref.watch(isRelatedNicknameProvider(map.ownerNickname));
    final bool running = ref.watch(relationRegistrationProvider);

    if (running) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return IconButton(
      icon: Icon(
        already ? Icons.how_to_reg : Icons.person_add_alt_1_outlined,
        color: already ? scheme.primary : null,
      ),
      tooltip: already ? l10n.relationConnected : l10n.relationConnect,
      onPressed: already ? null : () => _connect(context, ref),
    );
  }

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      // **링크를 통째로 넘긴다** — 토큰 추출은 서버가 한다.
      await ref
          .read(relationRegistrationProvider.notifier)
          .register(MapShareLink.urlOf(token));
    } on Object {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.relationConnectFailed)),
      );
    }
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
  );
}
