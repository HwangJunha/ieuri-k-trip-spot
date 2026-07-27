import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../onboarding/provider/onboarding_controller.dart';
import '../../router/app_router.dart';

/// TEMPORARY testing aid — a back button pinned to the top-left that steps back
/// through the first-run flow (onboarding → language, home → onboarding).
///
/// From home it resets the onboarding flag first so the flow replays instead of
/// being bounced straight back by the completion guard. Wired as a `ShellRoute`
/// overlay around the flow routes. Remove before shipping.
class DebugBackButton extends ConsumerWidget {
  const DebugBackButton({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  static const Map<String, String> _previousOf = <String, String>{
    Routes.onboarding: Routes.language,
    Routes.home: Routes.onboarding,
  };

  Future<void> _onBack(BuildContext context, WidgetRef ref, String target) async {
    // Leaving home means the flow was completed — re-open it before navigating.
    if (location == Routes.home) {
      await ref.read(onboardingControllerProvider.notifier).reset();
    }
    if (context.mounted) context.go(target);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? target = _previousOf[location];

    return Stack(
      children: <Widget>[
        child,
        if (target != null)
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Material(
                  color: Colors.black45,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: 'Debug: back',
                    onPressed: () => _onBack(context, ref, target),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
