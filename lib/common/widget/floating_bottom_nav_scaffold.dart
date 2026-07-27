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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: NavigationBar(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onTap,
                  destinations: <Widget>[
                    NavigationDestination(
                      icon: const Icon(Icons.home_outlined),
                      selectedIcon: const Icon(Icons.home),
                      label: l10n.navHome,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.map_outlined),
                      selectedIcon: const Icon(Icons.map),
                      label: l10n.navMap,
                    ),
                    NavigationDestination(
                      // Discover is center-emphasized (§8): filled accent puck.
                      icon: _DiscoverIcon(
                        selected:
                            navigationShell.currentIndex == _discoverIndex,
                      ),
                      label: l10n.navDiscover,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.event_outlined),
                      selectedIcon: const Icon(Icons.event),
                      label: l10n.navEvents,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.chat_bubble_outline),
                      selectedIcon: const Icon(Icons.chat_bubble),
                      label: l10n.navChat,
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
