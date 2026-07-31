import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import 'discover_swipe_view.dart';

/// The Discover (swipe) tab — real-time, location-based spot recommendations as a
/// swipeable card stack (SPEC-0002). Part of the spot domain. The routed widget
/// name and `routeName` stay stable (router/nav shell reference them); the body
/// hosts [DiscoverSwipeView].
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  static String get routeName => 'discover';

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDiscover)),
      body: const SafeArea(child: DiscoverSwipeView()),
    );
  }
}
