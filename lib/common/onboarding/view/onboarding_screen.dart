import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app_assets.dart';
import '../provider/onboarding_controller.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../router/app_router.dart';

/// Three-page onboarding carousel (Stitch design): a top bar with the brand
/// logo + Skip, a large media card per page (placeholder gradient + location
/// label + heart badge), a primary-colored title, page dots and a full-width
/// Next / Get-started action. Media is a placeholder to be replaced by real
/// photos later; all text is localized.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

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

  List<_OnboardingPage> _pages(AppLocalizations l10n, ColorScheme scheme) =>
      <_OnboardingPage>[
        _OnboardingPage(
          icon: Icons.swipe_outlined,
          title: l10n.onboardingTitle1,
          body: l10n.onboardingBody1,
          caption: l10n.onboardingCaption1,
          location: l10n.onboardingLocation1,
          color: scheme.primary,
        ),
        _OnboardingPage(
          icon: Icons.insights_outlined,
          title: l10n.onboardingTitle2,
          body: l10n.onboardingBody2,
          caption: l10n.onboardingCaption2,
          location: l10n.onboardingLocation2,
          color: scheme.secondary,
        ),
        _OnboardingPage(
          icon: Icons.forum_outlined,
          title: l10n.onboardingTitle3,
          body: l10n.onboardingBody3,
          caption: l10n.onboardingCaption3,
          location: l10n.onboardingLocation3,
          color: scheme.tertiary,
        ),
      ];

  Future<void> _finish() async {
    await ref.read(onboardingControllerProvider.notifier).complete();
    if (mounted) context.go(Routes.home);
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
    required this.caption,
    required this.location,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String body;
  final String caption;
  final String location;
  final Color color;
}

/// Placeholder media card: a gradient stand-in for a real photo, with a heart
/// badge and a caption/location overlay — matching the Stitch card layout.
class _MediaCard extends StatelessWidget {
  const _MediaCard({required this.page});

  final _OnboardingPage page;

  static const Color _badgeGreen = Color(0xFF2E9E5B);

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

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
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(child: Icon(page.icon, size: 88, color: Colors.white70)),
            Positioned(
              top: 16,
              right: 16,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: _badgeGreen,
                child: const Icon(Icons.favorite, color: Colors.white, size: 20),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    page.caption,
                    style: text.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.location_on,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        page.location,
                        style: text.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
