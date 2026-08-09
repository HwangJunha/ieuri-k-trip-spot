import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/spot_detail_route.dart';
import '../../../common/widget/home_section.dart';
import '../../../common/widget/settings_button.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../event/component/happening_now_section.dart';
import '../component/home_search_bar.dart';
import '../component/popular_spot_card.dart';
import '../component/spot_card.dart';
import '../model/popular_spot.dart';
import '../model/tourist_spot.dart';
import '../provider/home_section_providers.dart';
import 'search_screen.dart';

/// The Home tab: app bar + search bar + three sections (Near you, Happening
/// Now, Popular). Reads section providers only; never touches the repository
/// directly (CLAUDE.md §3).
///
/// Home lives in the `spot` domain: it is primarily a spot surface. The
/// "Happening Now" block is owned by the event domain and embedded here as a
/// single [HappeningNowSection] widget — the one deliberate cross-domain
/// composition point.
///
/// **세 섹션은 각각 자기 provider와 자기 상태를 갖는다**(R19). 한 섹션이 실패하거나
/// 비어도 나머지는 그대로 그려지고, 세 중 둘이 비어도 화면이 성립한다(AC-19.3).
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
          // 설정 진입점(SPEC-0011 R1). 하단 탭 5개는 SPEC-0008에서 고정됐으므로
          // 설정은 탭이 아니라 여기서 들어간다. 로그아웃은 설정 안으로 옮겨갔다
          // (R15) — 그 자리를 이 아이콘이 대신한다.
          const SettingsButton(),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 96),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              // 검색바를 누르면 검색 페이지로 간다(AC-10.1). `push`라서 돌아오면
              // 홈이 그대로 살아 있고 섹션 상태도 유지된다(AC-10.2).
              child: HomeSearchBar(
                onTap: () => context.pushNamed(SearchScreen.routeName),
              ),
            ),
            const SizedBox(height: 24),
            const _NearYouSection(),
            const SizedBox(height: 24),
            const HappeningNowSection(),
            const SizedBox(height: 24),
            const _PopularSection(),
          ],
        ),
      ),
    );
  }
}

/// "Near you"(R16) — 반경 안의 spot을 거리순 가로 스크롤로 보여준다.
class _NearYouSection extends ConsumerWidget {
  const _NearYouSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<TouristSpot>> spots = ref.watch(
      nearbySpotsSectionProvider,
    );

    return HomeSection<TouristSpot>(
      title: l10n.homeSectionNearYou,
      value: spots,
      emptyMessage: l10n.homeNearYouEmpty,
      // 이 섹션의 provider만 무효화한다 — 다른 두 섹션은 그대로다(AC-20.2).
      onRetry: () => ref.invalidate(nearbySpotsSectionProvider),
      builder: (List<TouristSpot> items) => SizedBox(
        height: 236,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (_, int i) => SpotCard(
            spot: items[i],
            onTap: () => openSpotDetail(
              context,
              id: items[i].id,
              category: items[i].category?.name,
              thumbnailUrl: items[i].thumbnailImageUrl,
            ),
          ),
        ),
      ),
    );
  }
}

/// "Popular"(R18) — 누적 좋아요 총합 기준. 랭킹 근거를 카드가 함께 보여준다.
class _PopularSection extends ConsumerWidget {
  const _PopularSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AsyncValue<List<PopularSpot>> spots = ref.watch(
      popularSpotsSectionProvider,
    );

    return HomeSection<PopularSpot>(
      title: l10n.homeSectionPopular,
      value: spots,
      emptyMessage: l10n.homePopularEmpty,
      onRetry: () => ref.invalidate(popularSpotsSectionProvider),
      builder: (List<PopularSpot> items) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            for (final PopularSpot p in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PopularSpotCard(
                  popular: p,
                  onTap: () => openSpotDetail(
                    context,
                    id: p.spot.id,
                    category: p.spot.category?.name,
                    thumbnailUrl: p.spot.thumbnailImageUrl,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
