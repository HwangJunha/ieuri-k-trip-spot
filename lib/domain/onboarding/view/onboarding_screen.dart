import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/app_assets.dart';
import '../../../common/widget/korea_icon.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../common/navigation/discover_route.dart';
import '../../auth/provider/auth_controller.dart';

/// Three-page onboarding carousel (Stitch design): a top bar with the brand
/// logo + Skip, a large media card per page (placeholder gradient + location
/// label + heart badge), a primary-colored title, page dots and a full-width
/// Next / Get-started action. Media is a placeholder to be replaced by real
/// photos later; all text is localized.
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
  List<_OnboardingPage> _pages(AppLocalizations l10n, ColorScheme scheme) =>
      <_OnboardingPage>[
        _OnboardingPage(
          icon: Icons.home_outlined,
          title: l10n.onboardingTitle1,
          body: l10n.onboardingBody1,
          color: scheme.primary,
        ),
        _OnboardingPage(
          // 전국 지도 탭과 같은 한반도 실루엣.
          icon: null,
          title: l10n.onboardingTitle2,
          body: l10n.onboardingBody2,
          color: scheme.secondary,
        ),
        _OnboardingPage(
          icon: Icons.explore_outlined,
          title: l10n.onboardingTitle3,
          body: l10n.onboardingBody3,
          color: scheme.primary,
        ),
        _OnboardingPage(
          icon: Icons.favorite_outline,
          title: l10n.onboardingTitle4,
          body: l10n.onboardingBody4,
          color: scheme.tertiary,
        ),
        _OnboardingPage(
          icon: Icons.map_outlined,
          title: l10n.onboardingTitle5,
          body: l10n.onboardingBody5,
          color: scheme.secondary,
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
    final List<_OnboardingPage> pages = _pages(l10n, theme.colorScheme);
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
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  /// 이 탭의 아이콘. **null이면 한반도 실루엣**([KoreaIcon])을 그린다 — 전국
  /// 지도 탭이 `Icons.*`에 없는 도형을 쓰기 때문이다.
  final IconData? icon;
  final String title;
  final String body;
  final Color color;
}

/// 이 탭이 무엇인지 한눈에 보여 주는 카드.
///
/// **사진이 아니라 탭 아이콘이다.** 예전에는 사진 자리에 그라디언트를 깔고 그 위에
/// 장소 이름·위치를 얹었는데, 실제 사진이 들어온 적이 없어 **있지도 않은 장소를
/// 소개하는 카드**가 되어 있었다(명동 길거리 음식 · 서울, 대한민국).
///
/// 온보딩이 가르치려는 것은 특정 장소가 아니라 **탭의 쓰임**이다. 그 탭에서 쓰는
/// 아이콘을 크게 보여 주면, 넘기고 나서 하단 바의 같은 아이콘과 곧바로 이어진다.
class _MediaCard extends StatelessWidget {
  const _MediaCard({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              page.color,
              Color.lerp(page.color, Colors.black, 0.35)!,
            ],
          ),
        ),
        child: Center(
          // 아이콘이 없는 장(전국 지도)은 한반도 실루엣을 그린다 — 그 탭이
          // `Icons.*`에 없는 도형을 쓰기 때문이다.
          child: page.icon == null
              ? const KoreaIcon(size: 104, color: Colors.white70, filled: true)
              : Icon(page.icon, size: 104, color: Colors.white70),
        ),
      ),
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
