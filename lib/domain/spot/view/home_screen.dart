import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/navigation/spot_detail_route.dart';
import '../../../common/widget/home_section.dart';
import '../../spot_qa/component/my_questions_button.dart';
import '../../dm/component/messages_button.dart';
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
          // **즐겨찾기 아이콘이 사라졌다**(SPEC-0025 R6). 라우팅 없이 "준비 중"
          // 스낵바만 띄우던 버튼이라, 없애도 도달 불가가 되는 화면이 없다 —
          // 좋아요 목록은 하단 탭이 유일하고 정상적인 진입점이다(R7).
          //
          // 설정 진입점(SPEC-0011 R1). 하단 탭 5개는 SPEC-0008에서 고정됐으므로
          // 설정은 탭이 아니라 여기서 들어간다. 로그아웃은 설정 안으로 옮겨갔다
          // (R15) — 그 자리를 이 아이콘이 대신한다.
          // DM 진입 + 안 읽음 표시(2026-08-18). 예전에는 설정 안에서만 대화 목록에
          // 들어갈 수 있어, 메시지가 와도 설정을 열어 봐야 알았다.
          // 「내 질문」(SPEC-0026). **서버에 알림이 없어 이 배지가 답변 도착을 알리는
          // 유일한 채널이다** — 앱을 열면 보이는 자리여야 알림 역할을 한다. 설정
          // 2뎁스 안에도 있지만 그건 찾아 들어가는 경로다.
          //
          // 메시지 옆인 이유: 둘 다 "내가 보낸 것에 대한 응답을 기다리는 인박스"다.
          const MyQuestionsButton(),
          const MessagesButton(),
          const SettingsButton(),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          // **세 섹션을 한꺼번에 다시 받는다.** 섹션마다 재시도 버튼이 따로 있지만
          // 그건 실패했을 때의 복구 경로다 — 성공해 있는 화면을 손으로 새로
          // 고칠 방법이 없었다(위치를 옮겼거나 행사가 갱신됐을 때).
          //
          // **`.future`를 await 해야 한다** — invalidate만 하고 끝나면 데이터가
          // 도착하기 전에 스피너가 걷혀 새로고침이 안 된 것처럼 보인다. 셋 중
          // 하나가 실패해도 나머지를 기다리도록 각각 catchError로 받는다.
          onRefresh: () async {
            ref
              ..invalidate(nearbySpotsSectionProvider)
              ..invalidate(popularSpotsSectionProvider);
            await Future.wait(<Future<void>>[
              ref
                  .read(nearbySpotsSectionProvider.future)
                  .catchError((Object _) => const <TouristSpot>[]),
              ref
                  .read(popularSpotsSectionProvider.future)
                  .catchError((Object _) => const <PopularSpot>[]),
              // 행사 섹션은 event 도메인이 스스로 무효화한다(경계 유지).
              HappeningNowSection.refresh(ref),
            ]);
          },
          child: ListView(
            // 항목이 적어도 당겨서 새로고침이 되도록 항상 스크롤을 허용한다.
            physics: const AlwaysScrollableScrollPhysics(),
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
              from: 'home_nearby',
              id: items[i].id,
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
                    from: 'home_popular',
                    id: p.spot.id,
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
