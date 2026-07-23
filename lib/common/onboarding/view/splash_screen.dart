import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app_assets.dart';
import '../../theme/app_colors.dart';
import '../provider/onboarding_controller.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../router/app_router.dart';

/// In-app splash (Stitch design): a full coral brand screen with a large white
/// app icon and white text, shown for a fixed delay before routing to
/// onboarding (first run) or home (returning user). Theme-independent — the
/// brand splash is always coral. Rendered in the active locale.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const Duration _delay = Duration(milliseconds: 1500);
  static const String _brand = 'K-Trip Spot';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(_delay);
    if (!mounted) return;
    final bool completed = ref.read(onboardingControllerProvider);
    context.go(completed ? Routes.home : Routes.language);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final TextTheme text = Theme.of(context).textTheme;
    const Color onCoral = Colors.white;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 72),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 3),
              SvgPicture.asset(AppAssets.appIconSplash, width: 150),
              const SizedBox(height: 28),
              Text(
                _brand,
                textAlign: TextAlign.center,
                style: text.headlineMedium?.copyWith(
                  color: onCoral,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.splashTagline,
                textAlign: TextAlign.center,
                style: text.bodyLarge?.copyWith(color: onCoral, fontSize: 14),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(
                    color: onCoral,
                    backgroundColor: Colors.white24,
                    minHeight: 3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.splashLoading.toUpperCase(),
                textAlign: TextAlign.center,
                style: text.labelMedium?.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              Text(
                l10n.splashSubTagline,
                textAlign: TextAlign.center,
                style: text.bodySmall?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
