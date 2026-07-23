import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../storage/app_preferences.dart';

part 'onboarding_controller.g.dart';

/// Whether the first-run onboarding flow has been completed. Drives the router
/// so returning users skip the splash → language → onboarding sequence.
@Riverpod(keepAlive: true)
class OnboardingController extends _$OnboardingController {
  @override
  bool build() => ref.watch(appPreferencesProvider).onboardingCompleted;

  Future<void> complete() async {
    await ref
        .read(appPreferencesProvider)
        .setOnboardingCompleted(completed: true);
    state = true;
  }

  /// Re-enables the first-run flow. Used by the temporary debug back button to
  /// replay splash → onboarding.
  Future<void> reset() async {
    await ref
        .read(appPreferencesProvider)
        .setOnboardingCompleted(completed: false);
    state = false;
  }
}
