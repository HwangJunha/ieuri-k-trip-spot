import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/app_assets.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../common/navigation/discover_route.dart';
import '../../auth/provider/auth_controller.dart';

/// 온보딩 다섯 장. 상단에 로고 + Skip, 장마다 큰 일러스트, primary 색 제목,
/// 설명 한 줄, 페이지 점, 하단 전체 폭 버튼(마지막은 "시작하기").
///
/// **하단 탭과 같은 순서다** — 넘기고 나면 곧바로 그 순서로 탭 바가 보인다.
/// 문구는 전부 l10n이다.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static String get routeName => 'onboarding';

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 온보딩 다섯 장. **하단 탭과 같은 순서, 같은 아이콘이다**(2026-08-25).
  ///
  /// 예전에는 스와이프·혼잡도·커뮤니티 세 장이었는데, 실제 탭 다섯 개와 어긋나
  /// 있었다 — 전국 지도(SPEC-0030)가 아예 빠져 있었고 "내 활동"이 좋아요와
  /// 커뮤니티를 묶은 것도 반영되지 않았다.
  ///
  /// 온보딩은 앱을 처음 여는 사람이 **어디에 무엇이 있는지** 배우는 자리다.
  /// 넘기고 나면 곧바로 그 순서로 탭 바가 보이므로, 아이콘이 같아야 방금 본
  /// 그림과 탭이 이어진다.
  List<_OnboardingPage> _pages(AppLocalizations l10n) =>
      <_OnboardingPage>[
        _OnboardingPage(
          image: AppAssets.onboarding[0],
          title: l10n.onboardingTitle1,
          body: l10n.onboardingBody1,
        ),
        _OnboardingPage(
          image: AppAssets.onboarding[1],
          title: l10n.onboardingTitle2,
          body: l10n.onboardingBody2,
        ),
        _OnboardingPage(
          image: AppAssets.onboarding[2],
          title: l10n.onboardingTitle3,
          body: l10n.onboardingBody3,
        ),
        _OnboardingPage(
          image: AppAssets.onboarding[3],
          title: l10n.onboardingTitle4,
          body: l10n.onboardingBody4,
        ),
        _OnboardingPage(
          image: AppAssets.onboarding[4],
          title: l10n.onboardingTitle5,
          body: l10n.onboardingBody5,
        ),
      ];

  Future<void> _finish() async {
    // Account-bound completion (spec §4.3): mark the signed-in account done;
    // the router redirect then lets it through. 착지점은 Discover다 — 앱의 핵심
    // 동선이 스와이프이므로 온보딩 직후 바로 카드를 보게 한다.
    await ref.read(authControllerProvider.notifier).completeOnboarding();
    if (mounted) context.goNamed(discoverRouteName);
  }

  void _next(int pageCount) {
    if (_index >= pageCount - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final List<_OnboardingPage> pages = _pages(l10n);
    final bool isLast = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SvgPicture.asset(
                    AppAssets.lockupFor(theme.brightness),
                    height: 28,
                  ),
                  TextButton(onPressed: _finish, child: Text(l10n.skip)),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (int page) => setState(() => _index = page),
                itemBuilder: (BuildContext context, int index) {
                  final _OnboardingPage page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 8),
                        Expanded(child: _MediaCard(page: page)),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
            _PageIndicator(count: pages.length, index: _index),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _next(pages.length),
                  child: Text(isLast ? l10n.getStarted : l10n.next),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.image,
    required this.title,
    required this.body,
  });

  /// 이 장의 일러스트 에셋 경로([AppAssets.onboarding]).
  final String image;
  final String title;
  final String body;
}

/// 이 장이 무엇을 말하는지 보여 주는 일러스트.
///
/// **다섯 장이 한 세트다.** 같은 결(플랫 벡터·얇은 외곽선·따뜻한 배경)로 그려져
/// 있어 넘길 때 그림체가 튀지 않는다 — 한 장만 다른 스타일로 갈아 끼우면 그 장이
/// 도드라진다.
///
/// 예전에는 사진 자리에 그라디언트를 깔고 장소 이름·위치를 얹었는데, 실제 사진이
/// 들어온 적이 없어 **있지도 않은 장소를 소개하는 카드**가 되어 있었다(명동 길거리
/// 음식 · 서울, 대한민국). 그 뒤로는 탭 아이콘을 크게 그렸고, 지금은 장마다 그린
/// 일러스트가 그 자리를 대신한다.
class _MediaCard extends StatelessWidget {
  const _MediaCard({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    // **배경을 깔지 않는다.** 일러스트 자체가 따뜻한 오프화이트 배경을 갖고 있어
    // 화면과 이어진다 — 카드 테두리를 두르면 그림이 액자에 갇힌 것처럼 보인다.
    return Image.asset(
      page.image,
      fit: BoxFit.contain,
      // 원본이 343x512로 작다. 화면 폭에 맞춰 늘리므로 보간 품질이 곧 선명도다.
      filterQuality: FilterQuality.medium,
      // 에셋이 빠져도 온보딩이 막히지 않는다 — 글자만으로도 뜻은 전해진다.
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
}


class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index
                  ? scheme.primary
                  : scheme.primary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
