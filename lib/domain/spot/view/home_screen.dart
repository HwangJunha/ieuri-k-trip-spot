import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../event/component/happening_now_section.dart';
import '../component/home_search_bar.dart';
import '../component/popular_spot_card.dart';
import '../component/section_header.dart';
import '../component/spot_card.dart';
import '../model/tourist_spot.dart';
import '../provider/spot_providers.dart';

/// The Home tab: app bar + inert search bar + three sections (Recommended,
/// Happening Now, Popular). Reads section providers only; never touches the
/// repository directly (CLAUDE.md §3).
///
/// Home lives in the `spot` domain: it is primarily a spot surface. The
/// "Happening Now" block is owned by the event domain and embedded here as a
/// single [HappeningNowSection] widget — the one deliberate cross-domain
/// composition point.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static String get routeName => 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle, style: theme.textTheme.titleLarge),
        actions: <Widget>[
          // Favorites has no destination yet (spec §2.2) — inert affordance
          // that shows a SnackBar rather than wiring a real route.
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: l10n.homeFavoritesTooltip,
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.comingSoon))),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 96),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HomeSearchBar(),
            ),
            const SizedBox(height: 24),
            _RecommendedSection(l10n: l10n),
            const SizedBox(height: 24),
            const HappeningNowSection(),
            const SizedBox(height: 24),
            _PopularSection(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _RecommendedSection extends ConsumerWidget {
  const _RecommendedSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TouristSpot>> spots = ref.watch(
      recommendedSpotsProvider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // "View all" only on Recommended, per the design reference (§5 gap).
          child: SectionHeader(
            title: l10n.homeSectionRecommended,
            onViewAll: () {},
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 236,
          child: _AsyncSpotList(
            value: spots,
            builder: (List<TouristSpot> items) => ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (_, int i) => SpotCard(spot: items[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularSection extends ConsumerWidget {
  const _PopularSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TouristSpot>> spots = ref.watch(popularSpotsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SectionHeader(title: l10n.homeSectionPopular),
          const SizedBox(height: 8),
          _AsyncSpotList(
            value: spots,
            builder: (List<TouristSpot> items) => Column(
              children: <Widget>[
                for (final TouristSpot s in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: PopularSpotCard(spot: s),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared `AsyncValue` boundary for the spot sections: spinner while loading,
/// the section content on data, an inline message on error.
class _AsyncSpotList extends StatelessWidget {
  const _AsyncSpotList({required this.value, required this.builder});

  final AsyncValue<List<TouristSpot>> value;
  final Widget Function(List<TouristSpot> items) builder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: builder,
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (Object error, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(AppLocalizations.of(context).errorUnknown),
      ),
    );
  }
}
