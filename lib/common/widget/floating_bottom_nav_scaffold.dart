import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/gen/app_localizations.dart';

/// The 5-tab shell chrome: renders the active tab's [StatefulNavigationShell]
/// with a floating, rounded bottom navigation bar (DESIGN.md §8). The Discover
/// tab (center) is visually emphasized.
///
/// Lives in `common/widget/` because it's cross-feature app chrome, not owned by
/// any single domain (spec §7). It reads only l10n and the shell — no feature
/// imports.
class FloatingBottomNavScaffold extends StatelessWidget {
  const FloatingBottomNavScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const int _discoverIndex = 2;

  /// 떠 있는 내비 바가 화면 하단에서 차지하는 높이(SafeArea 제외).
  ///
  /// `extendBody: true`라 **탭 화면의 body가 이 바 아래까지 그려진다.** 그래서 탭
  /// 화면이 FAB처럼 하단에 고정된 것을 두면 바에 가려진다 — 그런 화면은 이 값만큼
  /// 띄운다. 상수를 여기 두는 이유는 바의 높이·여백을 바꿀 때 가려짐 보정이 함께
  /// 따라오게 하기 위해서다(값을 화면 쪽에 복사해 두면 반드시 어긋난다).
  ///
  /// 내역: [NavigationBar] 기본 높이 + 위아래 여백.
  static const double barExtent =
      _navigationBarHeight + _barVerticalPadding * 2;

  /// 바를 감싼 위아래 여백. 실제 [Padding]이 이 값을 쓰므로 여백을 바꾸면
  /// [barExtent]가 함께 따라간다.
  static const double _barVerticalPadding = 8;

  /// Material [NavigationBar]의 기본 높이. 테마에서 높이를 지정하지 않아 기본값이다.
  static const double _navigationBarHeight = 80;

  void _onTap(int index) {
    // initialLocation:true re-taps reset the branch to its root (standard shell
    // behavior), matching the "tap active tab → go home" convention.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: _barVerticalPadding,
          ),
          child: Material(
            elevation: 3,
            color: theme.colorScheme.surfaceContainer,
            shadowColor: theme.colorScheme.shadow,
            borderRadius: BorderRadius.circular(999),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                // 선택 탭 뒤의 하늘색 pill(기본 인디케이터)을 제거한다.
                indicatorColor: Colors.transparent,
                // 선택된 탭 아이콘은 브랜드 빨강, 미선택은 기존 muted 색을 유지한다.
                iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
                  (Set<WidgetState> states) => IconThemeData(
                    color: states.contains(WidgetState.selected)
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: NavigationBar(
                  key: const Key('bottom_nav_bar'),
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onTap,
                  destinations: <Widget>[
                    NavigationDestination(
                      key: const Key('bottom_nav_home'),
                      icon: const Icon(Icons.home_outlined),
                      selectedIcon: const Icon(Icons.home),
                      label: l10n.navHome,
                    ),
                    // SPEC-0030 R17: 1번은 전국 지도(내가 채운 기록), 4번이
                    // 기존 뷰포트 지도(지금 주변에 뭐가 있나)다. 둘은 성격이
                    // 달라 합치지 않는다(설계 §9).
                    NavigationDestination(
                      key: const Key('bottom_nav_national_map'),
                      icon: const Icon(Icons.public_outlined),
                      selectedIcon: const Icon(Icons.public),
                      label: l10n.navNationalMap,
                    ),
                    NavigationDestination(
                      key: const Key('bottom_nav_discover'),
                      // Discover is center-emphasized (§8): filled accent puck.
                      icon: _DiscoverIcon(
                        selected:
                            navigationShell.currentIndex == _discoverIndex,
                      ),
                      label: l10n.navDiscover,
                    ),
                    // SPEC-0030 R18: 좋아요와 커뮤니티가 보관함 한 자리로 합쳐진다.
                    NavigationDestination(
                      key: const Key('bottom_nav_library'),
                      icon: const Icon(Icons.bookmark_outline),
                      selectedIcon: const Icon(Icons.bookmark),
                      label: l10n.navLibrary,
                    ),
                    NavigationDestination(
                      key: const Key('bottom_nav_map'),
                      icon: const Icon(Icons.map_outlined),
                      selectedIcon: const Icon(Icons.map),
                      label: l10n.navMap,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Center Discover destination: a filled primary puck so it reads as the
/// emphasized action (DESIGN.md §8).
class _DiscoverIcon extends StatelessWidget {
  const _DiscoverIcon({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: selected ? scheme.primary : scheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.explore,
        color: selected ? scheme.onPrimary : scheme.onPrimaryContainer,
      ),
    );
  }
}
